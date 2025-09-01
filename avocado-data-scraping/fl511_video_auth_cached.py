#!/usr/bin/env python3
"""
FL511 Video Authentication - Cached Version

Modified version of FL511VideoAuthProduction that uses pre-cached video auth responses
instead of calling the FL-511 GetVideoUrl endpoint directly during capture operations.

This eliminates rate limiting issues and improves reliability during continuous capture.
"""

import requests
import json
import logging
from typing import Dict, Optional, List
from urllib.parse import urljoin, urlparse
from pathlib import Path

# Configure logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

# Suppress SSL warnings for development
import warnings
warnings.filterwarnings('ignore', message='Unverified HTTPS request')
requests.packages.urllib3.disable_warnings()


class FL511VideoAuthCached:
    def __init__(self, cache_file_path: str = 'fl511_video_auth_cache.json'):
        """Initialize with cached video auth responses"""
        self.cache_file_path = cache_file_path
        self.session = requests.Session()
        
        # Headers for Divas cloud requests (unchanged)
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
        
        # Headers for streaming requests (unchanged)
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
        
        # Load cached data
        self.auth_cache = self._load_auth_cache()
        self.cameras_data = self._extract_cameras_data()

    def _load_auth_cache(self) -> Dict:
        """Load cached video auth responses"""
        try:
            if not Path(self.cache_file_path).exists():
                logger.error(f"Cache file not found: {self.cache_file_path}")
                logger.error("Run prefetch_video_auth_responses.py first to generate cache")
                return {}
                
            with open(self.cache_file_path, 'r') as f:
                cache_data = json.load(f)
            
            auth_responses = cache_data.get('auth_responses', {})
            logger.info(f"Loaded {len(auth_responses)} cached video auth responses")
            logger.info(f"Cache created: {cache_data.get('created_at', 'Unknown')}")
            
            return cache_data
            
        except Exception as e:
            logger.error(f"Failed to load auth cache: {e}")
            return {}

    def _extract_cameras_data(self) -> List[Dict]:
        """Extract camera data from cache in format compatible with original class"""
        cameras = []
        auth_responses = self.auth_cache.get('auth_responses', {})
        
        for camera_id, cache_entry in auth_responses.items():
            camera_metadata = cache_entry.get('camera_metadata', {})
            cameras.append(camera_metadata)
        
        logger.info(f"Extracted {len(cameras)} cameras from cache")
        return cameras

    def get_cameras_by_region(self, region: str = None) -> List[Dict]:
        """Get cameras filtered by region"""
        if not region:
            return self.cameras_data
        return [cam for cam in self.cameras_data if cam.get('region') == region]

    def get_camera_by_id(self, camera_id: str) -> Optional[Dict]:
        """Get specific camera by ID"""
        for camera in self.cameras_data:
            if camera['camera_id'] == camera_id:
                return camera
        return None

    def step1_get_cached_auth_info(self, camera_id: str) -> Optional[Dict]:
        """
        Step 1: Get cached video authentication info (replaces FL-511 API call)
        
        Args:
            camera_id: Camera ID from cache
            
        Returns:
            Cached auth response or None if not found
        """
        try:
            auth_responses = self.auth_cache.get('auth_responses', {})
            cache_entry = auth_responses.get(camera_id)
            
            if not cache_entry:
                logger.warning(f"❌ Camera {camera_id}: Not found in cache")
                return None
            
            auth_response = cache_entry.get('auth_response')
            if not auth_response:
                logger.warning(f"❌ Camera {camera_id}: No auth response in cache")
                return None
            
            logger.info(f"✅ Camera {camera_id}: Using cached auth response")
            return auth_response
            
        except Exception as e:
            logger.error(f"❌ Camera {camera_id}: Error accessing cache - {e}")
            return None

    def step2_get_streaming_token(self, auth_info: Dict) -> Optional[str]:
        """
        Step 2: Get streaming token from Divas cloud (unchanged)
        
        Args:
            auth_info: Auth response from cache
            
        Returns:
            Streaming token string or None if failed
        """
        url = 'https://divas.cloud/VDS-API/SecureTokenUri/GetSecureTokenUriBySourceId'
        
        try:
            logger.debug(f"Step 2: Getting streaming token...")
            
            response = self.session.post(url, headers=self.divas_headers, json=auth_info, timeout=30)
            response.raise_for_status()
            
            token_response = response.json() if response.content else response.text.strip('"')
            logger.debug(f"✅ Step 2 successful: {token_response}")
            
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
        """Step 3: Get HLS master playlist (fixed duplicate token issue)"""
        # Handle case where base_video_url already has token parameter
        if '?token=' in base_video_url:
            # Replace existing token with new one
            clean_url = base_video_url.split('?token=')[0]
        else:
            clean_url = base_video_url
            
        url = f"{clean_url}?token={token}"
        
        try:
            logger.debug(f"Step 3: Getting master playlist...")
            logger.debug(f"  URL: {url}")
            
            response = self.session.get(url, headers=self.stream_headers, timeout=30, verify=False)
            response.raise_for_status()
            
            playlist_content = response.text
            logger.debug(f"✅ Step 3 successful - Master playlist retrieved ({len(playlist_content)} chars)")
            
            if '#EXTM3U' not in playlist_content:
                logger.warning("❌ Response doesn't look like an M3U playlist")
                return None
                
            return playlist_content
            
        except requests.exceptions.RequestException as e:
            logger.error(f"❌ Step 3 failed - Request error: {e}")
            return None

    def step4_get_video_playlist(self, base_video_url: str, token: str) -> Optional[Dict]:
        """Step 4: Get HLS video playlist with segments (fixed duplicate token issue)"""
        xflow_url = base_video_url.replace('index.m3u8', 'xflow.m3u8')
        
        # Handle case where base_video_url already has token parameter
        if '?token=' in xflow_url:
            # Replace existing token with new one
            xflow_url = xflow_url.split('?token=')[0]
        
        url = f"{xflow_url}?token={token}"
        
        try:
            logger.debug(f"Step 4: Getting video playlist...")
            logger.debug(f"  URL: {url}")
            
            response = self.session.get(url, headers=self.stream_headers, timeout=30, verify=False)
            response.raise_for_status()
            
            playlist_content = response.text
            logger.info(f"✅ Step 4 successful - Video playlist retrieved ({len(playlist_content)} chars)")
            
            if '#EXTM3U' not in playlist_content:
                logger.warning("❌ Response doesn't look like an M3U playlist")
                logger.warning(f"Response content: {playlist_content[:500]}...")
                return None
            
            # Log the playlist content to see what we're getting
            logger.info(f"Playlist content preview: {playlist_content[:500]}...")
            
            segments = self._parse_m3u8_playlist(playlist_content, url)
            
            result = {
                'playlist_content': playlist_content,
                'segments': segments,
                'base_url': self._get_base_url(url),
                'playlist_url': url
            }
            
            logger.info(f"  Found {len(segments)} video segments")
            if len(segments) == 0:
                logger.warning("❌ No segments parsed from playlist")
                # Show more of the playlist for debugging
                logger.warning(f"Full playlist content: {playlist_content}")
            
            return result
            
        except requests.exceptions.RequestException as e:
            logger.error(f"❌ Step 4 failed - Request error: {e}")
            return None

    def step5_get_video_segment(self, segment_url: str) -> Optional[bytes]:
        """Step 5: Get individual video segment (unchanged)"""
        try:
            response = self.session.get(segment_url, headers=self.stream_headers, timeout=30, verify=False)
            response.raise_for_status()
            
            segment_data = response.content
            logger.debug(f"✅ Step 5 successful - Segment retrieved ({len(segment_data)} bytes)")
            
            return segment_data
            
        except requests.exceptions.RequestException as e:
            logger.error(f"❌ Step 5 failed - Request error: {e}")
            return None

    def _parse_m3u8_playlist(self, playlist_content: str, base_url: str) -> List[Dict]:
        """Parse m3u8 playlist to extract segment information (unchanged)"""
        import re
        
        segments = []
        lines = playlist_content.strip().split('\n')
        
        base_url_parsed = urlparse(base_url)
        base_path = '/'.join(base_url_parsed.path.split('/')[:-1]) + '/'
        base_domain = f"{base_url_parsed.scheme}://{base_url_parsed.netloc}"
        
        current_duration = None
        current_date = None
        
        for line in lines:
            line = line.strip()
            
            if line.startswith('#EXTINF:'):
                duration_match = re.search(r'#EXTINF:([\d.]+)', line)
                if duration_match:
                    current_duration = float(duration_match.group(1))
                    logger.debug(f"Found EXTINF: {line} -> duration: {current_duration}")
            
            elif line.startswith('#EXT-X-PROGRAM-DATE-TIME:'):
                current_date = line.replace('#EXT-X-PROGRAM-DATE-TIME:', '')
                logger.debug(f"Found program date: {current_date}")
            
            elif '.ts' in line and not line.startswith('#'):
                # Handle segment lines (like "175d71cfa01b_seg10702.ts?token=...")
                if not line.strip():
                    continue
                    
                logger.debug(f"Processing segment line: {line}")
                    
                # Fix duplicate token parameters in segment URLs
                if '&token=' in line:
                    # Remove duplicate token parameters
                    line = line.split('&token=')[0]
                    
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
                logger.debug(f"Added segment: {segment_info['filename']} - {full_url}")
                
                current_duration = None
                current_date = None
        
        return segments

    def _get_base_url(self, full_url: str) -> str:
        """Extract base URL from full URL (unchanged)"""
        parsed = urlparse(full_url)
        return f"{parsed.scheme}://{parsed.netloc}"

    def get_authenticated_stream_info(self, camera_id: str) -> Optional[Dict]:
        """
        Complete authentication flow using cached responses
        
        Args:
            camera_id: Camera ID from cache
            
        Returns:
            Dict with complete streaming information or None if failed
        """
        logger.info("=" * 60)
        logger.info(f"FL-511 Cached Video Authentication - Camera {camera_id}")
        logger.info("=" * 60)
        
        # Get camera info from cache
        camera_info = self.get_camera_by_id(camera_id)
        if not camera_info:
            logger.error(f"❌ Camera {camera_id} not found in cache")
            return None
        
        logger.info(f"📹 Camera: {camera_info.get('description', 'Unknown')}")
        logger.info(f"📍 Location: {camera_info.get('location', 'Unknown')}")
        logger.info(f"🔗 Base Video URL: {camera_info.get('video_url', 'Unknown')}")
        
        # Step 1: Get cached authentication info
        auth_info = self.step1_get_cached_auth_info(camera_id)
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
        logger.info("✅ Cached authentication flow completed successfully!")
        logger.info(f"📺 Streaming URL: {result['streaming_url']}")
        logger.info(f"🎬 Available segments: {len(result['segments'])}")
        logger.info("=" * 60)
        
        return result

    def download_video_segments(self, stream_info: Dict, max_segments: int = 5) -> List[Dict]:
        """Download video segments (unchanged from original)"""
        segments = stream_info.get('segments', [])
        camera_id = stream_info['camera_id']
        downloaded_segments = []
        
        if not segments:
            logger.warning(f"No segments available for camera {camera_id}")
            return downloaded_segments
        
        segments_to_download = segments[:max_segments]
        
        for i, segment in enumerate(segments_to_download):
            try:
                logger.info(f"Downloading segment {i+1}/{len(segments_to_download)} for camera {camera_id}")
                
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
    """Test the cached authentication system"""
    import argparse
    
    parser = argparse.ArgumentParser(description='FL-511 Cached Video Authentication System')
    parser.add_argument('--camera-id', help='Specific camera ID to test')
    parser.add_argument('--cache-file', default='fl511_video_auth_cache.json', help='Cache file path')
    parser.add_argument('--download-segments', type=int, default=3, help='Number of segments to download')
    
    args = parser.parse_args()
    
    # Initialize cached auth system
    auth_system = FL511VideoAuthCached(args.cache_file)
    
    if not auth_system.cameras_data:
        print("❌ No cached camera data found. Run prefetch_video_auth_responses.py first.")
        return 1
    
    print(f"📹 Loaded {len(auth_system.cameras_data)} cameras from cache")
    
    # Test specific camera or first available
    if args.camera_id:
        camera_id = args.camera_id
    else:
        camera_id = auth_system.cameras_data[0]['camera_id']
    
    print(f"\\n🧪 Testing camera: {camera_id}")
    
    # Get authenticated stream info
    stream_info = auth_system.get_authenticated_stream_info(camera_id)
    
    if not stream_info:
        print("❌ Failed to authenticate and get streaming information")
        return 1
    
    # Download video segments
    segments = auth_system.download_video_segments(stream_info, args.download_segments)
    
    if segments:
        print(f"\\n🎯 Successfully downloaded {len(segments)} video segments")
        total_size = sum(s['size_bytes'] for s in segments)
        print(f"📊 Total size: {total_size:,} bytes ({total_size/1024/1024:.2f} MB)")
        print(f"\\n✅ Cached system working perfectly!")
    else:
        print("❌ No video segments downloaded")
        return 1
    
    return 0


if __name__ == "__main__":
    exit(main())