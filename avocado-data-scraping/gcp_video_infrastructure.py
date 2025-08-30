#!/usr/bin/env python3
"""
GCP Video Infrastructure Setup for FL 511 Camera Streams

This module sets up the Google Cloud Platform infrastructure needed to:
1. Capture video streams from FL 511 traffic cameras
2. Store video segments in Cloud Storage 
3. Correlate video data with traffic incidents
4. Process and manage multi-day video storage

Infrastructure Components:
- Cloud Storage buckets for video storage
- Cloud Run services for video capture workers
- Cloud SQL for metadata and incident correlation
- Cloud Scheduler for automated capture jobs
"""

import os
import json
from datetime import datetime, timedelta
from typing import Dict, List, Optional
from google.cloud import storage
from google.cloud import run_v2
from google.cloud import scheduler
from google.cloud import sql_v1
import subprocess


class GCPVideoInfrastructure:
    def __init__(self, project_id: str, region: str = "us-central1"):
        """
        Initialize GCP infrastructure manager
        
        Args:
            project_id: GCP project ID
            region: GCP region for resources
        """
        self.project_id = project_id
        self.region = region
        self.storage_client = storage.Client(project=project_id)
        
    def setup_cloud_storage(self) -> Dict[str, str]:
        """
        Set up Cloud Storage buckets for video data storage
        
        Returns:
            Dict mapping bucket purposes to bucket names
        """
        buckets = {
            'video_segments': f"{self.project_id}-fl511-video-segments",
            'video_archives': f"{self.project_id}-fl511-video-archives", 
            'incident_metadata': f"{self.project_id}-fl511-incident-data",
            'camera_metadata': f"{self.project_id}-fl511-camera-data"
        }
        
        for purpose, bucket_name in buckets.items():
            try:
                bucket = self.storage_client.bucket(bucket_name)
                if not bucket.exists():
                    # Create bucket with appropriate settings
                    bucket = self.storage_client.create_bucket(
                        bucket_name,
                        location=self.region
                    )
                    
                    # Set lifecycle policy for video segments (delete after 30 days)
                    if purpose == 'video_segments':
                        lifecycle_config = {
                            "rule": [
                                {
                                    "action": {"type": "Delete"},
                                    "condition": {"age": 30}  # Delete after 30 days
                                }
                            ]
                        }
                        bucket.lifecycle_rules = lifecycle_config
                        bucket.patch()
                    
                    # Set lifecycle policy for archives (move to coldline after 7 days)
                    elif purpose == 'video_archives':
                        lifecycle_config = {
                            "rule": [
                                {
                                    "action": {"type": "SetStorageClass", "storageClass": "COLDLINE"},
                                    "condition": {"age": 7}
                                },
                                {
                                    "action": {"type": "Delete"},
                                    "condition": {"age": 365}  # Delete after 1 year
                                }
                            ]
                        }
                        bucket.lifecycle_rules = lifecycle_config
                        bucket.patch()
                    
                    print(f"✅ Created bucket: {bucket_name}")
                else:
                    print(f"✅ Bucket already exists: {bucket_name}")
                    
            except Exception as e:
                print(f"❌ Error creating bucket {bucket_name}: {e}")
                
        return buckets

    def deploy_video_capture_service(self, docker_image: str) -> str:
        """
        Deploy Cloud Run service for video capture
        
        Args:
            docker_image: Docker image URL for the video capture service
            
        Returns:
            Service URL
        """
        # This would deploy a Cloud Run service
        # For now, return the configuration needed
        service_config = {
            "apiVersion": "run.googleapis.com/v1",
            "kind": "Service",
            "metadata": {
                "name": "fl511-video-capture",
                "namespace": self.project_id
            },
            "spec": {
                "template": {
                    "metadata": {
                        "annotations": {
                            "autoscaling.knative.dev/maxScale": "100",
                            "run.googleapis.com/memory": "2Gi",
                            "run.googleapis.com/cpu": "2"
                        }
                    },
                    "spec": {
                        "containerConcurrency": 10,
                        "containers": [{
                            "image": docker_image,
                            "env": [
                                {"name": "PROJECT_ID", "value": self.project_id},
                                {"name": "REGION", "value": self.region}
                            ],
                            "resources": {
                                "limits": {
                                    "memory": "2Gi",
                                    "cpu": "2"
                                }
                            }
                        }]
                    }
                },
                "traffic": [{
                    "percent": 100,
                    "latestRevision": True
                }]
            }
        }
        
        print("📋 Cloud Run service configuration ready")
        return f"https://fl511-video-capture-{self.project_id}.a.run.app"

    def create_terraform_config(self) -> str:
        """
        Generate Terraform configuration for the infrastructure
        
        Returns:
            Terraform configuration as string
        """
        terraform_config = f'''
# FL 511 Video Infrastructure - Terraform Configuration

terraform {{
  required_providers {{
    google = {{
      source  = "hashicorp/google"
      version = "~> 4.0"
    }}
  }}
}}

provider "google" {{
  project = "{self.project_id}"
  region  = "{self.region}"
}}

# Cloud Storage Buckets
resource "google_storage_bucket" "video_segments" {{
  name     = "{self.project_id}-fl511-video-segments"
  location = "{self.region.upper()}"
  
  lifecycle_rule {{
    condition {{
      age = 30
    }}
    action {{
      type = "Delete"
    }}
  }}
  
  uniform_bucket_level_access = true
}}

resource "google_storage_bucket" "video_archives" {{
  name     = "{self.project_id}-fl511-video-archives"
  location = "{self.region.upper()}"
  
  lifecycle_rule {{
    condition {{
      age = 7
    }}
    action {{
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }}
  }}
  
  lifecycle_rule {{
    condition {{
      age = 365
    }}
    action {{
      type = "Delete"
    }}
  }}
  
  uniform_bucket_level_access = true
}}

resource "google_storage_bucket" "incident_metadata" {{
  name     = "{self.project_id}-fl511-incident-data"
  location = "{self.region.upper()}"
  
  uniform_bucket_level_access = true
}}

resource "google_storage_bucket" "camera_metadata" {{
  name     = "{self.project_id}-fl511-camera-data"
  location = "{self.region.upper()}"
  
  uniform_bucket_level_access = true
}}

# Cloud SQL Database for metadata
resource "google_sql_database_instance" "fl511_metadata" {{
  name             = "fl511-metadata-db"
  database_version = "POSTGRES_14"
  region          = "{self.region}"
  
  settings {{
    tier = "db-f1-micro"
    
    disk_autoresize       = true
    disk_autoresize_limit = 100
    disk_size            = 10
    disk_type           = "PD_SSD"
    
    backup_configuration {{
      enabled    = true
      start_time = "03:00"
    }}
    
    ip_configuration {{
      ipv4_enabled = true
      authorized_networks {{
        name  = "allow-all"
        value = "0.0.0.0/0"
      }}
    }}
  }}
  
  deletion_protection = false
}}

resource "google_sql_database" "incidents" {{
  name     = "fl511_incidents"
  instance = google_sql_database_instance.fl511_metadata.name
}}

resource "google_sql_database" "cameras" {{
  name     = "fl511_cameras"
  instance = google_sql_database_instance.fl511_metadata.name
}}

resource "google_sql_database" "video_segments" {{
  name     = "fl511_video_segments"
  instance = google_sql_database_instance.fl511_metadata.name
}}

# Cloud Run Service for Video Capture
resource "google_cloud_run_service" "video_capture" {{
  name     = "fl511-video-capture"
  location = "{self.region}"

  template {{
    spec {{
      containers {{
        image = "gcr.io/{self.project_id}/fl511-video-capture:latest"
        
        env {{
          name  = "PROJECT_ID"
          value = "{self.project_id}"
        }}
        
        env {{
          name  = "REGION"
          value = "{self.region}"
        }}
        
        resources {{
          limits = {{
            cpu    = "2"
            memory = "2Gi"
          }}
        }}
      }}
      
      container_concurrency = 10
    }}
    
    metadata {{
      annotations = {{
        "autoscaling.knative.dev/maxScale" = "100"
        "run.googleapis.com/memory"        = "2Gi"
        "run.googleapis.com/cpu"           = "2"
      }}
    }}
  }}

  traffic {{
    percent         = 100
    latest_revision = true
  }}
}}

# IAM for Cloud Run service
resource "google_cloud_run_service_iam_binding" "video_capture_invoker" {{
  location = google_cloud_run_service.video_capture.location
  service  = google_cloud_run_service.video_capture.name
  role     = "roles/run.invoker"
  
  members = [
    "allUsers"  # Change this to specific service accounts for production
  ]
}}

# Cloud Scheduler for periodic video capture
resource "google_cloud_scheduler_job" "video_capture_job" {{
  name             = "fl511-video-capture-cron"
  description      = "Trigger FL 511 video capture every 5 minutes"
  schedule         = "*/5 * * * *"  # Every 5 minutes
  time_zone        = "America/New_York"
  attempt_deadline = "300s"

  http_target {{
    http_method = "POST"
    uri         = "${{google_cloud_run_service.video_capture.status[0].url}}/capture"
    
    headers = {{
      "Content-Type" = "application/json"
    }}
    
    body = base64encode(jsonencode({{
      "action": "capture_all_cameras"
    }}))
  }}
}}

# Output important values
output "storage_buckets" {{
  value = {{
    video_segments    = google_storage_bucket.video_segments.name
    video_archives    = google_storage_bucket.video_archives.name
    incident_metadata = google_storage_bucket.incident_metadata.name
    camera_metadata   = google_storage_bucket.camera_metadata.name
  }}
}}

output "database_connection" {{
  value = {{
    host     = google_sql_database_instance.fl511_metadata.ip_address[0].ip_address
    database = google_sql_database.incidents.name
  }}
  sensitive = true
}}

output "cloud_run_url" {{
  value = google_cloud_run_service.video_capture.status[0].url
}}
'''
        
        return terraform_config

    def create_database_schema(self) -> str:
        """
        Generate SQL schema for the database
        
        Returns:
            SQL schema as string
        """
        schema_sql = '''
-- FL 511 Video Infrastructure Database Schema

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

CREATE OR REPLACE VIEW recent_video_segments AS
SELECT 
    vs.*,
    c.name as camera_name,
    c.roadway_name,
    c.region,
    i.description as incident_description,
    i.severity
FROM video_segments vs
JOIN traffic_cameras c ON vs.camera_id = c.id
LEFT JOIN traffic_incidents i ON vs.incident_id = i.id
WHERE vs.capture_timestamp >= NOW() - INTERVAL '7 days'
ORDER BY vs.capture_timestamp DESC;
'''
        
        return schema_sql


def create_docker_setup() -> Dict[str, str]:
    """
    Create Docker configuration files for the video capture service
    
    Returns:
        Dict with filenames and content
    """
    
    dockerfile = '''
FROM python:3.11-slim

# Install system dependencies for video processing
RUN apt-get update && apt-get install -y \\
    ffmpeg \\
    curl \\
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \\
  CMD curl -f http://localhost:8080/health || exit 1

# Run the application
CMD ["python", "video_capture_service.py"]
'''
    
    docker_compose = f'''
version: '3.8'

services:
  fl511-video-capture:
    build: .
    ports:
      - "8080:8080"
    environment:
      - PROJECT_ID=${{PROJECT_ID}}
      - REGION=${{REGION}}
      - GOOGLE_APPLICATION_CREDENTIALS=/app/credentials.json
    volumes:
      - ./credentials.json:/app/credentials.json:ro
      - ./video_data:/app/video_data
    restart: unless-stopped
    
  postgres:
    image: postgres:14
    environment:
      POSTGRES_DB: fl511_metadata
      POSTGRES_USER: fl511_user
      POSTGRES_PASSWORD: fl511_password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./schema.sql:/docker-entrypoint-initdb.d/01-schema.sql
    restart: unless-stopped

volumes:
  postgres_data:
'''
    
    requirements = '''
google-cloud-storage>=2.10.0
google-cloud-run>=0.10.0
google-cloud-sql>=3.4.0
google-cloud-scheduler>=2.13.0
requests>=2.32.0
flask>=2.3.0
psycopg2-binary>=2.9.0
sqlalchemy>=2.0.0
python-dotenv>=1.0.0
'''
    
    return {
        'Dockerfile': dockerfile,
        'docker-compose.yml': docker_compose,
        'requirements.txt': requirements
    }


def main():
    """Main function to demonstrate infrastructure setup"""
    import argparse
    
    parser = argparse.ArgumentParser(description='FL 511 Video Infrastructure Setup')
    parser.add_argument('--project-id', required=True, help='GCP Project ID')
    parser.add_argument('--region', default='us-central1', help='GCP Region')
    parser.add_argument('--setup-storage', action='store_true', help='Set up Cloud Storage buckets')
    parser.add_argument('--generate-terraform', action='store_true', help='Generate Terraform configuration')
    parser.add_argument('--generate-docker', action='store_true', help='Generate Docker configuration')
    
    args = parser.parse_args()
    
    # Initialize infrastructure manager
    infra = GCPVideoInfrastructure(args.project_id, args.region)
    
    if args.setup_storage:
        print("=== Setting up Cloud Storage ===")
        buckets = infra.setup_cloud_storage()
        print(f"Created buckets: {list(buckets.keys())}")
    
    if args.generate_terraform:
        print("=== Generating Terraform Configuration ===")
        terraform_config = infra.create_terraform_config()
        with open('fl511_infrastructure.tf', 'w') as f:
            f.write(terraform_config)
        print("✅ Terraform configuration written to fl511_infrastructure.tf")
        
        # Also create the database schema
        schema_sql = infra.create_database_schema()
        with open('database_schema.sql', 'w') as f:
            f.write(schema_sql)
        print("✅ Database schema written to database_schema.sql")
    
    if args.generate_docker:
        print("=== Generating Docker Configuration ===")
        docker_files = create_docker_setup()
        
        for filename, content in docker_files.items():
            with open(filename, 'w') as f:
                f.write(content)
            print(f"✅ {filename} created")
    
    print("\\n🚀 Infrastructure setup complete!")
    print("\\nNext steps:")
    print("1. Run: terraform init && terraform plan")
    print("2. Run: terraform apply")
    print("3. Build and deploy the video capture service")
    print("4. Configure the database with the provided schema")


if __name__ == "__main__":
    main()