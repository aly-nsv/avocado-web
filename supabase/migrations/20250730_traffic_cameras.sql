-- Create traffic_cameras table for universal traffic camera data
-- Designed to support cameras from all states with extensible metadata

CREATE TABLE IF NOT EXISTS public.traffic_cameras (
  -- Primary identifiers
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  external_id text UNIQUE NOT NULL, -- Original system ID (e.g., FL511 ID)
  
  -- Basic camera information
  name text NOT NULL,
  description text,
  
  -- Geographic location
  latitude double precision NOT NULL,
  longitude double precision NOT NULL,
  
  -- Hierarchical location data
  state_code text NOT NULL, -- Two-letter state code (FL, CA, TX, etc.)
  region text, -- State-specific region (Northeast, Central, etc.)
  county text,
  city text,
  
  -- Transportation details
  roadway text, -- Highway/road name (I-75, US-1, etc.)
  direction text, -- Northbound, Southbound, etc.
  mile_marker text, -- Mile marker or cross-street info
  location_description text, -- Full location description
  
  -- Camera metadata
  install_date timestamptz,
  status text DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'maintenance', 'offline')),
  sort_order integer DEFAULT 0,
  
  -- Media URLs
  video_url text, -- Primary streaming URL
  thumbnail_url text, -- Still image URL
  backup_video_urls jsonb, -- Array of backup streaming URLs
  
  -- Equipment and ownership
  equipment_metadata jsonb DEFAULT '{}', -- Equipment type, model, etc.
  ownership_metadata jsonb DEFAULT '{}', -- Agency, district, maintenance info
  
  -- Enhanced features for future expansion
  features jsonb DEFAULT '{}', -- Traffic detection, weather, PTZ, etc.
  accessibility jsonb DEFAULT '{}', -- ADA compliance, multilingual support
  data_quality jsonb DEFAULT '{}', -- Uptime, reliability scores
  
  -- Raw source data preservation
  raw_data jsonb, -- Complete original API response
  data_source text NOT NULL, -- Source system (fl511, caltrans, etc.)
  last_updated timestamptz DEFAULT now(),
  
  -- Audit fields
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_traffic_cameras_state_region ON public.traffic_cameras (state_code, region);
CREATE INDEX IF NOT EXISTS idx_traffic_cameras_location ON public.traffic_cameras USING gist (ll_to_earth(latitude, longitude));
CREATE INDEX IF NOT EXISTS idx_traffic_cameras_roadway ON public.traffic_cameras (roadway);
CREATE INDEX IF NOT EXISTS idx_traffic_cameras_status ON public.traffic_cameras (status);
CREATE INDEX IF NOT EXISTS idx_traffic_cameras_external_id ON public.traffic_cameras (external_id);
CREATE INDEX IF NOT EXISTS idx_traffic_cameras_data_source ON public.traffic_cameras (data_source);

-- Spatial index for geographic queries (requires postgis)
-- CREATE INDEX IF NOT EXISTS idx_traffic_cameras_geom ON public.traffic_cameras USING gist (st_point(longitude, latitude));

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_traffic_cameras_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update updated_at
CREATE TRIGGER trigger_update_traffic_cameras_updated_at
  BEFORE UPDATE ON public.traffic_cameras
  FOR EACH ROW
  EXECUTE FUNCTION update_traffic_cameras_updated_at();

-- RLS policies (optional - customize based on security needs)
ALTER TABLE public.traffic_cameras ENABLE ROW LEVEL SECURITY;

-- Policy to allow public read access to active cameras
CREATE POLICY "Allow public read access to active cameras" ON public.traffic_cameras
  FOR SELECT USING (status = 'active');

-- Insert sample Florida camera data for testing
-- This would typically be populated via the scraping system
INSERT INTO public.traffic_cameras (
  external_id,
  name,
  description,
  latitude,
  longitude,
  state_code,
  region,
  county,
  roadway,
  direction,
  location_description,
  video_url,
  thumbnail_url,
  data_source,
  equipment_metadata,
  raw_data
) VALUES (
  '1312',
  'I-75 Northbound - I-75 @ MM 384.7',
  'I-75 @ MM 384.7',
  29.628903,
  -82.393921,
  'FL',
  'Northeast',
  'Alachua',
  'I-75',
  'Northbound',
  'I-75 @ MM 384.7',
  'https://dis-se4.divas.cloud:8200/chan-1171_h/index.m3u8',
  'https://fl511.com/map/Cctv/1312',
  'fl511',
  '{"equipment_type": "application/x-mpegURL", "video_type": "application/x-mpegURL", "video_auth_required": true}',
  '{"source": "District 2", "sourceId": "1171", "areaId": "ALA"}'
) ON CONFLICT (external_id) DO NOTHING;

-- Comments for documentation
COMMENT ON TABLE public.traffic_cameras IS 'Universal traffic camera data for all states with extensible metadata';
COMMENT ON COLUMN public.traffic_cameras.external_id IS 'Original system identifier from source API';
COMMENT ON COLUMN public.traffic_cameras.equipment_metadata IS 'Camera equipment details: type, model, capabilities';
COMMENT ON COLUMN public.traffic_cameras.ownership_metadata IS 'Agency ownership: district, department, maintenance contact';
COMMENT ON COLUMN public.traffic_cameras.features IS 'Camera features: PTZ, traffic detection, weather sensors';
COMMENT ON COLUMN public.traffic_cameras.raw_data IS 'Complete original API response for debugging and future migration';