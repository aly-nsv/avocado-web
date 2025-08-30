#!/usr/bin/env python3
"""
Local test script for FL511 video authentication and streaming
Test the HSS feeds authentication flow before deploying to cloud
"""

import sys
import os
sys.path.append('fl-video-auth')

from fl511_video_auth_revised import FL511VideoAuth
from fl511_scraper import FL511Scraper

def test_auth_with_real_cameras():
    """Test authentication with cameras from recent incidents"""
    print("🔍 Finding cameras from recent incidents...")
    
    # Get recent incidents
    scraper = FL511Scraper()
    incidents = scraper.fetch_incidents()
    recent_incidents = scraper.filter_last_24_hours(incidents)
    
    # Extract cameras that require auth
    test_cameras = []
    for incident in recent_incidents[:5]:  # Test first 5 incidents
        if incident.cameras:
            for camera in incident.cameras:
                if camera.images:
                    for image in camera.images:
                        if image.is_video_auth_required:
                            test_cameras.append({
                                'id': image.camera_site_id,
                                'description': image.description,
                                'incident': incident.description
                            })
                        if len(test_cameras) >= 3:  # Test max 3 cameras
                            break
                if len(test_cameras) >= 3:
                    break
        if len(test_cameras) >= 3:
            break
    
    if not test_cameras:
        print("❌ No cameras with video auth found in recent incidents")
        return False
    
    print(f"📹 Found {len(test_cameras)} cameras to test:")
    for cam in test_cameras:
        print(f"  - Camera {cam['id']}: {cam['description']}")
        print(f"    Incident: {cam['incident']}")
    
    # Test authentication
    auth_client = FL511VideoAuth()
    successful_auths = 0
    
    for i, camera in enumerate(test_cameras):
        print(f"\n{'='*60}")
        print(f"Testing Camera {i+1}/{len(test_cameras)}: {camera['id']}")
        print(f"{'='*60}")
        
        # Test full auth flow
        stream_info = auth_client.get_video_stream_info(str(camera['id']))
        
        if stream_info and stream_info.get('segments'):
            print(f"✅ SUCCESS: Camera {camera['id']} authenticated")
            print(f"   Segments available: {len(stream_info['segments'])}")
            print(f"   Streaming URL: {stream_info.get('streaming_url', 'N/A')}")
            
            # Test downloading one segment
            if stream_info['segments']:
                print(f"\n🎬 Testing segment download...")
                success = auth_client.test_segment_download(stream_info, 0)
                if success:
                    successful_auths += 1
                    print(f"✅ Segment download successful for camera {camera['id']}")
                else:
                    print(f"❌ Segment download failed for camera {camera['id']}")
        else:
            print(f"❌ FAILED: Camera {camera['id']} authentication failed")
    
    print(f"\n{'='*60}")
    print(f"🏁 TEST RESULTS")
    print(f"{'='*60}")
    print(f"Cameras tested: {len(test_cameras)}")
    print(f"Successful authentications: {successful_auths}")
    print(f"Success rate: {(successful_auths/len(test_cameras)*100):.1f}%")
    
    return successful_auths > 0

def test_specific_camera(camera_id: str):
    """Test authentication with a specific camera ID"""
    print(f"🎯 Testing specific camera: {camera_id}")
    
    auth_client = FL511VideoAuth()
    stream_info = auth_client.get_video_stream_info(camera_id)
    
    if not stream_info:
        print(f"❌ Authentication failed for camera {camera_id}")
        return False
    
    print(f"✅ Authentication successful!")
    
    # Test segment download
    if stream_info.get('segments'):
        print(f"\n🎬 Testing segment download...")
        success = auth_client.test_segment_download(stream_info, 0)
        return success
    
    return True

def main():
    """Main test function"""
    print("🚀 FL511 Video Authentication Local Test")
    print("="*60)
    
    if len(sys.argv) > 1:
        # Test specific camera ID
        camera_id = sys.argv[1]
        success = test_specific_camera(camera_id)
    else:
        # Test with cameras from recent incidents
        success = test_auth_with_real_cameras()
    
    if success:
        print("\n✅ Local video auth tests PASSED - ready for cloud deployment!")
        return 0
    else:
        print("\n❌ Local video auth tests FAILED - check authentication flow")
        return 1

if __name__ == "__main__":
    exit(main())