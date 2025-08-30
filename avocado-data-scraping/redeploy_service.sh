#!/bin/bash
# Quick redeploy with single camera testing to avoid overwhelming FL511 servers

set -e

PROJECT_ID="${PROJECT_ID:-avocado-fl511-video}"
REGION="${REGION:-us-central1}"
SERVICE_NAME="fl511-video-capture"

echo "🔄 Redeploying FL511 service with quota-friendly settings..."

# Build and deploy with reduced specs
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
  --set-env-vars PROJECT_ID=$PROJECT_ID,REGION=$REGION,CAMERA_DATABASE=fl511_i4_i95_cameras.json,MAX_CAMERAS=10 \
  --allow-unauthenticated

# Get service URL
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region=$REGION --format="value(status.url)")
echo "✅ Service redeployed at: $SERVICE_URL"

# Test health
echo "🩺 Testing service health..."
curl -f "$SERVICE_URL/health"
echo ""

echo "✅ Ready to test 10-camera capture with incident correlation!"
echo "Run this to test 10-camera capture:"
echo "curl -X POST \"$SERVICE_URL/start_continuous_capture\" -H \"Content-Type: application/json\" -d '{\"duration_hours\": 1, \"capture_interval_minutes\": 5, \"max_cameras_per_batch\": 10, \"segments_per_camera\": 3}'"