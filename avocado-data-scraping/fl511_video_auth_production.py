#!/usr/bin/env python3
"""
FL511 Video Authentication - Production Implementation

Implements the verified 6-step authentication process:
1. Load camera details from JSON file (deterministic, no guesswork)
2. GET video URL from FL-511 (imageId -> token, sourceId, systemSourceId)  
3. POST to Divas SecureTokenUri API (get streaming token)
4. GET HLS master playlist (m3u8 with stream info)
5. GET HLS video playlist (m3u8 with video segments)
6. GET video segments (.ts files for streaming)

This is the PRODUCTION version for Google Cloud deployment.
"""

import requests
import json
import time
import re
import logging
from typing import Dict, Optional, List, Tuple
from urllib.parse import urljoin, urlparse

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Suppress SSL warnings for development
import warnings
warnings.filterwarnings('ignore', message='Unverified HTTPS request')
requests.packages.urllib3.disable_warnings()


class FL511VideoAuthProduction:
    def __init__(self, cameras_json_path: str = 'fl511_i4_i95_cameras.json'):
        """Initialize with camera data from JSON file"""
        self.cameras_json_path = cameras_json_path
        self.session = requests.Session()
        
        # Standard headers for FL-511 requests
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
        
        # Headers for Divas cloud requests
        self.divas_headers = {
            'accept': '*/*',
            'accept-language': 'en-US,en;q=0.9',
            'content-type': 'application/json',
            'origin': 'https://fl511.com',
            'priority': 'u=1, i',
            'referer': 'https://fl511.com/',
            'sec-ch-ua': '"Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"',
            'sec-ch-ua-mobile': '?0',
            'sec-ch-ua-platform': '"macOS"',
            'sec-fetch-dest': 'empty',
            'sec-fetch-mode': 'cors',
            'sec-fetch-site': 'cross-site',
            'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'
        }
        
        # Headers for streaming requests
        self.stream_headers = {
            'accept': '*/*',
            'accept-language': 'en-US,en;q=0.9',
            'origin': 'https://fl511.com',
            'priority': 'u=1, i',
            'referer': 'https://fl511.com/',
            'sec-ch-ua': '"Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"',
            'sec-ch-ua-mobile': '?0',
            'sec-ch-ua-platform': '"macOS"',
            'sec-fetch-dest': 'empty',
            'sec-fetch-mode': 'cors',
            'sec-fetch-site': 'cross-site',
            'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'
        }
        
        # Load camera data
        self.cameras_data = self._load_cameras_data()

    def _load_cameras_data(self) -> List[Dict]:
        """Load cameras from JSON file"""
        try:
            with open(self.cameras_json_path, 'r') as f:
                data = json.load(f)
            
            # Handle new format with metadata wrapper
            cameras_list = data.get('cameras', data) if isinstance(data, dict) else data
            
            # Extract cameras with video auth required
            auth_cameras = []
            for camera in cameras_list:
                # Check if camera has video auth and video URL
                if camera.get('is_video_auth_required') and camera.get('video_url'):
                    # Extract image_id from raw_data for API calls
                    image_id = camera.get('id')  # Default to camera id
                    if camera.get('raw_data', {}).get('images'):
                        # Get image_id from first image in raw_data
                        first_image = camera['raw_data']['images'][0]
                        image_id = str(first_image.get('id', image_id))
                    
                    auth_cameras.append({
                        'camera_id': str(camera.get('id', '')),
                        'image_id': image_id,  # This is the imageId for API calls
                        'video_url': camera.get('video_url', ''),
                        'description': camera.get('description', ''),
                        'location': camera.get('location', ''),
                        'region': camera.get('region', ''),
                        'county': camera.get('county', ''),
                        'roadway': camera.get('roadway', ''),
                        'direction': camera.get('direction', ''),
                        'latitude': camera.get('latitude'),
                        'longitude': camera.get('longitude')
                    })
            
            logger.info(f"Loaded {len(auth_cameras)} cameras with video authentication from JSON")
            return auth_cameras
            
        except Exception as e:
            logger.error(f"Failed to load cameras data: {e}")
            return []

    def get_cameras_by_region(self, region: str = None) -> List[Dict]:
        """Get cameras filtered by region"""
        if not region:
            return self.cameras_data
        return [cam for cam in self.cameras_data if cam['region'] == region]

    def get_camera_by_id(self, camera_id: str) -> Optional[Dict]:
        """Get specific camera by ID"""
        for camera in self.cameras_data:
            if camera['camera_id'] == camera_id:
                return camera
        return None

    def step1_get_video_auth_info(self, image_id: str) -> Optional[Dict]:
        """
        Step 1: Get video authentication info from FL-511
        
        Args:
            image_id: Image ID from camera data (NOT camera_id)
            
        Returns:
            Dict with token, sourceId, systemSourceId or None if failed
        """
        url = f'https://fl511.com/Camera/GetVideoUrl?imageId={image_id}'
        
        try:
            logger.info(f"Step 1: Getting video auth info for image ID {image_id}...")
            response = self.session.get(url, headers=self.fl511_headers, timeout=30)
            response.raise_for_status()
            
            data = response.json()
            logger.info(f"✅ Step 1 successful: {data}")
            return data
            
        except requests.exceptions.RequestException as e:
            logger.error(f"❌ Step 1 failed - Request error: {e}")
            return None
        except json.JSONDecodeError as e:
            logger.error(f"❌ Step 1 failed - JSON decode error: {e}")
            return None

    def step2_get_streaming_token(self, auth_info: Dict) -> Optional[str]:
        """
        Step 2: Get streaming token from Divas cloud
        
        Args:
            auth_info: Complete response from step 1
            
        Returns:
            Streaming token string or None if failed
        """
        url = 'https://divas.cloud/VDS-API/SecureTokenUri/GetSecureTokenUriBySourceId'
        
        try:
            logger.info(f"Step 2: Getting streaming token...")
            logger.info(f"  Payload: {json.dumps(auth_info, indent=2)}")
            
            response = self.session.post(url, headers=self.divas_headers, json=auth_info, timeout=30)
            response.raise_for_status()
            
            token_response = response.json() if response.content else response.text.strip('"')
            logger.info(f"✅ Step 2 successful: {token_response}")
            
            # Extract token from ?token=VALUE format
            if isinstance(token_response, str) and token_response.startswith('?token='):
                return token_response[7:]  # Remove "?token="
            
            return token_response
            
        except requests.exceptions.RequestException as e:
            logger.error(f"❌ Step 2 failed - Request error: {e}")
            return None
        except Exception as e:
            logger.error(f"❌ Step 2 failed - Error: {e}")
            return None

    def step3_get_master_playlist(self, base_video_url: str, token: str) -> Optional[str]:
        """
        Step 3: Get HLS master playlist (index.m3u8)
        
        Args:
            base_video_url: Base video URL from camera JSON data
            token: Streaming token from step 2
            
        Returns:
            Master playlist content or None if failed
        """
        url = f"{base_video_url}?token={token}"
        
        try:
            logger.info(f"Step 3: Getting master playlist...")
            logger.info(f"  URL: {url}")
            
            response = self.session.get(url, headers=self.stream_headers, timeout=30, verify=False)
            response.raise_for_status()
            
            playlist_content = response.text
            logger.info(f"✅ Step 3 successful - Master playlist retrieved ({len(playlist_content)} chars)")
            
            if '#EXTM3U' not in playlist_content:
                logger.warning("❌ Response doesn't look like an M3U playlist")
                return None
                
            return playlist_content
            
        except requests.exceptions.RequestException as e:
            logger.error(f"❌ Step 3 failed - Request error: {e}")
            return None

    def step4_get_video_playlist(self, base_video_url: str, token: str) -> Optional[Dict]:
        """
        Step 4: Get HLS video playlist (xflow.m3u8) with video segments
        
        Args:
            base_video_url: Base video URL from camera JSON data
            token: Streaming token from step 2
            
        Returns:
            Dict with playlist content and parsed segments or None if failed
        """
        # Replace index.m3u8 with xflow.m3u8 in the base URL
        xflow_url = base_video_url.replace('index.m3u8', 'xflow.m3u8')
        url = f"{xflow_url}?token={token}"
        
        try:
            logger.info(f"Step 4: Getting video playlist...")
            logger.info(f"  URL: {url}")
            
            response = self.session.get(url, headers=self.stream_headers, timeout=30, verify=False)
            response.raise_for_status()
            
            playlist_content = response.text
            logger.info(f"✅ Step 4 successful - Video playlist retrieved ({len(playlist_content)} chars)")
            
            if '#EXTM3U' not in playlist_content:
                logger.warning("❌ Response doesn't look like an M3U playlist")
                return None
            
            # Parse the playlist to extract segments
            segments = self._parse_m3u8_playlist(playlist_content, url)
            
            result = {
                'playlist_content': playlist_content,
                'segments': segments,
                'base_url': self._get_base_url(url),
                'playlist_url': url
            }
            
            logger.info(f"  Found {len(segments)} video segments")
            return result
            
        except requests.exceptions.RequestException as e:
            logger.error(f"❌ Step 4 failed - Request error: {e}")
            return None

    def step5_get_video_segment(self, segment_url: str) -> Optional[bytes]:
        """
        Step 5: Get individual video segment (.ts file)
        
        Args:
            segment_url: Full URL to video segment
            
        Returns:
            Video segment bytes or None if failed
        """
        try:
            logger.debug(f"Step 5: Getting video segment...")
            logger.debug(f"  URL: {segment_url}")
            
            response = self.session.get(segment_url, headers=self.stream_headers, timeout=30, verify=False)
            response.raise_for_status()
            
            segment_data = response.content
            logger.debug(f"✅ Step 5 successful - Segment retrieved ({len(segment_data)} bytes)")
            
            return segment_data
            
        except requests.exceptions.RequestException as e:
            logger.error(f"❌ Step 5 failed - Request error: {e}")
            return None

    def _parse_m3u8_playlist(self, playlist_content: str, base_url: str) -> List[Dict]:
        """Parse m3u8 playlist to extract segment information"""
        segments = []
        lines = playlist_content.strip().split('\n')
        
        base_url_parsed = urlparse(base_url)
        base_path = '/'.join(base_url_parsed.path.split('/')[:-1]) + '/'
        base_domain = f"{base_url_parsed.scheme}://{base_url_parsed.netloc}"
        
        current_duration = None
        current_date = None
        
        for line in lines:
            line = line.strip()
            
            # Parse segment duration
            if line.startswith('#EXTINF:'):
                duration_match = re.search(r'#EXTINF:([\d.]+)', line)
                if duration_match:
                    current_duration = float(duration_match.group(1))
            
            # Parse program date time
            elif line.startswith('#EXT-X-PROGRAM-DATE-TIME:'):
                current_date = line.replace('#EXT-X-PROGRAM-DATE-TIME:', '')
            
            # Parse segment URL
            elif line.endswith('.ts') or ('?token=' in line and '.ts' in line):
                if not line or line.startswith('#'):
                    continue
                    
                # Handle relative URLs
                if line.startswith('http'):
                    full_url = line
                else:
                    full_url = base_domain + base_path + line
                
                segment_info = {
                    'url': full_url,
                    'filename': line.split('?')[0].split('/')[-1],
                    'duration': current_duration,
                    'program_date_time': current_date
                }
                segments.append(segment_info)
                
                # Reset for next segment
                current_duration = None
                current_date = None
        
        return segments

    def _get_base_url(self, full_url: str) -> str:
        """Extract base URL from full URL"""
        parsed = urlparse(full_url)
        return f"{parsed.scheme}://{parsed.netloc}"

    def get_authenticated_stream_info(self, camera_id: str) -> Optional[Dict]:
        """
        Complete authentication flow for a camera - PRODUCTION VERSION
        
        Args:
            camera_id: Camera ID from JSON file
            
        Returns:
            Dict with complete streaming information or None if failed
        """
        logger.info("=" * 60)
        logger.info(f"FL-511 Video Authentication Flow - Camera {camera_id}")
        logger.info("=" * 60)
        
        # Get camera info from JSON data (no guesswork)
        camera_info = self.get_camera_by_id(camera_id)
        if not camera_info:
            logger.error(f"❌ Camera {camera_id} not found in JSON data")
            return None
        
        logger.info(f"📹 Camera: {camera_info['description']}")
        logger.info(f"📍 Location: {camera_info['location']}")
        logger.info(f"🔗 Base Video URL: {camera_info['video_url']}")
        
        # Step 1: Get authentication info using image_id
        auth_info = self.step1_get_video_auth_info(camera_info['image_id'])
        if not auth_info:
            return None
        
        # Step 2: Get streaming token
        streaming_token = self.step2_get_streaming_token(auth_info)
        if not streaming_token:
            return None
        
        # Step 3: Get master playlist
        master_playlist = self.step3_get_master_playlist(camera_info['video_url'], streaming_token)
        if not master_playlist:
            return None
        
        # Step 4: Get video playlist with segments
        video_playlist_info = self.step4_get_video_playlist(camera_info['video_url'], streaming_token)
        if not video_playlist_info:
            return None
        
        # Combine all information
        result = {
            'camera_id': camera_id,
            'camera_info': camera_info,
            'auth_info': auth_info,
            'streaming_token': streaming_token,
            'master_playlist': master_playlist,
            'video_playlist_info': video_playlist_info,
            'streaming_url': video_playlist_info['playlist_url'],
            'segments': video_playlist_info['segments']
        }
        
        logger.info("=" * 60)
        logger.info("✅ Authentication flow completed successfully!")
        logger.info(f"📺 Streaming URL: {result['streaming_url']}")
        logger.info(f"🎬 Available segments: {len(result['segments'])}")
        logger.info("=" * 60)
        
        return result

    def download_video_segments(self, stream_info: Dict, max_segments: int = 5) -> List[Dict]:
        """
        Download video segments for storage in Google Cloud
        
        Args:
            stream_info: Result from get_authenticated_stream_info()
            max_segments: Maximum segments to download
            
        Returns:
            List of downloaded segment data with metadata
        """
        segments = stream_info.get('segments', [])
        camera_id = stream_info['camera_id']
        downloaded_segments = []
        
        if not segments:
            logger.warning(f"No segments available for camera {camera_id}")
            return downloaded_segments
        
        # Download up to max_segments
        segments_to_download = segments[:max_segments]
        
        for i, segment in enumerate(segments_to_download):
            try:
                logger.info(f"Downloading segment {i+1}/{len(segments_to_download)} for camera {camera_id}")
                
                # Download segment data
                segment_data = self.step5_get_video_segment(segment['url'])
                
                if segment_data:
                    downloaded_segment = {
                        'camera_id': camera_id,
                        'filename': segment['filename'],
                        'data': segment_data,
                        'size_bytes': len(segment_data),
                        'duration': segment.get('duration'),
                        'program_date_time': segment.get('program_date_time'),
                        'segment_index': i,
                        'url': segment['url']
                    }
                    
                    downloaded_segments.append(downloaded_segment)
                    logger.info(f"✅ Downloaded segment: {segment['filename']} ({len(segment_data)} bytes)")
                    
                else:
                    logger.warning(f"❌ Failed to download segment {i+1} for camera {camera_id}")
                
            except Exception as e:
                logger.error(f"Error downloading segment {i+1} for camera {camera_id}: {e}")
                continue
        
        logger.info(f"Downloaded {len(downloaded_segments)} segments for camera {camera_id}")
        return downloaded_segments


def main():
    """Example usage of the production authentication system"""
    import argparse
    
    parser = argparse.ArgumentParser(description='FL-511 Video Authentication Production System')
    parser.add_argument('--camera-id', help='Specific camera ID to test')
    parser.add_argument('--region', help='Filter cameras by region')
    parser.add_argument('--list-cameras', action='store_true', help='List available cameras')
    parser.add_argument('--download-segments', type=int, default=3, help='Number of segments to download')
    
    args = parser.parse_args()
    
    # Initialize authentication system
    auth_system = FL511VideoAuthProduction()
    
    if args.list_cameras:
        cameras = auth_system.get_cameras_by_region(args.region)
        print(f"\n📹 Available cameras ({len(cameras)}):")
        for camera in cameras[:10]:  # Show first 10
            print(f"  ID: {camera['camera_id']} - {camera['description']} ({camera['region']})")
        return 0
    
    # Test specific camera or first available
    if args.camera_id:
        camera_id = args.camera_id
    else:
        cameras = auth_system.get_cameras_by_region(args.region)
        if not cameras:
            print("❌ No cameras available")
            return 1
        camera_id = cameras[0]['camera_id']
    
    # Get authenticated stream info
    stream_info = auth_system.get_authenticated_stream_info(camera_id)
    
    if not stream_info:
        print("❌ Failed to authenticate and get streaming information")
        return 1
    
    # Download video segments
    segments = auth_system.download_video_segments(stream_info, args.download_segments)
    
    if segments:
        print(f"\n🎯 Successfully downloaded {len(segments)} video segments")
        total_size = sum(s['size_bytes'] for s in segments)
        print(f"📊 Total size: {total_size:,} bytes ({total_size/1024/1024:.2f} MB)")
        
        print(f"\n🚀 Ready for Google Cloud deployment!")
        print(f"   Streaming URL: {stream_info['streaming_url']}")
        print(f"   This system can capture video segments for incident correlation")
    else:
        print("❌ No video segments downloaded")
        return 1
    
    return 0


if __name__ == "__main__":
    exit(main())