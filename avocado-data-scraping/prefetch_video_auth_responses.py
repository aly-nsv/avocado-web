#!/usr/bin/env python3
"""
Pre-fetch FL511 Video Authentication Responses

Fetches video auth responses for all I-4 and I-95 cameras and caches them
to avoid rate limiting during continuous capture operations.

This script:
1. Loads all I-4/I-95 cameras from fl511_i4_i95_cameras.json
2. Calls https://fl511.com/Camera/GetVideoUrl for each camera with delays
3. Saves responses to fl511_video_auth_cache.json
4. Handles failures gracefully with retries
"""

import json
import time
import requests
import logging
from datetime import datetime
from typing import Dict, List, Optional
from pathlib import Path

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class FL511VideoAuthCache:
    def __init__(self, cameras_json_path: str = 'fl511_i4_i95_cameras.json'):
        self.cameras_json_path = cameras_json_path
        self.cache_file_path = 'fl511_video_auth_cache.json'
        self.session = requests.Session()
        
        # Headers for FL-511 requests (from working implementation)
        self.fl511_headers = {
            'accept': '*/*',
            'accept-language': 'en-US,en;q=0.9',
            'priority': 'u=1, i',
            'referer': 'https://fl511.com/map',
            'sec-ch-ua': '"Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"',
            'sec-ch-ua-mobile': '?0',
            'sec-ch-ua-platform': '"macOS"',
            'sec-fetch-dest': 'empty',
            'sec-fetch-mode': 'cors',
            'sec-fetch-site': 'same-origin',
            'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
            'x-requested-with': 'XMLHttpRequest'
        }
        
        self.cameras_data = self._load_cameras_data()
    
    def _load_cameras_data(self) -> List[Dict]:
        """Load cameras from JSON file"""
        try:
            with open(self.cameras_json_path, 'r') as f:
                data = json.load(f)
            
            # Handle metadata wrapper format
            cameras_list = data.get('cameras', data) if isinstance(data, dict) else data
            
            # Extract I-4 and I-95 cameras with video auth
            target_cameras = []
            for camera in cameras_list:
                if (camera.get('is_video_auth_required') and 
                    camera.get('video_url') and
                    camera.get('roadway') in ['I-4', 'I-95']):
                    
                    # Extract image_id for API calls
                    image_id = camera.get('id')
                    if camera.get('raw_data', {}).get('images'):
                        first_image = camera['raw_data']['images'][0]
                        image_id = str(first_image.get('id', image_id))
                    
                    target_cameras.append({
                        'camera_id': str(camera.get('id', '')),
                        'image_id': str(image_id),
                        'video_url': camera.get('video_url', ''),
                        'description': camera.get('description', ''),
                        'location': camera.get('location', ''),
                        'roadway': camera.get('roadway', ''),
                        'region': camera.get('region', ''),
                        'latitude': camera.get('latitude'),
                        'longitude': camera.get('longitude')
                    })
            
            logger.info(f"Loaded {len(target_cameras)} I-4/I-95 cameras requiring video auth")
            return target_cameras
            
        except Exception as e:
            logger.error(f"Failed to load cameras data: {e}")
            return []
    
    def _fetch_video_auth_info(self, image_id: str, camera_id: str, retry_count: int = 3) -> Optional[Dict]:
        """
        Fetch video authentication info from FL-511 with retries
        
        Args:
            image_id: Image ID for the API call
            camera_id: Camera ID for logging
            retry_count: Number of retry attempts
            
        Returns:
            Auth response dict or None if failed
        """
        url = f'https://fl511.com/Camera/GetVideoUrl?imageId={image_id}'
        
        for attempt in range(retry_count):
            try:
                logger.info(f"Camera {camera_id}: Fetching auth info for image ID {image_id} (attempt {attempt + 1})")
                response = self.session.get(url, headers=self.fl511_headers, timeout=30)
                response.raise_for_status()
                
                auth_data = response.json()
                logger.info(f"✅ Camera {camera_id}: Success - {auth_data}")
                return auth_data
                
            except requests.exceptions.RequestException as e:
                logger.warning(f"⚠️  Camera {camera_id}: Request error (attempt {attempt + 1}): {e}")
                if attempt < retry_count - 1:
                    backoff_time = 5 * (attempt + 1)  # 5s, 10s, 15s
                    logger.info(f"   Backing off {backoff_time}s before retry...")
                    time.sleep(backoff_time)
                    
            except json.JSONDecodeError as e:
                logger.warning(f"⚠️  Camera {camera_id}: JSON decode error (attempt {attempt + 1}): {e}")
                if attempt < retry_count - 1:
                    backoff_time = 5 * (attempt + 1)
                    time.sleep(backoff_time)
                    
            except Exception as e:
                logger.error(f"❌ Camera {camera_id}: Unexpected error (attempt {attempt + 1}): {e}")
                if attempt < retry_count - 1:
                    backoff_time = 5 * (attempt + 1)
                    time.sleep(backoff_time)
        
        logger.error(f"❌ Camera {camera_id}: Failed after {retry_count} attempts")
        return None
    
    def prefetch_all_auth_responses(self, delay_seconds: float = 3.0, batch_size: int = 10) -> Dict:
        """
        Pre-fetch video auth responses for all cameras (incremental mode)
        
        Args:
            delay_seconds: Delay between requests to avoid rate limiting
            batch_size: Process cameras in batches with longer delays
            
        Returns:
            Dict with cached responses and statistics
        """
        # Load existing cache first
        cache_data = self.load_existing_cache()
        if not cache_data:
            # Create new cache structure
            cache_data = {
                'created_at': datetime.now().isoformat(),
                'total_cameras': len(self.cameras_data),
                'successful_responses': 0,
                'failed_responses': 0,
                'auth_responses': {}
            }
        else:
            # Update metadata for existing cache
            cache_data['last_updated'] = datetime.now().isoformat()
            cache_data['total_cameras'] = len(self.cameras_data)
        
        # Find cameras we haven't cached yet
        existing_camera_ids = set(cache_data.get('auth_responses', {}).keys())
        all_camera_ids = {cam['camera_id'] for cam in self.cameras_data}
        missing_camera_ids = all_camera_ids - existing_camera_ids
        
        if not missing_camera_ids:
            logger.info(f"✅ All {len(all_camera_ids)} cameras already cached!")
            return cache_data
        
        cameras_to_fetch = [cam for cam in self.cameras_data if cam['camera_id'] in missing_camera_ids]
        
        logger.info(f"🚀 Incremental pre-fetch mode")
        logger.info(f"   Total cameras: {len(self.cameras_data)}")
        logger.info(f"   Already cached: {len(existing_camera_ids)}")
        logger.info(f"   Still need: {len(missing_camera_ids)}")
        logger.info(f"   Delay between requests: {delay_seconds}s")
        logger.info(f"   Batch size: {batch_size} cameras")
        
        for i, camera in enumerate(cameras_to_fetch):
            camera_id = camera['camera_id']
            image_id = camera['image_id']
            
            logger.info(f"\\n📹 Processing camera {i+1}/{len(cameras_to_fetch)}: {camera_id}")
            logger.info(f"   Description: {camera['description']}")
            logger.info(f"   Roadway: {camera['roadway']} | Region: {camera['region']}")
            logger.info(f"   Progress: {len(existing_camera_ids) + i}/{len(self.cameras_data)} total")
            
            # Fetch auth response
            auth_response = self._fetch_video_auth_info(image_id, camera_id)
            
            if auth_response:
                cache_data['auth_responses'][camera_id] = {
                    'camera_metadata': camera,
                    'auth_response': auth_response,
                    'fetched_at': datetime.now().isoformat(),
                    'image_id': image_id
                }
                cache_data['successful_responses'] += 1
                logger.info(f"✅ Camera {camera_id}: Cached successfully")
                
                # Save after each success to preserve progress
                self._save_cache(cache_data)
                
            else:
                cache_data['failed_responses'] += 1
                logger.error(f"❌ Camera {camera_id}: Failed to cache")
            
            # Add delay to avoid rate limiting
            if i < len(cameras_to_fetch) - 1:  # Don't delay after last camera
                if (i + 1) % batch_size == 0:
                    # Longer delay after each batch
                    batch_delay = delay_seconds * 3
                    logger.info(f"⏸️  Batch complete. Waiting {batch_delay}s before next batch...")
                    time.sleep(batch_delay)
                else:
                    logger.info(f"⏸️  Waiting {delay_seconds}s...")
                    time.sleep(delay_seconds)
        
        # Save cache to file
        self._save_cache(cache_data)
        
        # Print summary
        success_rate = (cache_data['successful_responses'] / cache_data['total_cameras']) * 100
        logger.info(f"\\n🎯 PRE-FETCH COMPLETE!")
        logger.info(f"   Total cameras: {cache_data['total_cameras']}")
        logger.info(f"   Successful: {cache_data['successful_responses']}")
        logger.info(f"   Failed: {cache_data['failed_responses']}")
        logger.info(f"   Success rate: {success_rate:.1f}%")
        logger.info(f"   Cache saved to: {self.cache_file_path}")
        
        return cache_data
    
    def _save_cache(self, cache_data: Dict):
        """Save cache data to JSON file"""
        try:
            with open(self.cache_file_path, 'w') as f:
                json.dump(cache_data, f, indent=2, ensure_ascii=False)
            logger.info(f"💾 Cache saved to {self.cache_file_path}")
        except Exception as e:
            logger.error(f"Failed to save cache: {e}")
    
    def load_existing_cache(self) -> Optional[Dict]:
        """Load existing cache file if it exists"""
        try:
            if Path(self.cache_file_path).exists():
                with open(self.cache_file_path, 'r') as f:
                    cache_data = json.load(f)
                logger.info(f"📁 Loaded existing cache: {cache_data.get('successful_responses', 0)} responses")
                return cache_data
            return None
        except Exception as e:
            logger.error(f"Failed to load existing cache: {e}")
            return None
    
    def update_cache(self, delay_seconds: float = 1.0):
        """Update existing cache with failed cameras"""
        existing_cache = self.load_existing_cache()
        if not existing_cache:
            logger.info("No existing cache found. Running full pre-fetch...")
            return self.prefetch_all_auth_responses(delay_seconds)
        
        # Find cameras that failed or are missing
        cached_camera_ids = set(existing_cache.get('auth_responses', {}).keys())
        all_camera_ids = {cam['camera_id'] for cam in self.cameras_data}
        missing_camera_ids = all_camera_ids - cached_camera_ids
        
        if not missing_camera_ids:
            logger.info("✅ All cameras already cached!")
            return existing_cache
        
        logger.info(f"🔄 Updating cache for {len(missing_camera_ids)} missing cameras")
        
        # Fetch missing cameras
        for camera in self.cameras_data:
            if camera['camera_id'] in missing_camera_ids:
                camera_id = camera['camera_id']
                image_id = camera['image_id']
                
                logger.info(f"📹 Fetching missing camera: {camera_id}")
                auth_response = self._fetch_video_auth_info(image_id, camera_id)
                
                if auth_response:
                    existing_cache['auth_responses'][camera_id] = {
                        'camera_metadata': camera,
                        'auth_response': auth_response,
                        'fetched_at': datetime.now().isoformat(),
                        'image_id': image_id
                    }
                    existing_cache['successful_responses'] += 1
                    logger.info(f"✅ Camera {camera_id}: Added to cache")
                else:
                    existing_cache['failed_responses'] += 1
                    logger.error(f"❌ Camera {camera_id}: Still failing")
                
                time.sleep(delay_seconds)
        
        # Save updated cache
        self._save_cache(existing_cache)
        return existing_cache


def main():
    """Run the pre-fetch process"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Pre-fetch FL511 video authentication responses')
    parser.add_argument('--delay', type=float, default=4.0, help='Delay between requests (seconds)')
    parser.add_argument('--batch-size', type=int, default=5, help='Cameras per batch')
    parser.add_argument('--update', action='store_true', help='Update existing cache instead of full rebuild')
    parser.add_argument('--cameras-file', default='fl511_i4_i95_cameras.json', help='Camera data file')
    
    args = parser.parse_args()
    
    # Create cache manager
    cache_manager = FL511VideoAuthCache(args.cameras_file)
    
    if not cache_manager.cameras_data:
        logger.error("No camera data found! Check your cameras file.")
        return 1
    
    # Run pre-fetch
    if args.update:
        result = cache_manager.update_cache(args.delay)
    else:
        result = cache_manager.prefetch_all_auth_responses(args.delay, args.batch_size)
    
    # Print final stats
    if result:
        success_rate = (result['successful_responses'] / result['total_cameras']) * 100
        print(f"\\n🚀 READY FOR PRODUCTION!")
        print(f"   Cached responses: {result['successful_responses']}")
        print(f"   Success rate: {success_rate:.1f}%")
        print(f"   Cache file: fl511_video_auth_cache.json")
        print(f"\\n   Next step: Update video_capture_service.py to use cached responses")
        
        return 0 if success_rate > 50 else 1
    
    return 1


if __name__ == "__main__":
    exit(main())