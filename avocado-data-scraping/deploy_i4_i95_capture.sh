#!/bin/bash
# FL511 I4-I95 Video Capture - 24-Hour Deployment Script
# Deploys continuous video capture for 700+ cameras across Florida's major interstates

set -e

echo "🚀 Deploying FL511 I4-I95 Video Capture System"
echo "============================================="

# Configuration
PROJECT_ID="${PROJECT_ID:-avocado-fl511-video}"
REGION="${REGION:-us-central1}"
SERVICE_NAME="fl511-video-capture"

# Step 1: Set GCP project
echo "📋 Setting up GCP project..."
gcloud config set project $PROJECT_ID

# Step 2: Enable required APIs
echo "🔧 Enabling required GCP APIs..."
gcloud services enable run.googleapis.com
gcloud services enable sql-component.googleapis.com
gcloud services enable cloudscheduler.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable cloudbuild.googleapis.com

# Step 3: Create Cloud Storage buckets
echo "🗄️  Creating Cloud Storage buckets..."
gsutil mb -p $PROJECT_ID gs://$PROJECT_ID-fl511-video-segments || echo "Bucket exists"
gsutil mb -p $PROJECT_ID gs://$PROJECT_ID-fl511-video-archives || echo "Bucket exists"
gsutil mb -p $PROJECT_ID gs://$PROJECT_ID-fl511-incident-data || echo "Bucket exists"
gsutil mb -p $PROJECT_ID gs://$PROJECT_ID-fl511-camera-data || echo "Bucket exists"

# Apply lifecycle policies
echo "⏰ Setting up storage lifecycle policies..."
gsutil lifecycle set bucket-lifecycle-video-segments.json gs://$PROJECT_ID-fl511-video-segments
gsutil lifecycle set bucket-lifecycle-video-archives.json gs://$PROJECT_ID-fl511-video-archives

# Step 4: Create Cloud SQL instance
echo "🗃️  Creating Cloud SQL database..."
gcloud sql instances create fl511-metadata-db \
  --database-version=POSTGRES_14 \
  --tier=db-f1-micro \
  --region=$REGION \
  --authorized-networks=0.0.0.0/0 \
  --no-backup || echo "Database exists"

# Create database and user
gcloud sql databases create fl511_incidents --instance=fl511-metadata-db || echo "Database exists"
gcloud sql users create fl511_user --instance=fl511-metadata-db --password=AfUa9sQ7r6PcXufDVPJhwK || echo "User exists"

# Step 5: Deploy database schema
echo "📊 Setting up database schema..."
CLOUD_SQL_IP=$(gcloud sql instances describe fl511-metadata-db --format="value(ipAddresses[0].ipAddress)")
echo "Database IP: $CLOUD_SQL_IP"
# Note: Run schema manually: psql "host=$CLOUD_SQL_IP dbname=fl511_incidents user=fl511_user password=AfUa9sQ7r6PcXufDVPJhwK" < database_schema.sql

# Step 6: Build and deploy Cloud Run service
echo "🐳 Building and deploying Cloud Run service..."
gcloud builds submit --tag gcr.io/$PROJECT_ID/$SERVICE_NAME:latest .

gcloud run deploy $SERVICE_NAME \
  --image gcr.io/$PROJECT_ID/$SERVICE_NAME:latest \
  --platform managed \
  --region $REGION \
  --memory 2Gi \
  --cpu 2 \
  --timeout 3600 \
  --max-instances 25 \
  --min-instances 1 \
  --concurrency 10 \
  --set-env-vars PROJECT_ID=$PROJECT_ID,REGION=$REGION,CAMERA_DATABASE=fl511_i4_i95_cameras.json,MAX_CAMERAS=50 \
  --allow-unauthenticated

# Get service URL
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region=$REGION --format="value(status.url)")
echo "✅ Service deployed at: $SERVICE_URL"

# Step 7: Set up Cloud Scheduler jobs
echo "⏰ Setting up automated capture schedules..."

# Main I4-I95 capture job (every 2 minutes)
gcloud scheduler jobs delete fl511-i4-i95-capture-cron --quiet || true
gcloud scheduler jobs create http fl511-i4-i95-capture-cron \
  --schedule="*/2 * * * *" \
  --uri="${SERVICE_URL}/capture" \
  --http-method=POST \
  --headers="Content-Type=application/json" \
  --message-body='{"action":"capture_all_i4_i95","max_cameras":50,"segments_per_camera":5,"batch_size":25}' \
  --timeout=1800s

# Incident scraping job (every 5 minutes)
gcloud scheduler jobs delete fl511-incident-scraper-cron --quiet || true
gcloud scheduler jobs create http fl511-incident-scraper-cron \
  --schedule="*/5 * * * *" \
  --uri="${SERVICE_URL}/scrape_incidents" \
  --http-method=POST \
  --headers="Content-Type=application/json" \
  --message-body='{"regions":["Central","Northeast","Southeast","Tampa Bay"]}' \
  --timeout=300s

echo "🎯 DEPLOYMENT COMPLETE!"
echo "======================"
echo "Service URL: $SERVICE_URL"
echo "Cameras: 50 I-4 cameras (initial deployment)"
echo "Capture frequency: Every 2 minutes"
echo "Incident monitoring: Every 5 minutes"
echo ""

# Step 8: Start immediate 24-hour continuous capture
echo "🚀 Starting immediate 24-hour continuous capture..."
curl -X POST "${SERVICE_URL}/start_continuous_capture" \
  -H "Content-Type: application/json" \
  -d '{
    "duration_hours": 24,
    "capture_interval_minutes": 2,
    "max_cameras_per_batch": 50,
    "segments_per_camera": 5,
    "enable_incident_correlation": true
  }'

echo ""
echo "✅ 24-hour continuous capture STARTED!"
echo ""
echo "📊 Monitor progress:"
echo "curl $SERVICE_URL/capture_status"
echo ""
echo "🛑 Health check:"
echo "curl $SERVICE_URL/health"
echo ""
echo "📈 View database schema setup command:"
echo "psql \"host=$CLOUD_SQL_IP dbname=fl511_incidents user=fl511_user password=AfUa9sQ7r6PcXufDVPJhwK\" < database_schema.sql"
echo ""
echo "🎯 Expected results after 24 hours:"
echo "- ~35GB of video data captured (50 I-4 cameras)"
echo "- ~25,000 video segments stored"  
echo "- Incident correlation tracking"
echo "- Cost: ~$6 for 24 hours"