-- FL511 Video-Incident Correlation Database Schema
-- Clean, optimized design for video segment and incident correlation
-- Based on analysis of actual FL511 API data and video segment structure

-- =============================================================================
-- CAMERAS TABLE
-- Master list of traffic cameras with geolocation data
-- =============================================================================
CREATE TABLE cameras (
    camera_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description VARCHAR(500),
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,
    roadway VARCHAR(20) NOT NULL,           -- I-4, I-95, etc.
    direction VARCHAR(20),                  -- Northbound, Southbound, etc.
    region VARCHAR(50) NOT NULL,            -- Tampa Bay, Northeast, etc.  
    county VARCHAR(100) NOT NULL,
    location VARCHAR(500),
    install_date TIMESTAMP,
    equipment_type VARCHAR(100),
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- INCIDENTS TABLE  
-- Traffic incidents from FL511 API with timing and location data
-- =============================================================================
CREATE TABLE incidents (
    incident_id INTEGER PRIMARY KEY,
    dt_row_id VARCHAR(50),
    source_id VARCHAR(50),
    roadway_name VARCHAR(50) NOT NULL,
    county VARCHAR(100),
    region VARCHAR(50),
    incident_type VARCHAR(100) NOT NULL,    -- Construction Zones, Accident, etc.
    severity VARCHAR(20),                   -- Major, Minor, etc.
    direction VARCHAR(20),
    description TEXT,
    start_date TIMESTAMP NOT NULL,
    last_updated TIMESTAMP,
    end_date TIMESTAMP,
    source VARCHAR(100),                    -- DIVAS - District 6, etc.
    dot_district VARCHAR(50),
    location_description TEXT,
    detour_description TEXT,
    lane_description TEXT,
    scraped_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- VIDEO_SEGMENTS TABLE
-- Individual video segments captured from cameras with complete metadata
-- =============================================================================
CREATE TABLE video_segments (
    segment_id SERIAL PRIMARY KEY,
    camera_id VARCHAR(20) NOT NULL REFERENCES cameras(camera_id),
    segment_filename VARCHAR(200) NOT NULL,
    storage_bucket VARCHAR(100) NOT NULL,
    storage_path VARCHAR(500) NOT NULL,
    storage_url TEXT NOT NULL,
    
    -- Video technical metadata
    segment_duration DECIMAL(5,2),          -- Duration in seconds (e.g., 2.0)
    segment_size_bytes BIGINT,
    segment_index INTEGER,
    program_date_time TIMESTAMP,            -- Original timestamp from HLS playlist
    
    -- Capture metadata  
    capture_timestamp TIMESTAMP NOT NULL,   -- When we captured this segment
    capture_session_id UUID,                -- Links related segments from same capture run
    
    -- Derived camera location (for correlation efficiency)
    camera_latitude DECIMAL(10,8) NOT NULL,
    camera_longitude DECIMAL(11,8) NOT NULL, 
    camera_roadway VARCHAR(20) NOT NULL,
    camera_region VARCHAR(50) NOT NULL,
    camera_county VARCHAR(100) NOT NULL,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Ensure uniqueness per camera/segment
    UNIQUE(camera_id, segment_filename)
);

-- =============================================================================  
-- CORRELATIONS TABLE
-- Links incidents to video segments based on spatial/temporal proximity
-- =============================================================================
CREATE TABLE correlations (
    correlation_id SERIAL PRIMARY KEY,
    incident_id INTEGER NOT NULL REFERENCES incidents(incident_id),
    segment_id INTEGER NOT NULL REFERENCES video_segments(segment_id),
    
    -- Correlation metrics
    distance_km DECIMAL(8,3) NOT NULL,      -- Distance between camera and incident
    time_offset_minutes INTEGER NOT NULL,   -- Minutes between incident start and video capture
    confidence_score DECIMAL(3,2) DEFAULT 0.8,  -- 0.0 to 1.0 correlation confidence
    
    -- Correlation metadata
    correlation_method VARCHAR(50) DEFAULT 'spatial_temporal',
    correlation_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Prevent duplicate correlations
    UNIQUE(incident_id, segment_id)
);

-- =============================================================================
-- INDEXES FOR PERFORMANCE
-- =============================================================================

-- Camera lookups
CREATE INDEX idx_cameras_roadway ON cameras(roadway);
CREATE INDEX idx_cameras_region ON cameras(region);  
CREATE INDEX idx_cameras_location ON cameras(latitude, longitude);

-- Incident lookups
CREATE INDEX idx_incidents_roadway ON incidents(roadway_name);
CREATE INDEX idx_incidents_time ON incidents(start_date);
CREATE INDEX idx_incidents_type ON incidents(incident_type);
CREATE INDEX idx_incidents_region ON incidents(region);

-- Video segment lookups (most critical for correlation)
CREATE INDEX idx_video_segments_camera ON video_segments(camera_id);
CREATE INDEX idx_video_segments_time ON video_segments(capture_timestamp);
CREATE INDEX idx_video_segments_roadway ON video_segments(camera_roadway);
CREATE INDEX idx_video_segments_location ON video_segments(camera_latitude, camera_longitude);
CREATE INDEX idx_video_segments_session ON video_segments(capture_session_id);

-- Correlation lookups
CREATE INDEX idx_correlations_incident ON correlations(incident_id);
CREATE INDEX idx_correlations_segment ON correlations(segment_id);
CREATE INDEX idx_correlations_confidence ON correlations(confidence_score);
CREATE INDEX idx_correlations_distance ON correlations(distance_km);

-- =============================================================================
-- CORRELATION FUNCTION
-- Finds video segments that correlate with incidents based on:
-- 1. Same roadway (I-4, I-95, etc.)
-- 2. Geographic proximity (within radius_km)  
-- 3. Temporal proximity (within time_window_minutes of incident start)
-- =============================================================================
CREATE OR REPLACE FUNCTION correlate_incidents_with_videos(
    radius_km DECIMAL DEFAULT 2.0,
    time_window_minutes INTEGER DEFAULT 60
) RETURNS INTEGER AS $$
DECLARE
    correlations_created INTEGER := 0;
    incident_record RECORD;
    segment_record RECORD;
    distance_km DECIMAL;
    time_diff_minutes INTEGER;
BEGIN
    -- Loop through recent incidents (last 24 hours)
    FOR incident_record IN
        SELECT incident_id, roadway_name, region, start_date
        FROM incidents 
        WHERE start_date >= NOW() - INTERVAL '24 hours'
          AND roadway_name IN ('I-4', 'I-95')  -- Focus on major highways
    LOOP
        -- Find video segments on same roadway within time window
        FOR segment_record IN
            SELECT 
                vs.segment_id,
                vs.camera_id,
                vs.capture_timestamp,
                vs.camera_latitude,
                vs.camera_longitude,
                c.latitude as camera_lat,
                c.longitude as camera_lng,
                -- Calculate distance using Haversine formula (simplified for Florida)
                (111.0 * SQRT(
                    POWER(vs.camera_latitude - c.latitude, 2) + 
                    POWER(COS(RADIANS((vs.camera_latitude + c.latitude) / 2)) * 
                          (vs.camera_longitude - c.longitude), 2)
                )) as calculated_distance
            FROM video_segments vs
            JOIN cameras c ON vs.camera_id = c.camera_id
            WHERE vs.camera_roadway = incident_record.roadway_name
              AND vs.capture_timestamp BETWEEN 
                  incident_record.start_date - (time_window_minutes || ' minutes')::INTERVAL
                  AND incident_record.start_date + (time_window_minutes || ' minutes')::INTERVAL
        LOOP
            distance_km := segment_record.calculated_distance;
            time_diff_minutes := ABS(EXTRACT(EPOCH FROM (segment_record.capture_timestamp - incident_record.start_date)) / 60);
            
            -- Create correlation if within distance threshold
            IF distance_km <= radius_km THEN
                INSERT INTO correlations 
                (incident_id, segment_id, distance_km, time_offset_minutes, 
                 confidence_score, correlation_method)
                VALUES (
                    incident_record.incident_id,
                    segment_record.segment_id,
                    distance_km,
                    time_diff_minutes,
                    GREATEST(0.5, 1.0 - (distance_km / radius_km) * 0.3), -- Higher confidence for closer cameras
                    'spatial_temporal'
                )
                ON CONFLICT (incident_id, segment_id) DO NOTHING;
                
                IF FOUND THEN
                    correlations_created := correlations_created + 1;
                END IF;
            END IF;
        END LOOP;
    END LOOP;
    
    RETURN correlations_created;
END;
$$ LANGUAGE plpgsql;

-- =============================================================================
-- UTILITY VIEWS FOR EASY QUERYING
-- =============================================================================

-- Active incidents with video coverage
CREATE VIEW incidents_with_video AS
SELECT 
    i.incident_id,
    i.roadway_name,
    i.incident_type,
    i.description,
    i.start_date,
    COUNT(c.correlation_id) as video_count,
    ARRAY_AGG(DISTINCT vs.camera_id) as camera_ids,
    MIN(c.distance_km) as closest_camera_km,
    MAX(c.confidence_score) as best_confidence
FROM incidents i
JOIN correlations c ON i.incident_id = c.incident_id  
JOIN video_segments vs ON c.segment_id = vs.segment_id
WHERE i.start_date >= NOW() - INTERVAL '7 days'
GROUP BY i.incident_id, i.roadway_name, i.incident_type, i.description, i.start_date
ORDER BY i.start_date DESC;

-- Recent video segments with incident correlations
CREATE VIEW video_segments_with_incidents AS
SELECT 
    vs.segment_id,
    vs.camera_id,
    vs.segment_filename,
    vs.storage_url,
    vs.capture_timestamp,
    vs.camera_roadway,
    i.incident_id,
    i.incident_type,
    i.description as incident_description,
    c.distance_km,
    c.confidence_score
FROM video_segments vs
JOIN correlations c ON vs.segment_id = c.segment_id
JOIN incidents i ON c.incident_id = i.incident_id
WHERE vs.capture_timestamp >= NOW() - INTERVAL '7 days'
ORDER BY vs.capture_timestamp DESC;

-- =============================================================================
-- SAMPLE QUERIES
-- =============================================================================

/*
-- Find all video segments for a specific incident
SELECT * FROM video_segments_with_incidents 
WHERE incident_id = 12345;

-- Find incidents near a specific camera
SELECT DISTINCT i.* 
FROM incidents i
JOIN correlations c ON i.incident_id = c.incident_id
JOIN video_segments vs ON c.segment_id = vs.segment_id  
WHERE vs.camera_id = '2242'
  AND c.distance_km <= 1.0;

-- Get video coverage statistics by roadway
SELECT 
    vs.camera_roadway,
    COUNT(DISTINCT vs.camera_id) as camera_count,
    COUNT(vs.segment_id) as total_segments,
    COUNT(DISTINCT c.incident_id) as incidents_with_video
FROM video_segments vs
LEFT JOIN correlations c ON vs.segment_id = c.segment_id
GROUP BY vs.camera_roadway
ORDER BY incidents_with_video DESC;
*/