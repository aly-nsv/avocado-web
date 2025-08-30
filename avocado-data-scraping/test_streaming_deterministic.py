#!/usr/bin/env python3
"""
Test streaming using deterministic video URLs from the JSON file
"""

import sys
import json
sys.path.append('fl-video-auth')

from fl511_video_auth_revised import FL511VideoAuth

def load_cameras():
    """Load cameras from the JSON file"""
    with open('fl511_cameras_all_regions_20250730_135009.json', 'r') as f:
        return json.load(f)

def test_streaming_with_json():
    """Test streaming using video URLs from the JSON file"""
    print("🎯 Testing FL511 streaming with deterministic URLs from JSON")
    print("="*60)
    
    # Load cameras and find ones with video auth required
    cameras = load_cameras()
    auth_cameras = []
    
    for camera in cameras:
        if camera.get('raw_data', {}).get('images'):
            for image in camera['raw_data']['images']:
                if image.get('isVideoAuthRequired') and image.get('videoUrl'):
                    auth_cameras.append({
                        'camera_id': str(image['cameraSiteId']),
                        'source_id': camera['raw_data'].get('sourceId'),
                        'video_url': image['videoUrl'],
                        'description': camera['description'],
                        'location': camera['location']
                    })
                    if len(auth_cameras) >= 3:  # Test first 3
                        break
        if len(auth_cameras) >= 3:
            break
    
    if not auth_cameras:
        print("❌ No cameras with video auth found in JSON")
        return None
    
    print(f"📹 Found {len(auth_cameras)} cameras to test:")
    for cam in auth_cameras:
        print(f"  - Camera {cam['camera_id']}: {cam['description']}")
        print(f"    Base video URL: {cam['video_url']}")
    
    # Test authentication and streaming
    auth_client = FL511VideoAuth()
    
    for i, camera in enumerate(auth_cameras):
        print(f"\n{'='*60}")
        print(f"Testing Camera {i+1}: {camera['camera_id']} - {camera['description']}")
        print(f"{'='*60}")
        
        # Step 1: Get authentication token
        video_info = auth_client.step1_get_video_url(camera['camera_id'])
        if not video_info:
            print(f"❌ Failed to get auth info for camera {camera['camera_id']}")
            continue
        
        # Step 2: Get streaming token
        token = video_info.get('token')
        source_id = video_info.get('sourceId')
        system_source_id = video_info.get('systemSourceId', 'District 2')
        
        token_info = auth_client.step2_get_secure_token_uri(token, source_id, system_source_id)
        if not token_info:
            print(f"❌ Failed to get streaming token for camera {camera['camera_id']}")
            continue
        
        # Extract streaming token
        if isinstance(token_info, str) and token_info.startswith('?token='):
            streaming_token = token_info[7:]
        else:
            print(f"❌ Unexpected token format: {token_info}")
            continue
        
        # Build authenticated URL using the base video URL from JSON
        base_url = camera['video_url']
        authenticated_url = f"{base_url}?token={streaming_token}"
        
        print(f"✅ Authentication successful!")
        print(f"🔗 Authenticated streaming URL:")
        print(f"   {authenticated_url}")
        
        # Test if the URL works
        import requests
        try:
            response = requests.get(authenticated_url, timeout=10, verify=False)
            if response.status_code == 200 and '#EXTM3U' in response.text:
                print(f"✅ HLS playlist accessible!")
                print(f"   Content preview: {response.text[:100]}...")
                
                # Save for ffplay test
                playlist_file = f"camera_{camera['camera_id']}_playlist.m3u8"
                with open(playlist_file, 'w') as f:
                    f.write(response.text)
                
                print(f"\n🎬 Ready for ffplay test!")
                print(f"   Playlist saved to: {playlist_file}")
                print(f"   Test command: ffplay -i '{authenticated_url}'")
                
                return authenticated_url
            else:
                print(f"❌ URL not accessible (status: {response.status_code})")
        except Exception as e:
            print(f"❌ Error testing URL: {e}")
    
    return None

def main():
    url = test_streaming_with_json()
    if url:
        print(f"\n✅ SUCCESS! Ready to stream with ffplay")
        print(f"🎥 Stream URL: {url}")
        return url
    else:
        print(f"\n❌ No working streaming URLs found")
        return None

if __name__ == "__main__":
    url = main()
    if url:
        print(f"\n🚀 Run this command to stream:")
        print(f"ffplay -i '{url}'")