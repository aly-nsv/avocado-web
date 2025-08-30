# FL511 Video-Incident Correlation Database

## Overview
This database system correlates FL511 traffic incidents with captured video segments from traffic cameras, enabling historical analysis and incident investigation through video evidence.

## Architecture Decisions

### **Why PostgreSQL?**
- **Geospatial Support**: Built-in geographic functions for distance calculations
- **JSON Support**: Flexible metadata storage for video segments
- **ACID Compliance**: Critical for data integrity in incident correlation
- **Performance**: Excellent indexing for time-series and geospatial queries

### **Schema Design Philosophy**
1. **Normalized Structure**: Separate entities for cameras, incidents, video segments, and correlations
2. **Denormalized Location Data**: Camera coordinates stored in video_segments for query performance
3. **Confidence Scoring**: Correlation quality metrics for filtering unreliable matches
4. **Immutable Segments**: Video segments are never updated, only created
5. **Flexible Metadata**: JSON-compatible structure for extensibility

## Database Schema

### Core Tables

#### `cameras`
Master reference for all traffic cameras with geographic and operational metadata.

```sql
-- Key fields: camera_id (PK), latitude/longitude, roadway, region
-- Indexes: roadway, region, geographic location
-- Purpose: Authoritative camera registry with location data
```

#### `incidents` 
FL511 traffic incidents with timing and location information.

```sql
-- Key fields: incident_id (PK), roadway_name, start_date, incident_type
-- Indexes: roadway, time, region, incident_type  
-- Purpose: Store and query traffic incidents from FL511 API
```

#### `video_segments`
Individual video files captured from cameras with complete metadata.

```sql
-- Key fields: segment_id (PK), camera_id (FK), capture_timestamp, storage_url
-- Indexes: camera_id, time, roadway, geographic location
-- Purpose: Track all video segments with correlation metadata
-- Note: Includes denormalized camera location for performance
```

#### `correlations`
Links incidents to video segments based on spatial-temporal proximity.

```sql
-- Key fields: correlation_id (PK), incident_id (FK), segment_id (FK)
-- Metrics: distance_km, time_offset_minutes, confidence_score
-- Purpose: Enable incident-to-video queries with quality scoring
```

### Correlation Algorithm

The `correlate_incidents_with_videos()` function uses:

1. **Roadway Matching**: Same highway (I-4, I-95, etc.)
2. **Geographic Proximity**: Within configurable radius (default 2km)
3. **Temporal Window**: Within time range of incident start (default ±60 minutes)
4. **Confidence Scoring**: Distance-based quality metric (closer = higher confidence)

**Distance Calculation**: Simplified Haversine formula optimized for Florida's geographic constraints.

## Data Flow

```
FL511 API → Incident Scraper → incidents table
     ↓
Camera Video Stream → Video Capture → video_segments table
     ↓  
Correlation Function → spatial/temporal matching → correlations table
     ↓
Query Interface → incident-to-video mapping
```

## Query Patterns

### Find Video Evidence for Incident
```sql
SELECT vs.storage_url, vs.camera_id, c.confidence_score
FROM incidents i
JOIN correlations c ON i.incident_id = c.incident_id
JOIN video_segments vs ON c.segment_id = vs.segment_id
WHERE i.incident_id = ?
ORDER BY c.confidence_score DESC;
```

### Find Incidents in Video Segment
```sql  
SELECT i.incident_type, i.description, c.distance_km
FROM video_segments vs
JOIN correlations c ON vs.segment_id = c.segment_id
JOIN incidents i ON c.incident_id = i.incident_id
WHERE vs.segment_filename = ?;
```

### Coverage Analysis
```sql
SELECT 
    roadway_name,
    COUNT(DISTINCT camera_id) as camera_coverage,
    COUNT(incident_id) as total_incidents,
    COUNT(correlation_id) as incidents_with_video
FROM incidents_with_video
GROUP BY roadway_name;
```

## Performance Considerations

### Indexes Strategy
- **Spatial Indexes**: lat/lng for geographic queries
- **Time Indexes**: capture_timestamp, start_date for temporal queries  
- **Composite Indexes**: (roadway, time) for correlation function
- **Foreign Key Indexes**: All join columns indexed

### Query Optimization
- **Denormalized Location**: Camera coordinates in video_segments table
- **Materialized Views**: Pre-computed correlation summaries
- **Partition Strategy**: Consider time-based partitioning for large datasets

## Data Retention

### Storage Lifecycle
- **Video Segments**: 30 days in standard storage, then archive
- **Incidents**: Retained indefinitely for historical analysis
- **Correlations**: Retained with video segments
- **Cameras**: Updated as needed, historical versions preserved

## Backup Strategy

### Critical Data Priority
1. **Correlations** - Most valuable, difficult to recreate
2. **Incidents** - Historical record, API-dependent
3. **Video Segments** - Large volume, backed up to cold storage
4. **Cameras** - Reference data, can be rebuilt from JSON

## Monitoring & Health Checks

### Key Metrics
- **Correlation Rate**: % incidents with video evidence
- **Coverage Gaps**: Roadway segments without camera coverage
- **Data Freshness**: Time since last incident/segment insertion
- **Storage Growth**: Video segment volume trends

### Alerts
- Correlation function failures
- Missing incidents for >1 hour
- Video capture gaps on critical cameras
- Storage quota approaching limits

## Migration History

### v1.0 - Initial Schema (2025-08-28)
- Created core tables: cameras, incidents, video_segments, correlations
- Implemented spatial-temporal correlation function
- Added utility views for common queries
- Established indexing strategy for performance

### Future Migrations
- Planned: Add incident severity weighting to correlation scoring
- Planned: Implement multi-camera incident triangulation
- Planned: Add real-time correlation triggers

## Security Considerations

### Data Sensitivity
- **Public Data**: All FL511 incidents and camera locations are public
- **Storage URLs**: Video segments contain sensitive location data
- **Access Control**: Implement role-based access for correlation queries

### Privacy Compliance
- **Data Minimization**: Only store necessary metadata
- **Retention Limits**: Automatic cleanup of old video segments
- **Audit Trail**: Log all correlation queries for compliance

## Troubleshooting

### Common Issues
1. **No Correlations Created**: Check roadway name matching between cameras and incidents
2. **Low Confidence Scores**: Verify camera coordinate accuracy
3. **Missing Video Segments**: Check storage bucket permissions and capture service health
4. **Slow Correlation Queries**: Verify indexes exist and statistics are current

### Debug Queries
```sql
-- Check correlation function performance
EXPLAIN ANALYZE SELECT correlate_incidents_with_videos(2.0, 60);

-- Verify data completeness  
SELECT 
    'cameras' as table_name, COUNT(*) as records FROM cameras
UNION ALL
SELECT 'incidents', COUNT(*) FROM incidents
UNION ALL  
SELECT 'video_segments', COUNT(*) FROM video_segments
UNION ALL
SELECT 'correlations', COUNT(*) FROM correlations;
```

## API Integration Points

### FL511 Incident API
- **Endpoint**: `https://fl511.com/List/GetData/traffic`
- **Polling Frequency**: Every 5 minutes
- **Rate Limits**: 100 requests/hour
- **Data Format**: JSON with nested incident objects

### Video Capture Service
- **Integration**: Direct database insertion via `video_segments` table
- **Metadata Source**: HLS playlist + camera registry
- **Storage**: Google Cloud Storage with signed URLs

---

*Last Updated: 2025-08-28*  
*Schema Version: 1.0*