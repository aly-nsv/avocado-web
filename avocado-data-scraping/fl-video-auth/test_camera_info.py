#!/usr/bin/env python3
"""
Test script to get camera information from FL-511 API
"""

import requests
import json
import time

# Let's try to get camera information directly from the cameras API
def get_camera_info(camera_id="1248"):
    """Get camera information from FL-511 cameras API"""
    
    # Try the cameras list API that we know works
    url = "https://fl511.com/List/GetData/Cameras"
    
    # Parameters for pagination - get first 10 cameras
    params = {
        'start': 0,
        'length': 10,
        '_': int(time.time() * 1000)
    }
    
    headers = {
        'Accept': 'application/json, text/javascript, */*; q=0.01',
        'Accept-Language': 'en-US,en;q=0.9',
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
        'X-Requested-With': 'XMLHttpRequest',
        'Referer': 'https://fl511.com/map'
    }
    
    try:
        print(f"Getting camera info for ID: {camera_id}")
        response = requests.get(url, params=params, headers=headers, timeout=30)
        response.raise_for_status()
        
        data = response.json()
        print(f"Response: {json.dumps(data, indent=2)}")
        
        # Look for our camera in the results
        if 'data' in data:
            for camera in data['data']:
                if str(camera.get('id')) == str(camera_id):
                    print(f"\nFound camera {camera_id}:")
                    print(json.dumps(camera, indent=2))
                    return camera
                    
        print(f"Camera {camera_id} not found in results")
        return None
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return None

if __name__ == "__main__":
    get_camera_info()