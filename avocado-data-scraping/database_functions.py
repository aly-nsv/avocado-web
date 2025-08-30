#!/usr/bin/env python3
"""
FL511 Database Functions
Clean insertion and correlation functions for video segments and incidents
"""

import json
from datetime import datetime
from typing import Dict, List, Optional
import uuid

class FL511Database:
    def __init__(self, db_connection):
        """Initialize with database connection"""
        self.db = db_connection
    
    def insert_cameras_from_json(self, cameras_file: str):
        """
        Load camera data from fl511_i4_i95_cameras.json into database
        
        Args:
            cameras_file: Path to camera JSON file
        """
        with open(cameras_file, 'r') as f:
            data = json.load(f)
        
        cameras = data['cameras']
        inserted = 0
        
        with self.db.connect() as conn:
            for camera in cameras:
                conn.execute("""
                    INSERT INTO cameras (
                        camera_id, name, description, latitude, longitude,
                        roadway, direction, region, county, location,
                        install_date, equipment_type
                    ) VALUES (
                        %(camera_id)s, %(name)s, %(description)s, %(latitude)s, %(longitude)s,
                        %(roadway)s, %(direction)s, %(region)s, %(county)s, %(location)s,
                        %(install_date)s, %(equipment_type)s
                    ) ON CONFLICT (camera_id) DO UPDATE SET
                        updated_at = CURRENT_TIMESTAMP
                """, {
                    'camera_id': camera['id'],
                    'name': camera.get('name', ''),
                    'description': camera.get('description', ''),
                    'latitude': camera.get('latitude'),
                    'longitude': camera.get('longitude'),
                    'roadway': camera.get('roadway'),
                    'direction': camera.get('direction'),
                    'region': camera.get('region'),
                    'county': camera.get('county'),
                    'location': camera.get('location'),
                    'install_date': camera.get('install_date'),
                    'equipment_type': camera.get('equipment_type')
                })
                inserted += 1
            
            conn.commit()
        
        print(f"✅ Inserted {inserted} cameras into database")
        return inserted
    
    def insert_incident(self, incident_data: Dict) -> bool:
        """
        Insert a single incident from FL511 API response
        
        Args:
            incident_data: Incident dictionary from FL511 API
            
        Returns:
            True if inserted successfully
        """
        try:
            with self.db.connect() as conn:
                # Parse start_date from FL511 format "8/27/25, 10:35 PM"
                start_date_str = incident_data.get('start_date', '')
                try:
                    start_date = datetime.strptime(start_date_str, '%m/%d/%y, %I:%M %p')
                except:
                    start_date = datetime.now()
                
                # Parse last_updated similarly
                last_updated_str = incident_data.get('last_updated', '')
                try:
                    last_updated = datetime.strptime(last_updated_str, '%m/%d/%y, %I:%M %p')
                except:
                    last_updated = datetime.now()
                
                conn.execute("""
                    INSERT INTO incidents (
                        incident_id, dt_row_id, source_id, roadway_name, county, region,
                        incident_type, severity, direction, description, start_date,
                        last_updated, end_date, source, dot_district, location_description,
                        detour_description, lane_description, scraped_at
                    ) VALUES (
                        %(incident_id)s, %(dt_row_id)s, %(source_id)s, %(roadway_name)s, 
                        %(county)s, %(region)s, %(incident_type)s, %(severity)s, 
                        %(direction)s, %(description)s, %(start_date)s, %(last_updated)s,
                        %(end_date)s, %(source)s, %(dot_district)s, %(location_description)s,
                        %(detour_description)s, %(lane_description)s, %(scraped_at)s
                    ) ON CONFLICT (incident_id) DO UPDATE SET
                        last_updated = EXCLUDED.last_updated,
                        description = EXCLUDED.description,
                        updated_at = CURRENT_TIMESTAMP
                """, {
                    'incident_id': incident_data.get('id'),
                    'dt_row_id': incident_data.get('dt_row_id'),
                    'source_id': incident_data.get('source_id'),
                    'roadway_name': incident_data.get('roadway_name'),
                    'county': incident_data.get('county'),
                    'region': incident_data.get('region'),
                    'incident_type': incident_data.get('incident_type'),
                    'severity': incident_data.get('severity'),
                    'direction': incident_data.get('direction'),
                    'description': incident_data.get('description'),
                    'start_date': start_date,
                    'last_updated': last_updated,
                    'end_date': None,  # FL511 doesn't provide end dates
                    'source': incident_data.get('source'),
                    'dot_district': incident_data.get('dot_district'),
                    'location_description': incident_data.get('location_description'),
                    'detour_description': incident_data.get('detour_description'),
                    'lane_description': incident_data.get('lane_description'),
                    'scraped_at': datetime.now()
                })
                
                conn.commit()
                return True
                
        except Exception as e:
            print(f"Error inserting incident {incident_data.get('id')}: {e}")
            return False
    
    def insert_video_segment(self, segment_data: Dict, session_id: Optional[str] = None) -> bool:
        """
        Insert a video segment with complete metadata
        
        Args:
            segment_data: Video segment data from capture process
            session_id: Optional capture session UUID for grouping related segments
            
        Returns:
            True if inserted successfully
        """
        try:
            with self.db.connect() as conn:
                # Get camera location data for correlation efficiency
                camera_result = conn.execute("""
                    SELECT latitude, longitude, roadway, region, county
                    FROM cameras WHERE camera_id = %(camera_id)s
                """, {'camera_id': segment_data['camera_id']})
                
                camera_row = camera_result.fetchone()
                if not camera_row:
                    print(f"Warning: Camera {segment_data['camera_id']} not found in cameras table")
                    return False
                
                conn.execute("""
                    INSERT INTO video_segments (
                        camera_id, segment_filename, storage_bucket, storage_path, storage_url,
                        segment_duration, segment_size_bytes, segment_index, program_date_time,
                        capture_timestamp, capture_session_id,
                        camera_latitude, camera_longitude, camera_roadway, camera_region, camera_county
                    ) VALUES (
                        %(camera_id)s, %(segment_filename)s, %(storage_bucket)s, %(storage_path)s, %(storage_url)s,
                        %(segment_duration)s, %(segment_size_bytes)s, %(segment_index)s, %(program_date_time)s,
                        %(capture_timestamp)s, %(capture_session_id)s,
                        %(camera_latitude)s, %(camera_longitude)s, %(camera_roadway)s, %(camera_region)s, %(camera_county)s
                    ) ON CONFLICT (camera_id, segment_filename) DO UPDATE SET
                        capture_timestamp = EXCLUDED.capture_timestamp,
                        capture_session_id = EXCLUDED.capture_session_id
                """, {
                    'camera_id': segment_data.get('camera_id'),
                    'segment_filename': segment_data.get('filename'),
                    'storage_bucket': segment_data.get('storage_bucket'),
                    'storage_path': segment_data.get('storage_path'),
                    'storage_url': segment_data.get('storage_url'),
                    'segment_duration': segment_data.get('segment_duration'),
                    'segment_size_bytes': segment_data.get('segment_size'),
                    'segment_index': segment_data.get('segment_index'),
                    'program_date_time': segment_data.get('program_date_time'),
                    'capture_timestamp': segment_data.get('capture_timestamp'),
                    'capture_session_id': session_id,
                    'camera_latitude': camera_row[0],
                    'camera_longitude': camera_row[1],
                    'camera_roadway': camera_row[2],
                    'camera_region': camera_row[3],
                    'camera_county': camera_row[4]
                })
                
                conn.commit()
                return True
                
        except Exception as e:
            print(f"Error inserting video segment {segment_data.get('filename')}: {e}")
            return False
    
    def run_correlation(self, radius_km: float = 2.0, time_window_minutes: int = 60) -> int:
        """
        Run incident-video correlation using database function
        
        Args:
            radius_km: Maximum distance for correlation
            time_window_minutes: Time window around incident start time
            
        Returns:
            Number of correlations created
        """
        with self.db.connect() as conn:
            result = conn.execute("""
                SELECT correlate_incidents_with_videos(%(radius)s, %(time_window)s)
            """, {
                'radius': radius_km,
                'time_window': time_window_minutes
            })
            
            correlations_created = result.fetchone()[0]
            print(f"✅ Created {correlations_created} incident-video correlations")
            
            # Show some examples
            examples = conn.execute("""
                SELECT 
                    i.incident_id,
                    i.roadway_name,
                    i.incident_type,
                    LEFT(i.description, 50) as short_description,
                    vs.camera_id,
                    c.distance_km,
                    c.confidence_score,
                    vs.segment_filename
                FROM correlations c
                JOIN incidents i ON c.incident_id = i.incident_id
                JOIN video_segments vs ON c.segment_id = vs.segment_id
                ORDER BY c.correlation_timestamp DESC
                LIMIT 5
            """).fetchall()
            
            print("\n📹 Recent correlations:")
            for example in examples:
                print(f"  Incident {example[0]} ({example[1]} {example[2]}) "
                      f"→ Camera {example[4]} ({example[5]:.1f}km, {example[6]:.2f} confidence) "
                      f"→ {example[7]}")
            
            return correlations_created
    
    def get_incidents_for_video_segment(self, segment_filename: str) -> List[Dict]:
        """
        Find all incidents correlated with a specific video segment
        
        Args:
            segment_filename: Name of the video segment file
            
        Returns:
            List of incident dictionaries
        """
        with self.db.connect() as conn:
            results = conn.execute("""
                SELECT 
                    i.incident_id,
                    i.roadway_name,
                    i.incident_type,
                    i.description,
                    i.start_date,
                    c.distance_km,
                    c.confidence_score,
                    c.time_offset_minutes
                FROM incidents i
                JOIN correlations c ON i.incident_id = c.incident_id
                JOIN video_segments vs ON c.segment_id = vs.segment_id
                WHERE vs.segment_filename = %(filename)s
                ORDER BY c.confidence_score DESC
            """, {'filename': segment_filename})
            
            incidents = []
            for row in results:
                incidents.append({
                    'incident_id': row[0],
                    'roadway_name': row[1],
                    'incident_type': row[2],
                    'description': row[3],
                    'start_date': row[4],
                    'distance_km': float(row[5]),
                    'confidence_score': float(row[6]),
                    'time_offset_minutes': row[7]
                })
            
            return incidents
    
    def get_video_segments_for_incident(self, incident_id: int) -> List[Dict]:
        """
        Find all video segments correlated with a specific incident
        
        Args:
            incident_id: FL511 incident ID
            
        Returns:
            List of video segment dictionaries
        """
        with self.db.connect() as conn:
            results = conn.execute("""
                SELECT 
                    vs.camera_id,
                    vs.segment_filename,
                    vs.storage_url,
                    vs.capture_timestamp,
                    c.distance_km,
                    c.confidence_score,
                    c.time_offset_minutes
                FROM video_segments vs
                JOIN correlations c ON vs.segment_id = c.segment_id
                WHERE c.incident_id = %(incident_id)s
                ORDER BY c.confidence_score DESC, c.distance_km ASC
            """, {'incident_id': incident_id})
            
            segments = []
            for row in results:
                segments.append({
                    'camera_id': row[0],
                    'segment_filename': row[1],
                    'storage_url': row[2],
                    'capture_timestamp': row[3],
                    'distance_km': float(row[4]),
                    'confidence_score': float(row[5]),
                    'time_offset_minutes': row[6]
                })
            
            return segments

# =============================================================================
# EXAMPLE USAGE
# =============================================================================

"""
# Initialize database connection
from sqlalchemy import create_engine
engine = create_engine('postgresql://user:password@host/database')
db = FL511Database(engine)

# Load cameras
db.insert_cameras_from_json('fl511_i4_i95_cameras.json')

# Insert incident (from FL511 API response)
incident_data = {
    'id': 260338,
    'roadway_name': 'I-4',
    'incident_type': 'Accident',
    'description': 'Vehicle accident on I-4',
    'start_date': '8/28/25, 10:30 AM',
    # ... other fields
}
db.insert_incident(incident_data)

# Insert video segment (from capture process)
segment_data = {
    'camera_id': '2242',
    'filename': '220454_7d3b72eb2af1_seg15115.ts',
    'storage_bucket': 'video-segments',
    'storage_path': 'camera_2242/20250828/220454_7d3b72eb2af1_seg15115.ts',
    'storage_url': 'gs://bucket/path/file.ts',
    'segment_duration': 2.0,
    'segment_size': 70000,
    'capture_timestamp': datetime.now(),
    # ... other fields
}
session_id = str(uuid.uuid4())
db.insert_video_segment(segment_data, session_id)

# Run correlation
correlations_created = db.run_correlation(radius_km=2.0, time_window_minutes=60)

# Query correlations
incidents = db.get_incidents_for_video_segment('220454_7d3b72eb2af1_seg15115.ts')
segments = db.get_video_segments_for_incident(260338)
"""