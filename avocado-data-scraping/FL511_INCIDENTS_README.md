# FL 511 Traffic Incidents Scraper

A comprehensive Python scraper for collecting traffic incident data from Florida's 511 system. This scraper is designed to fetch all available incidents with proper pagination, filter for recent incidents from the last 24 hours, and export data in a database-ready JSON format.

## Features

- **Complete Data Extraction**: Fetches all available traffic incidents with automatic pagination
- **24-Hour Filtering**: Filters incidents to those updated in the last 24 hours
- **Database-Ready Output**: Structured JSON format suitable for PostgreSQL ingestion
- **Comprehensive Data Model**: Includes all available fields from the FL 511 API
- **Error Handling**: Robust error handling with retry logic and rate limiting
- **Statistics Generation**: Provides detailed statistics about scraped data

## Installation

1. Create and activate a virtual environment:
```bash
python3 -m venv venv
source venv/bin/activate
```

2. Install required dependencies:
```bash
pip install -r requirements.txt
```

## Usage

### Basic Usage

Simply run the scraper to fetch all current incidents:

```bash
python fl511_scraper.py
```

This will:
1. Fetch all traffic incidents from FL 511
2. Filter incidents from the last 24 hours
3. Export both complete and recent datasets as JSON files
4. Display summary statistics

### Output Files

The scraper generates two main output files:

1. **`fl511_all_incidents.json`** - All available incidents
2. **`fl511_recent_incidents.json`** - Incidents from last 24 hours only

### Data Structure

Each incident contains the following fields:

#### Core Fields
- `id`: Unique incident identifier
- `roadway_name`: Road or highway name
- `county`: County where incident occurred
- `region`: Florida region (Northeast, Southeast, etc.)
- `incident_type`: Type of incident (Construction Zones, Incidents, etc.)
- `severity`: Severity level (Major, Intermediate, Minor)
- `description`: Detailed incident description
- `start_date`: When incident started
- `last_updated`: Last update timestamp

#### Additional Fields
- Location details (coordinates, descriptions)
- Traffic restrictions (lane closures, detours)
- Associated cameras with video streams
- Source information and metadata

## API Data Categories

### Incident Types
- Construction Zones
- Closures  
- Other Events
- Incidents
- Disabled Vehicles
- Road Condition
- Congestion

### Severity Levels
- Major
- Intermediate
- Minor
- N/A

### Florida Regions
- Central
- Northeast
- Panhandle
- Southeast
- Southwest
- Tampa Bay

## Database Integration

The JSON output is designed for easy PostgreSQL ingestion:

1. The top-level structure includes metadata about the scraping operation
2. The `incidents` array contains individual incident records
3. All fields are properly typed and nullable where appropriate
4. Timestamps are in ISO format for easy database parsing

### Example Database Schema

```sql
CREATE TABLE traffic_incidents (
    id INTEGER PRIMARY KEY,
    dt_row_id VARCHAR(50),
    source_id VARCHAR(50),
    roadway_name VARCHAR(200),
    county VARCHAR(100),
    region VARCHAR(50),
    incident_type VARCHAR(100),
    severity VARCHAR(50),
    direction VARCHAR(50),
    description TEXT,
    start_date TIMESTAMP,
    last_updated TIMESTAMP,
    source VARCHAR(200),
    -- Additional fields as needed
    scraped_at TIMESTAMP
);
```

## Configuration

The scraper can be customized by modifying the `FL511Scraper` class:

- **Rate Limiting**: Adjust the `delay` parameter in `fetch_incidents()`
- **Pagination Size**: Modify the `length` parameter (default: 100)
- **Time Filtering**: Customize the 24-hour window in `filter_last_24_hours()`

## Statistics Output

The scraper provides comprehensive statistics including:

- Total incident counts by type, severity, region, and county
- Top roadways with most incidents
- Breakdown of recent vs. all incidents
- Metadata about the scraping operation

## Error Handling

The scraper includes robust error handling for:

- Network timeouts and connection issues
- API rate limiting
- Malformed data parsing
- Date parsing edge cases

## Automation

For regular data collection, you can set up a cron job:

```bash
# Run every hour
0 * * * * /path/to/venv/bin/python /path/to/fl511_scraper.py
```

## Dependencies

- `requests`: HTTP client for API calls
- `dataclasses`: Data structure definitions (built-in)
- `json`: JSON parsing and generation (built-in)
- `datetime`: Date/time handling (built-in)
- `enum`: Enumeration definitions (built-in)

## License

This scraper is for educational and defensive security purposes only. Please respect the FL 511 API terms of service and implement appropriate rate limiting.