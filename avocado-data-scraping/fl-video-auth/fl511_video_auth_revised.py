#!/usr/bin/env python3
"""
FL-511 Video Stream Authentication - Revised Implementation

Implements the correct 4-step authentication process:
1. GET video URL from FL-511 (imageId -> token, sourceId, systemSourceId)  
2. POST to Divas SecureTokenUri API (get streaming URL with token)
3. GET HLS playlist (m3u8 file with segment list)
4. GET video segments (.ts files for streaming)
"""

import requests
import json
import time
import re
import warnings
from urllib.parse import urljoin, urlparse
from typing import Dict, Optional, List

# Suppress SSL warnings for development
warnings.filterwarnings('ignore', message='Unverified HTTPS request')
requests.packages.urllib3.disable_warnings()


class FL511VideoAuth:
    def __init__(self):
        """Initialize the FL-511 video authentication client"""
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

    def step1_get_video_url(self, camera_id: str) -> Optional[Dict]:
        """
        Step 1: Get video URL from FL-511
        
        Args:
            camera_id: Camera ID (imageId parameter)
            
        Returns:
            Dict with token, sourceId, systemSourceId or None if failed
        """
        url = f'https://fl511.com/Camera/GetVideoUrl?imageId={camera_id}'
        
        try:
            print(f"Step 1: Getting video URL for camera {camera_id}...")
            response = self.session.get(url, headers=self.fl511_headers, timeout=30)
            response.raise_for_status()
            
            data = response.json()
            print(f"✅ Step 1 successful: {json.dumps(data, indent=2)}")
            return data
            
        except requests.exceptions.RequestException as e:
            print(f"❌ Step 1 failed - Request error: {e}")
            return None
        except json.JSONDecodeError as e:
            print(f"❌ Step 1 failed - JSON decode error: {e}")
            return None

    def step2_get_secure_token_uri(self, token: str, source_id: str, system_source_id: str = "District 2") -> Optional[Dict]:
        """
        Step 2: Get secure token URI from Divas cloud
        
        Args:
            token: Token from step 1
            source_id: Source ID from step 1  
            system_source_id: System source ID (defaults to "District 2")
            
        Returns:
            Dict with secure URI and streaming details or None if failed
        """
        url = 'https://divas.cloud/VDS-API/SecureTokenUri/GetSecureTokenUriBySourceId'
        
        payload = {
            "token": token,
            "sourceId": source_id,
            "systemSourceId": system_source_id
        }
        
        try:
            print(f"Step 2: Getting secure token URI...")
            print(f"  Payload: {json.dumps(payload, indent=2)}")
            
            response = self.session.post(url, headers=self.divas_headers, json=payload, timeout=30)
            response.raise_for_status()
            
            data = response.json()
            print(f"✅ Step 2 successful: {json.dumps(data, indent=2)}")
            return data
            
        except requests.exceptions.RequestException as e:
            print(f"❌ Step 2 failed - Request error: {e}")
            return None
        except json.JSONDecodeError as e:
            print(f"❌ Step 2 failed - JSON decode error: {e}")
            return None

    def step3_get_hls_playlist(self, secure_uri: str, silent_fail: bool = False) -> Optional[Dict]:
        """
        Step 3: Get HLS playlist (m3u8) with current segments
        
        Args:
            secure_uri: Secure URI from step 2
            
        Returns:
            Dict with playlist content and parsed segments or None if failed
        """
        try:
            print(f"Step 3: Getting HLS playlist...")
            print(f"  URL: {secure_uri}")
            
            response = self.session.get(secure_uri, headers=self.stream_headers, timeout=30, verify=False)
            response.raise_for_status()
            
            playlist_content = response.text
            print(f"✅ Step 3 successful - Playlist retrieved ({len(playlist_content)} chars)")
            
            # Parse the playlist to extract segments
            segments = self._parse_m3u8_playlist(playlist_content, secure_uri)
            
            result = {
                'playlist_content': playlist_content,
                'segments': segments,
                'base_url': self._get_base_url(secure_uri)
            }
            
            print(f"  Found {len(segments)} video segments")
            return result
            
        except requests.exceptions.RequestException as e:
            if not silent_fail:
                print(f"❌ Step 3 failed - Request error: {e}")
            return None

    def step4_get_video_segment(self, segment_url: str) -> Optional[bytes]:
        """
        Step 4: Get individual video segment (.ts file)
        
        Args:
            segment_url: Full URL to video segment
            
        Returns:
            Video segment bytes or None if failed
        """
        try:
            print(f"Step 4: Getting video segment...")
            print(f"  URL: {segment_url}")
            
            response = self.session.get(segment_url, headers=self.stream_headers, timeout=30, verify=False)
            response.raise_for_status()
            
            segment_data = response.content
            print(f"✅ Step 4 successful - Segment retrieved ({len(segment_data)} bytes)")
            
            return segment_data
            
        except requests.exceptions.RequestException as e:
            print(f"❌ Step 4 failed - Request error: {e}")
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
                line = line.strip()
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

    def get_video_stream_info(self, camera_id: str) -> Optional[Dict]:
        """
        Complete authentication flow - get streaming info for a camera
        
        Args:
            camera_id: FL-511 camera ID
            
        Returns:
            Dict with complete streaming information or None if failed
        """
        print("=" * 60)
        print(f"FL-511 Video Authentication Flow - Camera {camera_id}")
        print("=" * 60)
        
        # Step 1: Get video URL
        video_info = self.step1_get_video_url(camera_id)
        if not video_info:
            return None
        
        # Extract required data from step 1
        token = video_info.get('token')
        source_id = video_info.get('sourceId')
        system_source_id = video_info.get('systemSourceId', 'District 2')
        
        if not token or not source_id:
            print(f"❌ Missing required data from step 1: token={token}, sourceId={source_id}")
            return None
        
        # Step 2: Get secure token URI
        token_info = self.step2_get_secure_token_uri(token, source_id, system_source_id)
        if not token_info:
            return None
        
        # Handle different response formats from step 2
        if isinstance(token_info, str):
            # Response is a token parameter string like "?token=..."
            # Extract just the token value (remove "?token=")
            if token_info.startswith('?token='):
                token_value = token_info[7:]  # Remove "?token="
            else:
                token_value = token_info
            
            print(f"Extracted token value: {token_value}")
            source_id = video_info.get('sourceId')
        elif isinstance(token_info, dict):
            # Response is a JSON object with secureUri
            secure_uri = token_info.get('secureUri')
            if not secure_uri:
                print("❌ No secureUri found in step 2 response")
                return None
        else:
            print("❌ Unexpected response format from step 2")
            return None
        
        # Step 3: Get HLS playlist - try multiple servers and patterns if needed
        playlist_info = None
        if isinstance(token_info, str):
            # Get video URL from video info if available
            video_url = video_info.get('videoUrl') or video_info.get('url')
            if video_url:
                test_uri = video_url + token_info  # token_info still has "?token=" format here
                print(f"Trying video URL from response: {video_url}")
                playlist_info = self.step3_get_hls_playlist(test_uri, silent_fail=True)
                if playlist_info:
                    secure_uri = test_uri
                else:
                    print("  ❌ Video URL from response failed")
            
            # If video URL didn't work, try server/pattern combinations
            if not playlist_info:
                servers_to_try = ['dis-se1', 'dis-se14', 'dis-se2', 'dis-se3']
                patterns_to_try = [
                    f"chan-8306_h/xflow.m3u8",   # Pattern from your curl example (exact match)
                    f"chan-{source_id}_h/xflow.m3u8",   # Pattern with xflow.m3u8 using sourceId
                    f"chan-{camera_id}_h/xflow.m3u8",   # Pattern with xflow.m3u8 using camera_id
                    f"chan-1013_h/index.m3u8",  # Fallback pattern from existing code
                    f"chan-{source_id}_h/index.m3u8",  # Standard pattern with index.m3u8
                    f"chan-8306_h/index.m3u8",   # Pattern from your curl example with index
                    f"chan-{camera_id}_h/index.m3u8",  # Try camera ID as channel
                ]
                
                for server in servers_to_try:
                    for pattern in patterns_to_try:
                        # Construct URL with proper token format: ?token=VALUE
                        test_uri = f"https://{server}.divas.cloud:8200/{pattern}?token={token_value}"
                        print(f"Trying: {server} with {pattern}")
                        playlist_info = self.step3_get_hls_playlist(test_uri, silent_fail=True)
                        if playlist_info:
                            secure_uri = test_uri  # Update secure_uri to the working one
                            print(f"✅ Found working combination: {server} + {pattern}")
                            break
                    if playlist_info:
                        break
            
            if not playlist_info:
                print("❌ Failed to find working server/pattern combination for HLS playlist")
                return None
        else:
            playlist_info = self.step3_get_hls_playlist(secure_uri)
            if not playlist_info:
                return None
        
        # Combine all information
        result = {
            'camera_id': camera_id,
            'step1_video_info': video_info,
            'step2_token_info': token_info,
            'step3_playlist_info': playlist_info,
            'streaming_url': secure_uri,
            'segments': playlist_info['segments']
        }
        
        print("=" * 60)
        print("✅ Authentication flow completed successfully!")
        print(f"📺 Streaming URL: {secure_uri}")
        print(f"🎬 Available segments: {len(playlist_info['segments'])}")
        print("=" * 60)
        
        return result

    def test_segment_download(self, stream_info: Dict, segment_index: int = 0) -> bool:
        """
        Test downloading a specific video segment
        
        Args:
            stream_info: Result from get_video_stream_info()
            segment_index: Which segment to download (default: first)
            
        Returns:
            True if successful, False otherwise
        """
        segments = stream_info.get('segments', [])
        if not segments:
            print("❌ No segments available")
            return False
        
        if segment_index >= len(segments):
            segment_index = 0
        
        segment = segments[segment_index]
        segment_data = self.step4_get_video_segment(segment['url'])
        
        if segment_data:
            print(f"✅ Successfully downloaded segment {segment_index}: {segment['filename']}")
            print(f"   Size: {len(segment_data)} bytes")
            print(f"   Duration: {segment.get('duration', 'unknown')} seconds")
            return True
        else:
            return False


def main():
    """Main function for testing the authentication flow"""
    import argparse
    
    parser = argparse.ArgumentParser(description='FL-511 Video Authentication Test')
    parser.add_argument('camera_id', help='Camera ID to test')
    parser.add_argument('--test-segment', action='store_true', help='Test downloading a video segment')
    parser.add_argument('--segment-index', type=int, default=0, help='Segment index to download (default: 0)')
    
    args = parser.parse_args()
    
    # Create authentication client
    auth_client = FL511VideoAuth()
    
    # Get streaming information
    stream_info = auth_client.get_video_stream_info(args.camera_id)
    
    if not stream_info:
        print("❌ Failed to authenticate and get streaming information")
        return 1
    
    # Test segment download if requested
    if args.test_segment:
        print("\n" + "=" * 60)
        print("Testing video segment download...")
        print("=" * 60)
        
        success = auth_client.test_segment_download(stream_info, args.segment_index)
        if not success:
            print("❌ Segment download test failed")
            return 1
    
    print("\n🎯 To use this stream in a video player:")
    print(f"   URL: {stream_info['streaming_url']}")
    print("   Example: ffplay -i '<URL>'")
    
    return 0


if __name__ == "__main__":
    exit(main())