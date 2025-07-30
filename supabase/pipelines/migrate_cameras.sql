-- Florida 511 Camera Data Migration SQL Pipeline
-- ===============================================
-- 
-- This script provides SQL functions for migrating camera data from JSON
-- files into the traffic_cameras table. It includes data transformation,
-- deduplication, and validation logic.
--
-- Usage:
--   1. Load JSON data into a temporary table
--   2. Call migration functions
--   3. Validate results

-- Create temporary table for JSON import
CREATE TEMP TABLE IF NOT EXISTS temp_florida_cameras_json (
    json_data JSONB NOT NULL
);

-- Function to transform and insert Florida camera data
CREATE OR REPLACE FUNCTION migrate_florida_cameras_from_json()
RETURNS TABLE (
    operation TEXT,
    external_id TEXT,
    success BOOLEAN,
    error_message TEXT
) 
LANGUAGE plpgsql
AS $$
DECLARE
    camera_record RECORD;
    existing_camera_id UUID;
    transformed_data JSONB;
    insert_data RECORD;
BEGIN
    -- Iterate through all JSON records
    FOR camera_record IN 
        SELECT json_data FROM temp_florida_cameras_json
    LOOP
        BEGIN
            -- Extract and validate required fields
            IF NOT (camera_record.json_data ? 'id' AND 
                   camera_record.json_data ? 'name' AND 
                   camera_record.json_data ? 'latitude' AND 
                   camera_record.json_data ? 'longitude') THEN
                
                RETURN QUERY SELECT 
                    'SKIP'::TEXT,
                    COALESCE(camera_record.json_data->>'id', 'unknown')::TEXT,
                    FALSE,
                    'Missing required fields'::TEXT;
                CONTINUE;
            END IF;

            -- Check if camera already exists
            SELECT id INTO existing_camera_id 
            FROM public.traffic_cameras 
            WHERE external_id = (camera_record.json_data->>'id') 
            AND data_source = 'fl511';

            -- Transform data
            SELECT INTO insert_data
                (camera_record.json_data->>'id')::TEXT as external_id,
                TRIM(camera_record.json_data->>'name') as name,
                NULLIF(TRIM(camera_record.json_data->>'description'), '') as description,
                (camera_record.json_data->>'latitude')::DOUBLE PRECISION as latitude,
                (camera_record.json_data->>'longitude')::DOUBLE PRECISION as longitude,
                'FL'::TEXT as state_code,
                NULLIF(TRIM(camera_record.json_data->>'region'), '') as region,
                NULLIF(TRIM(camera_record.json_data->>'county'), '') as county,
                NULLIF(TRIM(camera_record.json_data->>'roadway'), '') as roadway,
                NULLIF(TRIM(camera_record.json_data->>'direction'), '') as direction,
                NULLIF(TRIM(camera_record.json_data->>'location'), '') as location_description,
                CASE 
                    WHEN (camera_record.json_data->>'status') = 'active' THEN 'active'::TEXT
                    ELSE 'inactive'::TEXT
                END as status,
                NULLIF(TRIM(camera_record.json_data->>'video_url'), '') as video_url,
                NULLIF(TRIM(camera_record.json_data->>'thumbnail_url'), '') as thumbnail_url,
                CASE 
                    WHEN camera_record.json_data ? 'install_date' 
                    THEN (camera_record.json_data->>'install_date')::TIMESTAMPTZ
                    ELSE NULL
                END as install_date,
                -- Extract mile marker from location
                CASE 
                    WHEN position('MM' in UPPER(camera_record.json_data->>'location')) > 0
                    THEN TRIM(split_part(split_part(UPPER(camera_record.json_data->>'location'), 'MM', 2), ' ', 2))
                    ELSE NULL
                END as mile_marker,
                -- Equipment metadata
                jsonb_build_object(
                    'equipment_type', camera_record.json_data->>'equipment_type',
                    'sort_order', COALESCE((camera_record.json_data->>'sort_order')::INT, 0),
                    'video_type', CASE 
                        WHEN camera_record.json_data->>'video_url' LIKE '%.m3u8%' THEN 'hls'
                        ELSE 'unknown'
                    END,
                    'video_format', camera_record.json_data->>'equipment_type'
                ) as equipment_metadata,
                -- Ownership metadata
                jsonb_build_object(
                    'source_id', camera_record.json_data->'raw_data'->>'sourceId',
                    'source', camera_record.json_data->'raw_data'->>'source',
                    'area_id', camera_record.json_data->'raw_data'->>'areaId',
                    'area', camera_record.json_data->'raw_data'->>'area'
                ) as ownership_metadata,
                camera_record.json_data as raw_data,
                'fl511'::TEXT as data_source;

            IF existing_camera_id IS NOT NULL THEN
                -- Update existing camera
                UPDATE public.traffic_cameras SET
                    name = insert_data.name,
                    description = insert_data.description,
                    latitude = insert_data.latitude,
                    longitude = insert_data.longitude,
                    region = insert_data.region,
                    county = insert_data.county,
                    roadway = insert_data.roadway,
                    direction = insert_data.direction,
                    location_description = insert_data.location_description,
                    status = insert_data.status,
                    video_url = insert_data.video_url,
                    thumbnail_url = insert_data.thumbnail_url,
                    install_date = insert_data.install_date,
                    mile_marker = insert_data.mile_marker,
                    equipment_metadata = insert_data.equipment_metadata,
                    ownership_metadata = insert_data.ownership_metadata,
                    raw_data = insert_data.raw_data,
                    updated_at = NOW()
                WHERE id = existing_camera_id;

                RETURN QUERY SELECT 
                    'UPDATE'::TEXT,
                    insert_data.external_id,
                    TRUE,
                    NULL::TEXT;
            ELSE
                -- Insert new camera
                INSERT INTO public.traffic_cameras (
                    external_id, name, description, latitude, longitude, state_code,
                    region, county, roadway, direction, location_description, status,
                    video_url, thumbnail_url, install_date, mile_marker,
                    equipment_metadata, ownership_metadata, raw_data, data_source
                ) VALUES (
                    insert_data.external_id, insert_data.name, insert_data.description,
                    insert_data.latitude, insert_data.longitude, insert_data.state_code,
                    insert_data.region, insert_data.county, insert_data.roadway,
                    insert_data.direction, insert_data.location_description, insert_data.status,
                    insert_data.video_url, insert_data.thumbnail_url, insert_data.install_date,
                    insert_data.mile_marker, insert_data.equipment_metadata,
                    insert_data.ownership_metadata, insert_data.raw_data, insert_data.data_source
                );

                RETURN QUERY SELECT 
                    'INSERT'::TEXT,
                    insert_data.external_id,
                    TRUE,
                    NULL::TEXT;
            END IF;

        EXCEPTION WHEN OTHERS THEN
            RETURN QUERY SELECT 
                'ERROR'::TEXT,
                COALESCE(camera_record.json_data->>'id', 'unknown')::TEXT,
                FALSE,
                SQLERRM::TEXT;
        END;
    END LOOP;
END;
$$;

-- Function to validate migration results
CREATE OR REPLACE FUNCTION validate_camera_migration()
RETURNS TABLE (
    metric TEXT,
    value BIGINT
) 
LANGUAGE sql
AS $$
    SELECT 'total_cameras'::TEXT, COUNT(*)::BIGINT FROM public.traffic_cameras WHERE data_source = 'fl511'
    UNION ALL
    SELECT 'active_cameras'::TEXT, COUNT(*)::BIGINT FROM public.traffic_cameras WHERE data_source = 'fl511' AND status = 'active'
    UNION ALL
    SELECT 'cameras_with_video'::TEXT, COUNT(*)::BIGINT FROM public.traffic_cameras WHERE data_source = 'fl511' AND video_url IS NOT NULL
    UNION ALL
    SELECT 'cameras_with_hls'::TEXT, COUNT(*)::BIGINT FROM public.traffic_cameras WHERE data_source = 'fl511' AND video_url LIKE '%.m3u8%'
    UNION ALL
    SELECT 'unique_regions'::TEXT, COUNT(DISTINCT region)::BIGINT FROM public.traffic_cameras WHERE data_source = 'fl511' AND region IS NOT NULL
    UNION ALL
    SELECT 'unique_counties'::TEXT, COUNT(DISTINCT county)::BIGINT FROM public.traffic_cameras WHERE data_source = 'fl511' AND county IS NOT NULL
    ORDER BY metric;
$$;

-- Function to get migration summary by region
CREATE OR REPLACE FUNCTION get_camera_summary_by_region()
RETURNS TABLE (
    region TEXT,
    total_cameras BIGINT,
    active_cameras BIGINT,
    cameras_with_video BIGINT
) 
LANGUAGE sql
AS $$
    SELECT 
        COALESCE(region, 'Unknown') as region,
        COUNT(*) as total_cameras,
        COUNT(*) FILTER (WHERE status = 'active') as active_cameras,
        COUNT(*) FILTER (WHERE video_url IS NOT NULL) as cameras_with_video
    FROM public.traffic_cameras 
    WHERE data_source = 'fl511'
    GROUP BY region
    ORDER BY total_cameras DESC;
$$;

-- Sample usage commands (comment out when running):
-- 
-- -- 1. Load JSON data (replace with actual data):
-- INSERT INTO temp_florida_cameras_json (json_data) 
-- SELECT jsonb_array_elements('[
--     {"id": "1312", "name": "I-75 Northbound", "latitude": 29.628903, ...}
-- ]'::jsonb);
-- 
-- -- 2. Run migration:
-- SELECT * FROM migrate_florida_cameras_from_json();
-- 
-- -- 3. Validate results:
-- SELECT * FROM validate_camera_migration();
-- SELECT * FROM get_camera_summary_by_region();
-- 
-- -- 4. Clean up:
-- DROP TABLE IF EXISTS temp_florida_cameras_json;