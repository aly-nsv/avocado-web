-- 2025-09-02 Aly applied in production via BigQuery Console
-- Migration: Add incident_id to video_segments table for crash correlation

ALTER TABLE video_segments 
ADD COLUMN incident_id INTEGER REFERENCES incidents(incident_id);