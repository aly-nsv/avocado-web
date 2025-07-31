#!/usr/bin/env python3
"""
Play FL-511 video stream using the streaming proxy to solve token expiration issues
"""

import sys
import time
import subprocess
import threading
import signal
from streaming_proxy import StreamingProxyServer

def main():
    camera_id = "1248"
    if len(sys.argv) > 1:
        camera_id = sys.argv[1]
    
    print("=" * 60)
    print("FL-511 Live Stream Player (with Proxy)")
    print("=" * 60)
    print("🔧 This method uses a local proxy to handle token refresh")
    print("🔧 This solves the 401 Unauthorized error you were experiencing")
    print()
    
    # Start the proxy server
    proxy = StreamingProxyServer(port=8889)  # Use different port to avoid conflicts
    
    def cleanup_and_exit(sig, frame):
        print('\n🛑 Stopping proxy and video player...')
        proxy.stop()
        sys.exit(0)
    
    signal.signal(signal.SIGINT, cleanup_and_exit)
    
    try:
        # Start proxy in background
        base_url = proxy.start()
        time.sleep(1)  # Give proxy a moment to start
        
        # Get the proxy URL for this camera
        proxy_url = proxy.get_proxy_url(camera_id)
        
        print(f"🎯 Camera ID: {camera_id}")
        print(f"🔗 Proxy URL: {proxy_url}")
        print()
        print("🚀 Starting video player...")
        print("💡 The proxy will handle token refresh automatically")
        print("💡 Press 'q' in the video window to quit")
        print("💡 Press Ctrl+C in this terminal to stop everything")
        print()
        
        # Launch video player with proxy URL
        try:
            cmd = [
                'ffplay',
                '-i', proxy_url,
                '-window_title', f'FL-511 Camera {camera_id} - Live Stream (Proxy)',
                '-autoexit',
                '-loglevel', 'error',
                '-hide_banner'
            ]
            
            process = subprocess.Popen(cmd)
            print(f"✅ Video player launched (PID: {process.pid})")
            
            # Wait for the video player to finish
            try:
                print("🎥 Video is playing via proxy... Press Ctrl+C to stop")
                process.wait()
                print("Video player closed.")
            except KeyboardInterrupt:
                print("\nStopping video...")
                process.terminate()
                print("Video stopped.")
                
        except FileNotFoundError:
            print("❌ ffplay not found. Install with: brew install ffmpeg")
            print(f"📋 Proxy URL (copy to your video player): {proxy_url}")
            print("\n💡 You can also test in a browser or with other players like VLC")
            
            # Keep proxy running so user can test manually
            try:
                print("🔄 Proxy server is still running for manual testing...")
                print("Press Ctrl+C to stop")
                while True:
                    time.sleep(1)
            except KeyboardInterrupt:
                pass
                
        except Exception as e:
            print(f"❌ Error launching video: {e}")
            print(f"📋 Proxy URL (copy to your video player): {proxy_url}")
    
    finally:
        proxy.stop()

if __name__ == "__main__":
    main()