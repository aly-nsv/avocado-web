#!/usr/bin/env python3
"""
Quick analysis script for scraped camera data
"""

import json
import sys

def analyze_camera_data(filename):
    """Analyze the scraped camera data"""
    try:
        with open(filename, 'r') as f:
            cameras = json.load(f)
        
        print(f"=== Florida 511 Northeast Camera Analysis ===")
        print(f"Total cameras scraped: {len(cameras)}")
        print(f"Cameras with video URLs: {len([c for c in cameras if c.get('video_url')])}")
        print(f"Cameras with coordinates: {len([c for c in cameras if c.get('latitude') and c.get('longitude')])}")
        print(f"Active cameras: {len([c for c in cameras if c.get('status') == 'active'])}")
        
        # County breakdown
        counties = {}
        for cam in cameras:
            county = cam.get('county', 'Unknown')
            counties[county] = counties.get(county, 0) + 1
        
        print(f"\n=== Counties ===")
        for county, count in sorted(counties.items()):
            print(f"{county}: {count} cameras")
        
        # Roadway breakdown
        roadways = {}
        for cam in cameras:
            roadway = cam.get('roadway', 'Unknown')
            roadways[roadway] = roadways.get(roadway, 0) + 1
        
        print(f"\n=== Top Roadways ===")
        top_roadways = sorted(roadways.items(), key=lambda x: x[1], reverse=True)[:10]
        for roadway, count in top_roadways:
            print(f"{roadway}: {count} cameras")
        
        # Sample video URLs
        print(f"\n=== Sample Video URLs ===")
        video_cameras = [c for c in cameras if c.get('video_url')][:5]
        for i, cam in enumerate(video_cameras, 1):
            print(f"{i}. {cam['name']}")
            print(f"   Video: {cam['video_url']}")
            print(f"   Thumbnail: {cam['thumbnail_url']}")
            print()
        
        return cameras
        
    except Exception as e:
        print(f"Error analyzing data: {e}")
        return None

if __name__ == "__main__":
    filename = sys.argv[1] if len(sys.argv) > 1 else "fl511_cameras_northeast_20250730_134645.json"
    analyze_camera_data(filename)