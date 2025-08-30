# FL 511 Video Infrastructure - Terraform Configuration

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

# Cloud Storage Buckets
resource "google_storage_bucket" "video_segments" {
  name     = "${var.project_id}-fl511-video-segments"
  location = upper(var.region)
  
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
  
  uniform_bucket_level_access = true
  
  versioning {
    enabled = false
  }
}

resource "google_storage_bucket" "video_archives" {
  name     = "${var.project_id}-fl511-video-archives"
  location = upper(var.region)
  
  lifecycle_rule {
    condition {
      age = 7
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }
  
  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type = "Delete"
    }
  }
  
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "incident_metadata" {
  name     = "${var.project_id}-fl511-incident-data"
  location = upper(var.region)
  
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "camera_metadata" {
  name     = "${var.project_id}-fl511-camera-data"
  location = upper(var.region)
  
  uniform_bucket_level_access = true
}

# Cloud SQL Database for metadata
resource "google_sql_database_instance" "fl511_metadata" {
  name             = "fl511-metadata-db"
  database_version = "POSTGRES_14"
  region          = var.region
  
  settings {
    tier = "db-f1-micro"
    
    disk_autoresize       = true
    disk_autoresize_limit = 100
    disk_size            = 10
    disk_type           = "PD_SSD"
    
    backup_configuration {
      enabled    = true
      start_time = "03:00"
    }
    
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "allow-all"
        value = "0.0.0.0/0"
      }
    }
  }
  
  deletion_protection = false
}

resource "google_sql_database" "incidents" {
  name     = "fl511_incidents"
  instance = google_sql_database_instance.fl511_metadata.name
}

resource "google_sql_database" "cameras" {
  name     = "fl511_cameras"
  instance = google_sql_database_instance.fl511_metadata.name
}

resource "google_sql_database" "video_segments" {
  name     = "fl511_video_segments"
  instance = google_sql_database_instance.fl511_metadata.name
}

# Cloud Run Service for Video Capture
resource "google_cloud_run_service" "video_capture" {
  name     = "fl511-video-capture"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/fl511-video-capture:latest"
        
        env {
          name  = "PROJECT_ID"
          value = var.project_id
        }
        
        env {
          name  = "REGION"
          value = var.region
        }
        
        env {
          name  = "DATABASE_NAME"
          value = "fl511_incidents"
        }
        
        env {
          name  = "DATABASE_USER"
          value = "fl511_user"
        }
        
        env {
          name  = "DATABASE_PASSWORD"
          value = var.database_password
        }
        
        resources {
          limits = {
            cpu    = "2"
            memory = "2Gi"
          }
        }
      }
      
      container_concurrency = 10
    }
    
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "100"
        "run.googleapis.com/memory"        = "2Gi"
        "run.googleapis.com/cpu"           = "2"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

variable "database_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "fl511_secure_password_123"
}

# IAM for Cloud Run service
resource "google_cloud_run_service_iam_binding" "video_capture_invoker" {
  location = google_cloud_run_service.video_capture.location
  service  = google_cloud_run_service.video_capture.name
  role     = "roles/run.invoker"
  
  members = [
    "allUsers"  # Change this to specific service accounts for production
  ]
}

# Cloud Scheduler for periodic video capture
resource "google_cloud_scheduler_job" "video_capture_job" {
  name             = "fl511-video-capture-cron"
  description      = "Trigger FL 511 video capture every 5 minutes"
  schedule         = "*/5 * * * *"  # Every 5 minutes
  time_zone        = "America/New_York"
  attempt_deadline = "300s"

  http_target {
    http_method = "POST"
    uri         = "${google_cloud_run_service.video_capture.status[0].url}/capture"
    
    headers = {
      "Content-Type" = "application/json"
    }
    
    body = base64encode(jsonencode({
      "action": "capture_all_cameras",
      "max_cameras": 10,
      "segments_per_camera": 5
    }))
  }
}

# Enable required APIs
resource "google_project_service" "cloud_run_api" {
  service = "run.googleapis.com"
}

resource "google_project_service" "cloud_sql_api" {
  service = "sql-component.googleapis.com"
}

resource "google_project_service" "cloud_scheduler_api" {
  service = "cloudscheduler.googleapis.com"
}

resource "google_project_service" "storage_api" {
  service = "storage.googleapis.com"
}

resource "google_project_service" "container_api" {
  service = "container.googleapis.com"
}

# Output important values
output "storage_buckets" {
  value = {
    video_segments    = google_storage_bucket.video_segments.name
    video_archives    = google_storage_bucket.video_archives.name
    incident_metadata = google_storage_bucket.incident_metadata.name
    camera_metadata   = google_storage_bucket.camera_metadata.name
  }
}

output "database_connection" {
  value = {
    host     = google_sql_database_instance.fl511_metadata.ip_address[0].ip_address
    database = google_sql_database.incidents.name
    instance = google_sql_database_instance.fl511_metadata.connection_name
  }
  sensitive = true
}

output "cloud_run_url" {
  value = google_cloud_run_service.video_capture.status[0].url
}