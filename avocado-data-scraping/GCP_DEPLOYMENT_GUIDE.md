# FL 511 I4-I95 Video Infrastructure - GCP Deployment Guide

This guide will help you deploy the FL 511 video capture infrastructure on Google Cloud Platform for **continuous monitoring of I-4 and I-95 highways**. The system captures video from 700+ cameras across Florida's major interstates for incident correlation and traffic analysis.

## 🚀 Quick Start (Ready by Tomorrow)

### Prerequisites

1. **GCP Account with Billing Enabled**
2. **gcloud CLI installed and authenticated**
3. **Terraform installed** (optional, for infrastructure as code)
4. **Docker installed** (for local testing)

### Step 1: Set Up GCP Project

```bash
# Create new project
gcloud projects create avocado-fl511-video --name="FL511 Video Capture"

# Set as default project
gcloud config set project avocado-fl511-video

# Enable billing (required for Cloud SQL and other services)
# Do this through the GCP Console: https://console.cloud.google.com/billing
```

### Step 2: Quick Deploy with gcloud (Fastest Option)
Note: Billing must be enabled for this to work. Can be done through the GCP Console: https://console.cloud.google.com/billing.

```bash
# Enable required APIs
gcloud services enable run.googleapis.com
gcloud services enable sql-component.googleapis.com
gcloud services enable cloudscheduler.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable cloudbuild.googleapis.com

# Create Cloud Storage buckets
gsutil mb gs://avocado-fl511-video-fl511-video-segments
gsutil mb gs://avocado-fl511-video-fl511-video-archives
gsutil mb gs://avocado-fl511-video-fl511-incident-data
gsutil mb gs://avocado-fl511-video-fl511-camera-data

# Set lifecycle policies
gsutil lifecycle set bucket-lifecycle-video-segments.json gs://avocado-fl511-video-fl511-video-segments
gsutil lifecycle set bucket-lifecycle-video-archives.json gs://avocado-fl511-video-fl511-video-archives

# Create Cloud SQL instance
gcloud sql instances create fl511-metadata-db \
  --database-version=POSTGRES_14 \
  --tier=db-f1-micro \
  --region=us-central1 \
  --authorized-networks=0.0.0.0/0

# Create database and user
gcloud sql databases create fl511_incidents --instance=fl511-metadata-db
gcloud sql users create fl511_user --instance=fl511-metadata-db --password=AfUa9sQ7r6PcXufDVPJhwK
```

### Step 3: Deploy with Terraform (Recommended)

```bash
# Initialize Terraform
terraform init

# Set variables
export TF_VAR_project_id="avocado-fl511-video"
export TF_VAR_region="us-central1"

# Plan deployment
terraform plan

# Apply infrastructure
terraform apply
```

### Step 4: Build and Deploy the Video Capture Service

```bash
# Build and push Docker image with I4-I95 camera database
gcloud builds submit --tag gcr.io/avocado-fl511-video/fl511-video-capture:latest .

# Deploy to Cloud Run with enhanced specs for 700+ cameras
gcloud run deploy fl511-video-capture \
  --image gcr.io/avocado-fl511-video/fl511-video-capture:latest \
  --platform managed \
  --region us-central1 \
  --memory 8Gi \
  --cpu 4 \
  --timeout 3600 \
  --max-instances 200 \
  --min-instances 5 \
  --concurrency 50 \
  --set-env-vars PROJECT_ID=avocado-fl511-video,REGION=us-central1,CAMERA_DATABASE=fl511_i4_i95_cameras.json \
  --allow-unauthenticated
```

### Step 5: Set Up Database Schema

```bash
# Get Cloud SQL IP
CLOUD_SQL_IP=$(gcloud sql instances describe fl511-metadata-db --format="value(ipAddresses[0].ipAddress)")

# Connect to database and run schema
psql "host=$CLOUD_SQL_IP dbname=fl511_incidents user=fl511_user password=fl511_secure_password_123" < database_schema.sql
```

### Step 6: Set Up 24-Hour Continuous Capture

```bash
# Get Cloud Run service URL
SERVICE_URL=$(gcloud run services describe fl511-video-capture --region=us-central1 --format="value(status.url)")

# Create Cloud Scheduler job for continuous I4-I95 capture
gcloud scheduler jobs create http fl511-i4-i95-capture-cron \
  --schedule="*/2 * * * *" \
  --uri="${SERVICE_URL}/capture" \
  --http-method=POST \
  --headers="Content-Type=application/json" \
  --message-body='{"action":"capture_all_i4_i95","max_cameras":100,"segments_per_camera":5,"batch_size":50}' \
  --timeout=1800s

# Create incident scraping job (every 5 minutes)
gcloud scheduler jobs create http fl511-incident-scraper-cron \
  --schedule="*/5 * * * *" \
  --uri="${SERVICE_URL}/scrape_incidents" \
  --http-method=POST \
  --headers="Content-Type=application/json" \
  --message-body='{"regions":["Central","Northeast","Southeast","Tampa Bay"]}' \
  --timeout=300s

# Create incident correlation job (every 10 minutes)
gcloud scheduler jobs create http fl511-incident-correlation-cron \
  --schedule="*/10 * * * *" \
  --uri="${SERVICE_URL}/correlate_incidents" \
  --http-method=POST \
  --headers="Content-Type=application/json" \
  --message-body='{"lookback_hours":2}' \
  --timeout=600s
```

### Step 7: Trigger Immediate 24-Hour Capture

```bash
# Start immediate continuous capture for 24 hours
curl -X POST "${SERVICE_URL}/start_continuous_capture" \
  -H "Content-Type: application/json" \
  -d '{
    "duration_hours": 24,
    "capture_interval_minutes": 2,
    "max_cameras_per_batch": 100,
    "segments_per_camera": 5,
    "enable_incident_correlation": true
  }'

# Monitor capture status
curl "${SERVICE_URL}/capture_status"
```

## 📋 Detailed Infrastructure Components

### Cloud Storage Buckets

1. **Video Segments** (`*-fl511-video-segments`)
   - Stores raw video segments (.ts files)
   - 30-day lifecycle policy for cost optimization
   - Standard storage class

2. **Video Archives** (`*-fl511-video-archives`) 
   - Long-term video storage
   - Coldline storage after 7 days
   - 1-year retention policy

3. **Incident Metadata** (`*-fl511-incident-data`)
   - JSON exports of incident data
   - Permanent storage

4. **Camera Metadata** (`*-fl511-camera-data`)
   - Camera configuration and status
   - Permanent storage

### Cloud SQL Database

**Instance:** `fl511-metadata-db`
- **Engine:** PostgreSQL 14
- **Tier:** db-f1-micro (upgradeable)
- **Storage:** 10GB SSD (auto-resize enabled)

**Databases:**
- `fl511_incidents` - Incident tracking and correlation
- `fl511_cameras` - Camera metadata
- `fl511_video_segments` - Video segment tracking

### Cloud Run Service

**Service:** `fl511-video-capture`
- **Memory:** 2GB
- **CPU:** 2 vCPU
- **Concurrency:** 10 requests per instance
- **Auto-scaling:** 0-100 instances

### Cloud Scheduler

**Job:** `fl511-video-capture-cron`
- **Schedule:** Every 5 minutes
- **Action:** Triggers video capture for active incidents
- **Timeout:** 5 minutes

## 🔧 Configuration

### Environment Variables

Set these in Cloud Run:

```bash
PROJECT_ID=avocado-fl511-video
REGION=us-central1
DATABASE_NAME=fl511_incidents
DATABASE_USER=fl511_user
DATABASE_PASSWORD=fl511_secure_password_123
```

### Local Development

```bash
# Set up environment
cp .env.example .env
# Edit .env with your project details

# Run locally with Docker Compose
docker-compose up -d

# Or run directly
python video_capture_service.py
```

## 📊 Monitoring and Operations

### Health Checks

```bash
# Check service health
curl https://fl511-video-capture-[HASH]-uc.a.run.app/health

# Get service status
curl https://fl511-video-capture-[HASH]-uc.a.run.app/status

# Manual capture trigger
curl -X POST https://fl511-video-capture-[HASH]-uc.a.run.app/capture \
  -H "Content-Type: application/json" \
  -d '{"max_cameras": 5, "segments_per_camera": 3}'
```

### Database Queries

```sql
-- Check recent captures
SELECT * FROM recent_video_segments LIMIT 10;

-- Active incidents with cameras
SELECT * FROM active_incidents_with_cameras;

-- Storage usage
SELECT 
  COUNT(*) as total_segments,
  SUM(segment_size_bytes) as total_bytes,
  AVG(segment_duration) as avg_duration
FROM video_segments 
WHERE capture_timestamp >= NOW() - INTERVAL '24 hours';
```

### Storage Management

```bash
# Check bucket usage
gsutil du -sh gs://avocado-fl511-video-fl511-video-segments

# List recent files
gsutil ls -l gs://avocado-fl511-video-fl511-video-segments/** | head -20

# Download specific video segment
gsutil cp gs://avocado-fl511-video-fl511-video-segments/camera_1234/20250828/segment_001.ts ./
```

## 💰 Cost Optimization

### Expected Monthly Costs (Rough Estimates)

- **Cloud Storage:** $5-15/month (depending on video retention)
- **Cloud SQL:** $7/month (db-f1-micro)
- **Cloud Run:** $5-20/month (depending on usage)
- **Cloud Scheduler:** $0.10/month
- **Data Transfer:** $1-5/month

**Total: ~$20-50/month**

### Cost Optimization Tips

1. **Tune capture frequency** - Reduce from 5min to 10min intervals
2. **Limit cameras** - Focus on high-priority incident areas
3. **Optimize storage lifecycle** - Shorter retention for video segments
4. **Use preemptible instances** for batch processing

## 🔒 Security Considerations

### Current Setup (Development)
- Public Cloud Run endpoints
- Open database access (0.0.0.0/0)
- No authentication on API endpoints

### Production Hardening
1. **Restrict Cloud Run to authenticated requests**
2. **Use Cloud SQL Private IP**
3. **Implement API authentication**
4. **Set up VPC firewall rules**
5. **Enable audit logging**

## 🚨 Troubleshooting

### Common Issues

1. **"Permission denied" errors**
   ```bash
   gcloud auth application-default login
   gcloud config set project avocado-fl511-video
   ```

2. **Cloud SQL connection failures**
   - Check authorized networks
   - Verify user credentials
   - Ensure database exists

3. **Video capture failures**
   - Check FL 511 API availability
   - Verify camera authentication
   - Review Cloud Run logs

4. **Storage upload errors**
   - Check bucket permissions
   - Verify service account access
   - Monitor quota limits

### Logs and Debugging

```bash
# View Cloud Run logs
gcloud logs read "resource.type=cloud_run_revision" --limit=50

# View specific service logs
gcloud logs read "resource.type=cloud_run_revision AND resource.labels.service_name=fl511-video-capture" --limit=20

# View scheduler logs
gcloud logs read "resource.type=cloud_scheduler_job" --limit=10
```

## ⚡ Ready for Tomorrow

**This infrastructure can be deployed in under 30 minutes and start capturing video data immediately.**

**Key benefits:**
- ✅ **Scalable:** Handles multiple cameras simultaneously
- ✅ **Cost-effective:** Pay only for what you use
- ✅ **Reliable:** Auto-scaling and managed services
- ✅ **Integrated:** Incident correlation built-in
- ✅ **Storage-optimized:** Automated lifecycle management

**Next steps after deployment:**
1. Monitor first few capture cycles
2. Tune capture parameters based on needs
3. Set up alerting for failures
4. Implement data analysis pipeline
5. Scale to more cameras as needed

The system is designed to capture video evidence during traffic incidents automatically, providing valuable data for analysis and correlation with incident reports.