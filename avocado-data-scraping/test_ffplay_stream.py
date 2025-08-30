#!/usr/bin/env python3
"""
Test FL511 streaming with ffplay using correct URL construction
"""

import sys
import json
import requests
import warnings
sys.path.append('fl-video-auth')

from fl511_video_auth_revised import FL511VideoAuth

warnings.filterwarnings('ignore')

def get_working_stream_url():
    """Get a working authenticated stream URL"""
    print("🎯 Getting working stream URL for ffplay test")
    print("="*60)
    
    # Use camera 1312 which we know has video auth
    camera_id = "1312"
    auth_client = FL511VideoAuth()
    
    print(f"Testing camera {camera_id}...")
    
    # Get authentication
    video_info = auth_client.step1_get_video_url(camera_id)
    if not video_info:
        return None
    
    token = video_info.get('token')
    source_id = video_info.get('sourceId')  # This is the CORRECT source ID
    system_source_id = video_info.get('systemSourceId')
    
    print(f"✅ Auth successful - Source ID from API: {source_id}")
    
    token_info = auth_client.step2_get_secure_token_uri(token, source_id, system_source_id)
    if not token_info:
        return None
    
    streaming_token = token_info[7:] if token_info.startswith('?token=') else token_info
    print(f"✅ Streaming token obtained")
    
    # Try different URL patterns with the CORRECT source ID from auth API
    servers = ['dis-se1', 'dis-se2', 'dis-se3', 'dis-se4', 'dis-se14', 'dis-se15']
    patterns = [
        f'chan-{source_id}_h/index.m3u8',
        f'chan-{source_id}_h/xflow.m3u8',
        f'chan-{source_id}_m/index.m3u8',
        f'chan-{source_id}_l/index.m3u8'
    ]
    
    session = requests.Session()
    headers = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
        'Accept': '*/*',
        'Referer': 'https://fl511.com/',
        'Origin': 'https://fl511.com'
    }
    
    print(f"\n🔍 Testing URL patterns with source ID {source_id}...")
    
    for server in servers:
        for pattern in patterns:
            url = f"https://{server}.divas.cloud:8200/{pattern}?token={streaming_token}"
            try:
                print(f"Testing: {server}.divas.cloud:8200/{pattern}", end='')
                response = session.get(url, headers=headers, timeout=15, verify=False)
                
                if response.status_code == 200 and '#EXTM3U' in response.text:
                    print(" ✅ SUCCESS!")
                    
                    # Save playlist for inspection
                    playlist_file = f"working_playlist_{camera_id}.m3u8"
                    with open(playlist_file, 'w') as f:
                        f.write(response.text)
                    
                    print(f"\n🎬 Working streaming URL found!")
                    print(f"   URL: {url}")
                    print(f"   Playlist saved: {playlist_file}")
                    print(f"   Content preview: {response.text[:200]}...")
                    
                    return url
                else:
                    print(f" ❌ ({response.status_code})")
                    
            except Exception as e:
                print(f" ❌ (timeout/error)")
    
    print("\n❌ No working URL patterns found")
    return None

def main():
    url = get_working_stream_url()
    
    if url:
        print(f"\n✅ SUCCESS! Ready to stream with ffplay")
        print(f"🎥 Command to run:")
        print(f"ffplay -i '{url}'")
        print(f"\n🔧 Alternative ffplay options:")
        print(f"ffplay -fflags +genpts -i '{url}'")
        print(f"ffplay -loglevel debug -i '{url}'")
        
        # Test if ffplay is available
        import subprocess
        try:
            subprocess.run(['which', 'ffplay'], check=True, capture_output=True)
            print(f"\n✅ ffplay is available - ready to stream!")
        except:
            print(f"\n⚠️  ffplay not found. Install with: brew install ffmpeg")
        
        return url
    else:
        print(f"\n❌ Could not establish working stream URL")
        return None

if __name__ == "__main__":
    main()