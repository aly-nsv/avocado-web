#!/usr/bin/env python3
"""
Camera Quality Reviewer - Web Interface

This application allows you to review video segments for each camera and label their quality.
- Navigate through cameras in numeric order
- View all video segments for a camera
- Convert .ts files to .mp4 for playback
- Label camera quality as high/low with keyboard shortcuts
- Persist quality labels to the JSON file

Uses a simple web interface accessible via browser.
"""

import json
import csv
import os
import subprocess
import tempfile
import threading
import webbrowser
import concurrent.futures
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import parse_qs, urlparse
import socketserver
import time
import shutil


class CameraQualityReviewer:
    def __init__(self, camera_json_path: str, video_csv_path: str, port: int = 8080):
        self.camera_json_path = camera_json_path
        self.video_csv_path = video_csv_path
        self.port = port
        
        # Load data
        self.cameras = self.load_cameras()
        self.video_segments = self.load_video_segments()
        
        # Current state
        self.current_camera_index = 0
        self.current_segment_index = 0
        self.status_message = "Ready"
        
        # Video serving
        self.videos_dir = os.path.join(tempfile.gettempdir(), 'camera_quality_videos')
        os.makedirs(self.videos_dir, exist_ok=True)
        self.downloaded_videos = {}  # {camera_id: {segment_index: local_path}}
        self.download_status = {}  # {camera_id: {segment_index: status}}
        
        print(f"Loaded {len(self.cameras)} cameras")
        print(f"Loaded video segments for {len(self.video_segments)} cameras")
        
        # Start loading first camera
        if self.cameras:
            first_camera_id = self.cameras[0]['camera_id']
            segments_count = len(self.get_current_segments())
            self.status_message = f"Loading first camera {first_camera_id} with {segments_count} segments..."
            threading.Thread(target=self._load_first_camera, daemon=True).start()
    
    def _load_first_camera(self):
        """Load videos for the first camera."""
        if not self.cameras:
            return
        
        camera_id = self.cameras[0]['camera_id']
        self.download_all_segments_for_camera(camera_id)
        
        completed = sum(1 for status in self.download_status.get(camera_id, {}).values() 
                       if status == 'ready')
        segments_count = len(self.get_current_segments())
        self.status_message = f"First camera loaded! {completed}/{segments_count} videos ready."
    
    def load_cameras(self) -> List[Dict]:
        """Load cameras from JSON file, sorted by camera_id numerically."""
        with open(self.camera_json_path, 'r') as f:
            cameras = json.load(f)
        
        # Sort by camera_id numerically
        cameras.sort(key=lambda x: int(x['camera_id']))
        
        # Add quality field if not present
        for camera in cameras:
            if 'quality' not in camera:
                camera['quality'] = None
        
        return cameras
    
    def load_video_segments(self) -> Dict[str, List[Dict]]:
        """Load video segments from CSV, grouped by camera_id."""
        segments_by_camera = {}
        
        with open(self.video_csv_path, 'r') as f:
            reader = csv.DictReader(f)
            for row in reader:
                camera_id = row['camera_id']
                if camera_id not in segments_by_camera:
                    segments_by_camera[camera_id] = []
                segments_by_camera[camera_id].append(row)
        
        # Sort segments within each camera by segment filename
        for camera_id in segments_by_camera:
            segments_by_camera[camera_id].sort(key=lambda x: x['segment_filename'])
        
        return segments_by_camera
    
    def get_current_camera(self) -> Dict:
        """Get current camera data."""
        if 0 <= self.current_camera_index < len(self.cameras):
            return self.cameras[self.current_camera_index]
        return {}
    
    def get_current_segments(self) -> List[Dict]:
        """Get segments for current camera."""
        camera = self.get_current_camera()
        if not camera:
            return []
        return self.video_segments.get(camera['camera_id'], [])
    
    def download_and_convert_segment(self, ts_url: str, segment_filename: str, output_path: str) -> bool:
        """Download .ts file and convert to .mp4 for web serving."""
        try:
            print(f"[DEBUG] Starting download for {segment_filename}")
            
            # Download the .ts file using gsutil for GCS URLs
            ts_path = output_path.replace('.mp4', '.ts')
            
            if ts_url.startswith('gs://'):
                # Use gsutil for Google Cloud Storage URLs
                download_cmd = ['gsutil', 'cp', ts_url, ts_path]
                print(f"[DEBUG] Using gsutil to download from: {ts_url}")
            else:
                # Use curl for HTTP URLs
                download_cmd = ['curl', '-s', '-f', '-o', ts_path, ts_url]
                print(f"[DEBUG] Using curl to download from: {ts_url}")
            
            download_result = subprocess.run(download_cmd, capture_output=True, text=True, timeout=60)
            
            if download_result.returncode != 0:
                print(f"[DEBUG] Download failed for {segment_filename}: {download_result.stderr}")
                print(f"[DEBUG] Command used: {' '.join(download_cmd)}")
                
                # Check for authentication issues
                if 'Reauthentication' in download_result.stderr or 'authentication' in download_result.stderr.lower():
                    print(f"[DEBUG] Authentication issue detected. You may need to run: gcloud auth login")
                
                return False
                
            if not os.path.exists(ts_path):
                print(f"[DEBUG] Downloaded file doesn't exist: {ts_path}")
                return False
                
            file_size = os.path.getsize(ts_path)
            if file_size == 0:
                print(f"[DEBUG] Downloaded file is empty: {ts_path}")
                return False
            
            print(f"[DEBUG] Downloaded {segment_filename}: {file_size} bytes")
            
            # Convert to mp4
            convert_cmd = [
                'ffmpeg', '-y', '-i', ts_path,
                '-c:v', 'libx264', '-preset', 'fast', '-crf', '28',
                '-c:a', 'aac', '-b:a', '64k',
                '-movflags', 'faststart',
                '-t', '15',  # Limit to 15 seconds for faster loading
                output_path
            ]
            
            convert_result = subprocess.run(convert_cmd, capture_output=True, text=True, timeout=45)
            
            if convert_result.returncode != 0:
                print(f"[DEBUG] FFmpeg conversion failed for {segment_filename}: {convert_result.stderr}")
            
            # Clean up ts file
            if os.path.exists(ts_path):
                os.unlink(ts_path)
            
            success = convert_result.returncode == 0 and os.path.exists(output_path)
            if success:
                print(f"[DEBUG] Conversion successful for {segment_filename}: {os.path.getsize(output_path)} bytes")
            else:
                print(f"[DEBUG] Conversion failed for {segment_filename}")
            
            return success
            
        except subprocess.TimeoutExpired:
            print(f"[DEBUG] Timeout during processing of {segment_filename}")
            return False
        except Exception as e:
            print(f"[DEBUG] Exception during processing of {segment_filename}: {str(e)}")
            return False
    
    def set_quality(self, quality: Optional[str]) -> str:
        """Set quality for current camera."""
        if not self.cameras or self.current_camera_index >= len(self.cameras):
            return "No camera selected"
        
        self.cameras[self.current_camera_index]['quality'] = quality
        
        camera_id = self.cameras[self.current_camera_index]['camera_id']
        quality_text = quality.upper() if quality else "CLEARED"
        
        return f"Set camera {camera_id} quality to {quality_text}"
    
    def download_all_segments_for_camera(self, camera_id: str) -> None:
        """Download and convert all segments for a camera."""
        segments = self.video_segments.get(camera_id, [])
        if not segments:
            return
        
        # Initialize status tracking
        self.download_status[camera_id] = {}
        self.downloaded_videos[camera_id] = {}
        
        def download_segment(segment_index, segment):
            filename = segment['segment_filename']
            video_url = segment.get('storage_url')
            
            if not video_url:
                self.download_status[camera_id][segment_index] = 'no_url'
                return
            
            # Create output path
            safe_filename = filename.replace('.ts', f'_{segment_index}.mp4')
            output_path = os.path.join(self.videos_dir, f"camera_{camera_id}_{safe_filename}")
            
            self.download_status[camera_id][segment_index] = 'downloading'
            
            print(f"[DEBUG] Downloading segment {segment_index} from {video_url}")
            
            if self.download_and_convert_segment(video_url, filename, output_path):
                self.downloaded_videos[camera_id][segment_index] = output_path
                self.download_status[camera_id][segment_index] = 'ready'
                print(f"[DEBUG] ✓ Successfully converted segment {segment_index}")
            else:
                self.download_status[camera_id][segment_index] = 'failed'
                print(f"[DEBUG] ✗ Failed to convert segment {segment_index}")
        
        # Download segments in parallel (limit to 3 concurrent)
        with concurrent.futures.ThreadPoolExecutor(max_workers=3) as executor:
            futures = []
            for i, segment in enumerate(segments):
                future = executor.submit(download_segment, i, segment)
                futures.append(future)
            
            # Wait for all downloads
            concurrent.futures.wait(futures)
    
    def navigate_camera(self, direction: int) -> str:
        """Navigate to next/previous camera. direction: 1 for next, -1 for prev."""
        new_index = self.current_camera_index + direction
        
        if 0 <= new_index < len(self.cameras):
            self.current_camera_index = new_index
            self.current_segment_index = 0  # Reset segment selection
            
            camera_id = self.cameras[self.current_camera_index]['camera_id']
            segments_count = len(self.get_current_segments())
            
            # Start downloading videos for this camera
            self.status_message = f"Loading camera {camera_id} and downloading {segments_count} video segments..."
            
            def download_in_background():
                self.download_all_segments_for_camera(camera_id)
                completed = sum(1 for status in self.download_status.get(camera_id, {}).values() 
                              if status == 'ready')
                self.status_message = f"Camera {camera_id} loaded. {completed}/{segments_count} videos ready."
            
            threading.Thread(target=download_in_background, daemon=True).start()
            
            return f"Loading camera {camera_id} with {segments_count} video segments..."
        else:
            return "Cannot navigate further in that direction"
    
    def navigate_segment(self, direction: int) -> str:
        """Navigate to next/previous segment. direction: 1 for next, -1 for prev."""
        segments = self.get_current_segments()
        new_index = self.current_segment_index + direction
        
        if 0 <= new_index < len(segments):
            self.current_segment_index = new_index
            return f"Selected segment {new_index + 1}/{len(segments)}"
        else:
            return "Cannot navigate further in that direction"
    
    def play_current_segment(self) -> str:
        """Note about current segment video - videos are embedded in page."""
        segments = self.get_current_segments()
        
        if not segments or self.current_segment_index >= len(segments):
            return "No video segment selected"
        
        return f"Current segment {self.current_segment_index + 1} video is embedded in the page below"
    
    def play_segment_by_index(self, segment_index: int) -> str:
        """Note about segment video - videos are embedded in page."""
        segments = self.get_current_segments()
        
        if not segments or segment_index >= len(segments):
            return "Invalid segment index"
        
        return f"Segment {segment_index + 1} video is embedded in the page below"
    
    def save_progress(self) -> str:
        """Save current progress to JSON file."""
        try:
            with open(self.camera_json_path, 'w') as f:
                json.dump(self.cameras, f, indent=2)
            
            reviewed_count = sum(1 for c in self.cameras if c.get('quality') is not None)
            return f"Progress saved! {reviewed_count} cameras reviewed."
        except Exception as e:
            return f"Failed to save progress: {str(e)}"
    
    def get_stats(self) -> Dict:
        """Get current statistics."""
        total_cameras = len(self.cameras)
        reviewed_count = sum(1 for c in self.cameras if c.get('quality') is not None)
        high_quality = sum(1 for c in self.cameras if c.get('quality') == 'high')
        low_quality = sum(1 for c in self.cameras if c.get('quality') == 'low')
        
        return {
            'total_cameras': total_cameras,
            'reviewed_count': reviewed_count,
            'high_quality': high_quality,
            'low_quality': low_quality,
            'current_index': self.current_camera_index + 1,
            'completion_percent': round((reviewed_count / total_cameras) * 100, 1) if total_cameras > 0 else 0
        }
    
    def generate_html(self) -> str:
        """Generate HTML interface."""
        camera = self.get_current_camera()
        segments = self.get_current_segments()
        stats = self.get_stats()
        
        # Get camera metadata from segments if available
        camera_info = {}
        if segments:
            sample = segments[0]
            camera_info = {
                'roadway': sample.get('camera_roadway', 'N/A'),
                'region': sample.get('camera_region', 'N/A'),
                'county': sample.get('camera_county', 'N/A')
            }
        
        # Build segments grid
        segments_html = ""
        camera_id = camera.get('camera_id', '')
        
        for i, segment in enumerate(segments):
            filename = segment['segment_filename']
            date = segment.get('capture_timestamp', '')[:10] if segment.get('capture_timestamp') else 'Unknown'
            size_mb = round(int(segment.get('segment_size_bytes', 0)) / 1024 / 1024, 1)
            duration = float(segment.get('segment_duration', 0))
            
            # Get download status
            status = self.download_status.get(camera_id, {}).get(i, 'pending')
            has_video = camera_id in self.downloaded_videos and i in self.downloaded_videos[camera_id]
            
            status_colors = {
                'ready': '#28a745',
                'failed': '#dc3545',
                'downloading': '#ffc107',
                'no_url': '#6c757d',
                'pending': '#e9ecef'
            }
            
            status_texts = {
                'ready': '✓ Ready',
                'failed': '✗ Failed',
                'downloading': '⬇ Downloading...',
                'no_url': '❌ No URL',
                'pending': '⏳ Pending'
            }
            
            selected_class = "selected" if i == self.current_segment_index else ""
            
            # Video player or placeholder
            video_html = ""
            if has_video:
                video_path = f"/video/{camera_id}/{i}"
                video_html = f"""
                <div class="video-container">
                    <video controls muted preload="metadata" width="100%">
                        <source src="{video_path}" type="video/mp4">
                        Your browser doesn't support video playback.
                    </video>
                </div>
                """
            elif status == 'downloading':
                video_html = '<div class="video-placeholder downloading">⏳ Converting video...</div>'
            elif status == 'failed':
                video_html = '<div class="video-placeholder failed">❌ Failed to load</div>'
            else:
                video_html = '<div class="video-placeholder pending">⏸ Video pending...</div>'
            
            segments_html += f"""
            <div class="segment-card {selected_class}" onclick="selectSegment({i})">
                <div class="segment-header">
                    <div class="segment-number">#{i+1}</div>
                    <div class="segment-status" style="background: {status_colors.get(status, '#e9ecef')};">
                        {status_texts.get(status, 'Pending')}
                    </div>
                </div>
                {video_html}
                <div class="segment-filename">{filename}</div>
                <div class="segment-details">
                    <div>{date}</div>
                    <div>{size_mb} MB • {duration:.1f}s</div>
                </div>
            </div>
            """
        
        quality_color = {
            'high': '#28a745',
            'low': '#dc3545',
            None: '#6c757d'
        }.get(camera.get('quality'), '#6c757d')
        
        quality_text = {
            'high': 'HIGH QUALITY',
            'low': 'LOW QUALITY',
            None: 'NOT REVIEWED'
        }.get(camera.get('quality'), 'NOT REVIEWED')
        
        html = f"""
<!DOCTYPE html>
<html>
<head>
    <title>Camera Quality Reviewer</title>
    <meta charset="utf-8">
    <style>
        body {{ font-family: Arial, sans-serif; margin: 20px; background: #f8f9fa; }}
        .container {{ max-width: 1400px; margin: 0 auto; }}
        .card {{ background: white; border-radius: 8px; padding: 20px; margin: 15px 0; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }}
        .header {{ display: flex; justify-content: space-between; align-items: center; }}
        .camera-id {{ font-size: 24px; font-weight: bold; color: #007bff; }}
        .quality {{ font-weight: bold; color: {quality_color}; }}
        .controls {{ display: flex; gap: 10px; flex-wrap: wrap; }}
        .btn {{ padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; }}
        .btn-high {{ background: #28a745; color: white; }}
        .btn-low {{ background: #dc3545; color: white; }}
        .btn-clear {{ background: #6c757d; color: white; }}
        .btn-nav {{ background: #007bff; color: white; }}
        .btn-action {{ background: #17a2b8; color: white; }}
        .btn-save {{ background: #ffc107; color: black; }}
        .stats {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 15px; }}
        .stat {{ text-align: center; }}
        .stat-value {{ font-size: 24px; font-weight: bold; color: #007bff; }}
        .stat-label {{ color: #6c757d; margin-top: 5px; }}
        .status {{ background: #e9ecef; padding: 10px; border-radius: 5px; margin: 10px 0; }}
        .keyboard-help {{ background: #fff3cd; padding: 10px; border-radius: 5px; margin: 10px 0; }}
        .current-segment {{ font-weight: bold; color: #007bff; }}
        code {{ background: #f8f9fa; padding: 2px 4px; border-radius: 3px; }}
        
        /* Video segments grid */
        .segments-grid {{ 
            display: grid; 
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); 
            gap: 20px; 
            max-height: 80vh; 
            overflow-y: auto; 
            padding: 20px; 
            border: 1px solid #dee2e6; 
            border-radius: 5px;
            background: #f8f9fa;
        }}
        
        .segment-card {{
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: all 0.2s ease;
            border: 2px solid transparent;
        }}
        
        .segment-card:hover {{
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            transform: translateY(-1px);
        }}
        
        .segment-card.selected {{
            border-color: #007bff;
            background: #e6f3ff;
        }}
        
        .segment-header {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }}
        
        .segment-number {{
            font-weight: bold;
            color: #007bff;
            font-size: 14px;
        }}
        
        .segment-status {{
            font-size: 11px;
            color: white;
            padding: 2px 6px;
            border-radius: 10px;
            font-weight: bold;
        }}
        
        .segment-status.available {{
            background: #28a745;
        }}
        
        .segment-status.unavailable {{
            background: #dc3545;
        }}
        
        .segment-filename {{
            font-family: monospace;
            font-size: 12px;
            color: #495057;
            margin-bottom: 8px;
            word-break: break-all;
        }}
        
        .segment-details {{
            font-size: 11px;
            color: #6c757d;
            margin-bottom: 10px;
        }}
        
        .segment-actions {{
            display: flex;
            justify-content: center;
        }}
        
        .segment-actions button {{
            background: #007bff;
            color: white;
            border: none;
            padding: 5px 15px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }}
        
        .segment-actions button:hover:not(:disabled) {{
            background: #0056b3;
        }}
        
        .segment-actions button:disabled {{
            background: #6c757d;
            cursor: not-allowed;
        }}
        
        /* Video elements */
        .video-container {{
            margin: 8px 0;
            border-radius: 4px;
            overflow: hidden;
        }}
        
        .video-container video {{
            width: 100%;
            height: 200px;
            background: #000;
        }}
        
        .video-placeholder {{
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 8px 0;
            border-radius: 4px;
            font-size: 14px;
            font-weight: bold;
        }}
        
        .video-placeholder.pending {{
            background: #e9ecef;
            color: #6c757d;
        }}
        
        .video-placeholder.downloading {{
            background: #fff3cd;
            color: #856404;
        }}
        
        .video-placeholder.failed {{
            background: #f8d7da;
            color: #721c24;
        }}
    </style>
</head>
<body>
    <div class="container">
        <h1>Camera Quality Reviewer</h1>
        
        <div class="card">
            <div class="header">
                <div>
                    <div class="camera-id">Camera #{camera.get('camera_id', 'N/A')}</div>
                    <div>{camera_info.get('roadway', 'N/A')} - {camera_info.get('county', 'N/A')} ({camera_info.get('region', 'N/A')})</div>
                </div>
                <div class="quality">{quality_text}</div>
            </div>
        </div>
        
        <div class="card">
            <h3>Statistics</h3>
            <div class="stats">
                <div class="stat">
                    <div class="stat-value">{stats['current_index']}/{stats['total_cameras']}</div>
                    <div class="stat-label">Current Position</div>
                </div>
                <div class="stat">
                    <div class="stat-value">{stats['reviewed_count']}</div>
                    <div class="stat-label">Reviewed</div>
                </div>
                <div class="stat">
                    <div class="stat-value">{stats['high_quality']}</div>
                    <div class="stat-label">High Quality</div>
                </div>
                <div class="stat">
                    <div class="stat-value">{stats['low_quality']}</div>
                    <div class="stat-label">Low Quality</div>
                </div>
                <div class="stat">
                    <div class="stat-value">{stats['completion_percent']}%</div>
                    <div class="stat-label">Complete</div>
                </div>
            </div>
        </div>
        
        <div class="card">
            <h3>Camera Navigation</h3>
            <div class="controls">
                <button class="btn btn-nav" onclick="navigate('prev_camera')">← Previous Camera (P)</button>
                <button class="btn btn-nav" onclick="navigate('next_camera')">Next Camera (N) →</button>
            </div>
        </div>
        
        <div class="card">
            <h3>Quality Controls</h3>
            <div class="controls">
                <button class="btn btn-high" onclick="setQuality('high')">High Quality (H)</button>
                <button class="btn btn-low" onclick="setQuality('low')">Low Quality (L)</button>
                <button class="btn btn-clear" onclick="setQuality('clear')">Clear Quality</button>
                <button class="btn btn-save" onclick="saveProgress()">Save Progress</button>
            </div>
        </div>
        
        <div class="card">
            <div class="header">
                <h3>Video Segments ({len(segments)} total)</h3>
                <div class="current-segment">
                    Current: Segment {self.current_segment_index + 1}/{len(segments)} - 
                    {segments[self.current_segment_index]['segment_filename'] if segments and self.current_segment_index < len(segments) else 'None'}
                </div>
            </div>
            
            <div class="controls" style="margin: 15px 0;">
                <button class="btn btn-nav" onclick="navigate('prev_segment')">← Previous Segment</button>
                <button class="btn btn-nav" onclick="navigate('next_segment')">Next Segment →</button>
            </div>
            
            <div class="segments-grid">
                {segments_html}
            </div>
        </div>
        
        <div class="status">
            <strong>Status:</strong> <span id="status">{self.status_message}</span>
        </div>
        
        <div class="keyboard-help">
            <strong>Keyboard Shortcuts:</strong> H=High Quality, L=Low Quality, N=Next Camera, P=Previous Camera, 
            Arrow Keys=Navigate Segments, S=Save Progress. Videos load automatically in grid below.
        </div>
    </div>

    <script>
        // Auto-refresh every 2 seconds
        setInterval(() => {{
            fetch('/status').then(r => r.text()).then(status => {{
                document.getElementById('status').textContent = status;
            }});
        }}, 2000);
        
        // Keyboard shortcuts
        document.addEventListener('keydown', (e) => {{
            if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;
            
            switch(e.key.toLowerCase()) {{
                case 'h': setQuality('high'); break;
                case 'l': setQuality('low'); break;
                case 'n': navigate('next_camera'); break;
                case 'p': navigate('prev_camera'); break;
                case 'arrowleft': navigate('prev_segment'); break;
                case 'arrowright': navigate('next_segment'); break;
                case 's': saveProgress(); break;
            }}
        }});
        
        function navigate(action) {{
            fetch('/' + action, {{method: 'POST'}})
                .then(r => r.text())
                .then(msg => {{
                    document.getElementById('status').textContent = msg;
                    setTimeout(() => location.reload(), 500);
                }});
        }}
        
        function setQuality(quality) {{
            fetch('/set_quality?quality=' + quality, {{method: 'POST'}})
                .then(r => r.text())
                .then(msg => {{
                    document.getElementById('status').textContent = msg;
                    setTimeout(() => location.reload(), 500);
                }});
        }}
        
        function selectSegment(index) {{
            fetch('/select_segment?index=' + index, {{method: 'POST'}})
                .then(r => r.text())
                .then(msg => {{
                    document.getElementById('status').textContent = msg;
                    setTimeout(() => location.reload(), 500);
                }});
        }}
        
        function saveProgress() {{
            fetch('/save_progress', {{method: 'POST'}})
                .then(r => r.text())
                .then(msg => {{
                    document.getElementById('status').textContent = msg;
                }});
        }}
    </script>
</body>
</html>
        """
        return html
    


class RequestHandler(BaseHTTPRequestHandler):
    def __init__(self, reviewer, *args, **kwargs):
        self.reviewer = reviewer
        super().__init__(*args, **kwargs)
    
    def do_GET(self):
        """Handle GET requests."""
        path = urlparse(self.path).path
        
        if path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(self.reviewer.generate_html().encode('utf-8'))
        elif path == '/status':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(self.reviewer.status_message.encode('utf-8'))
        elif path.startswith('/video/'):
            # Serve video files: /video/{camera_id}/{segment_index}
            try:
                parts = path.split('/')
                camera_id = parts[2]
                segment_index = int(parts[3])
                
                if (camera_id in self.reviewer.downloaded_videos and 
                    segment_index in self.reviewer.downloaded_videos[camera_id]):
                    
                    video_path = self.reviewer.downloaded_videos[camera_id][segment_index]
                    
                    if os.path.exists(video_path):
                        self.send_response(200)
                        self.send_header('Content-type', 'video/mp4')
                        self.send_header('Content-Length', str(os.path.getsize(video_path)))
                        self.send_header('Accept-Ranges', 'bytes')
                        self.end_headers()
                        
                        with open(video_path, 'rb') as f:
                            shutil.copyfileobj(f, self.wfile)
                    else:
                        self.send_error(404, "Video file not found")
                else:
                    self.send_error(404, "Video not available")
            except (IndexError, ValueError):
                self.send_error(400, "Invalid video path")
        else:
            self.send_error(404)
    
    def do_POST(self):
        """Handle POST requests."""
        path = urlparse(self.path).path
        query = parse_qs(urlparse(self.path).query)
        
        message = "Unknown action"
        
        if path == '/next_camera':
            message = self.reviewer.navigate_camera(1)
        elif path == '/prev_camera':
            message = self.reviewer.navigate_camera(-1)
        elif path == '/next_segment':
            message = self.reviewer.navigate_segment(1)
        elif path == '/prev_segment':
            message = self.reviewer.navigate_segment(-1)
        elif path == '/set_quality':
            quality = query.get('quality', [''])[0]
            if quality == 'clear':
                quality = None
            message = self.reviewer.set_quality(quality)
        elif path == '/play_segment':
            message = self.reviewer.play_current_segment()
        elif path == '/play_segment_by_index':
            try:
                index = int(query.get('index', ['0'])[0])
                message = self.reviewer.play_segment_by_index(index)
            except ValueError:
                message = "Invalid segment index"
        elif path == '/select_segment':
            try:
                index = int(query.get('index', ['0'])[0])
                segments = self.reviewer.get_current_segments()
                if 0 <= index < len(segments):
                    self.reviewer.current_segment_index = index
                    message = f"Selected segment {index + 1}/{len(segments)}"
                else:
                    message = "Invalid segment index"
            except ValueError:
                message = "Invalid segment index"
        elif path == '/save_progress':
            message = self.reviewer.save_progress()
        
        self.reviewer.status_message = message
        
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(message.encode('utf-8'))
    
    def log_message(self, format, *args):
        # Suppress request logging
        pass


def main():
    """Main entry point."""
    import sys
    
    # Default file paths
    camera_json = "camera_results_20251004.json"
    video_csv = "camera_video_segment_samples_20251004_1755.csv"
    
    # Check if files exist
    if not os.path.exists(camera_json):
        print(f"Error: Camera JSON file not found: {camera_json}")
        print("Please ensure the file exists in the current directory.")
        return 1
    
    if not os.path.exists(video_csv):
        print(f"Error: Video CSV file not found: {video_csv}")
        print("Please ensure the file exists in the current directory.")
        return 1
    
    # Check for ffplay
    try:
        subprocess.run(['ffplay', '-version'], capture_output=True, check=True)
    except (FileNotFoundError, subprocess.CalledProcessError):
        print("Error: ffplay is required but not found in PATH or not working.")
        print("Please install ffmpeg (which includes ffplay) for video playback.")
        print("On macOS: brew install ffmpeg")
        print("On Ubuntu: sudo apt install ffmpeg")
        return 1
    
    print(f"Loading cameras from: {camera_json}")
    print(f"Loading video segments from: {video_csv}")
    
    reviewer = CameraQualityReviewer(camera_json, video_csv)
    
    # Create HTTP server
    port = 8081
    
    def handler(*args, **kwargs):
        RequestHandler(reviewer, *args, **kwargs)
    
    try:
        with HTTPServer(('localhost', port), handler) as httpd:
            print(f"\\nServer started at http://localhost:{port}")
            print("\\nKeyboard shortcuts in browser:")
            print("  H - Mark camera as High Quality")
            print("  L - Mark camera as Low Quality") 
            print("  N - Next Camera")
            print("  P - Previous Camera")
            print("  ← → - Navigate Segments")
            print("  Space - Play Current Segment")
            print("  S - Save Progress")
            print("\\nPress Ctrl+C to stop the server")
            
            # Open browser automatically
            webbrowser.open(f'http://localhost:{port}')
            
            try:
                httpd.serve_forever()
            except KeyboardInterrupt:
                print("\\nShutting down...")
                return 0
    except OSError as e:
        if e.errno == 48:  # Address already in use
            print(f"Port {port} is already in use. Please close other applications using this port or change the port.")
        else:
            print(f"Error starting server: {e}")
        return 1


if __name__ == '__main__':
    import sys
    sys.exit(main())