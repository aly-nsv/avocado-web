# Florida 511 Traffic Camera Scraper

A Python-based data scraping system for collecting traffic camera metadata from Florida's 511 system, designed to feed data into the Avocado web application.

## 🎯 Purpose

This system scrapes comprehensive traffic camera data from Florida's 511 system, specifically targeting the Northeast region. It extracts essential metadata including coordinates, video streams, and camera details for integration with the main Avocado security dashboard.

## 📊 Complete Results Summary

- **4,564 cameras** successfully scraped across all Florida regions ✅
- **3,958 cameras** with active video streams (HLS format) - 86.7%
- **All 4,564 cameras** include GPS coordinates and metadata
- **100% coverage** of expected dataset

### Regional Breakdown
- **Southeast**: 1,186 cameras (Miami-Dade, Broward, Palm Beach areas)
- **Central**: 1,129 cameras (Orlando, Tampa metro areas)
- **Tampa Bay**: 692 cameras (Hillsborough, Pinellas counties)
- **Northeast**: 591 cameras (Jacksonville, Duval area)
- **Panhandle**: 571 cameras (Tallahassee, Pensacola areas)
- **Southwest**: 395 cameras (Naples, Fort Myers areas)

### Top Coverage Areas
- **Orange County**: 503 cameras (Orlando metro)
- **Broward County**: 463 cameras (Fort Lauderdale area)
- **Miami-Dade County**: 396 cameras (Miami metro)
- **Hillsborough County**: 347 cameras (Tampa area)
- **Leon County**: 289 cameras (Tallahassee area)

### Major Highway Coverage
- **I-75**: 674 cameras (statewide corridor)
- **I-95**: 552 cameras (east coast corridor)
- **Florida's Turnpike**: 508 cameras (toll road system)
- **I-10**: 428 cameras (panhandle corridor)
- **I-4**: 224 cameras (Orlando-Tampa corridor)

## 🛠️ Setup

1. **Create Virtual Environment**:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

2. **Install Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

## 🚀 Usage

### Run Single Region Scraper
```bash
source venv/bin/activate
python3 fl511_camera_scraper.py  # Scrapes Northeast by default
```

### Run All Regions Scraper
```bash
source venv/bin/activate
python3 scrape_all_regions.py  # Scrapes all 6 regions
```

### Create Combined Dataset
```bash
source venv/bin/activate
python3 create_combined_dataset.py  # Combines all regions into master file
```

### Analyze Results
```bash
python3 analyze_cameras.py [filename.json]
```

## 📁 Output Files

### Individual Region Files
- `fl511_cameras_northeast_YYYYMMDD_HHMMSS.json` (591 cameras)
- `fl511_cameras_central_YYYYMMDD_HHMMSS.json` (1,129 cameras)
- `fl511_cameras_panhandle_YYYYMMDD_HHMMSS.json` (571 cameras)
- `fl511_cameras_southeast_YYYYMMDD_HHMMSS.json` (1,186 cameras)
- `fl511_cameras_southwest_YYYYMMDD_HHMMSS.json` (395 cameras)
- `fl511_cameras_tampa_bay_YYYYMMDD_HHMMSS.json` (692 cameras)

### Combined Dataset
- `fl511_cameras_complete_florida_YYYYMMDD_HHMMSS.json` (4,564 cameras)
- `fl511_florida_statistics_YYYYMMDD_HHMMSS.json` (analysis summary)

### Logs
- `fl511_scraper.log` (single region scraping)
- `all_regions_scraper.log` (multi-region scraping)

## 🎥 Video Stream Format

All video URLs are in **HLS format** (`application/x-mpegURL`):
```
https://dis-se4.divas.cloud:8200/chan-1171_h/index.m3u8
```

These streams can be played directly in modern browsers or integrated into video players that support HLS.

## 📋 Data Structure

Each camera includes:
```json
{
  "id": "1312",
  "name": "I-75 Northbound - I-75 @ MM 384.7",
  "latitude": 29.628903,
  "longitude": -82.393921,
  "video_url": "https://dis-se4.divas.cloud:8200/chan-1171_h/index.m3u8",
  "thumbnail_url": "https://fl511.com/map/Cctv/1312",
  "region": "Northeast",
  "county": "Alachua",
  "roadway": "I-75",
  "direction": "Northbound",
  "install_date": "2024-12-12T16:12:05.3752272+00:00",
  "status": "active"
}
```

## 🔧 Configuration

### Modify Region Filter
Edit the `region` parameter in `fl511_camera_scraper.py`:
```python
cameras = scraper.scrape_all_cameras(region="Northeast")  # Change as needed
```

### Available Regions
- Northeast
- Northwest  
- Central
- Southeast
- Southwest

### Rate Limiting
Default: 1 second delay between requests. Modify `REQUEST_DELAY` in the scraper class.

## 📈 Future Enhancements

- [ ] Support for multiple regions
- [ ] Real-time camera status monitoring
- [ ] Video stream health checking
- [ ] Historical data collection
- [ ] Integration with main Avocado application

## 🔒 Security & Ethics

- Uses only public FL 511 API endpoints
- Respects rate limits (1 req/second)
- No authentication required - public data only
- Defensive scraping practices implemented

## 📝 Files

- `fl511_camera_scraper.py` - Main scraper application
- `analyze_cameras.py` - Data analysis utility
- `requirements.txt` - Python dependencies
- `CLAUDE.md` - Claude AI system instructions
- `README.md` - This documentation

---

**Integration Ready**: This data is structured for easy consumption by the Avocado web application's dashboard system.