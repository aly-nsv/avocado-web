-- Migration: Add labels column to incidents for AI-based incident labeling
-- Date: 2025-09-09
-- Author: Claude Code
-- Purpose: Enable structured labeling of incidents using GPT-4 based on incident descriptions

-- Add labels column as JSONB for flexible label storage
ALTER TABLE incidents 
ADD COLUMN labels JSONB DEFAULT '[]'::jsonb;

-- Create index on labels for efficient querying
CREATE INDEX idx_incidents_labels ON incidents USING GIN (labels);

-- Create index for querying by label type
CREATE INDEX idx_incidents_labels_type ON incidents USING GIN ((labels -> 'label_type'));

-- Add index for finding unlabeled incidents efficiently
CREATE INDEX idx_incidents_unlabeled ON incidents (incident_id) 
WHERE labels IS NULL OR labels = '[]'::jsonb;

-- Add comment explaining the structure
COMMENT ON COLUMN incidents.labels IS 'JSON array of AI-predicted label objects based on incident description. Each label contains: {
  "label_type": "collision|stationary_vehicle|pedestrian|etc",
  "confidence": 0.0-1.0,
  "source": "ai",
  "model": "gpt-4",
  "timestamp": "ISO_8601_timestamp",
  "metadata": {
    "from_description": true,
    "batch_id": "uuid_for_tracking_processing_runs"
  }
}';

-- Example of label structure for incidents:
/*
Sample labels column content for incidents:
[
  {
    "label_type": "collision",
    "confidence": 0.90,
    "source": "ai",
    "model": "gpt-4",
    "timestamp": "2025-09-09T20:15:00Z",
    "metadata": {
      "from_description": true,
      "batch_id": "550e8400-e29b-41d4-a716-446655440001",
      "description_analyzed": "Vehicle collision on I-4 westbound with lanes blocked"
    }
  },
  {
    "label_type": "stationary_vehicle",
    "confidence": 0.85,
    "source": "ai",
    "model": "gpt-4", 
    "timestamp": "2025-09-09T20:15:00Z",
    "metadata": {
      "from_description": true,
      "batch_id": "550e8400-e29b-41d4-a716-446655440001"
    }
  }
]
*/
