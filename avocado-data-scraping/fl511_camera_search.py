#!/usr/bin/env python3
"""
FL-511 Camera Search API

Dynamically searches for cameras based on incident data using FL-511's camera search API.
Uses targeted query parameters to find relevant cameras near incident locations.
"""

import json
import requests
import urllib.parse
import logging
import re
from typing import Dict, List, Optional
from datetime import datetime

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class FL511CameraSearch:
    """Search for cameras using FL-511 API with dynamic query parameters"""
    
    def __init__(self):
        self.base_url = "https://fl511.com/List/GetData/Cameras"
        self.session = requests.Session()
        
        # Headers based on your working curl command
        self.headers = {
            'accept': 'application/json, text/javascript, */*; q=0.01',
            'accept-language': 'en-US,en;q=0.9',
            'content-type': 'application/json',
            'priority': 'u=1, i',
            'referer': 'https://fl511.com/cctv',
            'sec-ch-ua': '"Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"',
            'sec-ch-ua-mobile': '?0',
            'sec-ch-ua-platform': '"macOS"',
            'sec-fetch-dest': 'empty',
            'sec-fetch-mode': 'cors',
            'sec-fetch-site': 'same-origin',
            'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
            'x-requested-with': 'XMLHttpRequest'
        }
    
    def build_camera_search_query(self, 
                                  roadway: str = None,
                                  region: str = None, 
                                  county: str = None,
                                  direction: str = None,
                                  location_keywords: str = None,
                                  limit: int = 50) -> str:
        """
        Build FL-511 camera search query based on incident parameters
        
        Args:
            roadway: Highway name (I-4, I-75, etc.)
            region: Florida region (Northeast, Tampa Bay, etc.)
            county: County name
            direction: Traffic direction (Northbound, Southbound, etc.)
            location_keywords: Keywords from incident description to search in location
            limit: Maximum cameras to return
            
        Returns:
            URL-encoded query string
        """
        
        # Base query structure (based on your curl command)
        query = {
            "columns": [
                {"data": None, "name": ""},
                {"name": "sortOrder", "s": True},
                {"name": "region", "s": True},
                {"name": "county", "s": True}, 
                {"name": "roadway", "s": True},
                {"name": "location"},
                {"name": "direction", "s": True},
                {"data": 7, "name": ""},
                {"name": "description", "s": True},
                {"name": "roadwayName"},
                {"name": "severity"},
                {"name": "startDate"},
                {"name": "type"}
            ],
            "order": [
                {"column": 1, "dir": "asc"},  # Sort by sortOrder
                {"column": 4, "dir": "asc"}   # Then by roadway
            ],
            "start": 0,
            "length": limit,
            "search": {"value": ""}
        }
        
        # Add targeted search filters based on incident data
        if roadway:
            # Search for roadway in the roadway column (index 4)
            for col in query["columns"]:
                if col.get("name") == "roadway":
                    col["search"] = {"value": roadway}
                    break
        
        if region:
            # Search for region in the region column (index 2)  
            for col in query["columns"]:
                if col.get("name") == "region":
                    col["search"] = {"value": region}
                    break
        
        if county:
            # Search for county in the county column (index 3)
            for col in query["columns"]:
                if col.get("name") == "county":
                    col["search"] = {"value": county}
                    break
        
        if direction:
            # Search for direction in the direction column (index 6)
            for col in query["columns"]:
                if col.get("name") == "direction":
                    col["search"] = {"value": direction}
                    break
        
        if location_keywords:
            # Use global search for location keywords
            query["search"]["value"] = location_keywords
        
        # URL encode the query
        query_json = json.dumps(query, separators=(',', ':'))
        return urllib.parse.quote(query_json)
    
    def search_cameras_for_incident(self, incident_data: Dict) -> List[Dict]:
        """
        Search for cameras relevant to a specific incident
        
        Args:
            incident_data: Incident data from FL-511 API
            
        Returns:
            List of relevant cameras with video URLs
        """
        incident_roadway = incident_data.get('roadwayName', '')
        incident_region = incident_data.get('region', '')
        incident_county = incident_data.get('county', '')
        incident_direction = incident_data.get('direction', '')
        incident_description = incident_data.get('description', '')
        
        logger.info(f"🔍 Searching cameras for incident {incident_data.get('id', 'unknown')}")
        logger.info(f"   Location: {incident_roadway}, {incident_county}, {incident_region}")
        logger.info(f"   Direction: {incident_direction}")
        
        # Strategy 1: Exact roadway + region + direction match (for highways)
        cameras = []
        if incident_roadway and incident_roadway.upper().startswith('I-'):
            logger.info(f"🛣️  Highway incident - searching by roadway: {incident_roadway}")
            cameras.extend(self._search_by_roadway(
                roadway=incident_roadway,
                region=incident_region,
                direction=incident_direction
            ))
        
        # Strategy 2: County + region match (for local roads)
        if not cameras and incident_county:
            logger.info(f"🏘️  Local road incident - searching by county: {incident_county}")
            cameras.extend(self._search_by_county(
                county=incident_county,
                region=incident_region
            ))
        
        # Strategy 3: Location keyword search
        if not cameras:
            # Extract meaningful keywords from incident description
            location_keywords = self._extract_location_keywords(incident_description)
            if location_keywords:
                logger.info(f"🔍 Keyword search: {location_keywords}")
                cameras.extend(self._search_by_keywords(location_keywords))
        
        # Filter to cameras with video URLs and add metadata
        video_cameras = self._process_camera_results(cameras, incident_data)
        
        logger.info(f"✅ Found {len(video_cameras)} cameras with video for incident")
        return video_cameras
    
    def _search_by_roadway(self, roadway: str, region: str = None, direction: str = None) -> List[Dict]:
        """Search cameras by roadway, region, and direction"""
        try:
            query_encoded = self.build_camera_search_query(
                roadway=roadway,
                region=region,
                direction=direction,
                limit=20  # Limit for highway searches
            )
            
            url = f"{self.base_url}?query={query_encoded}&lang=en-US"
            response = self.session.get(url, headers=self.headers, timeout=30)
            response.raise_for_status()
            
            data = response.json()
            cameras = data.get('data', [])
            logger.info(f"   Roadway search returned {len(cameras)} cameras")
            return cameras
            
        except Exception as e:
            logger.error(f"❌ Error searching by roadway: {e}")
            return []
    
    def _search_by_county(self, county: str, region: str = None) -> List[Dict]:
        """Search cameras by county and region"""
        try:
            query_encoded = self.build_camera_search_query(
                county=county,
                region=region,
                limit=15  # Limit for county searches  
            )
            
            url = f"{self.base_url}?query={query_encoded}&lang=en-US"
            response = self.session.get(url, headers=self.headers, timeout=30)
            response.raise_for_status()
            
            data = response.json()
            cameras = data.get('data', [])
            logger.info(f"   County search returned {len(cameras)} cameras")
            return cameras
            
        except Exception as e:
            logger.error(f"❌ Error searching by county: {e}")
            return []
    
    def _search_by_keywords(self, keywords: str) -> List[Dict]:
        """Search cameras by location keywords"""
        try:
            query_encoded = self.build_camera_search_query(
                location_keywords=keywords,
                limit=10  # Limit for keyword searches
            )
            
            url = f"{self.base_url}?query={query_encoded}&lang=en-US"
            response = self.session.get(url, headers=self.headers, timeout=30)
            response.raise_for_status()
            
            data = response.json()
            cameras = data.get('data', [])
            logger.info(f"   Keyword search returned {len(cameras)} cameras")
            return cameras
            
        except Exception as e:
            logger.error(f"❌ Error searching by keywords: {e}")
            return []
    
    def _extract_location_keywords(self, description: str) -> str:
        """Extract meaningful location keywords from incident description"""
        if not description:
            return ""
        
        # Extract street names, landmarks, and mile markers
        keywords = []
        
        # Mile marker patterns
        mm_match = re.search(r'MM\s+(\d+\.?\d*)', description, re.IGNORECASE)
        if mm_match:
            keywords.append(f"MM {mm_match.group(1)}")
        
        # Street/road names (look for common patterns)
        road_patterns = [
            r'\b([A-Z][a-z]+\s+(?:Blvd|Boulevard|Ave|Avenue|St|Street|Rd|Road|Dr|Drive|Way|Hwy|Highway))\b',
            r'\b(State Road\s+\d+)\b',
            r'\b(SR-?\d+)\b',
            r'\b(US-?\d+)\b'
        ]
        
        for pattern in road_patterns:
            matches = re.findall(pattern, description, re.IGNORECASE)
            keywords.extend(matches)
        
        # Return first few meaningful keywords
        return " ".join(keywords[:3]) if keywords else ""
    
    def _process_camera_results(self, cameras: List[Dict], incident_data: Dict) -> List[Dict]:
        """Process camera results to extract video URLs and add relevance scoring"""
        video_cameras = []
        
        for camera in cameras:
            # Check if camera has video
            images = camera.get('images', [])
            if not images or not images[0].get('videoUrl'):
                continue
            
            # Extract coordinates
            coordinates = self._extract_coordinates(camera.get('latLng', {}))
            
            # Calculate relevance score
            relevance_score = self._calculate_relevance_score(camera, incident_data)
            
            video_camera = {
                'camera_id': camera['id'],
                'video_url': images[0]['videoUrl'],
                'description': camera.get('location', ''),
                'roadway': camera.get('roadway', ''),
                'direction': camera.get('direction', ''),
                'region': camera.get('region', ''),
                'county': camera.get('county', ''),
                'coordinates': coordinates,
                'relevance_score': relevance_score,
                'raw_camera_data': camera  # Include full camera data for auth
            }
            
            video_cameras.append(video_camera)
        
        # Sort by relevance score (higher is better)
        video_cameras.sort(key=lambda x: x['relevance_score'], reverse=True)
        
        return video_cameras[:5]  # Return top 5 most relevant
    
    def _extract_coordinates(self, lat_lng: Dict) -> Optional[tuple]:
        """Extract lat/lon from camera coordinate data"""
        try:
            wkt = lat_lng.get('geography', {}).get('wellKnownText', '')
            if 'POINT' in wkt:
                coords = wkt.replace('POINT (', '').replace(')', '').split()
                if len(coords) == 2:
                    return (float(coords[1]), float(coords[0]))  # lat, lon
        except:
            pass
        return None
    
    def _calculate_relevance_score(self, camera: Dict, incident_data: Dict) -> float:
        """Calculate relevance score for camera-incident match"""
        score = 0.0
        
        # Roadway match (highest priority)
        if camera.get('roadway', '').lower() == incident_data.get('roadwayName', '').lower():
            score += 5.0
        
        # Direction match
        if camera.get('direction', '').lower() == incident_data.get('direction', '').lower():
            score += 2.0
        
        # County match
        if camera.get('county', '').lower() == incident_data.get('county', '').lower():
            score += 2.0
        
        # Region match
        if camera.get('region', '').lower() == incident_data.get('region', '').lower():
            score += 1.0
        
        # Mile marker proximity (if extractable)
        camera_mm = self._extract_mile_marker(camera.get('location', ''))
        incident_mm = self._extract_mile_marker(incident_data.get('description', ''))
        
        if camera_mm and incident_mm:
            distance = abs(camera_mm - incident_mm)
            if distance <= 1.0:  # Within 1 mile
                score += 3.0
            elif distance <= 3.0:  # Within 3 miles
                score += 1.5
            elif distance <= 5.0:  # Within 5 miles
                score += 0.5
        
        return score
    
    def _extract_mile_marker(self, location_text: str) -> Optional[float]:
        """Extract mile marker from location text"""
        if not location_text:
            return None
        
        mm_patterns = [
            r'MM\s+(\d+\.?\d*)',
            r'Mile\s+(\d+\.?\d*)',
            r'@\s+(\d+\.?\d*)',
        ]
        
        for pattern in mm_patterns:
            match = re.search(pattern, location_text, re.IGNORECASE)
            if match:
                return float(match.group(1))
        return None


def main():
    """Test the camera search functionality"""
    # Example incident data
    test_incident = {
        "id": 265996,
        "roadwayName": "I-4",
        "description": "Multi-vehicle crash on I-4 Eastbound at MM 68.5. Right lane blocked.",
        "county": "Orange",
        "region": "Central", 
        "direction": "Eastbound"
    }
    
    # Create searcher
    searcher = FL511CameraSearch()
    
    # Search for cameras
    cameras = searcher.search_cameras_for_incident(test_incident)
    
    print(f"\n🎯 Found {len(cameras)} relevant cameras:")
    for i, camera in enumerate(cameras, 1):
        print(f"{i}. Camera {camera['camera_id']} (Score: {camera['relevance_score']:.1f})")
        print(f"   Location: {camera['description']}")
        print(f"   Video URL: {camera['video_url']}")
        print(f"   Direction: {camera['direction']}")
        if camera['coordinates']:
            print(f"   Coordinates: {camera['coordinates']}")
        print()


if __name__ == "__main__":
    main()