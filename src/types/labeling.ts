// Types for human-AI validation labeling system

export interface LabelType {
  label_type: string;
  category: string;
  priority: number;
  description: string;
  modality: string;
  examples: string;
  question_text: string;
}

export interface LabelMetadata {
  question_id?: string;
  ai_suggested?: boolean;
  review_session_id?: string;
  model?: string;
  [key: string]: any;
}

export interface VideoSegmentLabel {
  label_type: string;
  confidence: number; // 0.0 to 1.0
  source: 'human' | 'ai';
  user_id?: string;
  timestamp: string; // ISO 8601
  metadata: LabelMetadata;
}

export interface VideoSegment {
  segment_id: number;
  camera_id: string;
  segment_filename: string;
  storage_bucket: string;
  storage_path: string;
  storage_url: string;
  segment_duration: number;
  segment_size_bytes: number;
  segment_index: number;
  program_date_time?: string;
  capture_timestamp: string;
  capture_session_id?: string;
  camera_latitude: number;
  camera_longitude: number;
  camera_roadway: string;
  camera_region: string;
  camera_county: string;
  incident_id?: number;
  avocado_version?: string;
  labels: VideoSegmentLabel[];
  created_at: string;
}

export interface Incident {
  incident_id: number;
  dt_row_id?: string;
  source_id?: string;
  roadway_name: string;
  county?: string;
  region?: string;
  incident_type: string;
  severity?: string;
  direction?: string;
  description?: string;
  start_date: string;
  last_updated?: string;
  end_date?: string;
  source?: string;
  dot_district?: string;
  location_description?: string;
  detour_description?: string;
  lane_description?: string;
  scraped_at: string;
  created_at: string;
  updated_at: string;
  labels?: any[]; // JSON array of AI suggestions
}

export interface IncidentWithSegments extends Incident {
  video_segments: VideoSegment[];
}

export interface QuestionStep {
  id: string;
  question: string;
  type: 'multi_select' | 'review_suggestions' | 'confidence_rating';
  categories?: string[];
  priority_filter?: number[];
  required: boolean;
  next: string;
}

export interface QuestionFlow {
  [key: string]: QuestionStep;
}

export interface LabelingConfig {
  incidents: LabelType[];
  actors: LabelType[];
  question_flow: QuestionFlow;
}

export interface VideoStreamSelection {
  segment_id: number;
  selected: boolean;
}

export interface LabelSelection {
  label_type: string;
  selected: boolean;
  confidence?: number; // 1-5 scale for UI, converted to 0-1 for storage
  segment_ids: number[]; // which video segments this label applies to
}

export interface AISuggestion {
  label_type: string;
  confidence: number;
  reasoning: string;
}

export interface ReviewSession {
  session_id: string;
  incident_id: number;
  user_id?: string;
  started_at: string;
  completed_at?: string;
  current_step: string;
  video_selections: VideoStreamSelection[];
  label_selections: LabelSelection[];
  ai_suggestions: AISuggestion[];
}

export interface LabelingFormState {
  currentStep: string;
  videoSelections: VideoStreamSelection[];
  labelSelections: LabelSelection[];
  aiSuggestions: AISuggestion[];
  sessionId: string;
  isSubmitting: boolean;
  errors: Record<string, string>;
  // Local labeling process state
  videoQuality?: 'high' | 'medium' | 'low' | 'none';
  localLabelingSession?: LocalLabelingSession[];
}

export interface ReviewIncidentData {
  incident: Incident;
  video_segments: VideoSegment[];
  total_segments: number;
  cameras_involved: string[];
}

// API Response types
export interface GetIncidentsResponse {
  incidents: ReviewIncidentData[];
  total_count: number;
  has_more: boolean;
}

export interface SubmitLabelsRequest {
  session_id: string;
  incident_id: number;
  labels: VideoSegmentLabel[];
  video_selections: VideoStreamSelection[];
}

export interface SubmitLabelsResponse {
  success: boolean;
  labels_created: number;
  session_id: string;
  errors?: string[];
}

export interface GetAISuggestionsRequest {
  incident_description: string;
  incident_type: string;
}

export interface GetAISuggestionsResponse {
  suggestions: AISuggestion[];
  model_used: string;
  processing_time_ms: number;
}

// Local labeling process types
export interface LocalLabelingSession {
  incident_id: number;
  video_quality: 'high' | 'medium' | 'low' | 'none';
  labels: LocalLabelData[];
  completed_at?: string;
}

export interface LocalLabelData {
  incident_id: number;
  video_quality: 'high' | 'medium' | 'low' | 'none';
  selected_labels: string[];
  ai_suggested_labels: AISuggestion[];
  confidence_ratings: Record<string, number>;
  notes?: string;
  timestamp: string;
}

export interface CSVDownloadData {
  incident_id: number;
  roadway_name: string;
  incident_type: string;
  description: string;
  video_quality: string;
  selected_labels: string;
  ai_suggested_labels: string;
  confidence_average: number;
  timestamp: string;
  notes: string;
}