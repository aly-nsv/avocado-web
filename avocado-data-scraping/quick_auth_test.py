#!/usr/bin/env python3
"""
Quick test of FL511 video authentication steps 1-2 only
This helps verify the auth flow is working before cloud deployment
"""

import sys
sys.path.append('fl-video-auth')

from fl511_video_auth_revised import FL511VideoAuth

def test_auth_steps_only():
    """Test just the authentication steps (1-2) to verify they work"""
    print("🎯 Quick FL511 Video Authentication Test")
    print("Testing Steps 1-2 only (authentication flow)")
    print("="*60)
    
    # Use a known camera ID for testing
    test_camera_id = "673"  # From recent test
    
    auth_client = FL511VideoAuth()
    
    # Step 1: Get video URL
    print(f"Testing camera {test_camera_id}...")
    video_info = auth_client.step1_get_video_url(test_camera_id)
    
    if not video_info:
        print("❌ Step 1 failed")
        return False
    
    print("✅ Step 1 SUCCESS - Got token and source info")
    token = video_info.get('token')
    source_id = video_info.get('sourceId')
    system_source_id = video_info.get('systemSourceId')
    
    print(f"  Token: {token}")
    print(f"  Source ID: {source_id}")
    print(f"  System Source ID: {system_source_id}")
    
    # Step 2: Get secure token
    if not token or not source_id:
        print("❌ Missing required data from step 1")
        return False
    
    token_info = auth_client.step2_get_secure_token_uri(token, source_id, system_source_id)
    
    if not token_info:
        print("❌ Step 2 failed")
        return False
    
    print("✅ Step 2 SUCCESS - Got streaming token")
    print(f"  Token info: {token_info}")
    
    # Extract the actual token value
    if isinstance(token_info, str) and token_info.startswith('?token='):
        streaming_token = token_info[7:]  # Remove "?token="
        print(f"  Streaming token: {streaming_token}")
        
        # Show example URLs that could work
        print("\n🔗 Example streaming URLs to test manually:")
        print(f"  https://dis-se1.divas.cloud:8200/chan-{source_id}_h/index.m3u8?token={streaming_token}")
        print(f"  https://dis-se14.divas.cloud:8200/chan-{source_id}_h/index.m3u8?token={streaming_token}")
        print(f"  https://dis-se2.divas.cloud:8200/chan-{source_id}_h/xflow.m3u8?token={streaming_token}")
        
        print("\n✅ AUTHENTICATION FLOW WORKING!")
        print("🚀 Ready for cloud deployment - auth steps 1-2 are successful")
        return True
    
    return False

if __name__ == "__main__":
    success = test_auth_steps_only()
    exit(0 if success else 1)