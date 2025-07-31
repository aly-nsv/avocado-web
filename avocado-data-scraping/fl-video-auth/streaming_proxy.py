#!/usr/bin/env python3
"""
FL-511 Video Streaming Proxy Server

This proxy server handles token refresh automatically, solving the issue where
tokens expire while the video player is trying to access video segments.
"""

import http.server
import socketserver
import urllib.parse
import requests
import time
import threading
import json
from fl511_video_tester_cli import FL511VideoTesterCLI

class StreamingProxyHandler(http.server.BaseHTTPRequestHandler):
    """HTTP request handler that proxies video streams with automatic token refresh"""
    
    def __init__(self, *args, **kwargs):
        self.tester = FL511VideoTesterCLI()
        super().__init__(*args, **kwargs)
    
    def do_GET(self):
        """Handle GET requests by proxying them to the video server with fresh tokens"""
        try:
            # Parse the request URL
            parsed_url = urllib.parse.urlparse(self.path)
            query_params = urllib.parse.parse_qs(parsed_url.query)
            
            # Extract camera_id from the path (format: /camera/{camera_id}/...)
            path_parts = parsed_url.path.strip('/').split('/')
            if len(path_parts) < 2 or path_parts[0] != 'camera':
                self.send_error(404, "Invalid path format. Use /camera/{camera_id}/...")
                return
            
            camera_id = path_parts[1]
            remaining_path = '/'.join(path_parts[2:]) if len(path_parts) > 2 else 'index.m3u8'
            
            self.log_message(f"Proxying request for camera {camera_id}, path: {remaining_path}")
            
            # Get fresh authentication for this camera
            video_info = self.tester._get_video_url(camera_id)
            if not video_info:
                self.send_error(502, "Failed to get video info from FL-511")
                return
            
            token_info = self.tester._get_secure_token(video_info)
            if not token_info:
                self.send_error(502, "Failed to get secure token")
                return
            
            # Construct the actual video server URL
            video_url = video_info.get('videoUrl') or video_info.get('url')
            if not video_url:
                # Fallback for known cameras
                if camera_id == "1248":
                    video_url = "https://dis-se14.divas.cloud:8200/chan-1013_h"
                else:
                    self.send_error(502, f"No video URL found for camera {camera_id}")
                    return
            
            # Remove any existing index.m3u8 from the base URL
            if video_url.endswith('/index.m3u8'):
                video_url = video_url[:-12]
            elif video_url.endswith('.m3u8'):
                video_url = video_url.rsplit('/', 1)[0]
            
            # Construct the final URL with token
            token_param = token_info.get('tokenParam', '')
            target_url = f"{video_url}/{remaining_path}{token_param}"
            
            self.log_message(f"Proxying to: {target_url}")
            
            # Make request to the video server
            headers = {
                'Accept': '*/*',
                'Accept-Language': 'en-US,en;q=0.9',
                'Origin': 'https://fl511.com',
                'Referer': 'https://fl511.com/',
                'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'
            }
            
            response = requests.get(target_url, headers=headers, timeout=30, verify=False, stream=True)
            
            if response.status_code != 200:
                self.log_message(f"Video server returned {response.status_code}")
                self.send_error(response.status_code, f"Video server error: {response.status_code}")
                return
            
            # Forward the response
            self.send_response(200)
            
            # Forward relevant headers
            for header, value in response.headers.items():
                if header.lower() not in ['connection', 'transfer-encoding']:
                    self.send_header(header, value)
            
            self.end_headers()
            
            # Stream the content
            for chunk in response.iter_content(chunk_size=8192):
                if chunk:
                    self.wfile.write(chunk)
                    
        except Exception as e:
            self.log_message(f"Error proxying request: {str(e)}")
            self.send_error(500, f"Proxy error: {str(e)}")
    
    def log_message(self, format, *args):
        """Override to add timestamps to log messages"""
        timestamp = time.strftime('%H:%M:%S')
        print(f"[{timestamp}] PROXY: {format % args}")

class StreamingProxyServer:
    """Proxy server that handles FL-511 video streams with automatic token refresh"""
    
    def __init__(self, port=8888):
        self.port = port
        self.server = None
        self.server_thread = None
    
    def start(self):
        """Start the proxy server in a background thread"""
        self.server = socketserver.TCPServer(("localhost", self.port), StreamingProxyHandler)
        self.server_thread = threading.Thread(target=self.server.serve_forever, daemon=True)
        self.server_thread.start()
        print(f"🚀 Streaming proxy server started on http://localhost:{self.port}")
        print(f"💡 Use URLs like: http://localhost:{self.port}/camera/1248/index.m3u8")
        return f"http://localhost:{self.port}"
    
    def stop(self):
        """Stop the proxy server"""
        if self.server:
            self.server.shutdown()
            self.server.server_close()
            if self.server_thread:
                self.server_thread.join()
            print("🛑 Streaming proxy server stopped")
    
    def get_proxy_url(self, camera_id):
        """Get the proxy URL for a specific camera"""
        return f"http://localhost:{self.port}/camera/{camera_id}/index.m3u8"

def main():
    """Start the proxy server and keep it running"""
    import argparse
    import signal
    import sys
    
    parser = argparse.ArgumentParser(description='FL-511 Video Streaming Proxy Server')
    parser.add_argument('--port', '-p', type=int, default=8888, help='Port to listen on (default: 8888)')
    parser.add_argument('--camera-id', '-c', default='1248', help='Test with this camera ID')
    parser.add_argument('--test', '-t', action='store_true', help='Test the proxy with a camera')
    
    args = parser.parse_args()
    
    # Create and start the proxy server
    proxy = StreamingProxyServer(args.port)
    
    def signal_handler(sig, frame):
        print('\n🛑 Stopping proxy server...')
        proxy.stop()
        sys.exit(0)
    
    signal.signal(signal.SIGINT, signal_handler)
    
    try:
        base_url = proxy.start()
        
        if args.test:
            test_url = proxy.get_proxy_url(args.camera_id)
            print(f"\n🧪 Testing proxy with camera {args.camera_id}")
            print(f"Test URL: {test_url}")
            
            # Test the proxy
            try:
                import subprocess
                print("🎥 Launching video player to test proxy...")
                subprocess.run([
                    'ffplay',
                    '-i', test_url,
                    '-window_title', f'FL-511 Camera {args.camera_id} (via Proxy)',
                    '-autoexit'
                ])
            except FileNotFoundError:
                print("❌ ffplay not found. Install with: brew install ffmpeg")
                print(f"📋 Test URL (copy to your video player): {test_url}")
        else:
            print(f"\n📋 Proxy URLs:")
            print(f"   Camera 1248: {proxy.get_proxy_url('1248')}")
            print(f"   Other cameras: {base_url}/camera/{{camera_id}}/index.m3u8")
            print("\n💡 Press Ctrl+C to stop the server")
        
        # Keep the server running
        while True:
            time.sleep(1)
            
    except KeyboardInterrupt:
        proxy.stop()

if __name__ == "__main__":
    main()