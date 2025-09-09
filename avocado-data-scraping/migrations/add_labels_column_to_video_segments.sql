-- Migration: Add labels column to video_segments for human-AI validation
-- Date: 2025-09-08
-- Author: Claude Code
-- Purpose: Enable structured labeling of video segments for ML training dataset creation

-- Add labels column as JSONB for flexible label storage
ALTER TABLE video_segments 
ADD COLUMN labels JSONB DEFAULT '[]'::jsonb;

-- Create index on labels for efficient querying
CREATE INDEX idx_video_segments_labels ON video_segments USING GIN (labels);

-- Create index for querying by label type
CREATE INDEX idx_video_segments_labels_type ON video_segments USING GIN ((labels -> 'label_type'));

-- Add comment explaining the structure
COMMENT ON COLUMN video_segments.labels IS 'JSON array of label objects. Each label contains: {
  "label_type": "collision|stationary_vehicle|pedestrian|etc",
  "confidence": 0.0-1.0,
  "source": "human|ai",
  "user_id": "user_identifier_or_null",
  "timestamp": "ISO_8601_timestamp",
  "metadata": {
    "question_id": "optional_question_identifier",
    "ai_suggested": boolean,
    "review_session_id": "uuid_for_grouping_related_labels"
  }
}';

-- Example of label structure:
/*
Sample labels column content:
[
  {
    "label_type": "collision",
    "confidence": 0.95,
    "source": "human",
    "user_id": "user_123",
    "timestamp": "2025-09-08T10:30:00Z",
    "metadata": {
      "question_id": "q1_can_see_collision",
      "ai_suggested": true,
      "review_session_id": "550e8400-e29b-41d4-a716-446655440000"
    }
  },
  {
    "label_type": "passenger_vehicle",
    "confidence": 0.85,
    "source": "ai",
    "user_id": null,
    "timestamp": "2025-09-08T10:25:00Z",
    "metadata": {
      "model": "gpt-4",
      "review_session_id": "550e8400-e29b-41d4-a716-446655440000"
    }
  }
]
*/