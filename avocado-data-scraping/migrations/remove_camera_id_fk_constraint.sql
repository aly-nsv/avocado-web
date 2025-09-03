-- Migration: Remove foreign key constraint on camera_id in video_segments table
-- Date: 2025-01-02
-- Purpose: Allow video_segments to reference cameras that may not exist in cameras table

ALTER TABLE video_segments 
DROP CONSTRAINT video_segments_camera_id_fkey;