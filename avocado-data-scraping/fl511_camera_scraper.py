#!/usr/bin/env python3
"""
Florida 511 Traffic Camera Scraper

This script scrapes traffic camera data from the Florida 511 system,
specifically targeting the Northeast region to collect comprehensive
camera metadata including video stream URLs.
"""

import requests
import json
import time
import urllib.parse
from typing import Dict, List, Optional, Any
from dataclasses import dataclass, asdict
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('fl511_scraper.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


@dataclass
class TrafficCamera:
    """Traffic camera entity with all relevant metadata"""
    id: Optional[str] = None
    name: Optional[str] = None
    description: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    install_date: Optional[str] = None
    equipment_type: Optional[str] = None
    region: Optional[str] = None
    county: Optional[str] = None
    roadway: Optional[str] = None
    location: Optional[str] = None
    direction: Optional[str] = None
    sort_order: Optional[int] = None
    video_url: Optional[str] = None
    thumbnail_url: Optional[str] = None
    status: Optional[str] = None
    raw_data: Optional[Dict] = None


class FL511CameraScraper:
    """Scraper for Florida 511 traffic camera data"""
    
    BASE_URL = "https://fl511.com/List/GetData/Cameras"
    BATCH_SIZE = 100
    REQUEST_DELAY = 1.0  # Delay between requests to be respectful
    
    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
            'Accept': 'application/json, text/javascript, */*; q=0.01',
            'Accept-Language': 'en-US,en;q=0.9',
            'Content-Type': 'application/json',
            'Referer': 'https://fl511.com/cctv',
            'Sec-Fetch-Dest': 'empty',
            'Sec-Fetch-Mode': 'cors',
            'Sec-Fetch-Site': 'same-origin',
            'X-Requested-With': 'XMLHttpRequest'
        })
    
    def build_query_params(self, start: int = 0, length: int = 100, region: str = "Northeast") -> str:
        """Build the query parameters for the API request"""
        query_data = {
            "columns": [
                {"data": None, "name": ""},
                {"name": "sortOrder", "s": True},
                {"name": "region", "search": {"value": region}, "s": True},
                {"name": "county", "s": True},
                {"name": "roadway", "s": True},
                {"name": "location"},
                {"name": "direction", "s": True},
                {"data": 7, "name": ""}
            ],
            "order": [
                {"column": 1, "dir": "asc"},
                {"column": 2, "dir": "asc"}
            ],
            "start": start,
            "length": length,
            "search": {"value": ""}
        }
        
        # Convert to JSON and URL encode
        query_json = json.dumps(query_data, separators=(',', ':'))
        return urllib.parse.quote(query_json)
    
    def fetch_camera_batch(self, start: int = 0, region: str = "Northeast") -> Optional[Dict]:
        """Fetch a batch of camera data from the API"""
        try:
            query_param = self.build_query_params(start=start, region=region)
            url = f"{self.BASE_URL}?query={query_param}&lang=en-US"
            
            logger.info(f"Fetching cameras starting at {start}")
            response = self.session.get(url, timeout=30)
            response.raise_for_status()
            
            return response.json()
            
        except requests.RequestException as e:
            logger.error(f"Error fetching camera batch starting at {start}: {e}")
            return None
        except json.JSONDecodeError as e:
            logger.error(f"Error parsing JSON response: {e}")
            return None
    
    def parse_camera_data(self, raw_data: Dict[str, Any]) -> TrafficCamera:
        """Parse raw camera data into TrafficCamera object"""
        try:
            camera = TrafficCamera()
            camera.raw_data = raw_data
            
            # Extract basic camera information
            camera.id = str(raw_data.get('id', ''))
            camera.name = raw_data.get('location', '')
            camera.description = raw_data.get('location', '')
            camera.region = raw_data.get('region', '')
            camera.county = raw_data.get('county', '')
            camera.roadway = raw_data.get('roadway', '')
            camera.direction = raw_data.get('direction', '')
            camera.location = raw_data.get('location', '')
            camera.sort_order = raw_data.get('sortOrder', 0)
            camera.status = 'active' if raw_data.get('visible', False) else 'inactive'
            
            # Extract coordinates from latLng
            lat_lng = raw_data.get('latLng', {})
            if lat_lng and 'geography' in lat_lng:
                geography = lat_lng['geography']
                wkt = geography.get('wellKnownText', '')
                if wkt.startswith('POINT'):
                    # Parse "POINT (-82.393921 29.628903)"
                    coords = wkt.replace('POINT (', '').replace(')', '').split()
                    if len(coords) == 2:
                        camera.longitude = float(coords[0])
                        camera.latitude = float(coords[1])
            
            # Extract installation/update dates
            camera.install_date = raw_data.get('created', '')
            
            # Extract video information from images array
            images = raw_data.get('images', [])
            if images:
                first_image = images[0]
                camera.video_url = first_image.get('videoUrl', '')
                camera.thumbnail_url = first_image.get('imageUrl', '')
                camera.equipment_type = first_image.get('videoType', '')
                
                # Build full URLs if they're relative
                if camera.thumbnail_url and camera.thumbnail_url.startswith('/'):
                    camera.thumbnail_url = f"https://fl511.com{camera.thumbnail_url}"
            
            # Additional metadata
            camera.name = f"{camera.roadway} {camera.direction} - {camera.location}".strip(' - ')
            
            return camera
            
        except Exception as e:
            logger.error(f"Error parsing camera data: {e}")
            return TrafficCamera(raw_data=raw_data)
    
    def scrape_all_cameras(self, region: str = "Northeast") -> List[TrafficCamera]:
        """Scrape all cameras for the specified region"""
        all_cameras = []
        start = 0
        
        logger.info(f"Starting scrape for region: {region}")
        
        while True:
            batch_data = self.fetch_camera_batch(start=start, region=region)
            
            if not batch_data:
                logger.error(f"Failed to fetch batch starting at {start}")
                break
            
            # Extract camera data from response
            cameras_data = batch_data.get('data', [])
            records_total = batch_data.get('recordsTotal', 0)
            records_filtered = batch_data.get('recordsFiltered', 0)
            
            logger.info(f"Batch {start//self.BATCH_SIZE + 1}: {len(cameras_data)} cameras, "
                       f"{records_filtered} total filtered records")
            
            if not cameras_data:
                logger.info("No more camera data found")
                break
            
            # Parse each camera
            for camera_raw in cameras_data:
                camera = self.parse_camera_data(camera_raw)
                all_cameras.append(camera)
            
            # Check if we've got all cameras
            if len(cameras_data) < self.BATCH_SIZE or start + len(cameras_data) >= records_filtered:
                logger.info("Reached end of available camera data")
                break
            
            start += self.BATCH_SIZE
            time.sleep(self.REQUEST_DELAY)  # Be respectful to the API
        
        logger.info(f"Scraping complete. Total cameras collected: {len(all_cameras)}")
        return all_cameras
    
    def save_cameras_to_json(self, cameras: List[TrafficCamera], filename: str = None):
        """Save camera data to JSON file"""
        if filename is None:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = f"fl511_cameras_northeast_{timestamp}.json"
        
        # Convert to dictionaries for JSON serialization
        cameras_dict = [asdict(camera) for camera in cameras]
        
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(cameras_dict, f, indent=2, ensure_ascii=False)
        
        logger.info(f"Saved {len(cameras)} cameras to {filename}")
        return filename


def main():
    """Main execution function"""
    scraper = FL511CameraScraper()
    
    try:
        # Scrape all Northeast cameras
        cameras = scraper.scrape_all_cameras(region="Northeast")
        
        if cameras:
            # Save to JSON file
            filename = scraper.save_cameras_to_json(cameras)
            print(f"Successfully scraped {len(cameras)} cameras and saved to {filename}")
            
            # Print summary
            print(f"\nSummary:")
            print(f"Total cameras: {len(cameras)}")
            print(f"Cameras with location data: {len([c for c in cameras if c.location])}")
            print(f"Cameras with roadway data: {len([c for c in cameras if c.roadway])}")
            print(f"Unique counties: {len(set(c.county for c in cameras if c.county))}")
            
        else:
            print("No cameras were scraped")
            
    except Exception as e:
        logger.error(f"Error in main execution: {e}")
        print(f"Error: {e}")


if __name__ == "__main__":
    main()