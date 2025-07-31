#!/usr/bin/env python3
"""
Get fresh authentication and immediately play the video stream
"""

import sys
import subprocess
from fl511_video_tester_cli import FL511VideoTesterCLI

def main():
    camera_id = "1248"
    if len(sys.argv) > 1:
        camera_id = sys.argv[1]
    
    print("=" * 60)
    print("FL-511 Live Stream Player")
    print("=" * 60)
    
    # Create tester instance and get fresh authentication
    tester = FL511VideoTesterCLI()
    
    print(f"Getting fresh authentication for camera {camera_id}...")
    stream_url = tester.test_video_stream(camera_id)
    
    if stream_url:
        print("\n" + "=" * 60)
        print("🎥 LAUNCHING VIDEO PLAYER")
        print("=" * 60)
        
        # Launch video player immediately with fresh token
        try:
            cmd = [
                'ffplay',
                '-i', stream_url,
                '-window_title', f'FL-511 Camera {camera_id} - Live Stream',
                '-autoexit',
                '-loglevel', 'error',  # Only show errors
                '-hide_banner'  # Hide banner
            ]
            
            print("🚀 Starting video player...")
            print("💡 A video window should open shortly")
            print("💡 Press 'q' in the video window to quit")
            
            # Start the video player
            process = subprocess.Popen(cmd)
            print(f"✅ Video player launched (PID: {process.pid})")
            
            # Wait for the video player to finish
            try:
                print("\nVideo is playing... Press Ctrl+C to stop")
                process.wait()
                print("Video player closed.")
            except KeyboardInterrupt:
                print("\nStopping video...")
                process.terminate()
                print("Video stopped.")
                
        except FileNotFoundError:
            print("❌ ffplay not found. Install with: brew install ffmpeg")
            print(f"📋 Stream URL (copy to your video player): {stream_url}")
        except Exception as e:
            print(f"❌ Error launching video: {e}")
            print(f"📋 Stream URL (copy to your video player): {stream_url}")
    else:
        print("\n❌ Failed to get authenticated stream URL")
        sys.exit(1)

if __name__ == "__main__":
    main()