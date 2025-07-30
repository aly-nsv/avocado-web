#!/usr/bin/env python3
"""
Create combined dataset from all scraped regions
"""

import json
from datetime import datetime

def create_combined_dataset():
    """Combine all region datasets into one master file"""
    
    regions = {
        'Northeast': 'fl511_cameras_northeast_20250730_134645.json',
        'Central': 'fl511_cameras_central_20250730_135009.json', 
        'Panhandle': 'fl511_cameras_panhandle_20250730_135009.json',
        'Southeast': 'fl511_cameras_southeast_20250730_135009.json',
        'Southwest': 'fl511_cameras_southwest_20250730_135009.json',
        'Tampa Bay': 'fl511_cameras_tampa_bay_20250730_135009.json'
    }
    
    all_cameras = []
    region_stats = {}
    
    print("=== CREATING COMBINED DATASET ===")
    
    for region, filename in regions.items():
        try:
            with open(filename, 'r') as f:
                cameras = json.load(f)
            
            # Add region info to each camera
            for camera in cameras:
                camera['scraped_region'] = region
                all_cameras.append(camera)
            
            region_stats[region] = len(cameras)
            print(f"Loaded {region}: {len(cameras)} cameras")
            
        except Exception as e:
            print(f"Error loading {region}: {e}")
    
    # Save combined dataset
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    combined_filename = f"fl511_cameras_complete_florida_{timestamp}.json"
    
    with open(combined_filename, 'w', encoding='utf-8') as f:
        json.dump(all_cameras, f, indent=2, ensure_ascii=False)
    
    print(f"\n✅ Combined dataset saved: {combined_filename}")
    print(f"Total cameras: {len(all_cameras)}")
    
    # Create summary statistics
    stats = analyze_combined_dataset(all_cameras)
    
    # Save statistics
    stats_filename = f"fl511_florida_statistics_{timestamp}.json"
    with open(stats_filename, 'w', encoding='utf-8') as f:
        json.dump(stats, f, indent=2, ensure_ascii=False)
    
    print(f"✅ Statistics saved: {stats_filename}")
    
    return all_cameras, stats

def analyze_combined_dataset(cameras):
    """Analyze the complete Florida camera dataset"""
    
    stats = {
        'total_cameras': len(cameras),
        'scrape_date': datetime.now().isoformat(),
        'regions': {},
        'counties': {},
        'roadways': {},
        'video_stats': {
            'cameras_with_video': 0,
            'cameras_with_coordinates': 0,
            'active_cameras': 0
        }
    }
    
    print("\n=== DATASET ANALYSIS ===")
    
    # Region breakdown
    for camera in cameras:
        region = camera.get('scraped_region', 'Unknown')
        stats['regions'][region] = stats['regions'].get(region, 0) + 1
        
        county = camera.get('county', 'Unknown')
        stats['counties'][county] = stats['counties'].get(county, 0) + 1
        
        roadway = camera.get('roadway', 'Unknown')
        stats['roadways'][roadway] = stats['roadways'].get(roadway, 0) + 1
        
        # Video statistics
        if camera.get('video_url'):
            stats['video_stats']['cameras_with_video'] += 1
        if camera.get('latitude') and camera.get('longitude'):
            stats['video_stats']['cameras_with_coordinates'] += 1
        if camera.get('status') == 'active':
            stats['video_stats']['active_cameras'] += 1
    
    # Print summary
    print(f"Total cameras: {stats['total_cameras']}")
    print(f"Cameras with video: {stats['video_stats']['cameras_with_video']}")
    print(f"Cameras with coordinates: {stats['video_stats']['cameras_with_coordinates']}")
    print(f"Active cameras: {stats['video_stats']['active_cameras']}")
    
    print(f"\nRegion distribution:")
    for region, count in sorted(stats['regions'].items()):
        print(f"  {region}: {count}")
    
    print(f"\nTop 10 counties:")
    top_counties = sorted(stats['counties'].items(), key=lambda x: x[1], reverse=True)[:10]
    for county, count in top_counties:
        print(f"  {county}: {count}")
    
    print(f"\nTop 10 roadways:")
    top_roadways = sorted(stats['roadways'].items(), key=lambda x: x[1], reverse=True)[:10]
    for roadway, count in top_roadways:
        print(f"  {roadway}: {count}")
    
    return stats

if __name__ == "__main__":
    create_combined_dataset()