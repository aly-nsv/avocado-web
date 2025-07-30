#!/usr/bin/env python3
"""
Scrape all Florida 511 regions to get complete camera dataset
"""

import json
import time
from datetime import datetime
from fl511_camera_scraper import FL511CameraScraper
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('all_regions_scraper.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

def scrape_all_regions():
    """Scrape all regions and save to separate files"""
    
    regions = [
        "Central",
        "Panhandle", 
        "Southeast",
        "Southwest",
        "Tampa Bay",
        "Statewide"
    ]
    
    # We already have Northeast
    regions_completed = ["Northeast"]
    
    scraper = FL511CameraScraper()
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    results = {}
    total_cameras = 0
    
    # Load existing Northeast data
    try:
        with open('fl511_cameras_northeast_20250730_134645.json', 'r') as f:
            northeast_cameras = json.load(f)
            results["Northeast"] = northeast_cameras
            total_cameras += len(northeast_cameras)
            logger.info(f"Loaded existing Northeast data: {len(northeast_cameras)} cameras")
    except FileNotFoundError:
        logger.warning("Northeast data file not found, will need to re-scrape")
        regions.insert(0, "Northeast")
    
    for region in regions:
        logger.info(f"Starting scrape for region: {region}")
        
        try:
            cameras = scraper.scrape_all_cameras(region=region)
            
            if cameras:
                # Save region-specific file
                filename = f"fl511_cameras_{region.lower().replace(' ', '_')}_{timestamp}.json"
                scraper.save_cameras_to_json(cameras, filename)
                
                results[region] = cameras
                total_cameras += len(cameras)
                
                logger.info(f"Region {region}: {len(cameras)} cameras scraped")
                print(f"✅ {region}: {len(cameras)} cameras")
            else:
                logger.error(f"Failed to scrape region: {region}")
                print(f"❌ {region}: Failed to scrape")
            
            # Small delay between regions to be respectful
            time.sleep(2)
            
        except Exception as e:
            logger.error(f"Error scraping region {region}: {e}")
            print(f"❌ {region}: Error - {e}")
    
    # Create combined dataset
    all_cameras = []
    for region, cameras in results.items():
        # Add region info and extend list
        for camera in cameras:
            # Convert TrafficCamera objects to dict if needed
            if hasattr(camera, '__dict__'):
                camera_dict = camera.__dict__.copy()
            else:
                camera_dict = camera.copy()
            
            camera_dict['scraped_region'] = region
            all_cameras.append(camera_dict)
    
    # Save combined dataset
    combined_filename = f"fl511_cameras_all_regions_{timestamp}.json"
    try:
        with open(combined_filename, 'w', encoding='utf-8') as f:
            json.dump(all_cameras, f, indent=2, ensure_ascii=False)
        logger.info(f"Saved combined dataset: {combined_filename}")
    except Exception as e:
        logger.error(f"Error saving combined dataset: {e}")
        # Save without the combined file for now
        pass
    
    # Summary
    print(f"\n=== SCRAPING COMPLETE ===")
    print(f"Total cameras scraped: {total_cameras}")
    print(f"Expected cameras: 4,564")
    print(f"Difference: {4564 - total_cameras}")
    print(f"Coverage: {(total_cameras/4564)*100:.1f}%")
    
    print(f"\nRegion breakdown:")
    for region, cameras in results.items():
        print(f"  {region}: {len(cameras)} cameras")
    
    logger.info(f"All regions scraping complete. Total: {total_cameras} cameras")
    return results, all_cameras

if __name__ == "__main__":
    scrape_all_regions()