-- FL 511 I4-I95 Video Infrastructure Database Schema
-- Enhanced for 700+ cameras across Florida's major interstates

-- Traffic Incidents Table
CREATE TABLE IF NOT EXISTS traffic_incidents (
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
    end_date TIMESTAMP,
    source VARCHAR(200),
    state VARCHAR(50) DEFAULT 'Florida',
    country VARCHAR(50) DEFAULT 'United States',
    sub_type VARCHAR(50),
    dot_district VARCHAR(50),
    location_description TEXT,
    detour_description TEXT,
    lane_description TEXT,
    recurrence_description TEXT,
    comment TEXT,
    width_restriction VARCHAR(50),
    height_restriction VARCHAR(50),
    height_under_restriction VARCHAR(50),
    length_restriction VARCHAR(50),
    weight_restriction VARCHAR(50),
    is_full_closure BOOLEAN DEFAULT FALSE,
    show_on_map BOOLEAN DEFAULT TRUE,
    major_event VARCHAR(200),
    tooltip_url VARCHAR(500),
    scraped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Traffic Cameras Table
CREATE TABLE IF NOT EXISTS traffic_cameras (
    id INTEGER PRIMARY KEY,
    camera_site_id INTEGER,
    name VARCHAR(200),
    description TEXT,
    roadway_name VARCHAR(200),
    county VARCHAR(100),
    region VARCHAR(50),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    install_date DATE,
    equipment_type VARCHAR(100),
    direction VARCHAR(50),
    video_url TEXT,
    image_url TEXT,
    video_type VARCHAR(50),
    is_video_auth_required BOOLEAN DEFAULT FALSE,
    source_id VARCHAR(50),
    system_source_id VARCHAR(50),
    status VARCHAR(20) DEFAULT 'active',
    last_checked TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Video Segments Table
CREATE TABLE IF NOT EXISTS video_segments (
    id SERIAL PRIMARY KEY,
    camera_id INTEGER REFERENCES traffic_cameras(id),
    incident_id INTEGER REFERENCES traffic_incidents(id),
    segment_filename VARCHAR(200),
    storage_bucket VARCHAR(100),
    storage_path VARCHAR(500),
    segment_duration DECIMAL(5, 2),
    segment_size_bytes BIGINT,
    capture_timestamp TIMESTAMP,
    program_date_time TIMESTAMP,
    stream_url TEXT,
    segment_index INTEGER,
    playlist_sequence INTEGER,
    storage_class VARCHAR(20) DEFAULT 'STANDARD',
    is_archived BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Camera-Incident Relationships Table
CREATE TABLE IF NOT EXISTS camera_incident_relationships (
    id SERIAL PRIMARY KEY,
    camera_id INTEGER REFERENCES traffic_cameras(id),
    incident_id INTEGER REFERENCES traffic_incidents(id),
    distance_km DECIMAL(8, 3),
    relationship_type VARCHAR(50), -- 'nearby', 'same_roadway', 'direct'
    confidence_score DECIMAL(3, 2), -- 0.0 to 1.0
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(camera_id, incident_id)
);

-- Video Capture Jobs Table
CREATE TABLE IF NOT EXISTS video_capture_jobs (
    id SERIAL PRIMARY KEY,
    job_name VARCHAR(100),
    cameras_targeted INTEGER[],
    incidents_targeted INTEGER[],
    capture_duration_minutes INTEGER,
    job_status VARCHAR(20) DEFAULT 'pending', -- pending, running, completed, failed
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    segments_captured INTEGER DEFAULT 0,
    total_size_bytes BIGINT DEFAULT 0,
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_incidents_last_updated ON traffic_incidents(last_updated);
CREATE INDEX IF NOT EXISTS idx_incidents_region ON traffic_incidents(region);
CREATE INDEX IF NOT EXISTS idx_incidents_roadway ON traffic_incidents(roadway_name);
CREATE INDEX IF NOT EXISTS idx_cameras_region ON traffic_cameras(region);
CREATE INDEX IF NOT EXISTS idx_cameras_roadway ON traffic_cameras(roadway_name);
CREATE INDEX IF NOT EXISTS idx_segments_camera_timestamp ON video_segments(camera_id, capture_timestamp);
CREATE INDEX IF NOT EXISTS idx_segments_incident ON video_segments(incident_id);
CREATE INDEX IF NOT EXISTS idx_relationships_camera ON camera_incident_relationships(camera_id);
CREATE INDEX IF NOT EXISTS idx_relationships_incident ON camera_incident_relationships(incident_id);

-- Views for common queries
CREATE OR REPLACE VIEW active_incidents_with_cameras AS
SELECT 
    i.*,
    c.id as camera_id,
    c.name as camera_name,
    c.video_url,
    cir.distance_km,
    cir.relationship_type
FROM traffic_incidents i
JOIN camera_incident_relationships cir ON i.id = cir.incident_id
JOIN traffic_cameras c ON cir.camera_id = c.id
WHERE i.last_updated >= NOW() - INTERVAL '24 hours'
  AND c.status = 'active'
ORDER BY i.last_updated DESC, cir.distance_km ASC;

-- I4-I95 Camera Metadata Table (from JSON database)
CREATE TABLE IF NOT EXISTS i4_i95_cameras (
    id SERIAL PRIMARY KEY,
    camera_id VARCHAR(50) UNIQUE NOT NULL,
    image_id VARCHAR(50) NOT NULL, -- For video authentication
    name VARCHAR(200),
    description TEXT,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    install_date TIMESTAMP,
    equipment_type VARCHAR(100) DEFAULT 'application/x-mpegURL',
    region VARCHAR(50),
    county VARCHAR(100),
    roadway VARCHAR(10), -- 'I-4' or 'I-95'
    location TEXT,
    direction VARCHAR(50),
    video_url TEXT,
    thumbnail_url TEXT,
    is_video_auth_required BOOLEAN DEFAULT TRUE,
    status VARCHAR(20) DEFAULT 'active',
    last_video_capture TIMESTAMP,
    total_segments_captured INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Enhanced Video Segments with Geolocation
CREATE TABLE IF NOT EXISTS video_segments_enhanced (
    id SERIAL PRIMARY KEY,
    camera_id VARCHAR(50) REFERENCES i4_i95_cameras(camera_id),
    segment_filename VARCHAR(200) NOT NULL,
    storage_bucket VARCHAR(100) NOT NULL,
    storage_path VARCHAR(500) NOT NULL,
    storage_url TEXT NOT NULL,
    segment_duration DECIMAL(5, 2),
    segment_size_bytes BIGINT,
    capture_timestamp TIMESTAMP NOT NULL,
    program_date_time TIMESTAMP,
    segment_index INTEGER,
    
    -- Camera location at time of capture
    camera_latitude DECIMAL(10, 8),
    camera_longitude DECIMAL(11, 8),
    camera_location TEXT,
    camera_roadway VARCHAR(10),
    camera_region VARCHAR(50),
    camera_county VARCHAR(100),
    camera_direction VARCHAR(50),
    
    -- Incident correlation (populated retroactively)
    correlated_incident_id INTEGER,
    correlation_confidence DECIMAL(3, 2), -- 0.0 to 1.0
    correlation_distance_km DECIMAL(8, 3),
    correlation_timestamp TIMESTAMP,
    
    -- Storage management
    storage_class VARCHAR(20) DEFAULT 'STANDARD',
    lifecycle_action VARCHAR(20), -- 'pending', 'archived', 'deleted'
    archived_at TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Incident-Video Correlation Jobs
CREATE TABLE IF NOT EXISTS correlation_jobs (
    id SERIAL PRIMARY KEY,
    job_name VARCHAR(100),
    lookback_hours INTEGER DEFAULT 2,
    target_regions VARCHAR(50)[] DEFAULT ARRAY['Central', 'Northeast', 'Southeast', 'Tampa Bay'],
    target_roadways VARCHAR(10)[] DEFAULT ARRAY['I-4', 'I-95'],
    
    -- Job statistics
    job_status VARCHAR(20) DEFAULT 'pending', -- pending, running, completed, failed
    incidents_processed INTEGER DEFAULT 0,
    video_segments_processed INTEGER DEFAULT 0,
    correlations_created INTEGER DEFAULT 0,
    correlation_threshold DECIMAL(3, 2) DEFAULT 0.5,
    
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    duration_seconds INTEGER,
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Continuous Capture Sessions
CREATE TABLE IF NOT EXISTS capture_sessions (
    id SERIAL PRIMARY KEY,
    session_name VARCHAR(100),
    duration_hours INTEGER,
    capture_interval_minutes INTEGER,
    max_cameras_per_batch INTEGER,
    segments_per_camera INTEGER,
    
    -- Session status
    session_status VARCHAR(20) DEFAULT 'active', -- active, paused, completed, failed
    started_at TIMESTAMP NOT NULL,
    scheduled_end_at TIMESTAMP,
    actual_end_at TIMESTAMP,
    
    -- Statistics
    total_capture_rounds INTEGER DEFAULT 0,
    total_cameras_processed INTEGER DEFAULT 0,
    total_segments_captured INTEGER DEFAULT 0,
    total_data_size_bytes BIGINT DEFAULT 0,
    successful_captures INTEGER DEFAULT 0,
    failed_captures INTEGER DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Additional indexes for I4-I95 specific queries
CREATE INDEX IF NOT EXISTS idx_i4_i95_cameras_roadway ON i4_i95_cameras(roadway);
CREATE INDEX IF NOT EXISTS idx_i4_i95_cameras_region ON i4_i95_cameras(region);
CREATE INDEX IF NOT EXISTS idx_i4_i95_cameras_auth ON i4_i95_cameras(is_video_auth_required);
CREATE INDEX IF NOT EXISTS idx_video_segments_enhanced_timestamp ON video_segments_enhanced(capture_timestamp);
CREATE INDEX IF NOT EXISTS idx_video_segments_enhanced_camera ON video_segments_enhanced(camera_id);
CREATE INDEX IF NOT EXISTS idx_video_segments_enhanced_roadway ON video_segments_enhanced(camera_roadway);
CREATE INDEX IF NOT EXISTS idx_video_segments_enhanced_correlation ON video_segments_enhanced(correlated_incident_id);
CREATE INDEX IF NOT EXISTS idx_correlation_jobs_status ON correlation_jobs(job_status);
CREATE INDEX IF NOT EXISTS idx_capture_sessions_status ON capture_sessions(session_status);

-- Enhanced views for I4-I95 operations
CREATE OR REPLACE VIEW i4_i95_camera_summary AS
SELECT 
    roadway,
    region,
    county,
    COUNT(*) as camera_count,
    COUNT(CASE WHEN is_video_auth_required THEN 1 END) as auth_required_count,
    COUNT(CASE WHEN last_video_capture >= NOW() - INTERVAL '1 hour' THEN 1 END) as recently_active_count
FROM i4_i95_cameras 
WHERE status = 'active'
GROUP BY roadway, region, county
ORDER BY roadway, region, county;

CREATE OR REPLACE VIEW recent_video_segments AS
SELECT 
    vse.*,
    ic.name as camera_name,
    ti.description as incident_description,
    ti.severity,
    ti.incident_type
FROM video_segments_enhanced vse
JOIN i4_i95_cameras ic ON vse.camera_id = ic.camera_id
LEFT JOIN traffic_incidents ti ON vse.correlated_incident_id = ti.id
WHERE vse.capture_timestamp >= NOW() - INTERVAL '7 days'
ORDER BY vse.capture_timestamp DESC;

CREATE OR REPLACE VIEW active_capture_status AS
SELECT 
    cs.*,
    (cs.total_segments_captured * 100.0 / NULLIF(cs.total_cameras_processed * cs.segments_per_camera, 0)) as capture_success_rate,
    (cs.total_data_size_bytes / 1024.0 / 1024.0) as total_data_size_mb,
    EXTRACT(EPOCH FROM (NOW() - cs.started_at)) / 3600.0 as runtime_hours
FROM capture_sessions cs
WHERE cs.session_status IN ('active', 'paused')
ORDER BY cs.started_at DESC;

-- Function to correlate incidents with video segments retroactively
CREATE OR REPLACE FUNCTION correlate_incidents_with_video(
    lookback_hours INTEGER DEFAULT 2,
    correlation_threshold DECIMAL DEFAULT 0.5
) RETURNS TABLE (
    segments_processed INTEGER,
    correlations_created INTEGER
) AS $$
DECLARE
    segments_count INTEGER := 0;
    correlations_count INTEGER := 0;
    segment_record RECORD;
    incident_record RECORD;
    distance_km DECIMAL;
    confidence DECIMAL;
BEGIN
    -- Process video segments from the last N hours
    FOR segment_record IN
        SELECT * FROM video_segments_enhanced 
        WHERE capture_timestamp >= NOW() - (lookback_hours || ' hours')::INTERVAL
          AND correlated_incident_id IS NULL
          AND camera_latitude IS NOT NULL 
          AND camera_longitude IS NOT NULL
    LOOP
        segments_count := segments_count + 1;
        
        -- Find nearby incidents within time window
        FOR incident_record IN
            SELECT *, 
                   ST_Distance(
                       ST_GeogFromText('POINT(' || segment_record.camera_longitude || ' ' || segment_record.camera_latitude || ')'),
                       ST_GeogFromText('POINT(-82.0 28.0)') -- Placeholder - would use actual incident coordinates
                   ) / 1000.0 as distance_km
            FROM traffic_incidents
            WHERE last_updated BETWEEN (segment_record.capture_timestamp - INTERVAL '1 hour')
                                   AND (segment_record.capture_timestamp + INTERVAL '1 hour')
              AND roadway_name = segment_record.camera_roadway
            ORDER BY distance_km
            LIMIT 1
        LOOP
            -- Calculate confidence based on proximity and timing
            confidence := GREATEST(0.0, 1.0 - (incident_record.distance_km / 5.0)); -- Max 5km range
            
            IF confidence >= correlation_threshold THEN
                -- Update video segment with correlation
                UPDATE video_segments_enhanced 
                SET correlated_incident_id = incident_record.id,
                    correlation_confidence = confidence,
                    correlation_distance_km = incident_record.distance_km,
                    correlation_timestamp = NOW()
                WHERE id = segment_record.id;
                
                correlations_count := correlations_count + 1;
            END IF;
        END LOOP;
    END LOOP;
    
    RETURN QUERY SELECT segments_count, correlations_count;
END;
$$ LANGUAGE plpgsql;