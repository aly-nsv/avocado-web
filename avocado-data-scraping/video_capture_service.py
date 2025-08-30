#!/usr/bin/env python3
"""
FL 511 Video Capture Service

Cloud Run service that captures video segments from FL 511 traffic cameras
and stores them in Cloud Storage with proper incident correlation.

This service:
1. Fetches current incidents and active cameras
2. Correlates cameras with nearby incidents  
3. Authenticates with FL 511 video streams
4. Captures video segments and stores in GCS
5. Updates metadata in Cloud SQL database
"""

import os
import json
import time
import logging
import asyncio
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Tuple
from concurrent.futures import ThreadPoolExecutor, as_completed
from flask import Flask, request, jsonify
from google.cloud import storage
from google.cloud.sql.connector import Connector
import sqlalchemy
from sqlalchemy import text
import requests
import threading

# Import our custom modules
from fl511_scraper import FL511Scraper, TrafficIncident
from fl511_video_auth_cached import FL511VideoAuthCached


# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Flask app
app = Flask(__name__)

# Global configuration
PROJECT_ID = os.getenv('PROJECT_ID')
REGION = os.getenv('REGION', 'us-central1')
DATABASE_NAME = os.getenv('DATABASE_NAME', 'fl511_incidents')
DATABASE_USER = os.getenv('DATABASE_USER', 'fl511_user') 
DATABASE_PASSWORD = os.getenv('DATABASE_PASSWORD', 'AfUa9sQ7r6PcXufDVPJhwK')

# Storage buckets
VIDEO_SEGMENTS_BUCKET = f"{PROJECT_ID}-fl511-video-segments"
INCIDENT_METADATA_BUCKET = f"{PROJECT_ID}-fl511-incident-data"
CAMERA_METADATA_BUCKET = f"{PROJECT_ID}-fl511-camera-data"


class VideoCapturePipeline:
    def __init__(self):
        """Initialize the video capture pipeline for I4-I95 highways"""
        self.storage_client = storage.Client()
        self.incident_scraper = FL511Scraper()
        self.video_auth = FL511VideoAuthCached()
        self.db_pool = None
        self.capture_status = {
            'active': False,
            'start_time': None,
            'cameras_processed': 0,
            'segments_captured': 0,
            'errors': 0
        }
        self._setup_database()
        
    def _setup_database(self):
        """Set up database connection pool"""
        try:
            # Initialize Cloud SQL Python Connector
            connector = Connector()
            
            def getconn():
                conn = connector.connect(
                    f"{PROJECT_ID}:{REGION}:fl511-metadata-db",
                    "pg8000",
                    user=DATABASE_USER,
                    password=DATABASE_PASSWORD,
                    db=DATABASE_NAME
                )
                return conn
            
            # Create connection pool
            self.db_pool = sqlalchemy.create_engine(
                "postgresql+pg8000://",
                creator=getconn,
                pool_size=5,
                max_overflow=2,
                pool_timeout=30,
                pool_recycle=-1
            )
            
            logger.info("Database connection pool established")
            
        except Exception as e:
            logger.error(f"Failed to setup database: {e}")
            self.db_pool = None
    
    def fetch_recent_incidents(self, hours: int = 24) -> List[TrafficIncident]:
        """Fetch recent incidents from FL 511"""
        logger.info(f"Fetching incidents from last {hours} hours...")
        
        try:
            # Get all incidents
            all_incidents = self.incident_scraper.fetch_incidents()
            
            # Filter to recent incidents
            recent_incidents = self.incident_scraper.filter_last_24_hours(all_incidents)
            
            logger.info(f"Found {len(recent_incidents)} recent incidents")
            return recent_incidents
            
        except Exception as e:
            logger.error(f"Error fetching incidents: {e}")
            return []
    
    def get_cameras_for_incidents(self, incidents: List[TrafficIncident]) -> List[Dict]:
        """
        Extract cameras associated with incidents
        
        Args:
            incidents: List of traffic incidents
            
        Returns:
            List of unique cameras with incident correlation
        """
        cameras = []
        camera_incident_map = {}
        
        for incident in incidents:
            if incident.cameras:
                for camera in incident.cameras:
                    if camera.images:
                        for image in camera.images:
                            camera_key = f"camera_{image.camera_site_id}"
                            
                            if camera_key not in camera_incident_map:
                                camera_incident_map[camera_key] = {
                                    'camera_id': image.camera_site_id,
                                    'image_id': image.id,
                                    'description': image.description,
                                    'video_url': image.video_url,
                                    'is_auth_required': image.is_video_auth_required,
                                    'incidents': []
                                }
                            
                            # Add incident to this camera
                            camera_incident_map[camera_key]['incidents'].append({
                                'incident_id': incident.id,
                                'roadway': incident.roadway_name,
                                'county': incident.county,
                                'severity': incident.severity,
                                'description': incident.description,
                                'last_updated': incident.last_updated
                            })
        
        cameras = list(camera_incident_map.values())
        logger.info(f"Found {len(cameras)} unique cameras associated with incidents")
        return cameras
    
    def authenticate_camera_stream(self, camera_id: str) -> Optional[Dict]:
        """
        Authenticate with FL 511 to get streaming information
        
        Args:
            camera_id: FL 511 camera ID
            
        Returns:
            Streaming information dict or None if failed
        """
        try:
            logger.info(f"Authenticating camera stream for camera {camera_id}")
            stream_info = self.video_auth.get_video_stream_info(camera_id)
            
            if stream_info and stream_info.get('segments'):
                logger.info(f"✅ Camera {camera_id}: Got {len(stream_info['segments'])} segments")
                return stream_info
            else:
                logger.warning(f"❌ Camera {camera_id}: Authentication failed")
                return None
                
        except Exception as e:
            logger.error(f"Error authenticating camera {camera_id}: {e}")
            return None
    
    def capture_video_segments(self, stream_info: Dict, max_segments: int = 10) -> List[Dict]:
        """
        Capture video segments from authenticated stream
        
        Args:
            stream_info: Stream info from authentication
            max_segments: Maximum segments to capture
            
        Returns:
            List of captured segment metadata
        """
        segments = stream_info.get('segments', [])
        camera_id = stream_info.get('camera_id')
        captured_segments = []
        
        if not segments:
            logger.warning(f"No segments available for camera {camera_id}")
            return captured_segments
        
        # Capture up to max_segments
        segments_to_capture = segments[:max_segments]
        
        for i, segment in enumerate(segments_to_capture):
            try:
                logger.info(f"Capturing segment {i+1}/{len(segments_to_capture)} for camera {camera_id}")
                
                # Download segment data
                segment_data = self.video_auth.step4_get_video_segment(segment['url'])
                
                if segment_data:
                    # Upload to Cloud Storage
                    filename = f"camera_{camera_id}/{datetime.now().strftime('%Y%m%d')}/{segment['filename']}"
                    
                    bucket = self.storage_client.bucket(VIDEO_SEGMENTS_BUCKET)
                    blob = bucket.blob(filename)
                    
                    # Upload with metadata
                    blob.upload_from_string(
                        segment_data,
                        content_type='video/MP2T'  # MPEG-TS format
                    )
                    
                    # Set metadata
                    blob.metadata = {
                        'camera_id': str(camera_id),
                        'segment_duration': str(segment.get('duration', 0)),
                        'program_date_time': segment.get('program_date_time', ''),
                        'capture_timestamp': datetime.now().isoformat(),
                        'segment_index': str(i)
                    }
                    blob.patch()
                    
                    captured_segment = {
                        'camera_id': camera_id,
                        'filename': segment['filename'],
                        'storage_path': filename,
                        'storage_bucket': VIDEO_SEGMENTS_BUCKET,
                        'segment_size': len(segment_data),
                        'segment_duration': segment.get('duration'),
                        'capture_timestamp': datetime.now(),
                        'program_date_time': segment.get('program_date_time'),
                        'segment_index': i,
                        'storage_url': f"gs://{VIDEO_SEGMENTS_BUCKET}/{filename}"
                    }
                    
                    captured_segments.append(captured_segment)
                    logger.info(f"✅ Stored segment: {filename} ({len(segment_data)} bytes)")
                    
                else:
                    logger.warning(f"❌ Failed to download segment {i+1} for camera {camera_id}")
                
            except Exception as e:
                logger.error(f"Error capturing segment {i+1} for camera {camera_id}: {e}")
                continue
        
        logger.info(f"Captured {len(captured_segments)} segments for camera {camera_id}")
        return captured_segments
    
    def store_metadata(self, incidents: List[TrafficIncident], cameras: List[Dict], video_segments: List[Dict]):
        """Store metadata in Cloud SQL database"""
        if not self.db_pool:
            logger.error("Database not available")
            return
        
        try:
            with self.db_pool.connect() as conn:
                # Store incidents
                for incident in incidents:
                    conn.execute(text("""
                        INSERT INTO traffic_incidents 
                        (id, dt_row_id, source_id, roadway_name, county, region, incident_type, 
                         severity, direction, description, start_date, last_updated, source, scraped_at)
                        VALUES (:id, :dt_row_id, :source_id, :roadway_name, :county, :region, :incident_type,
                                :severity, :direction, :description, :start_date, :last_updated, :source, :scraped_at)
                        ON CONFLICT (id) DO UPDATE SET
                            last_updated = EXCLUDED.last_updated,
                            description = EXCLUDED.description,
                            updated_at = CURRENT_TIMESTAMP
                    """), {
                        'id': incident.id,
                        'dt_row_id': incident.dt_row_id,
                        'source_id': incident.source_id,
                        'roadway_name': incident.roadway_name,
                        'county': incident.county,
                        'region': incident.region,
                        'incident_type': incident.incident_type,
                        'severity': incident.severity,
                        'direction': incident.direction,
                        'description': incident.description,
                        'start_date': incident.start_date,
                        'last_updated': incident.last_updated,
                        'source': incident.source,
                        'scraped_at': incident.scraped_at
                    })
                
                # Store video segments
                for segment in video_segments:
                    conn.execute(text("""
                        INSERT INTO video_segments
                        (camera_id, segment_filename, storage_bucket, storage_path, segment_duration,
                         segment_size_bytes, capture_timestamp, program_date_time, segment_index)
                        VALUES (:camera_id, :filename, :storage_bucket, :storage_path, :duration,
                                :size_bytes, :capture_timestamp, :program_date_time, :segment_index)
                    """), {
                        'camera_id': segment['camera_id'],
                        'filename': segment['filename'],
                        'storage_bucket': segment['storage_bucket'],
                        'storage_path': segment['storage_path'],
                        'duration': segment['segment_duration'],
                        'size_bytes': segment['segment_size'],
                        'capture_timestamp': segment['capture_timestamp'],
                        'program_date_time': segment['program_date_time'],
                        'segment_index': segment['segment_index']
                    })
                
                conn.commit()
                logger.info("✅ Metadata stored successfully")
                
        except Exception as e:
            logger.error(f"Error storing metadata: {e}")
    
    def store_video_segments_metadata(self, video_segments: List[Dict]):
        """Store video segments metadata in database for correlation with incidents"""
        if not self.db_pool:
            logger.error("Database not available for storing video segments metadata")
            return
        
        if not video_segments:
            logger.info("No video segments to store")
            return
        
        try:
            with self.db_pool.connect() as conn:
                # Store video segments with enhanced metadata for incident correlation
                for segment in video_segments:
                    conn.execute(text("""
                        INSERT INTO video_segments
                        (camera_id, segment_filename, storage_bucket, storage_path, storage_url, segment_duration,
                         segment_size_bytes, capture_timestamp, program_date_time, segment_index,
                         camera_latitude, camera_longitude, camera_roadway, camera_region, camera_county)
                        VALUES (:camera_id, :filename, :storage_bucket, :storage_path, :storage_url, :duration,
                                :size_bytes, :capture_timestamp, :program_date_time, :segment_index,
                                :camera_latitude, :camera_longitude, :roadway, :region, :county)
                        ON CONFLICT (camera_id, segment_filename) DO UPDATE SET
                            capture_timestamp = EXCLUDED.capture_timestamp,
                            updated_at = CURRENT_TIMESTAMP
                    """), {
                        'camera_id': segment.get('camera_id'),
                        'filename': segment.get('filename'),
                        'storage_bucket': segment.get('storage_bucket'),
                        'storage_path': segment.get('storage_path'),
                        'storage_url': segment.get('storage_url'),
                        'duration': segment.get('segment_duration'),
                        'size_bytes': segment.get('segment_size'),
                        'capture_timestamp': segment.get('capture_timestamp'),
                        'program_date_time': segment.get('program_date_time'),
                        'segment_index': segment.get('segment_index'),
                        'camera_latitude': segment.get('latitude'),
                        'camera_longitude': segment.get('longitude'),
                        'roadway': segment.get('camera_roadway'),
                        'region': segment.get('camera_region'),
                        'county': segment.get('camera_county')
                    })
                
                conn.commit()
                logger.info(f"✅ Stored {len(video_segments)} video segments metadata for incident correlation")
                
        except Exception as e:
            logger.error(f"Error storing video segments metadata: {e}")
    
    def correlate_incidents_with_video_segments(self, correlation_radius_km: float = 2.0, time_window_minutes: int = 60):
        """
        Correlate recent incidents with video segments based on proximity and timing
        
        Args:
            correlation_radius_km: Radius in kilometers to search for nearby cameras
            time_window_minutes: Time window in minutes to correlate incidents with segments
        """
        if not self.db_pool:
            logger.error("Database not available for incident correlation")
            return
        
        try:
            with self.db_pool.connect() as conn:
                logger.info("🔗 Starting incident-video correlation...")
                
                # Use the PostgreSQL function to perform correlation
                result = conn.execute(text("""
                    SELECT correlate_incidents_with_videos(:radius_km, :time_window_min)
                """), {
                    'radius_km': correlation_radius_km,
                    'time_window_min': time_window_minutes
                })
                
                correlation_count = result.fetchone()[0]
                logger.info(f"✅ Created {correlation_count} incident-video correlations")
                
                # Log some examples of correlations
                examples = conn.execute(text("""
                    SELECT 
                        ci.incident_id,
                        ti.roadway_name,
                        ti.description as incident_description,
                        ci.camera_id,
                        ci.distance_km,
                        vs.segment_filename,
                        ci.created_at
                    FROM camera_incident_relationships ci
                    JOIN traffic_incidents ti ON ci.incident_id = ti.id
                    JOIN video_segments_enhanced vs ON ci.camera_id = vs.camera_id 
                        AND vs.capture_timestamp BETWEEN ti.start_date - INTERVAL '%d minutes' 
                        AND ti.start_date + INTERVAL '%d minutes'
                    ORDER BY ci.created_at DESC
                    LIMIT 5
                """ % (time_window_minutes, time_window_minutes))).fetchall()
                
                for example in examples:
                    logger.info(f"📹 Correlation: Incident {example[0]} on {example[1]} ({example[2][:50]}...) "
                               f"→ Camera {example[3]} ({example[4]:.1f}km away) → {example[5]}")
                
        except Exception as e:
            logger.error(f"Error correlating incidents with video segments: {e}")
    
    def run_i4_i95_capture_job(self, max_cameras: int = 100, segments_per_camera: int = 5, batch_size: int = 50) -> Dict:
        """
        Run continuous video capture for all I4-I95 cameras
        
        Args:
            max_cameras: Maximum cameras to process per batch
            segments_per_camera: Segments to capture per camera
            batch_size: Cameras to process simultaneously
            
        Returns:
            Job results summary
        """
        job_start = datetime.now()
        logger.info("=== Starting I4-I95 Continuous Video Capture Job ===")
        
        # Update capture status
        self.capture_status.update({
            'active': True,
            'start_time': job_start,
            'cameras_processed': 0,
            'segments_captured': 0,
            'errors': 0
        })
        
        # Get cameras, filtered by environment settings
        max_cameras_env = int(os.getenv('MAX_CAMERAS', max_cameras))
        all_cameras = self.video_auth.cameras_data
        
        # Filter to I-4 cameras only if MAX_CAMERAS is 50 or less
        if max_cameras_env <= 50:
            i4_cameras = [cam for cam in all_cameras if cam.get('roadway') == 'I-4']
            all_cameras = i4_cameras
            logger.info(f"Filtering to I-4 cameras only: {len(all_cameras)} cameras")
        
        logger.info(f"Found {len(all_cameras)} cameras for processing (max: {max_cameras_env})")
        
        # Process cameras in batches
        cameras_to_process = all_cameras[:max_cameras_env]
        all_video_segments = []
        successful_cameras = 0
        failed_cameras = 0
        
        # Process in batches to avoid overwhelming the system
        for i in range(0, len(cameras_to_process), batch_size):
            batch = cameras_to_process[i:i + batch_size]
            logger.info(f"Processing batch {i//batch_size + 1}: cameras {i+1}-{min(i+batch_size, len(cameras_to_process))}")
            
            with ThreadPoolExecutor(max_workers=min(10, len(batch))) as executor:
                # Submit authentication tasks for this batch
                auth_futures = {
                    executor.submit(self.authenticate_and_capture_camera, camera, segments_per_camera): camera
                    for camera in batch
                }
                
                # Process results as they complete
                for future in as_completed(auth_futures):
                    camera = auth_futures[future]
                    camera_id = camera['camera_id']
                    
                    try:
                        segments = future.result()
                        if segments:
                            all_video_segments.extend(segments)
                            successful_cameras += 1
                            self.capture_status['segments_captured'] += len(segments)
                        else:
                            failed_cameras += 1
                            self.capture_status['errors'] += 1
                            
                        self.capture_status['cameras_processed'] += 1
                        
                    except Exception as e:
                        logger.error(f"Error processing camera {camera_id}: {e}")
                        failed_cameras += 1
                        self.capture_status['errors'] += 1
                        self.capture_status['cameras_processed'] += 1
            
            # Small delay between batches to be respectful to FL511 APIs
            if i + batch_size < len(cameras_to_process):
                time.sleep(2)
        
        # Store all metadata
        if all_video_segments:
            self.store_video_segments_metadata(all_video_segments)
            
            # Correlate incidents with captured video segments
            logger.info("🔗 Running incident-video correlation...")
            self.correlate_incidents_with_video_segments(
                correlation_radius_km=2.0,  # 2km radius for correlation
                time_window_minutes=60      # 1-hour time window
            )
        
        # Job summary
        job_end = datetime.now()
        job_duration = (job_end - job_start).total_seconds()
        
        results = {
            "status": "completed",
            "job_duration_seconds": job_duration,
            "cameras_found": len(all_cameras),
            "cameras_processed": len(cameras_to_process),
            "cameras_successful": successful_cameras,
            "cameras_failed": failed_cameras,
            "video_segments_captured": len(all_video_segments),
            "total_video_size_bytes": sum(s.get('segment_size', 0) for s in all_video_segments),
            "started_at": job_start.isoformat(),
            "completed_at": job_end.isoformat()
        }
        
        self.capture_status['active'] = False
        
        logger.info("=== I4-I95 Video Capture Job Complete ===")
        logger.info(f"Results: {json.dumps(results, indent=2)}")
        
        return results

    def authenticate_and_capture_camera(self, camera: Dict, segments_per_camera: int) -> List[Dict]:
        """
        Authenticate and capture video segments for a single camera
        
        Args:
            camera: Camera info from database
            segments_per_camera: Number of segments to capture
            
        Returns:
            List of captured segment metadata
        """
        try:
            camera_id = camera['camera_id']
            
            # Get authenticated stream info
            stream_info = self.video_auth.get_authenticated_stream_info(camera_id)
            if not stream_info:
                logger.warning(f"Failed to authenticate camera {camera_id}")
                return []
            
            # Download video segments
            segments = self.video_auth.download_video_segments(stream_info, segments_per_camera)
            if not segments:
                logger.warning(f"No segments captured for camera {camera_id}")
                return []
            
            # Store segments in Cloud Storage
            stored_segments = []
            for segment in segments:
                try:
                    # Upload to Cloud Storage
                    timestamp = datetime.now()
                    filename = f"camera_{camera_id}/{timestamp.strftime('%Y%m%d')}/{timestamp.strftime('%H%M%S')}_{segment['filename']}"
                    
                    bucket = self.storage_client.bucket(VIDEO_SEGMENTS_BUCKET)
                    blob = bucket.blob(filename)
                    
                    # Upload segment data
                    blob.upload_from_string(
                        segment['data'],
                        content_type='video/MP2T'
                    )
                    
                    # Set metadata
                    blob.metadata = {
                        'camera_id': camera_id,
                        'location': camera.get('location', ''),
                        'roadway': camera.get('roadway', ''),
                        'region': camera.get('region', ''),
                        'county': camera.get('county', ''),
                        'direction': camera.get('direction', ''),
                        'segment_duration': str(segment.get('duration', 0)),
                        'program_date_time': segment.get('program_date_time', ''),
                        'capture_timestamp': timestamp.isoformat(),
                        'segment_index': str(segment['segment_index'])
                    }
                    blob.patch()
                    
                    stored_segment = {
                        'camera_id': camera_id,
                        'filename': segment['filename'],
                        'storage_path': filename,
                        'storage_bucket': VIDEO_SEGMENTS_BUCKET,
                        'segment_size': segment['size_bytes'],
                        'segment_duration': segment.get('duration'),
                        'capture_timestamp': timestamp,
                        'program_date_time': segment.get('program_date_time'),
                        'segment_index': segment['segment_index'],
                        'storage_url': f"gs://{VIDEO_SEGMENTS_BUCKET}/{filename}",
                        'camera_location': camera.get('location', ''),
                        'camera_roadway': camera.get('roadway', ''),
                        'camera_region': camera.get('region', ''),
                        'camera_county': camera.get('county', ''),
                        'camera_direction': camera.get('direction', ''),
                        'latitude': camera.get('latitude'),
                        'longitude': camera.get('longitude')
                    }
                    
                    stored_segments.append(stored_segment)
                    logger.info(f"✅ Stored segment: {filename} ({segment['size_bytes']} bytes)")
                    
                except Exception as e:
                    logger.error(f"Error storing segment {segment['filename']} for camera {camera_id}: {e}")
                    continue
            
            return stored_segments
            
        except Exception as e:
            logger.error(f"Error in authenticate_and_capture_camera for {camera.get('camera_id', 'unknown')}: {e}")
            return []

    def run_capture_job(self, max_cameras: int = 10, segments_per_camera: int = 5) -> Dict:
        """
        Run a complete video capture job
        
        Args:
            max_cameras: Maximum cameras to process
            segments_per_camera: Segments to capture per camera
            
        Returns:
            Job results summary
        """
        job_start = datetime.now()
        logger.info("=== Starting FL 511 Video Capture Job ===")
        
        # Step 1: Fetch recent incidents
        incidents = self.fetch_recent_incidents(hours=24)
        if not incidents:
            return {"status": "no_incidents", "message": "No recent incidents found"}
        
        # Step 2: Get cameras associated with incidents
        cameras = self.get_cameras_for_incidents(incidents)
        if not cameras:
            return {"status": "no_cameras", "message": "No cameras found for incidents"}
        
        # Limit cameras to process
        cameras_to_process = cameras[:max_cameras]
        logger.info(f"Processing {len(cameras_to_process)} cameras")
        
        # Step 3: Process cameras in parallel
        all_video_segments = []
        successful_cameras = 0
        failed_cameras = 0
        
        with ThreadPoolExecutor(max_workers=5) as executor:
            # Submit authentication tasks
            auth_futures = {
                executor.submit(self.authenticate_camera_stream, str(camera['camera_id'])): camera
                for camera in cameras_to_process
            }
            
            # Process results as they complete
            for future in as_completed(auth_futures):
                camera = auth_futures[future]
                camera_id = camera['camera_id']
                
                try:
                    stream_info = future.result()
                    if stream_info:
                        # Capture video segments
                        segments = self.capture_video_segments(stream_info, segments_per_camera)
                        if segments:
                            all_video_segments.extend(segments)
                            successful_cameras += 1
                        else:
                            failed_cameras += 1
                    else:
                        failed_cameras += 1
                        
                except Exception as e:
                    logger.error(f"Error processing camera {camera_id}: {e}")
                    failed_cameras += 1
        
        # Step 4: Store metadata
        self.store_metadata(incidents, cameras_to_process, all_video_segments)
        
        # Job summary
        job_end = datetime.now()
        job_duration = (job_end - job_start).total_seconds()
        
        results = {
            "status": "completed",
            "job_duration_seconds": job_duration,
            "incidents_processed": len(incidents),
            "cameras_found": len(cameras),
            "cameras_processed": len(cameras_to_process),
            "cameras_successful": successful_cameras,
            "cameras_failed": failed_cameras,
            "video_segments_captured": len(all_video_segments),
            "total_video_size_bytes": sum(s['segment_size'] for s in all_video_segments),
            "started_at": job_start.isoformat(),
            "completed_at": job_end.isoformat()
        }
        
        logger.info("=== Video Capture Job Complete ===")
        logger.info(f"Results: {json.dumps(results, indent=2)}")
        
        return results


# Global pipeline instance
pipeline = VideoCapturePipeline()


@app.route('/health')
def health_check():
    """Health check endpoint"""
    return jsonify({"status": "healthy", "service": "fl511-video-capture"})


@app.route('/capture', methods=['POST'])
def trigger_capture():
    """Trigger I4-I95 video capture job"""
    try:
        data = request.get_json() or {}
        action = data.get('action', 'capture_all_i4_i95')
        
        if action == 'capture_all_i4_i95':
            max_cameras = data.get('max_cameras', 100)
            segments_per_camera = data.get('segments_per_camera', 5)
            batch_size = data.get('batch_size', 50)
            
            logger.info(f"I4-I95 capture triggered: max_cameras={max_cameras}, segments_per_camera={segments_per_camera}, batch_size={batch_size}")
            
            # Run I4-I95 capture job
            results = pipeline.run_i4_i95_capture_job(max_cameras, segments_per_camera, batch_size)
            
        else:
            # Fallback to original capture method
            max_cameras = data.get('max_cameras', 10)
            segments_per_camera = data.get('segments_per_camera', 5)
            
            logger.info(f"Legacy capture triggered: max_cameras={max_cameras}, segments_per_camera={segments_per_camera}")
            
            # Run legacy capture job
            results = pipeline.run_capture_job(max_cameras, segments_per_camera)
        
        return jsonify(results), 200
        
    except Exception as e:
        logger.error(f"Error in capture endpoint: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/capture_status')
def get_capture_status():
    """Get current capture status"""
    status = pipeline.capture_status.copy()
    if status['start_time']:
        status['start_time'] = status['start_time'].isoformat()
    if status['active']:
        status['runtime_seconds'] = (datetime.now() - pipeline.capture_status['start_time']).total_seconds()
    
    return jsonify(status), 200

@app.route('/start_continuous_capture', methods=['POST'])
def start_continuous_capture():
    """Start continuous capture for specified duration"""
    try:
        data = request.get_json() or {}
        duration_hours = data.get('duration_hours', 24)
        capture_interval_minutes = data.get('capture_interval_minutes', 2)
        max_cameras_per_batch = data.get('max_cameras_per_batch', 100)
        segments_per_camera = data.get('segments_per_camera', 5)
        enable_incident_correlation = data.get('enable_incident_correlation', True)
        
        logger.info(f"Starting continuous capture for {duration_hours} hours")
        logger.info(f"Capture every {capture_interval_minutes} minutes, {max_cameras_per_batch} cameras per batch")
        
        # Start background thread for continuous capture
        def continuous_capture_worker():
            start_time = datetime.now()
            end_time = start_time + timedelta(hours=duration_hours)
            capture_count = 0
            
            while datetime.now() < end_time:
                try:
                    logger.info(f"=== Continuous Capture Round {capture_count + 1} ===")
                    
                    # Run capture job
                    results = pipeline.run_i4_i95_capture_job(
                        max_cameras=max_cameras_per_batch,
                        segments_per_camera=segments_per_camera,
                        batch_size=50
                    )
                    
                    capture_count += 1
                    logger.info(f"Completed capture round {capture_count}: {results.get('cameras_successful', 0)} successful")
                    
                    # Wait for next interval
                    if datetime.now() < end_time:
                        sleep_seconds = capture_interval_minutes * 60
                        logger.info(f"Waiting {capture_interval_minutes} minutes for next capture...")
                        time.sleep(sleep_seconds)
                    
                except Exception as e:
                    logger.error(f"Error in continuous capture round {capture_count + 1}: {e}")
                    time.sleep(60)  # Wait 1 minute before retry
            
            logger.info(f"=== Continuous Capture Complete: {capture_count} rounds in {duration_hours} hours ===")
        
        # Start background thread
        thread = threading.Thread(target=continuous_capture_worker, daemon=True)
        thread.start()
        
        return jsonify({
            "status": "started",
            "duration_hours": duration_hours,
            "capture_interval_minutes": capture_interval_minutes,
            "max_cameras_per_batch": max_cameras_per_batch,
            "segments_per_camera": segments_per_camera,
            "started_at": datetime.now().isoformat()
        }), 200
        
    except Exception as e:
        logger.error(f"Error starting continuous capture: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/scrape_incidents', methods=['POST'])
def scrape_incidents():
    """Scrape current incidents from FL511"""
    try:
        data = request.get_json() or {}
        regions = data.get('regions', ['Central', 'Northeast', 'Southeast', 'Tampa Bay'])
        
        logger.info(f"Scraping incidents for regions: {regions}")
        
        # Fetch incidents
        incidents = pipeline.fetch_recent_incidents(hours=24)
        
        # Filter by regions if specified  
        if regions and regions != ['ALL']:
            filtered_incidents = [
                incident for incident in incidents 
                if incident.region in regions
            ]
            logger.info(f"Filtered {len(incidents)} incidents to {len(filtered_incidents)} for regions {regions}")
        else:
            filtered_incidents = incidents
            logger.info(f"Using all {len(incidents)} incidents (no region filtering)")
        
        # Store incidents in database
        logger.info(f"Attempting to store {len(filtered_incidents)} incidents (db_pool: {pipeline.db_pool is not None})")
        if filtered_incidents and pipeline.db_pool:
            logger.info("Starting database insertion...")
            try:
                with pipeline.db_pool.connect() as conn:
                    for incident in filtered_incidents:
                        conn.execute(text("""
                            INSERT INTO incidents 
                            (incident_id, dt_row_id, source_id, roadway_name, county, region, incident_type, 
                             severity, direction, description, start_date, last_updated, source, scraped_at)
                            VALUES (:incident_id, :dt_row_id, :source_id, :roadway_name, :county, :region, :incident_type,
                                    :severity, :direction, :description, :start_date, :last_updated, :source, :scraped_at)
                            ON CONFLICT (incident_id) DO UPDATE SET
                                last_updated = EXCLUDED.last_updated,
                                description = EXCLUDED.description,
                                updated_at = CURRENT_TIMESTAMP
                        """), {
                            'incident_id': incident.id,
                            'dt_row_id': incident.dt_row_id,
                            'source_id': incident.source_id,
                            'roadway_name': incident.roadway_name,
                            'county': incident.county,
                            'region': incident.region,
                            'incident_type': incident.incident_type,
                            'severity': incident.severity,
                            'direction': incident.direction,
                            'description': incident.description,
                            'start_date': incident.start_date,
                            'last_updated': incident.last_updated,
                            'source': incident.source,
                            'scraped_at': incident.scraped_at
                        })
                    conn.commit()
                    logger.info(f"Stored {len(filtered_incidents)} incidents in database")
            except Exception as e:
                logger.error(f"Error storing incidents: {e}")
        
        return jsonify({
            "status": "completed",
            "total_incidents": len(incidents),
            "filtered_incidents": len(filtered_incidents),
            "regions": regions,
            "scraped_at": datetime.now().isoformat()
        }), 200
        
    except Exception as e:
        logger.error(f"Error scraping incidents: {e}")
        return jsonify({"error": str(e)}), 500


@app.route('/status')
def get_status():
    """Get service status"""
    return jsonify({
        "service": "fl511-video-capture",
        "project_id": PROJECT_ID,
        "region": REGION,
        "database_available": pipeline.db_pool is not None,
        "storage_buckets": {
            "video_segments": VIDEO_SEGMENTS_BUCKET,
            "incident_metadata": INCIDENT_METADATA_BUCKET,
            "camera_metadata": CAMERA_METADATA_BUCKET
        }
    })


@app.route('/')
def index():
    """Root endpoint"""
    return jsonify({
        "service": "FL 511 Video Capture Service",
        "endpoints": {
            "/health": "Health check",
            "/capture": "Trigger video capture (POST)",
            "/status": "Service status"
        }
    })


if __name__ == '__main__':
    # Run Flask app
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port, debug=False)