#!/usr/bin/env python3
"""
FL 511 Traffic Incidents Scraper

Scrapes traffic incident data from Florida's 511 system with support for:
- Pagination to fetch all available incidents
- 24-hour filtering for recent incidents
- Database-ready JSON output structure
- Enum-based data validation
"""

import json
import requests
from datetime import datetime, timedelta
from enum import Enum
from dataclasses import dataclass, asdict
from typing import List, Optional, Dict, Any
import urllib.parse
import time


class Region(Enum):
    CENTRAL = "Central"
    NORTHEAST = "Northeast" 
    PANHANDLE = "Panhandle"
    SOUTHEAST = "Southeast"
    SOUTHWEST = "Southwest"
    TAMPA_BAY = "Tampa Bay"


class Severity(Enum):
    NONE = "None"
    MINOR = "minor"
    INTERMEDIATE = "Intermediate" 
    MAJOR = "major"


class Direction(Enum):
    BOTH_DIRECTIONS = "Both Directions"
    EASTBOUND = "Eastbound"
    NORTHBOUND = "Northbound"
    SOUTHBOUND = "Southbound"
    UNKNOWN = "Unknown"
    WESTBOUND = "Westbound"


class IncidentType(Enum):
    CLOSURES = "Closures"
    CONGESTION = "Congestion"
    CONSTRUCTION_ZONES = "Construction Zones"
    DISABLED_VEHICLES = "Disabled Vehicles"
    INCIDENTS = "Incidents"
    OTHER_EVENTS = "Other Events"
    ROAD_CONDITION = "Road Condition"


class SubType(Enum):
    TYPE_1706 = "1706"
    TYPE_2082 = "2082" 
    TYPE_211 = "211"
    TYPE_212 = "212"
    TYPE_2978 = "2978"
    TYPE_47 = "47"
    TYPE_58 = "58"
    TYPE_95 = "95"
    BRIDGE_WORK = "BridgeWork"
    CRASH = "Crash"
    EMERGENCY_ROAD_WORK = "EmergencyRoadWork"
    PLANNED_CONSTRUCTION = "PlannedConstruction"
    PSA = "PSA"
    SCHEDULED_ROAD_WORK = "ScheduledRoadWork"
    SPECIAL_EVENT = "SpecialEvent"


@dataclass
class CameraImage:
    id: int
    camera_site_id: int
    sort_order: int
    description: str
    image_url: str
    image_type: int
    video_url: Optional[str] = None
    video_type: Optional[str] = None
    is_video_auth_required: bool = False


@dataclass
class Camera:
    location: Optional[str] = None
    images: Optional[List[CameraImage]] = None


@dataclass
class TrafficIncident:
    # Primary identifiers
    id: int
    dt_row_id: str
    source_id: str
    
    # Location information
    roadway_name: str
    county: str
    region: str
    
    # Incident details
    incident_type: str  # Will map to IncidentType enum
    severity: str  # Will map to Severity enum
    direction: str  # Will map to Direction enum
    description: str
    
    # Timing
    start_date: str
    last_updated: str
    
    # Source information
    source: str
    
    # Optional fields with defaults
    state: str = "Florida"
    country: str = "United States"
    sub_type: Optional[str] = None  # Will map to SubType enum
    end_date: Optional[str] = None
    dot_district: Optional[str] = None
    location_description: Optional[str] = None
    detour_description: Optional[str] = None
    lane_description: Optional[str] = None
    recurrence_description: Optional[str] = None
    comment: Optional[str] = None
    width_restriction: Optional[str] = None
    height_restriction: Optional[str] = None
    height_under_restriction: Optional[str] = None
    length_restriction: Optional[str] = None
    weight_restriction: Optional[str] = None
    is_full_closure: bool = False
    show_on_map: bool = True
    major_event: Optional[str] = None
    cameras: Optional[List[Camera]] = None
    tooltip_url: Optional[str] = None
    scraped_at: Optional[str] = None


class FL511Scraper:
    def __init__(self):
        self.base_url = "https://fl511.com"
        self.api_endpoint = f"{self.base_url}/List/GetData/traffic"
        self.session = requests.Session()
        self.session.headers.update({
            'Accept': 'application/json, text/javascript, */*; q=0.01',
            'Content-Type': 'application/json',
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36',
            'X-Requested-With': 'XMLHttpRequest'
        })
        
    def _build_query(self, start: int = 0, length: int = 100) -> str:
        """Build the query parameter for the API request"""
        query = {
            "columns": [
                {"data": None, "name": ""},
                {"name": "region"},
                {"name": "county"},
                {"name": "roadwayName"},
                {"name": "direction"},
                {"name": "type"},
                {"name": "severity"},
                {"name": "description"},
                {"name": "startDate"},
                {"name": "lastUpdated"},
                {"data": 10, "name": ""}
            ],
            "order": [{"column": 9, "dir": "desc"}],
            "start": start,
            "length": length,
            "search": {"value": ""}
        }
        return urllib.parse.quote(json.dumps(query))
    
    def _parse_camera_data(self, camera_data: List[Dict]) -> List[Camera]:
        """Parse camera data from API response"""
        if not camera_data:
            return []
            
        cameras = []
        for cam in camera_data:
            images = []
            if cam.get('images'):
                for img in cam['images']:
                    image = CameraImage(
                        id=img.get('id', 0),
                        camera_site_id=img.get('cameraSiteId', 0),
                        sort_order=img.get('sortOrder', 0),
                        description=img.get('description', ''),
                        image_url=img.get('imageUrl', ''),
                        image_type=img.get('imageType', 0),
                        video_url=img.get('videoUrl'),
                        video_type=img.get('videoType'),
                        is_video_auth_required=img.get('isVideoAuthRequired', False)
                    )
                    images.append(image)
            
            camera = Camera(
                location=cam.get('location'),
                images=images if images else None
            )
            cameras.append(camera)
        
        return cameras
    
    def _parse_incident(self, incident_data: Dict) -> TrafficIncident:
        """Parse a single incident from API response"""
        cameras = self._parse_camera_data(incident_data.get('cameras', []))
        
        return TrafficIncident(
            id=incident_data.get('id', 0),
            dt_row_id=incident_data.get('DT_RowId', ''),
            source_id=incident_data.get('sourceId', ''),
            roadway_name=incident_data.get('roadwayName', ''),
            county=incident_data.get('county', ''),
            region=incident_data.get('region', ''),
            state=incident_data.get('state', 'Florida'),
            country=incident_data.get('country', 'United States'),
            incident_type=incident_data.get('type', ''),
            sub_type=incident_data.get('eventSubType'),
            severity=incident_data.get('severity', ''),
            direction=incident_data.get('direction', ''),
            description=incident_data.get('description', ''),
            start_date=incident_data.get('startDate', ''),
            end_date=incident_data.get('endDate'),
            last_updated=incident_data.get('lastUpdated', ''),
            source=incident_data.get('source', ''),
            dot_district=incident_data.get('dotDistrict'),
            location_description=incident_data.get('locationDescription'),
            detour_description=incident_data.get('detourDescription'),
            lane_description=incident_data.get('laneDescription'),
            recurrence_description=incident_data.get('recurrenceDescription'),
            comment=incident_data.get('comment'),
            width_restriction=incident_data.get('widthRestriction'),
            height_restriction=incident_data.get('heightRestriction'),
            height_under_restriction=incident_data.get('heightUnderRestriction'),
            length_restriction=incident_data.get('lengthRestriction'),
            weight_restriction=incident_data.get('weightRestriction'),
            is_full_closure=incident_data.get('isFullClosure', False),
            show_on_map=incident_data.get('showOnMap', True),
            major_event=incident_data.get('majorEvent'),
            cameras=cameras if cameras else None,
            tooltip_url=incident_data.get('tooltipUrl'),
            scraped_at=datetime.now().isoformat()
        )
    
    def fetch_incidents(self, max_pages: Optional[int] = None, delay: float = 1.0) -> List[TrafficIncident]:
        """
        Fetch all traffic incidents with pagination
        
        Args:
            max_pages: Maximum number of pages to fetch (None for all)
            delay: Delay between requests in seconds
            
        Returns:
            List of TrafficIncident objects
        """
        incidents = []
        start = 0
        length = 100
        page_count = 0
        
        print(f"Starting to scrape FL 511 incidents...")
        
        while True:
            if max_pages and page_count >= max_pages:
                break
                
            query = self._build_query(start, length)
            url = f"{self.api_endpoint}?query={query}&lang=en"
            
            print(f"Fetching page {page_count + 1} (start={start}, length={length})...")
            
            try:
                response = self.session.get(url)
                response.raise_for_status()
                data = response.json()
                
                # Parse incidents from this page
                page_incidents = []
                for incident_data in data.get('data', []):
                    try:
                        incident = self._parse_incident(incident_data)
                        page_incidents.append(incident)
                    except Exception as e:
                        print(f"Error parsing incident {incident_data.get('id', 'unknown')}: {e}")
                
                incidents.extend(page_incidents)
                
                print(f"Fetched {len(page_incidents)} incidents from page {page_count + 1}")
                print(f"Total incidents so far: {len(incidents)}")
                
                # Check if we have more data
                records_total = data.get('recordsTotal', 0)
                if start + length >= records_total:
                    print(f"Reached end of data. Total available: {records_total}")
                    break
                
                # Prepare for next page
                start += length
                page_count += 1
                
                # Be respectful to the API
                if delay > 0:
                    time.sleep(delay)
                
            except Exception as e:
                print(f"Error fetching page {page_count + 1}: {e}")
                break
        
        print(f"Scraping complete. Total incidents fetched: {len(incidents)}")
        return incidents
    
    def filter_last_24_hours(self, incidents: List[TrafficIncident]) -> List[TrafficIncident]:
        """Filter incidents to those updated in the last 24 hours"""
        cutoff_time = datetime.now() - timedelta(hours=24)
        recent_incidents = []
        
        for incident in incidents:
            try:
                # Parse the lastUpdated field - format appears to be "M/D/YY, H:MM AM/PM"
                last_updated_str = incident.last_updated
                if last_updated_str:
                    # Handle the specific format from FL 511
                    last_updated = datetime.strptime(last_updated_str, "%m/%d/%y, %I:%M %p")
                    if last_updated >= cutoff_time:
                        recent_incidents.append(incident)
            except Exception as e:
                print(f"Error parsing date for incident {incident.id}: {e}")
                # Include incidents where we can't parse the date to be safe
                recent_incidents.append(incident)
        
        return recent_incidents
    
    def export_to_json(self, incidents: List[TrafficIncident], filename: str = None) -> str:
        """Export incidents to JSON format suitable for database ingestion"""
        if filename is None:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = f"fl511_incidents_{timestamp}.json"
        
        # Convert dataclasses to dictionaries
        incidents_dict = [asdict(incident) for incident in incidents]
        
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump({
                'scrape_metadata': {
                    'scraped_at': datetime.now().isoformat(),
                    'total_incidents': len(incidents),
                    'source': 'FL 511 Traffic API',
                    'api_endpoint': self.api_endpoint
                },
                'incidents': incidents_dict
            }, f, indent=2, ensure_ascii=False)
        
        print(f"Exported {len(incidents)} incidents to {filename}")
        return filename
    
    def get_summary_stats(self, incidents: List[TrafficIncident]) -> Dict[str, Any]:
        """Generate summary statistics for the scraped incidents"""
        if not incidents:
            return {}
        
        # Count by type
        type_counts = {}
        severity_counts = {}
        region_counts = {}
        county_counts = {}
        roadway_counts = {}
        
        for incident in incidents:
            # Type counts
            incident_type = incident.incident_type
            type_counts[incident_type] = type_counts.get(incident_type, 0) + 1
            
            # Severity counts  
            severity = incident.severity
            severity_counts[severity] = severity_counts.get(severity, 0) + 1
            
            # Region counts
            region = incident.region
            region_counts[region] = region_counts.get(region, 0) + 1
            
            # County counts
            county = incident.county
            county_counts[county] = county_counts.get(county, 0) + 1
            
            # Roadway counts
            roadway = incident.roadway_name
            roadway_counts[roadway] = roadway_counts.get(roadway, 0) + 1
        
        return {
            'total_incidents': len(incidents),
            'by_type': dict(sorted(type_counts.items(), key=lambda x: x[1], reverse=True)),
            'by_severity': dict(sorted(severity_counts.items(), key=lambda x: x[1], reverse=True)),
            'by_region': dict(sorted(region_counts.items(), key=lambda x: x[1], reverse=True)),
            'by_county': dict(sorted(county_counts.items(), key=lambda x: x[1], reverse=True)),
            'top_roadways': dict(sorted(roadway_counts.items(), key=lambda x: x[1], reverse=True)[:10])
        }


def main():
    """Main execution function"""
    scraper = FL511Scraper()
    
    # Fetch all incidents
    print("=== FL 511 Traffic Incidents Scraper ===")
    incidents = scraper.fetch_incidents()
    
    if not incidents:
        print("No incidents found!")
        return
    
    # Filter to last 24 hours
    print("\n=== Filtering to Last 24 Hours ===")
    recent_incidents = scraper.filter_last_24_hours(incidents)
    print(f"Found {len(recent_incidents)} incidents from the last 24 hours")
    
    # Export all incidents
    all_filename = scraper.export_to_json(incidents, "fl511_all_incidents.json")
    
    # Export recent incidents  
    recent_filename = scraper.export_to_json(recent_incidents, "fl511_recent_incidents.json")
    
    # Generate summaries
    print("\n=== Summary Statistics (All Incidents) ===")
    all_stats = scraper.get_summary_stats(incidents)
    print(json.dumps(all_stats, indent=2))
    
    print("\n=== Summary Statistics (Recent Incidents) ===")
    recent_stats = scraper.get_summary_stats(recent_incidents)
    print(json.dumps(recent_stats, indent=2))
    
    # Print some sample incidents
    print("\n=== Sample Recent Incidents ===")
    for i, incident in enumerate(recent_incidents[:5]):
        print(f"\n{i+1}. {incident.roadway_name} - {incident.county} County")
        print(f"   Type: {incident.incident_type} | Severity: {incident.severity}")
        print(f"   Description: {incident.description[:100]}...")
        print(f"   Last Updated: {incident.last_updated}")


if __name__ == "__main__":
    main()