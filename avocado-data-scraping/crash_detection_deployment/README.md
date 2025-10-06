# FL-511 Crash Detection Deployment

This folder contains the deployment configuration for the FL-511 incident monitor service.

## 🚀 Quick Deploy

```bash
cd crash_detection_deployment
./deploy.sh
```

## 📁 Files

- `crash_alert_monitor.py` - Main incident monitoring script
- `fl511_scraper.py` - FL-511 API scraper dependency
- `fl511_video_auth_production.py` - Video authentication dependency
- `requirements.txt` - Python dependencies
- `Dockerfile` - Container configuration
- `deploy.sh` - Deployment script
- `.dockerignore` - Files to exclude from container

## 🔧 Configuration

The service is configured with:
- **Poll interval**: 5 seconds
- **Video capture duration**: 5 minutes (300 seconds)
- **Max cameras per incident**: 5
- **GCS bucket**: `avocado-fl511-video-fl511-video-segments`
- **Memory**: 2GB
- **CPU**: 2 cores
- **Timeout**: 1 hour

## 🔐 Authentication

The container uses Google Cloud's Application Default Credentials (ADC) which are automatically provided by Cloud Run. No manual credential setup is needed.

## 📊 Monitoring

View logs:
```bash
gcloud logs tail --service=fl511-incident-monitor --region=us-central1
```

Stop the service:
```bash
gcloud run services delete fl511-incident-monitor --region=us-central1
```