#!/usr/bin/env python3
"""
FL-511 Crash Alert Monitor

Continuously monitors FL-511 incidents for crashes and triggers immediate video capture
from nearby cameras when crash incidents are detected.

This module:
1. Polls FL-511 incidents API every 5 seconds
2. Detects new crash-related incidents (case-insensitive "crash" detection)
3. Finds cameras near crash locations
4. Triggers immediate 5-minute video capture from those cameras
5. Stores incident and video metadata in database
"""

import time
import json
import logging
import psycopg2
from datetime import datetime, timedelta
from typing import Dict, List, Set, Optional
from concurrent.futures import ThreadPoolExecutor
from google.cloud import storage

# Import existing modules
from fl511_scraper import FL511Scraper, TrafficIncident
from fl511_video_auth_production import FL511VideoAuthProduction
from fl511_camera_search import FL511CameraSearch
import requests
import urllib.parse

# Configure logging
logging.basicConfig(
    level=logging.INFO, 
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('crash_alert_monitor.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class CrashAlertMonitor:
    """Monitor for crash incidents and trigger video capture"""
    
    def __init__(self, 
                 poll_interval: int = 5,
                 video_capture_duration: int = 300,  # 5 minutes in seconds
                 max_cameras_per_crash: int = 5,
                 gcs_bucket: str = 'avocado-fl511-video-fl511-video-segments'):
        """
        Initialize crash alert monitor
        
        Args:
            poll_interval: Seconds between incident polls
            video_capture_duration: Seconds to capture video after crash detected
            max_cameras_per_crash: Maximum cameras to capture per crash incident
            gcs_bucket: GCS bucket for video storage
        """
        self.poll_interval = poll_interval
        self.video_capture_duration = video_capture_duration
        self.max_cameras_per_crash = max_cameras_per_crash
        self.gcs_bucket = gcs_bucket
        
        # Initialize services
        self.incident_scraper = FL511Scraper()
        self.video_auth = FL511VideoAuthProduction()
        self.camera_search = FL511CameraSearch()
        
        # Database config
        self.db_config = {
            'host': '34.42.128.70',
            'database': 'fl511_incidents',
            'user': 'fl511_user',
            'password': 'AfUa9sQ7r6PcXufDVPJhwK'
        }
        
        # Initialize GCS client
        try:
            self.storage_client = storage.Client()
            logger.info(f"✅ GCS client initialized for bucket: {self.gcs_bucket}")
        except Exception as e:
            logger.warning(f"GCS credentials not configured: {e}. Video storage will be skipped.")
            self.storage_client = None
        
        # Track processed incidents to avoid duplicates
        self.processed_incidents: Set[int] = set()
        
        # Track active video capture sessions
        self.active_captures: Dict[int, Dict] = {}
        
        # Load existing incident IDs from database on startup
        self._load_existing_incident_ids()
        
        logger.info("🚨 Crash Alert Monitor initialized")
        logger.info(f"   Poll interval: {poll_interval} seconds")
        logger.info(f"   Video capture duration: {video_capture_duration/60:.1f} minutes")
        logger.info(f"   Max cameras per crash: {max_cameras_per_crash}")
        logger.info("   🔑 AUTH MODE: Dynamic camera authentication with fresh FL-511 API calls")
    

    
    def _load_existing_incident_ids(self):
        """Load all existing incident IDs from database to avoid reprocessing"""
        try:
            conn = psycopg2.connect(**self.db_config)
            cur = conn.cursor()
            
            cur.execute("SELECT DISTINCT incident_id FROM incidents")
            existing_ids = cur.fetchall()
            
            # Add all existing incident IDs to the processed set
            for (incident_id,) in existing_ids:
                # self.processed_incidents.add(incident_id)
                print(incident_id)
            
            conn.close()
            
            logger.info(f"📚 Loaded {len(self.processed_incidents)} existing incident IDs from database")
            
        except Exception as e:
            logger.error(f"❌ Failed to load existing incident IDs: {e}")
            # Continue with empty set if database load fails
    
    def is_crash_incident(self, incident: TrafficIncident) -> bool:
        """
        Check if incident is crash-related (case-insensitive)
        
        Args:
            incident: Traffic incident to check
            
        Returns:
            True if incident contains "crash" in type or description
        """
        crash_keywords = ['crash', 'accident', 'collision', 'wreck']
        
        # Check incident type
        incident_type = incident.incident_type.lower()
        if any(keyword in incident_type for keyword in crash_keywords):
            return True
        
        # Check description
        description = incident.description.lower()
        if any(keyword in description for keyword in crash_keywords):
            return True
        
        return False
    
    def find_nearby_cameras(self, incident: TrafficIncident) -> List[Dict]:
        """
        Find cameras near the incident location using FL511 Camera Search API
        
        Args:
            incident: Traffic incident
            
        Returns:
            List of nearby camera metadata with video URLs and relevance scoring
        """
        # Convert TrafficIncident to dict format for camera search
        incident_data = {
            'id': incident.id,
            'roadwayName': incident.roadway_name,
            'description': incident.description,
            'county': incident.county,
            'region': incident.region,
            'direction': incident.direction
        }
        
        # Use FL511 Camera Search API to find relevant cameras
        cameras = self.camera_search.search_cameras_for_incident(incident_data)
        
        # Convert camera search results to format expected by video capture
        formatted_cameras = []
        for camera in cameras[:self.max_cameras_per_crash]:
            # Extract camera data from search results
            formatted_camera = {
                'camera_id': camera['camera_id'],
                'video_url': camera['video_url'], 
                'description': camera['description'],
                'roadway': camera['roadway'],
                'region': camera['region'],
                'county': camera['county'],
                'direction': camera['direction'],
                'coordinates': camera['coordinates'],
                'relevance_score': camera['relevance_score'],
                # Include raw camera data for video auth if needed
                'raw_camera_data': camera.get('raw_camera_data', {})
            }
            formatted_cameras.append(formatted_camera)
        
        logger.info(f"📍 Camera search found {len(formatted_cameras)} relevant cameras")
        for i, cam in enumerate(formatted_cameras, 1):
            logger.info(f"   {i}. Camera {cam['camera_id']} (Score: {cam['relevance_score']:.1f}) - {cam['description']}")
        
        return formatted_cameras
    

    def capture_crash_video(self, incident: TrafficIncident, cameras: List[Dict]) -> Dict:
        """
        Capture video from cameras for crash incident
        
        Args:
            incident: Crash incident
            cameras: List of camera metadata
            
        Returns:
            Capture results summary
        """
        capture_start = datetime.now()
        capture_results = {
            'incident_id': incident.id,
            'capture_start': capture_start.isoformat(),
            'cameras_attempted': len(cameras),
            'cameras_successful': 0,
            'cameras_failed': 0,
            'video_segments': [],
            'total_size_bytes': 0
        }
        
        logger.info(f"🎬 Starting crash video capture for incident {incident.id}")
        logger.info(f"   Incident: {incident.description[:100]}...")
        logger.info(f"   Location: {incident.roadway_name}, {incident.region}")
        logger.info(f"   Cameras: {len(cameras)}")
        
        # Calculate how many segments to capture (5 minutes at ~2 seconds per segment)
        segments_to_capture = max(1, self.video_capture_duration // 2)  # ~150 segments for 5 minutes
        
        def capture_camera_video(camera: Dict) -> Optional[Dict]:
            """Capture video from a single camera"""
            camera_id = camera.get('camera_id')
            print("camera_id", camera_id)
            if not camera_id or camera_id == 'unknown':
                logger.warning(f"⚠️ Skipping camera with invalid ID: {camera_id}")
                return None
                
            try:
                logger.info(f"📹 Capturing from camera {camera_id}: {camera.get('description', 'Unknown')}")
                
                # Use FL511VideoAuthProduction with dynamic camera data
                logger.info(f"🔑 Authenticating dynamic camera {camera_id}")
                stream_info = self.video_auth.authenticate_camera_with_data(camera)
                if not stream_info:
                    logger.warning(f"❌ Failed to authenticate camera {camera_id}")
                    return None

                logger.info(f"✅ Dynamic camera authenticated for {camera_id}")
                logger.info(f"   Streaming URL: {stream_info.get('streaming_url', 'N/A')}")

                # Download video segments
                segments = self.video_auth.download_video_segments(stream_info, segments_to_capture)
                if not segments:
                    logger.warning(f"❌ No segments captured from camera {camera_id}")
                    return None
                
                # Store segments in GCS (using same pattern as working video_capture_service.py)
                stored_segments = []
                for segment in segments:
                    if self.storage_client:
                        try:
                            # Validate segment data
                            segment_data = segment.get('data')
                            if not segment_data or not isinstance(segment_data, bytes):
                                logger.warning(f"⚠️ Invalid or missing segment data for {segment.get('filename', 'unknown')}: {type(segment_data)}")
                                continue
                            
                            # Create GCS path using same pattern as working video_capture_service.py
                            gcs_path = f"camera_{camera_id}/{capture_start.strftime('%Y%m%d')}/{segment['filename']}"
                            
                            logger.info(f"📤 Uploading to GCS: gs://{self.gcs_bucket}/{gcs_path}")
                            logger.info(f"   Segment size: {len(segment_data):,} bytes")
                            
                            # Upload to GCS
                            bucket = self.storage_client.bucket(self.gcs_bucket)
                            blob = bucket.blob(gcs_path)
                            
                            # Upload with metadata
                            blob.upload_from_string(
                                segment_data,
                                content_type='video/MP2T'  # MPEG-TS format
                            )
                            
                            # Set metadata
                            blob.metadata = {
                                'incident_id': str(incident.id),
                                'camera_id': str(camera_id),
                                'capture_timestamp': capture_start.isoformat(),
                                'incident_type': str(incident.incident_type or ''),
                                'roadway': str(incident.roadway_name or ''),
                                'description': str(incident.description or '')[:200]
                            }
                            blob.patch()
                            
                            logger.info(f"✅ Successfully uploaded segment to GCS: gs://{self.gcs_bucket}/{gcs_path}")
                            
                            stored_segments.append({
                                'camera_id': camera_id,  # Add camera_id to each stored segment
                                'filename': segment['filename'],
                                'gcs_path': gcs_path,
                                'storage_url': f"gs://{self.gcs_bucket}/{gcs_path}",
                                'size_bytes': segment['size_bytes'],
                                'duration': segment.get('duration', 0),
                                'program_date_time': segment.get('program_date_time')
                            })
                            
                        except Exception as e:
                            logger.error(f"❌ Failed to store segment {segment['filename']} in GCS: {e}")
                            continue
                
                camera_result = {
                    'camera_id': camera_id,
                    'description': camera.get('description', 'Unknown'),
                    'segments_captured': len(stored_segments),
                    'total_size': sum(s['size_bytes'] for s in stored_segments),
                    'segments': stored_segments
                }
                
                logger.info(f"✅ Camera {camera_id}: {len(stored_segments)} segments, {camera_result['total_size']:,} bytes")
                return camera_result
                
            except Exception as e:
                logger.error(f"❌ Error capturing from camera {camera_id}: {e}")
                return None
        
        # Capture from multiple cameras in parallel
        with ThreadPoolExecutor(max_workers=3) as executor:
            camera_results = list(executor.map(capture_camera_video, cameras))
        
        # Process results
        for result in camera_results:
            if result:
                capture_results['cameras_successful'] += 1
                logger.info(f"🔍 Debug: camera result segments: {result['segments']}")
                for seg in result['segments']:
                    logger.info(f"🔍 Debug: segment keys before adding to video_segments: {list(seg.keys())}")
                capture_results['video_segments'].extend(result['segments'])
                capture_results['total_size_bytes'] += result['total_size']
            else:
                capture_results['cameras_failed'] += 1
        
        capture_end = datetime.now()
        capture_results['capture_end'] = capture_end.isoformat()
        capture_results['capture_duration_seconds'] = (capture_end - capture_start).total_seconds()
        
        logger.info(f"🎯 Crash video capture complete for incident {incident.id}")
        logger.info(f"   Duration: {capture_results['capture_duration_seconds']:.1f}s")
        logger.info(f"   Successful cameras: {capture_results['cameras_successful']}")
        logger.info(f"   Total segments: {len(capture_results['video_segments'])}")
        logger.info(f"   Total size: {capture_results['total_size_bytes']:,} bytes")
        
        return capture_results
    
    def store_crash_incident(self, incident: TrafficIncident, video_results: Dict):
        """
        Store crash incident and video metadata in database
        
        Args:
            incident: Crash incident
            video_results: Video capture results
        """
        try:
            conn = psycopg2.connect(**self.db_config)
            cur = conn.cursor()
            
            # Insert incident
            cur.execute('''
                INSERT INTO incidents 
                (incident_id, dt_row_id, source_id, roadway_name, county, region, 
                 incident_type, severity, direction, description, start_date, 
                 last_updated, source, scraped_at)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (incident_id) DO UPDATE SET
                    last_updated = EXCLUDED.last_updated,
                    description = EXCLUDED.description,
                    updated_at = CURRENT_TIMESTAMP
            ''', (
                incident.id, incident.dt_row_id, incident.source_id,
                incident.roadway_name, incident.county, incident.region,
                incident.incident_type, incident.severity, incident.direction,
                incident.description, incident.start_date, incident.last_updated,
                incident.source, incident.scraped_at
            ))
            
            # Store video capture metadata
            logger.info(f"🔍 Debug: video_results keys: {video_results.keys()}")
            logger.info(f"🔍 Debug: number of video segments: {len(video_results.get('video_segments', []))}")
            
            for i, segment in enumerate(video_results['video_segments']):
                logger.info(f"🔍 Debug segment {i}: {segment}")
                logger.info(f"🔍 Debug segment keys: {list(segment.keys())}")
                
                # Check if camera_id exists
                if 'camera_id' not in segment:
                    logger.error(f"❌ Missing camera_id in segment {i}: {segment}")
                    continue
                    
                camera_id = segment['camera_id']
                logger.info(f"🔍 Debug: using camera_id = '{camera_id}' for segment {segment.get('filename', 'unknown')}")
                
                try:
                    cur.execute('''
                        INSERT INTO video_segments
                        (camera_id, segment_filename, storage_bucket, storage_path, storage_url,
                         segment_duration, segment_size_bytes, segment_index, capture_timestamp,
                         camera_latitude, camera_longitude, camera_roadway, camera_region, camera_county,
                         incident_id)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        ON CONFLICT (camera_id, segment_filename) DO NOTHING
                    ''', (
                        camera_id,
                        segment['filename'],
                        self.gcs_bucket,
                        segment['gcs_path'],
                        segment['storage_url'],
                        segment.get('duration', 0),
                        segment['size_bytes'],
                        0,  # segment_index
                        video_results['capture_start'],
                        None, None,  # lat/lon - would need to look up from camera
                        incident.roadway_name,
                        incident.region,
                        incident.county,
                        incident.id  # incident_id for correlation
                    ))
                    logger.info(f"✅ Successfully inserted segment {segment['filename']} for camera {camera_id}")
                except Exception as segment_error:
                    logger.error(f"❌ Failed to insert segment {segment.get('filename', 'unknown')} for camera {camera_id}: {segment_error}")
                    continue
            
            conn.commit()
            conn.close()
            
            logger.info(f"💾 Stored crash incident {incident.id} and {len(video_results['video_segments'])} video segments in database")
            
        except Exception as e:
            logger.error(f"❌ Failed to store crash incident {incident.id} in database: {e}")
    
    def poll_incidents(self) -> List[TrafficIncident]:
        """
        Poll FL-511 for new incidents using pagination to get all incidents
        
        Returns:
            List of new crash incidents
        """
        try:
            # Fetch ALL incidents using pagination (no page limit)
            logger.info("📡 Fetching all current incidents from FL-511...")
            incidents = self.incident_scraper.fetch_incidents(max_pages=None)  # Get all pages
            if not incidents:
                return []
            
            logger.info(f"📊 Retrieved {len(incidents)} total incidents from FL-511")
            
            # Filter to new crash incidents only (no time filtering)
            new_crash_incidents = []
            skipped_existing = 0
            
            for incident in incidents:
                if incident.id in self.processed_incidents:
                    skipped_existing += 1
                    continue
                    
                if self.is_crash_incident(incident):
                    new_crash_incidents.append(incident)
                    self.processed_incidents.add(incident.id)
                else:
                    # Still mark non-crash incidents as processed to avoid checking them again
                    self.processed_incidents.add(incident.id)
            
            logger.info(f"📈 Processing summary:")
            logger.info(f"   Total incidents: {len(incidents)}")
            logger.info(f"   Already processed: {skipped_existing}")
            logger.info(f"   New crashes found: {len(new_crash_incidents)}")
            
            if new_crash_incidents:
                logger.info(f"🚨 NEW CRASH INCIDENTS:")
                for incident in new_crash_incidents:
                    logger.info(f"   {incident.id}: {incident.description[:100]}...")
            
            return new_crash_incidents
            
        except Exception as e:
            logger.error(f"❌ Error polling incidents: {e}")
            return []
    
    def run(self):
        """
        Main monitoring loop - runs continuously until interrupted
        """
        logger.info("🚨 Starting FL-511 Crash Alert Monitor")
        logger.info(f"   Monitoring for crashes every {self.poll_interval} seconds")
        logger.info("   Press Ctrl+C to stop")
        
        try:
            while True:
                loop_start = time.time()
                
                # Poll for new crash incidents
                crash_incidents = self.poll_incidents()
                
                # Process each new crash
                for incident in crash_incidents:
                    try:
                        logger.info(f"🚨 CRASH DETECTED: {incident.id}")
                        logger.info(f"   Description: {incident.description}")
                        logger.info(f"   Location: {incident.roadway_name}, {incident.region}")
                        
                        # Find nearby cameras
                        cameras = self.find_nearby_cameras(incident)
                        if not cameras:
                            logger.warning(f"❌ No cameras found near crash {incident.id}")
                            continue
                        
                        logger.info(f"📹 Found {len(cameras)} cameras near crash location")
                        
                        # Capture video from nearby cameras
                        video_results = self.capture_crash_video(incident, cameras)
                        
                        # Store incident and video metadata
                        self.store_crash_incident(incident, video_results)
                        
                        logger.info(f"✅ Crash {incident.id} processing complete")
                        
                    except Exception as e:
                        logger.error(f"❌ Error processing crash {incident.id}: {e}")
                
                # Wait for next poll (accounting for processing time)
                loop_duration = time.time() - loop_start
                sleep_time = max(0, self.poll_interval - loop_duration)
                if sleep_time > 0:
                    time.sleep(sleep_time)
                
        except KeyboardInterrupt:
            logger.info("🛑 Crash Alert Monitor stopped by user")
        except Exception as e:
            logger.error(f"💥 Crash Alert Monitor crashed: {e}")
            raise


def main():
    """Run the crash alert monitor"""
    import argparse
    
    parser = argparse.ArgumentParser(description='FL-511 Crash Alert Monitor')
    parser.add_argument('--poll-interval', type=int, default=5, help='Seconds between polls')
    parser.add_argument('--capture-duration', type=int, default=300, help='Video capture duration in seconds')
    parser.add_argument('--max-cameras', type=int, default=5, help='Max cameras per crash')
    parser.add_argument('--gcs-bucket', default='avocado-fl511-video-fl511-video-segments', help='GCS bucket for videos')
    
    args = parser.parse_args()
    
    # Create and run monitor
    monitor = CrashAlertMonitor(
        poll_interval=args.poll_interval,
        video_capture_duration=args.capture_duration,
        max_cameras_per_crash=args.max_cameras,
        gcs_bucket=args.gcs_bucket
    )
    
    monitor.run()


if __name__ == "__main__":
    main()