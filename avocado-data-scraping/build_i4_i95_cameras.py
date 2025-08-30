#!/usr/bin/env python3
"""
Build comprehensive camera list for I-4 and I-95 interstates
Fetches all cameras with proper pagination (100 per request max)

I-4: 224 cameras total
I-95: 552 cameras total
"""

import requests
import json
import time
from datetime import datetime
from typing import Dict, List
import urllib.parse

def fetch_cameras_paginated(roadway: str, total_expected: int) -> List[Dict]:
    """
    Fetch all cameras for a roadway using pagination
    
    Args:
        roadway: "I-4" or "I-95"
        total_expected: Expected total number of cameras
    
    Returns:
        List of all camera data
    """
    print(f"🚗 Fetching all {roadway} cameras (expected: {total_expected})...")
    
    all_cameras = []
    offset = 0
    page_size = 100  # API limit
    
    # Base query structure
    base_query = {
        "columns": [
            {"data": None, "name": ""},
            {"name": "sortOrder", "s": True},
            {"name": "region", "s": True},
            {"name": "county", "s": True},
            {"name": "roadway", "search": {"value": roadway}, "s": True},
            {"name": "location"},
            {"name": "direction", "s": True},
            {"data": 7, "name": ""}
        ],
        "order": [
            {"column": 1, "dir": "asc"},
            {"column": 2, "dir": "asc"}
        ],
        "search": {"value": ""}
    }
    
    headers = {
        'Cookie': '_region=ALL; _saveMapView={%22lat%22:29.652897766780686%2C%22lng%22:-82.55208400893679%2C%22zoom%22:13}; _culture=en; session-id=47AF290996121F81A6227D6DB0517C3F9CAEC260A1D7C64C0B7BB8D84BA62B9617FE0A8D62C05315BD8D8D6968E26A0956E2E181BAA3C0F4F2D2A0AEC37432AC71D1F3E3374810B601B8A4A8D5DFB672F30D8D80CAF5AD13104F574329BE1BF42E6B8AB05599CB2AAB34E65239C6E9726538EDA1764C9E933FEBC01001CFC650; session=session; __RequestVerificationToken=fd1sabnO63XumGKIhFl6hPZkgWgUF5fAkf2zZRZ89By6bcWEnpFSZpamsyDFaXooo5p5qZqlY3NT2PlWy3UXjFGzqo41; _gid=GA1.2.1244085659.1756344146; _gat=1; _ga=GA1.2.1643986082.1753892569; map={%22prevLatLng%22:[28.8137029142895%2C-81.27978050721657]%2C%22prevZoom%22:7%2C%22selectedLayers%22:[%22Cameras%22%2C%22TrafficSpeeds%22]%2C%22mapView%22:%222025-08-28T21:03:24.587Z%22%2C%22prevMapType%22:%22google%22}; _ga_07ZPFGG911=GS2.1.s1756414989$o9$g1$t1756415017$j32$l0$h0',
        '__requestverificationtoken': 'opVLoEUGrCRUP_RemHKKHbWsW92317EYnLP_1cZjPcHXPaRs_0LXqRtOu--1O2SuoOfUpzSnBmdKKtzqR7rWicGWMW81',
        'accept': 'application/json, text/javascript, */*; q=0.01',
        'accept-language': 'en-US,en;q=0.9',
        'content-type': 'application/json',
        'priority': 'u=1, i',
        'referer': 'https://fl511.com/cctv?start=0&length=10&order%5Bi%5D=1&order%5Bdir%5D=asc',
        'sec-ch-ua': '"Not;A=Brand";v="99", "Google Chrome";v="139", "Chromium";v="139"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"macOS"',
        'sec-fetch-dest': 'empty',
        'sec-fetch-mode': 'cors',
        'sec-fetch-site': 'same-origin',
        'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36',
        'x-requested-with': 'XMLHttpRequest'
    }
    
    session = requests.Session()
    
    while len(all_cameras) < total_expected:
        # Calculate how many to fetch this round
        remaining = total_expected - len(all_cameras)
        current_length = min(page_size, remaining)
        
        # Build query for this page
        query = base_query.copy()
        query["start"] = offset
        query["length"] = current_length
        
        # URL encode the query
        query_param = urllib.parse.quote(json.dumps(query))
        url = f'https://fl511.com/List/GetData/Cameras?query={query_param}&lang=en'
        
        print(f"  Fetching page: offset={offset}, length={current_length} (total so far: {len(all_cameras)})")
        
        try:
            response = session.get(url, headers=headers, timeout=30)
            response.raise_for_status()
            
            data = response.json()
            
            # Extract camera data
            cameras_data = data.get('data', [])
            if not cameras_data:
                print(f"  ⚠️  No more data returned, stopping")
                break
            
            all_cameras.extend(cameras_data)
            print(f"  ✅ Fetched {len(cameras_data)} cameras (total: {len(all_cameras)})")
            
            # Check if we got fewer cameras than expected (end of data)
            if len(cameras_data) < current_length:
                print(f"  ℹ️  Received fewer cameras than requested, likely at end of data")
                break
            
            offset += current_length
            
            # Rate limiting - be nice to the server
            time.sleep(0.5)
            
        except Exception as e:
            print(f"  ❌ Error fetching page at offset {offset}: {e}")
            break
    
    print(f"✅ Finished fetching {roadway}: {len(all_cameras)} cameras")
    return all_cameras

def process_camera_data(raw_cameras: List[Dict], roadway: str) -> List[Dict]:
    """
    Process raw camera data into structured format
    
    Args:
        raw_cameras: Raw camera data from API
        roadway: "I-4" or "I-95"
    
    Returns:
        Processed camera data with metadata
    """
    processed = []
    
    for camera in raw_cameras:
        try:
            # API returns objects with full camera details
            camera_data = {
                'id': str(camera.get('id', '')),
                'name': camera.get('location', ''),
                'description': camera.get('location', ''),
                'latitude': None,  # Extract from latLng if needed
                'longitude': None,  # Extract from latLng if needed
                'install_date': camera.get('created', ''),
                'equipment_type': 'application/x-mpegURL',  # Default for video cameras
                'region': camera.get('region', ''),
                'county': camera.get('county', ''),
                'roadway': camera.get('roadway', roadway),
                'location': camera.get('location', ''),
                'direction': camera.get('direction', ''),
                'sort_order': camera.get('sortOrder', 0),
                'status': 'active',
                'raw_data': camera  # Keep original for reference
            }
            
            # Extract coordinates from latLng if available
            if camera.get('latLng', {}).get('geography', {}).get('wellKnownText'):
                wkt = camera['latLng']['geography']['wellKnownText']
                # Parse "POINT (-82.428684 27.964729)" format
                if 'POINT (' in wkt:
                    coords = wkt.replace('POINT (', '').replace(')', '').split()
                    if len(coords) == 2:
                        camera_data['longitude'] = float(coords[0])
                        camera_data['latitude'] = float(coords[1])
            
            # Extract video URL from images array
            images = camera.get('images', [])
            for image in images:
                if image.get('videoUrl'):
                    camera_data['video_url'] = image['videoUrl']
                    camera_data['thumbnail_url'] = f"https://fl511.com{image.get('imageUrl', '')}"
                    camera_data['is_video_auth_required'] = image.get('isVideoAuthRequired', False)
                    # Use first image data
                    break
            
            processed.append(camera_data)
            
        except Exception as e:
            print(f"  ⚠️  Error processing camera {camera.get('id', 'unknown')}: {e}")
            continue
    
    return processed

def save_cameras_json(cameras: List[Dict], filename: str):
    """Save cameras to JSON file with metadata"""
    
    output = {
        'metadata': {
            'generated_at': datetime.now().isoformat(),
            'total_cameras': len(cameras),
            'roadways': list(set(cam.get('roadway', '') for cam in cameras)),
            'regions': list(set(cam.get('region', '') for cam in cameras)),
            'counties': list(set(cam.get('county', '') for cam in cameras))
        },
        'cameras': cameras
    }
    
    with open(filename, 'w') as f:
        json.dump(output, f, indent=2)
    
    print(f"💾 Saved {len(cameras)} cameras to {filename}")

def main():
    """Main function to build I-4 and I-95 camera lists"""
    print("🛣️  Building comprehensive I-4 and I-95 camera database")
    print("=" * 60)
    
    all_cameras = []
    
    # Fetch I-4 cameras (224 expected)
    print("\n📍 Step 1: Fetching I-4 cameras...")
    i4_cameras_raw = fetch_cameras_paginated("I-4", 224)
    i4_cameras = process_camera_data(i4_cameras_raw, "I-4")
    all_cameras.extend(i4_cameras)
    
    print(f"✅ I-4 cameras: {len(i4_cameras)}")
    
    # Wait before next roadway
    print("⏳ Waiting 2 seconds before fetching I-95...")
    time.sleep(2)
    
    # Fetch I-95 cameras (552 expected)
    print("\n📍 Step 2: Fetching I-95 cameras...")
    i95_cameras_raw = fetch_cameras_paginated("I-95", 552)
    i95_cameras = process_camera_data(i95_cameras_raw, "I-95")
    all_cameras.extend(i95_cameras)
    
    print(f"✅ I-95 cameras: {len(i95_cameras)}")
    
    # Save individual files
    save_cameras_json(i4_cameras, 'fl511_i4_cameras.json')
    save_cameras_json(i95_cameras, 'fl511_i95_cameras.json')
    
    # Save combined file
    save_cameras_json(all_cameras, 'fl511_i4_i95_cameras.json')
    
    print("\n" + "=" * 60)
    print("🎯 SUMMARY")
    print("=" * 60)
    print(f"I-4 cameras:  {len(i4_cameras):3d}")
    print(f"I-95 cameras: {len(i95_cameras):3d}")
    print(f"Total:        {len(all_cameras):3d}")
    
    # Show distribution by region
    regions = {}
    for camera in all_cameras:
        region = camera.get('region', 'Unknown')
        regions[region] = regions.get(region, 0) + 1
    
    print(f"\nRegion distribution:")
    for region, count in sorted(regions.items()):
        print(f"  {region}: {count}")
    
    print(f"\nFiles created:")
    print(f"  📄 fl511_i4_cameras.json - I-4 only ({len(i4_cameras)} cameras)")
    print(f"  📄 fl511_i95_cameras.json - I-95 only ({len(i95_cameras)} cameras)")
    print(f"  📄 fl511_i4_i95_cameras.json - Combined ({len(all_cameras)} cameras)")
    
    print(f"\n🚀 Ready to use with production authentication script!")

if __name__ == "__main__":
    main()