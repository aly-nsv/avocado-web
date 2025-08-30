# FL511 I4-I95 Video Capture Service - Enhanced for 700+ cameras
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY fl511_video_auth_cached.py .
COPY fl511_scraper.py .
COPY video_capture_service.py .
COPY fl511_i4_i95_cameras.json .
COPY fl511_video_auth_cache.json .
COPY database_schema.sql .

# Create necessary directories
RUN mkdir -p /app/logs /app/data

# Set environment variables
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1
ENV PORT=8080
ENV CAMERA_DATABASE=fl511_i4_i95_cameras.json

# Expose port
EXPOSE 8080

# Enhanced health check for I4-I95 service
HEALTHCHECK --interval=30s --timeout=30s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Run the application
CMD ["python", "video_capture_service.py"]