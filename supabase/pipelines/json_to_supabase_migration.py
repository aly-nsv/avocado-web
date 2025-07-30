#!/usr/bin/env python3
"""
Florida 511 Camera Data Migration Pipeline
==========================================

This script migrates camera data from JSON files to Supabase PostgreSQL database.
It handles data transformation, deduplication, and error recovery.

Usage:
    python json_to_supabase_migration.py --source ../avocado-data-scraping/ --dry-run
    python json_to_supabase_migration.py --source ../avocado-data-scraping/ --execute

Requirements:
    pip install supabase python-dotenv tqdm psycopg2-binary
"""

import json
import os
import sys
import argparse
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List, Optional, Any
import logging

try:
    from supabase import create_client, Client
    from dotenv import load_dotenv
    from tqdm import tqdm
except ImportError as e:
    print(f"Missing required packages: {e}")
    print("Install with: pip install supabase python-dotenv tqdm psycopg2-binary")
    sys.exit(1)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('migration.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

class CameraMigrationPipeline:
    """Pipeline for migrating Florida 511 camera data to Supabase"""
    
    def __init__(self, supabase_url: str, supabase_key: str):
        self.supabase: Client = create_client(supabase_url, supabase_key)
        self.batch_size = 100
        self.total_processed = 0
        self.total_inserted = 0
        self.total_updated = 0
        self.total_errors = 0
        
    def load_json_file(self, file_path: Path) -> List[Dict]:
        """Load camera data from JSON file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                logger.info(f"Loaded {len(data)} cameras from {file_path.name}")
                return data
        except Exception as e:
            logger.error(f"Failed to load {file_path}: {e}")
            return []
    
    def transform_camera_data(self, raw_camera: Dict) -> Dict:
        """Transform raw FL511 camera data to Supabase schema"""
        try:
            # Extract basic information
            transformed = {
                'external_id': str(raw_camera.get('id', '')),
                'name': raw_camera.get('name', '').strip(),
                'description': raw_camera.get('description', '').strip() or None,
                'latitude': float(raw_camera.get('latitude', 0)),
                'longitude': float(raw_camera.get('longitude', 0)),
                'state_code': 'FL',
                'region': raw_camera.get('region', '').strip() or None,
                'county': raw_camera.get('county', '').strip() or None,
                'roadway': raw_camera.get('roadway', '').strip() or None,
                'direction': raw_camera.get('direction', '').strip() or None,
                'location_description': raw_camera.get('location', '').strip() or None,
                'status': 'active' if raw_camera.get('status') == 'active' else 'inactive',
                'video_url': raw_camera.get('video_url', '').strip() or None,
                'thumbnail_url': raw_camera.get('thumbnail_url', '').strip() or None,
                'data_source': 'fl511'
            }
            
            # Handle install date
            install_date = raw_camera.get('install_date')
            if install_date:
                try:
                    # Parse ISO format datetime
                    transformed['install_date'] = datetime.fromisoformat(
                        install_date.replace('Z', '+00:00')
                    ).isoformat()
                except:
                    transformed['install_date'] = None
            else:
                transformed['install_date'] = None
            
            # Handle mile marker from location description
            location = raw_camera.get('location', '')
            if 'MM' in location:
                try:
                    # Extract mile marker (e.g., "I-75 @ MM 384.7" -> "384.7")
                    mm_part = location.split('MM')[1].strip().split()[0]
                    transformed['mile_marker'] = mm_part
                except:
                    transformed['mile_marker'] = None
            else:
                transformed['mile_marker'] = None
                
            # Build equipment metadata
            equipment_metadata = {
                'equipment_type': raw_camera.get('equipment_type'),
                'sort_order': raw_camera.get('sort_order', 0)
            }
            
            # Add video metadata if available
            if raw_camera.get('video_url') and '.m3u8' in raw_camera.get('video_url', ''):
                equipment_metadata['video_type'] = 'hls'
                equipment_metadata['video_format'] = 'application/x-mpegURL'
            
            transformed['equipment_metadata'] = equipment_metadata
            
            # Build ownership metadata from raw data
            ownership_metadata = {}
            raw_data = raw_camera.get('raw_data', {})
            if raw_data:
                ownership_metadata.update({
                    'source_id': raw_data.get('sourceId'),
                    'source': raw_data.get('source'),
                    'area_id': raw_data.get('areaId'),
                    'area': raw_data.get('area')
                })
            
            transformed['ownership_metadata'] = ownership_metadata
            
            # Store complete raw data for debugging and future migrations
            transformed['raw_data'] = raw_camera
            
            return transformed
            
        except Exception as e:
            logger.error(f"Failed to transform camera {raw_camera.get('id', 'unknown')}: {e}")
            return None
    
    def camera_exists(self, external_id: str) -> Optional[str]:
        """Check if camera already exists, return UUID if found"""
        try:
            result = self.supabase.table('traffic_cameras')\
                .select('id')\
                .eq('external_id', external_id)\
                .eq('data_source', 'fl511')\
                .execute()
            
            if result.data and len(result.data) > 0:
                return result.data[0]['id']
            return None
        except Exception as e:
            logger.error(f"Error checking camera existence for {external_id}: {e}")
            return None
    
    def insert_camera_batch(self, cameras: List[Dict], dry_run: bool = False) -> tuple:
        """Insert a batch of cameras into Supabase"""
        inserted_count = 0
        updated_count = 0
        error_count = 0
        
        for camera in cameras:
            try:
                self.total_processed += 1
                external_id = camera['external_id']
                
                if not external_id:
                    logger.warning(f"Skipping camera with no external_id")
                    error_count += 1
                    continue
                
                existing_id = self.camera_exists(external_id)
                
                if dry_run:
                    if existing_id:
                        logger.info(f"[DRY-RUN] Would update camera {external_id}")
                        updated_count += 1
                    else:
                        logger.info(f"[DRY-RUN] Would insert camera {external_id}")
                        inserted_count += 1
                    continue
                
                if existing_id:
                    # Update existing camera
                    update_data = camera.copy()
                    update_data['updated_at'] = datetime.now(timezone.utc).isoformat()
                    
                    result = self.supabase.table('traffic_cameras')\
                        .update(update_data)\
                        .eq('id', existing_id)\
                        .execute()
                    
                    if result.data:
                        updated_count += 1
                        logger.debug(f"Updated camera {external_id}")
                    else:
                        error_count += 1
                        logger.error(f"Failed to update camera {external_id}")
                        
                else:
                    # Insert new camera
                    result = self.supabase.table('traffic_cameras')\
                        .insert(camera)\
                        .execute()
                    
                    if result.data:
                        inserted_count += 1
                        logger.debug(f"Inserted camera {external_id}")
                    else:
                        error_count += 1
                        logger.error(f"Failed to insert camera {external_id}")
                        
            except Exception as e:
                error_count += 1
                logger.error(f"Error processing camera {camera.get('external_id', 'unknown')}: {e}")
        
        return inserted_count, updated_count, error_count
    
    def migrate_json_files(self, source_dir: Path, dry_run: bool = False) -> Dict[str, int]:
        """Migrate all camera JSON files from source directory"""
        logger.info(f"Starting migration from {source_dir}")
        logger.info(f"Dry run mode: {dry_run}")
        
        # Find all Florida camera JSON files
        json_files = list(source_dir.glob("fl511_cameras_*.json"))
        if not json_files:
            logger.error(f"No Florida camera JSON files found in {source_dir}")
            return {'total': 0, 'inserted': 0, 'updated': 0, 'errors': 0}
        
        logger.info(f"Found {len(json_files)} JSON files to process")
        
        all_cameras = []
        
        # Load all camera data
        for json_file in json_files:
            cameras = self.load_json_file(json_file)
            for camera in cameras:
                transformed = self.transform_camera_data(camera)
                if transformed:
                    all_cameras.append(transformed)
        
        logger.info(f"Loaded {len(all_cameras)} total cameras for migration")
        
        if not all_cameras:
            logger.warning("No valid camera data found")
            return {'total': 0, 'inserted': 0, 'updated': 0, 'errors': 0}
        
        # Process in batches with progress bar
        batches = [all_cameras[i:i + self.batch_size] 
                  for i in range(0, len(all_cameras), self.batch_size)]
        
        with tqdm(total=len(all_cameras), desc="Migrating cameras") as pbar:
            for batch in batches:
                inserted, updated, errors = self.insert_camera_batch(batch, dry_run)
                self.total_inserted += inserted
                self.total_updated += updated
                self.total_errors += errors
                pbar.update(len(batch))
        
        # Summary
        results = {
            'total': self.total_processed,
            'inserted': self.total_inserted,
            'updated': self.total_updated,
            'errors': self.total_errors
        }
        
        logger.info("Migration completed!")
        logger.info(f"Total processed: {results['total']}")
        logger.info(f"Inserted: {results['inserted']}")
        logger.info(f"Updated: {results['updated']}")
        logger.info(f"Errors: {results['errors']}")
        
        return results

def main():
    parser = argparse.ArgumentParser(description='Migrate Florida 511 camera data to Supabase')
    parser.add_argument('--source', type=str, required=True,
                       help='Path to directory containing JSON camera files')
    parser.add_argument('--dry-run', action='store_true',
                       help='Perform a dry run without writing to database')
    parser.add_argument('--env-file', type=str, default='.env.local',
                       help='Path to environment file with Supabase credentials')
    
    args = parser.parse_args()
    
    # Load environment variables
    env_path = Path(args.env_file)
    if env_path.exists():
        load_dotenv(env_path)
        logger.info(f"Loaded environment from {env_path}")
    else:
        logger.warning(f"Environment file {env_path} not found, using system environment")
    
    # Get Supabase credentials
    supabase_url = os.getenv('NEXT_PUBLIC_SUPABASE_URL')
    supabase_key = os.getenv('SUPABASE_SERVICE_ROLE_KEY')  # Use service role for admin access
    
    if not supabase_url or not supabase_key:
        logger.error("Missing Supabase credentials. Please set NEXT_PUBLIC_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY")
        sys.exit(1)
    
    source_dir = Path(args.source)
    if not source_dir.exists():
        logger.error(f"Source directory {source_dir} does not exist")
        sys.exit(1)
    
    # Run migration
    try:
        pipeline = CameraMigrationPipeline(supabase_url, supabase_key)
        results = pipeline.migrate_json_files(source_dir, args.dry_run)
        
        if results['errors'] > 0:
            logger.warning(f"Migration completed with {results['errors']} errors")
            sys.exit(1)
        else:
            logger.info("Migration completed successfully!")
            
    except Exception as e:
        logger.error(f"Migration failed: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()