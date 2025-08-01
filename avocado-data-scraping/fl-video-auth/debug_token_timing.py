#!/usr/bin/env python3
"""
Debug script to analyze token timing and expiration issues
"""

import time
import requests
import json
from fl511_video_tester_cli import FL511VideoTesterCLI

def test_token_timing(camera_id="1248", test_duration=60):
    """Test how long tokens remain valid and when they expire"""
    
    print("=" * 60)
    print("FL-511 Token Timing Debug")
    print("=" * 60)
    
    tester = FL511VideoTesterCLI()
    
    # Get initial authentication
    print("🔐 Getting initial authentication...")
    video_info = tester._get_video_url(camera_id)
    if not video_info:
        print("❌ Failed to get video info")
        return
    
    token_info = tester._get_secure_token(video_info)
    if not token_info:
        print("❌ Failed to get secure token")
        return
    
    # Construct the test URL
    token_param = token_info.get('tokenParam')
    if not token_param:
        print("❌ No token parameter found")
        return
    
    # Use video URL from response or fallback
    video_url = video_info.get('videoUrl') or video_info.get('url')
    if not video_url:
        video_url = "https://dis-se14.divas.cloud:8200/chan-1013_h/index.m3u8"
    
    test_url = video_url + token_param
    print(f"🎯 Test URL: {test_url}")
    print()
    
    headers = {
        'Accept': '*/*',
        'Accept-Language': 'en-US,en;q=0.9',
        'Origin': 'https://fl511.com',
        'Referer': 'https://fl511.com/',
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'
    }
    
    # Test the URL repeatedly to see when it starts failing
    print("⏱️  Testing token validity over time...")
    print("Time(s) | Status | Response Size | Notes")
    print("-" * 50)
    
    start_time = time.time()
    test_count = 0
    first_failure_time = None
    
    for elapsed in range(0, test_duration, 5):  # Test every 5 seconds
        current_time = time.time()
        elapsed_actual = current_time - start_time
        
        try:
            response = requests.get(test_url, headers=headers, timeout=10, verify=False)
            status = response.status_code
            size = len(response.content)
            
            if status == 200:
                notes = "✅ OK"
                # Parse playlist to see if it contains segments
                if response.text.strip():
                    lines = response.text.strip().split('\n')
                    segment_lines = [line for line in lines if line.endswith('.ts') or 'EXT-X-STREAM-INF' in line]
                    if segment_lines:
                        notes += f" ({len(segment_lines)} segments)"
            elif status == 401:
                notes = "❌ UNAUTHORIZED"
                if first_failure_time is None:
                    first_failure_time = elapsed_actual
            else:
                notes = f"⚠️  HTTP {status}"
                
        except requests.exceptions.RequestException as e:
            status = "ERR"
            size = 0
            notes = f"❌ {str(e)[:30]}..."
        
        print(f"{elapsed_actual:6.1f}  | {status:6} | {size:11} | {notes}")
        test_count += 1
        
        # If we've failed multiple times, no point continuing
        if first_failure_time and elapsed_actual - first_failure_time > 10:
            print("Multiple failures detected, stopping test...")
            break
        
        # Wait for next test interval
        time.sleep(5)
    
    print("-" * 50)
    if first_failure_time:
        print(f"🕐 Token became invalid after {first_failure_time:.1f} seconds")
    else:
        print(f"✅ Token remained valid for the entire {test_duration} second test")
    
    print()
    print("🔍 Additional Analysis:")
    
    # Test if we can get a fresh token and if it works immediately
    print("   Testing fresh token generation...")
    token_info_2 = tester._get_secure_token(video_info)
    if token_info_2:
        fresh_token_param = token_info_2.get('tokenParam')
        if fresh_token_param and fresh_token_param != token_param:
            print("   ✅ Fresh token generated successfully (different from original)")
            
            # Test the fresh token
            fresh_url = video_url + fresh_token_param
            try:
                response = requests.get(fresh_url, headers=headers, timeout=10, verify=False)
                if response.status_code == 200:
                    print("   ✅ Fresh token works immediately")
                else:
                    print(f"   ❌ Fresh token failed: HTTP {response.status_code}")
            except Exception as e:
                print(f"   ❌ Fresh token request failed: {e}")
        else:
            print("   ⚠️  Same token returned (may be cached)")
    else:
        print("   ❌ Failed to get fresh token")

def main():
    import argparse
    
    parser = argparse.ArgumentParser(description='Debug FL-511 token timing issues')
    parser.add_argument('--camera-id', '-c', default='1248', help='Camera ID to test')
    parser.add_argument('--duration', '-d', type=int, default=60, help='Test duration in seconds')
    
    args = parser.parse_args()
    
    test_token_timing(args.camera_id, args.duration)

if __name__ == "__main__":
    main()