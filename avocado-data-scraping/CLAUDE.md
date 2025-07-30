# Avocado Data Scraping - Claude Instructions

## 🎯 **System Context**

This folder contains a **separate Python-based data scraping system** designed to gather traffic camera data that will eventually be fed into the main Avocado web application. This is an independent system focused solely on data collection and processing.

## 🚦 **Current Focus: Florida 511 Traffic Cameras**

### **Primary Objective**
Scrape comprehensive traffic camera data from Florida's 511 system, specifically targeting the **Northeast region** to collect metadata for approximately 500-600 cameras.

### **Target Entity: Traffic Camera**
Each camera should contain the following metadata fields:
- **name/description** - Camera identifier and location description
- **lat/lon** - Geographic coordinates
- **install_date** - When the camera was installed
- **equipment_type** - Type of camera hardware
- **video_urls** - Direct streaming URLs for camera feeds
- **region** - Geographic region (focusing on Northeast)
- **county** - County location
- **roadway** - Associated road/highway
- **direction** - Camera orientation/direction

### **API Details**
- **Base URL**: `https://fl511.com/List/GetData/Cameras`
- **Pagination**: 100 items per request (use `start` and `length` parameters)
- **Filter**: Northeast region only
- **Expected Total**: ~500-600 cameras in Northeast region

### **Key Requirements**
1. **Pagination Handling**: API limits to 100 results per request - increment `start` parameter to fetch all data
2. **Data Extraction**: Parse JSON responses to extract all available camera metadata
3. **Video Stream Access**: Extract direct video URLs for streaming capabilities
4. **Data Structure**: Create consistent entity structure for feeding into main application

## 🛠️ **Technical Approach**

### **Language & Independence**
- **Python-based** system completely independent from the main Next.js application
- Self-contained with its own dependencies and execution environment
- Designed to output structured data that can be consumed by the web application

### **Development Guidelines**
- Focus on robust data collection and error handling
- Implement proper rate limiting to respect the 511 API
- Structure data for easy integration with the main application
- Include comprehensive logging for monitoring scraping operations

## 🔄 **Data Pipeline**

```
FL 511 API → Python Scraper → Structured Data → Avocado Web App
```

### **Future Extensibility**
The camera entity structure is designed to be extensible for:
- Additional regions beyond Northeast Florida
- Other traffic data sources
- Real-time streaming integration
- Historical data collection

## 📋 **Success Criteria**

A successful implementation should:
- [ ] Fetch all ~500-600 Northeast Florida cameras
- [ ] Extract complete metadata for each camera
- [ ] Include working video stream URLs
- [ ] Handle pagination automatically
- [ ] Provide structured output format
- [ ] Include error handling and retry logic
- [ ] Respect API rate limits

## 🚨 **Security & Ethics**

- **Defensive scraping only** - respect robots.txt and API terms
- **Rate limiting** - don't overwhelm the 511 service
- **Public data only** - FL 511 provides public traffic information
- **No credential storage** - use public endpoints only

---

**Note**: When working in this directory, treat this as a completely separate system from the main Avocado web application. The focus here is purely on data collection and preparation.