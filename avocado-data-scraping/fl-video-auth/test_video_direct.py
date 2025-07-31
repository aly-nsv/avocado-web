#!/usr/bin/env python3
"""
Direct test of video playback with a known working URL
"""

import subprocess
import sys
import time

def test_ffplay_with_url(stream_url):
    """Test ffplay directly with the stream URL"""
    print(f"Testing ffplay with URL: {stream_url[:80]}...")
    
    try:
        # Launch ffplay with the stream URL
        cmd = [
            'ffplay',
            '-i', stream_url,
            '-window_title', 'FL-511 Test Stream',
            '-autoexit',
            '-loglevel', 'warning'  # Reduce output but show important messages
        ]
        
        print("Launching ffplay...")
        print("Command:", ' '.join(cmd))
        
        process = subprocess.Popen(cmd)
        print(f"✅ ffplay started with PID: {process.pid}")
        print("🎥 Video window should be opening...")
        print("💡 Press 'q' in the video window to quit")
        print("💡 If no window appears, check Task Manager/Activity Monitor")
        
        # Wait a bit and check if process is still running
        time.sleep(2)
        poll_result = process.poll()
        
        if poll_result is None:
            print("✅ Video player is running successfully!")
            print("   The video should be playing in a separate window.")
        else:
            print(f"❌ Video player exited with code: {poll_result}")
            
        return process
        
    except FileNotFoundError:
        print("❌ ffplay not found in PATH")
        return None
    except Exception as e:
        print(f"❌ Error launching ffplay: {e}")
        return None

if __name__ == "__main__":
    # Use the last known working URL from the authentication test
    test_url = "https://dis-se14.divas.cloud:8200/chan-1013_h/index.m3u8?token=cac078feaeea70726a620e70cebb64d7cd5dfade65cefdfede206051d4c61234"
    
    if len(sys.argv) > 1:
        test_url = sys.argv[1]
    
    print("=" * 60)
    print("FL-511 Video Player Direct Test")
    print("=" * 60)
    
    process = test_ffplay_with_url(test_url)
    
    if process:
        try:
            # Keep the script running while video plays
            print("\nPress Ctrl+C to stop the video and exit")
            process.wait()  # Wait for ffplay to finish
        except KeyboardInterrupt:
            print("\nStopping video...")
            process.terminate()
            print("Video stopped.")