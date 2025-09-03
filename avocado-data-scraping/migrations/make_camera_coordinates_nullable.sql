-- Migration: Make camera_latitude and camera_longitude nullable
-- Date: 2025-01-02
-- Issue: NULL values being inserted but columns have NOT NULL constraint

ALTER TABLE video_segments 
ALTER COLUMN camera_latitude DROP NOT NULL;

ALTER TABLE video_segments 
ALTER COLUMN camera_longitude DROP NOT NULL;