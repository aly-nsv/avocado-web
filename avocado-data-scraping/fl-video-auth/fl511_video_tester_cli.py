#!/usr/bin/env python3
"""
FL-511 Video Stream Authentication Tester (CLI Version)

This script implements the authentication flow for FL-511 traffic camera video streams
with a command-line interface when tkinter is not available.
"""

import requests
import json
import time
import subprocess
import sys
import argparse
from urllib.parse import urlparse, parse_qs
import urllib3

# Suppress SSL warnings for streaming servers
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

class FL511VideoTesterCLI:
    def __init__(self):
        # Authentication data extracted from the curl commands
        self.session_cookies = {
            'session-id': '23DC12AED6DEE4656DDC44EFD1CB01D72334AA1EDCCB689994E257801B1862455BD604F0B6B709DB9E212E6899C51A151B174EFA8EF5123F0D33D633B9BA1C2E40AD1BBCBCC7D77EADE87B661CF56291E053DC1EB5F79DC8DB018E2206323FFF9513FB7878C040E971787FBD29396438E13E24CA35392B2E774F744E7194A468',
            '_culture': 'en',
            'session': 'session',
            '__RequestVerificationToken': 'EiXaNABDvph_UtOy3s4I7xCwNI0BuCq5AB8ZvDsbEpEn_uaS9673UrHWjY1Q0obA-_sLU5iccz6lU3omN41ClPW4tXs1',
            '_gid': 'GA1.2.145556750.1753896432',
            '_region': 'ALL',
            '_ga_07ZPFGG911': 'GS2.1.s1753982363$o2$g1$t1753982363$j60$l0$h0',
            '_ga': 'GA1.1.129985649.1753896432',
            'map': '{"prevLatLng":[29.876387533219038,-81.53312194824218],"prevZoom":11,"selectedLayers":["TrafficSpeeds","Cameras"],"mapView":"2025-07-31T17:21:26.559Z","prevMapType":"google"}',
            '.AspNet.ApplicationCookie': 'gQjY0668zf96_k7iBP0qDDTYPhcYxOlSBxeevXy4K10db-A29uqMiGQJd-QA0wHKNZTqIAW8MR29s-HkbUqNWY_wfZylHBgPiH43rXGKdlW2nK3bXZD1c94j2hz5UqO1mtKJP3OqtU0q9VWLP18KZQJH5sz8MTpt8Zt9IwIoW_IZT2qz13IKPy40dKxVYFJijc7-1zwMF_hb497baEvJXTE5vnUpsmvD3GXrLMYDWOqgfkfNeTyKzWuSpGBGN06S1-LXcgdUC5SLNvdVgN_5QvvNh1Of59XQVUfROIPnW4ldLIap63L8vVDWnWfVjT6L1vnjdiQ6Vb3P5RyQZEr1ID4NzL1zfcv6DpiymtDbpp-GbSIc7tek-uOv6pMZb7ea7cJNm2wQhAJH1WT1s_excE7nT0nfFUllc9GN1Uonyi39zvCtpCCGE81CXjdSvguDa7M0VBhSmGJk2QEmyMNk4laacTPFbMpuYwLAEXjqBn0CR2UlmXvjgu9KIEu1E4PC1cBJHA'
        }
        
        self.request_verification_token = 'G1JaniFRF7zv-0WnyAqk0qOiR8plYN_4e7aW3y8S_Hx9N9g1KW6fokzdkvmqtwEw8UB5hwuQKKJqVR5FWHcuh3O5ngcFFqS1ftclpeA0lvihFolZHZI84U4wuwIIeN6-g6QIyw2'
        
        self.headers = {
            'Accept': '*/*',
            'Accept-Language': 'en-US,en;q=0.9',
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
            'Sec-Ch-Ua': '"Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"',
            'Sec-Ch-Ua-Mobile': '?0',
            'Sec-Ch-Ua-Platform': '"macOS"',
            'Sec-Fetch-Dest': 'empty',
            'Sec-Fetch-Mode': 'cors',
            'Sec-Fetch-Site': 'same-origin',
            'X-Requested-With': 'XMLHttpRequest'
        }
        
    def log(self, message, level="INFO"):
        """Print log message with timestamp"""
        timestamp = time.strftime('%H:%M:%S')
        print(f"[{timestamp}] {level}: {message}")
        
    def test_video_stream(self, camera_id):
        """Test the complete video stream authentication flow"""
        try:
            self.log(f"Starting authentication test for camera ID: {camera_id}")
            
            # Step 1: Get video URL from FL-511
            self.log("Step 1: Getting video URL from FL-511...")
            video_info = self._get_video_url(camera_id)
            if not video_info:
                self.log("Failed to get video URL", "ERROR")
                return None
                
            self.log("Video info received:")
            print(json.dumps(video_info, indent=2))
            
            # Step 2: Get secure token from Divas
            self.log("Step 2: Getting secure token from Divas...")
            token_info = self._get_secure_token(video_info)
            if not token_info:
                self.log("Failed to get secure token", "ERROR")
                return None
                
            self.log("Token info received:")
            print(json.dumps(token_info, indent=2))
            
            # Step 3: Test stream access
            self.log("Step 3: Testing stream access...")
            stream_url = self._test_stream_access(token_info, video_info)
            if not stream_url:
                self.log("Failed to access stream", "ERROR")
                return None
                
            self.log(f"SUCCESS: Stream URL ready: {stream_url}")
            return stream_url
            
        except Exception as e:
            self.log(f"Error in authentication flow: {str(e)}", "ERROR")
            return None
            
    def _get_video_url(self, camera_id):
        """Step 1: Get video URL from FL-511"""
        url = f"https://fl511.com/Camera/GetVideoUrl?imageId={camera_id}&_={int(time.time() * 1000)}"
        
        headers = self.headers.copy()
        headers['__requestverificationtoken'] = self.request_verification_token
        headers['Referer'] = 'https://fl511.com/map'
        
        try:
            self.log(f"Making request to: {url}")
            response = requests.get(url, headers=headers, cookies=self.session_cookies, timeout=30)
            self.log(f"Response status: {response.status_code}")
            
            if response.status_code != 200:
                self.log(f"HTTP Error: {response.status_code} - {response.text[:200]}", "ERROR")
                return None
            
            try:
                data = response.json()
                self.log(f"Response data: {json.dumps(data, indent=2)}")
            except json.JSONDecodeError:
                self.log(f"Non-JSON response: {response.text[:200]}", "ERROR")
                return None
                
            # Check if we have the required fields for video authentication
            if data.get('token') and data.get('sourceId'):
                return data
            else:
                self.log(f"FL-511 response missing required fields: {data.get('message', 'No token or sourceId found')}", "ERROR")
                self.log(f"Full response: {json.dumps(data, indent=2)}")
                return None
                
        except requests.exceptions.RequestException as e:
            self.log(f"Request error getting video URL: {str(e)}", "ERROR")
            return None
        except json.JSONDecodeError as e:
            self.log(f"JSON decode error: {str(e)}", "ERROR")
            return None
            
    def _get_secure_token(self, video_info):
        """Step 2: Get secure token from Divas cloud"""
        url = "https://divas.cloud/VDS-API/SecureTokenUri/GetSecureTokenUriBySourceId"
        
        # Extract token and source info from video_info
        token = video_info.get('token')
        source_id = video_info.get('sourceId')
        system_source_id = video_info.get('systemSourceId', 'District 2')
        
        if not token or not source_id:
            self.log(f"Missing required data from video info: token={token}, sourceId={source_id}", "ERROR")
            return None
            
        payload = {
            "token": token,
            "sourceId": source_id,
            "systemSourceId": system_source_id
        }
        
        headers = {
            '__requestverificationtoken': self.request_verification_token,
            'Accept': '*/*',
            'Accept-Language': 'en-US,en;q=0.9',
            'Content-Type': 'application/json',
            'Origin': 'https://fl511.com',
            'Referer': 'https://fl511.com/',
            'User-Agent': self.headers['User-Agent']
        }
        
        try:
            self.log(f"Making request to: {url}")
            self.log(f"Payload: {json.dumps(payload, indent=2)}")
            response = requests.post(url, headers=headers, json=payload, timeout=30)
            self.log(f"Response status: {response.status_code}")
            
            if response.status_code != 200:
                self.log(f"HTTP Error: {response.status_code} - {response.text[:200]}", "ERROR")
                return None
            
            # Try to parse as JSON first
            try:
                data = response.json()
                self.log(f"JSON Response data: {json.dumps(data, indent=2)}")
                
                # Check if the data is a string (which would be the token parameter)
                if isinstance(data, str) and data.startswith('?token='):
                    self.log(f"Received token parameter: {data}")
                    return {'tokenParam': data}
                # Check for secureUri in the response if it's a dict
                elif isinstance(data, dict) and (data.get('secureUri') or data.get('data', {}).get('secureUri')):
                    return data
                else:
                    self.log(f"Unexpected JSON response format: {type(data)} - {data}", "ERROR")
                    return None
            except json.JSONDecodeError:
                # If not JSON, it might be a raw token string
                token_param = response.text.strip()
                self.log(f"Non-JSON response (token parameter): {token_param}")
                
                if token_param.startswith('?token='):
                    return {'tokenParam': token_param}
                else:
                    self.log(f"Unexpected response format: {token_param[:200]}", "ERROR")
                    return None
                
        except requests.exceptions.RequestException as e:
            self.log(f"Request error getting secure token: {str(e)}", "ERROR")
            return None
        except json.JSONDecodeError as e:
            self.log(f"JSON decode error: {str(e)}", "ERROR")
            return None
            
    def _test_stream_access(self, token_info, video_info):
        """Step 3: Test access to the HLS stream"""
        # Try different ways to get the secure URI
        secure_uri = token_info.get('secureUri')
        if not secure_uri and isinstance(token_info.get('data'), dict):
            secure_uri = token_info.get('data', {}).get('secureUri')
        
        # If we have a token parameter, construct the URL from the video info
        if not secure_uri and token_info.get('tokenParam'):
            token_param = token_info.get('tokenParam')
            
            # Try to get the video URL from the video_info response
            video_url = video_info.get('videoUrl') or video_info.get('url')
            
            if video_url:
                secure_uri = video_url + token_param
                self.log(f"Constructed secure URI from video info: {secure_uri}")
            else:
                # Fallback to hardcoded URL for camera 1248/646
                base_url = "https://dis-se14.divas.cloud:8200/chan-1013_h/index.m3u8"
                secure_uri = base_url + token_param
                self.log(f"Using fallback URL (may not work for all cameras): {secure_uri}")
        
        if not secure_uri:
            self.log(f"No secure URI found in token info: {json.dumps(token_info, indent=2)}", "ERROR")
            return None
            
        headers = {
            'Accept': '*/*',
            'Accept-Language': 'en-US,en;q=0.9',
            'Origin': 'https://fl511.com',
            'Referer': 'https://fl511.com/',
            'User-Agent': self.headers['User-Agent']
        }
        
        try:
            # Test the main playlist (disable SSL verification for streaming servers)
            response = requests.get(secure_uri, headers=headers, timeout=30, verify=False)
            response.raise_for_status()
            
            self.log(f"Successfully accessed stream playlist ({len(response.content)} bytes)")
            self.log("Playlist content preview:")
            print("-" * 50)
            print(response.text[:500] + "..." if len(response.text) > 500 else response.text)
            print("-" * 50)
            
            return secure_uri
            
        except requests.exceptions.RequestException as e:
            self.log(f"Request error testing stream access: {str(e)}", "ERROR")
            return None
            
    def play_video(self, stream_url):
        """Play the video stream using system video player"""
        self.log(f"Attempting to play video: {stream_url}")
        
        players = [
            ['ffplay', '-i', stream_url, '-window_title', 'FL-511 Camera Stream', '-autoexit'],
            ['vlc', stream_url],
            ['mpv', stream_url]
        ]
        
        for player_cmd in players:
            try:
                self.log(f"Trying {player_cmd[0]}...")
                process = subprocess.Popen(player_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                self.log(f"Video player started with {player_cmd[0]} (PID: {process.pid})")
                self.log("🎥 A video window should have opened!")
                self.log("💡 If you don't see it, check:")
                self.log("   - Behind other windows or minimized")
                self.log("   - On a different desktop/space (macOS)")
                self.log("   - System permissions dialog")
                return process
                
            except FileNotFoundError:
                continue
                
        # No player found
        self.log("No video player found. Available options:", "ERROR")
        print("Install one of the following:")
        print("  - ffmpeg: brew install ffmpeg")
        print("  - VLC: https://www.videolan.org/vlc/")
        print("  - mpv: brew install mpv")
        print(f"\nOr copy this URL to your browser/video player:\n{stream_url}")
        return None

def main():
    parser = argparse.ArgumentParser(description='Test FL-511 video stream authentication')
    parser.add_argument('--camera-id', '-c', default='1248', help='Camera ID to test (default: 1248)')
    parser.add_argument('--play', '-p', action='store_true', help='Automatically play video if authentication succeeds')
    parser.add_argument('--no-play', action='store_true', help='Only test authentication, do not play video')
    
    args = parser.parse_args()
    
    tester = FL511VideoTesterCLI()
    
    print("=" * 60)
    print("FL-511 Video Stream Authentication Tester")
    print("=" * 60)
    
    # Test authentication flow
    stream_url = tester.test_video_stream(args.camera_id)
    
    if stream_url:
        print("\n" + "=" * 60)
        print("AUTHENTICATION SUCCESSFUL!")
        print("=" * 60)
        print(f"Stream URL: {stream_url}")
        
        if not args.no_play:
            if args.play:
                tester.play_video(stream_url)
            else:
                play = input("\nWould you like to play the video? (y/N): ").lower().strip()
                if play in ['y', 'yes']:
                    tester.play_video(stream_url)
                else:
                    print("You can copy the URL above to play in your preferred video player.")
    else:
        print("\n" + "=" * 60)
        print("AUTHENTICATION FAILED")
        print("=" * 60)
        sys.exit(1)

if __name__ == "__main__":
    main()