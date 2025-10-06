#!/bin/bash

# FL-511 Incident Monitor Cloud Run Deployment Script
# This script deploys the incident monitor to Google Cloud Run

set -e

# Configuration
PROJECT_ID="avocado-fl511-video"
SERVICE_NAME="fl511-incident-monitor"
REGION="us-central1"
IMAGE_NAME="gcr.io/${PROJECT_ID}/${SERVICE_NAME}"

echo "🚀 Deploying FL-511 Incident Monitor to Cloud Run"
echo "Project: ${PROJECT_ID}"
echo "Service: ${SERVICE_NAME}"
echo "Region: ${REGION}"

# Check if gcloud is authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo "❌ Not authenticated with gcloud. Please run: gcloud auth login"
    exit 1
fi

# Set the project
echo "📋 Setting project to ${PROJECT_ID}"
gcloud config set project ${PROJECT_ID}

# Enable required APIs
echo "🔧 Enabling required APIs..."
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable storage.googleapis.com

# Build the container
echo "🏗️  Building container image..."
gcloud builds submit --tag ${IMAGE_NAME} .

# Deploy to Cloud Run
echo "🚀 Deploying to Cloud Run..."
gcloud run deploy ${SERVICE_NAME} \
    --image ${IMAGE_NAME} \
    --platform managed \
    --region ${REGION} \
    --memory 2Gi \
    --cpu 2 \
    --timeout 3600 \
    --max-instances 1 \
    --min-instances 1 \
    --no-allow-unauthenticated \
    --set-env-vars="GOOGLE_CLOUD_PROJECT=${PROJECT_ID}" \
    --set-env-vars="GCS_BUCKET=avocado-fl511-video-fl511-video-segments" \
    --set-env-vars="POLL_INTERVAL=5" \
    --set-env-vars="CAPTURE_DURATION=300" \
    --set-env-vars="MAX_CAMERAS=5"

# Get the service URL
SERVICE_URL=$(gcloud run services describe ${SERVICE_NAME} --region=${REGION} --format="value(status.url)")

echo "✅ Deployment complete!"
echo "🌐 Service URL: ${SERVICE_URL}"
echo "📊 View logs: gcloud logs tail --service=${SERVICE_NAME} --region=${REGION}"
echo "🛑 Stop service: gcloud run services delete ${SERVICE_NAME} --region=${REGION}"

# Show service status
echo ""
echo "📋 Service Status:"
gcloud run services describe ${SERVICE_NAME} --region=${REGION} --format="table(status.conditions[0].type,status.conditions[0].status,status.conditions[0].message)"