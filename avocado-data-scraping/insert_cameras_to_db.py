#!/usr/bin/env python3
"""
One-time script to insert cameras from fl511_cameras_all_regions.json into Postgres database.
Uses ON CONFLICT DO NOTHING to avoid duplicates and reports conflicts vs fresh inserts.
"""

import json
import psycopg2
from datetime import datetime
from typing import List, Set

def load_cameras_from_json(file_path: str) -> List[dict]:
    """Load cameras from JSON file"""
    try:
        with open(file_path, 'r') as f:
            cameras = json.load(f)
        print(f"✅ Loaded {len(cameras)} cameras from {file_path}")
        return cameras
    except Exception as e:
        print(f"❌ Error loading JSON file: {e}")
        return []

def parse_install_date(date_str: str) -> str:
    """Parse install date string to proper timestamp format"""
    if not date_str:
        return None
    
    try:
        # Handle different date formats
        if 'T' in date_str and '+' in date_str:
            # ISO format with timezone: "2024-12-12T16:12:05.3752272+00:00"
            # Remove microseconds if present and convert
            if '.' in date_str:
                base_date = date_str.split('.')[0]  # Get part before microseconds
                timezone = date_str.split('+')[-1] if '+' in date_str else '00:00'
                return f"{base_date}+{timezone}"
            return date_str
        else:
            # Try to parse as ISO format
            dt = datetime.fromisoformat(date_str.replace('Z', '+00:00'))
            return dt.isoformat()
    except:
        # If all else fails, return current timestamp
        return datetime.now().isoformat()

def insert_cameras_to_database(cameras: List[dict]) -> tuple:
    """
    Insert cameras into Postgres database
    Returns (fresh_inserts, conflicts) as sets of camera IDs
    """
    # Database configuration from crash_alert_monitor.py
    db_config = {
        'host': '34.42.128.70',
        'database': 'fl511_incidents', 
        'user': 'fl511_user',
        'password': 'AfUa9sQ7r6PcXufDVPJhwK'
    }
    
    fresh_inserts: Set[str] = set()
    conflicts: Set[str] = set()
    
    try:
        conn = psycopg2.connect(**db_config)
        cur = conn.cursor()
        
        print(f"🔗 Connected to database: {db_config['database']}")
        
        # First, get existing camera IDs to track conflicts
        cur.execute("SELECT camera_id FROM cameras")
        existing_camera_ids = {str(row[0]) for row in cur.fetchall()}
        print(f"📊 Found {len(existing_camera_ids)} existing cameras in database")
        
        insert_query = """
            INSERT INTO cameras (
                camera_id, name, description, latitude, longitude,
                roadway, direction, region, county, location,
                install_date, equipment_type, active, created_at, updated_at
            ) VALUES (
                %s, %s, %s, %s, %s,
                %s, %s, %s, %s, %s,
                %s, %s, %s, %s, %s
            ) ON CONFLICT (camera_id) DO NOTHING
        """
        
        successful_inserts = 0
        failed_inserts = 0
        
        print(f"🚀 Starting camera insertion...")
        
        for i, camera in enumerate(cameras, 1):
            try:
                camera_id = str(camera.get('id', ''))
                
                if not camera_id or camera_id == 'unknown':
                    print(f"⚠️ Skipping camera {i} with invalid ID: {camera_id}")
                    failed_inserts += 1
                    continue
                
                # Check if this will be a conflict
                if camera_id in existing_camera_ids:
                    conflicts.add(camera_id)
                else:
                    fresh_inserts.add(camera_id)
                
                # Parse install date
                install_date = None
                install_date_raw = camera.get('install_date')
                if install_date_raw:
                    install_date = parse_install_date(install_date_raw)
                
                # Prepare data for insertion
                insert_data = (
                    camera_id,                                           # camera_id
                    camera.get('name', '')[:200],                       # name (limit 200 chars)
                    camera.get('description', '')[:500],                # description (limit 500 chars)  
                    camera.get('latitude'),                             # latitude
                    camera.get('longitude'),                            # longitude
                    camera.get('roadway', '')[:20],                     # roadway (limit 20 chars)
                    camera.get('direction', '')[:20],                   # direction (limit 20 chars)
                    camera.get('region', '')[:50],                      # region (limit 50 chars)
                    camera.get('county', '')[:100],                     # county (limit 100 chars)
                    camera.get('location', '')[:500],                   # location (limit 500 chars)
                    install_date,                                       # install_date
                    camera.get('equipment_type', '')[:100],             # equipment_type (limit 100 chars)
                    True,                                               # active (default True)
                    datetime.now(),                                     # created_at
                    datetime.now()                                      # updated_at
                )
                
                cur.execute(insert_query, insert_data)
                successful_inserts += 1
                
                # Progress update every 500 cameras
                if i % 500 == 0:
                    print(f"📈 Progress: {i}/{len(cameras)} cameras processed...")
                    conn.commit()  # Commit periodically
                
            except Exception as e:
                print(f"❌ Error inserting camera {camera_id}: {e}")
                failed_inserts += 1
                continue
        
        # Final commit
        conn.commit()
        conn.close()
        
        print(f"✅ Camera insertion complete!")
        print(f"   Successful: {successful_inserts}")
        print(f"   Failed: {failed_inserts}")
        print(f"   Total processed: {len(cameras)}")
        
        return fresh_inserts, conflicts
        
    except Exception as e:
        print(f"❌ Database error: {e}")
        return set(), set()

def main():
    """Main function"""
    print("🏗️ FL-511 Camera Database Insertion")
    print("=" * 60)
    
    # Load cameras from JSON
    cameras = load_cameras_from_json('fl511_cameras_all_regions.json')
    if not cameras:
        print("❌ No cameras loaded, exiting")
        return
    
    # Insert cameras and track results
    fresh_inserts, conflicts = insert_cameras_to_database(cameras)
    
    # Report results
    print(f"\n📊 INSERTION SUMMARY:")
    print(f"=" * 60)
    print(f"Total cameras processed: {len(cameras)}")
    print(f"Fresh inserts: {len(fresh_inserts)}")
    print(f"Conflicts (existing): {len(conflicts)}")
    
    if conflicts:
        print(f"\n🔄 CONFLICTING CAMERA IDs ({len(conflicts)}):")
        print("=" * 60)
        # Sort conflicts numerically where possible
        try:
            sorted_conflicts = sorted(conflicts, key=lambda x: int(x) if x.isdigit() else float('inf'))
        except:
            sorted_conflicts = sorted(conflicts)
            
        for i, camera_id in enumerate(sorted_conflicts):
            print(f"   {i+1:4d}. {camera_id}")
            if i > 0 and (i + 1) % 20 == 0:  # Show first 20, then ask
                remaining = len(sorted_conflicts) - i - 1
                if remaining > 0:
                    print(f"   ... and {remaining} more conflicts")
                    break
    
    if fresh_inserts:
        print(f"\n🆕 FRESH INSERT CAMERA IDs ({len(fresh_inserts)}):")
        print("=" * 60)
        # Sort fresh inserts numerically where possible  
        try:
            sorted_fresh = sorted(fresh_inserts, key=lambda x: int(x) if x.isdigit() else float('inf'))
        except:
            sorted_fresh = sorted(fresh_inserts)
            
        for i, camera_id in enumerate(sorted_fresh):
            print(f"   {i+1:4d}. {camera_id}")
            if i > 0 and (i + 1) % 20 == 0:  # Show first 20, then ask
                remaining = len(sorted_fresh) - i - 1
                if remaining > 0:
                    print(f"   ... and {remaining} more fresh inserts")
                    break
    
    print(f"\n✅ Database insertion complete!")

if __name__ == "__main__":
    main()