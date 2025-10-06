#!/usr/bin/env python3
"""
Camera Quality Reviewer GUI

This application allows you to review video segments for each camera and label their quality.
- Navigate through cameras in numeric order
- View all video segments for a camera
- Convert .ts files to .mp4 for playback
- Label camera quality as high/low with keyboard shortcuts
- Persist quality labels to the JSON file
"""

import json
import csv
import os
import subprocess
import tempfile
import threading
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import webbrowser


class CameraQualityReviewer:
    def __init__(self, camera_json_path: str, video_csv_path: str):
        self.camera_json_path = camera_json_path
        self.video_csv_path = video_csv_path
        
        # Load data
        self.cameras = self.load_cameras()
        self.video_segments = self.load_video_segments()
        
        # Current state
        self.current_camera_index = 0
        self.current_segment_index = 0
        self.temp_video_files = []  # Track temporary files for cleanup
        
        # Create GUI
        self.setup_gui()
        
        # Load first camera
        self.load_camera()
    
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
    
    def setup_gui(self):
        """Create the GUI interface."""
        self.root = tk.Tk()
        self.root.title("Camera Quality Reviewer")
        self.root.geometry("1200x800")
        
        # Main frame
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Configure grid weights
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(1, weight=1)
        main_frame.rowconfigure(2, weight=1)
        
        # Camera info section
        self.setup_camera_info(main_frame)
        
        # Video segments section
        self.setup_video_segments(main_frame)
        
        # Controls section
        self.setup_controls(main_frame)
        
        # Status bar
        self.status_var = tk.StringVar()
        status_bar = ttk.Label(main_frame, textvariable=self.status_var)
        status_bar.grid(row=3, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(10, 0))
        
        # Keyboard bindings
        self.root.bind('<Key-h>', lambda e: self.set_quality('high'))
        self.root.bind('<Key-l>', lambda e: self.set_quality('low'))
        self.root.bind('<Key-n>', lambda e: self.next_camera())
        self.root.bind('<Key-p>', lambda e: self.prev_camera())
        self.root.bind('<Key-Right>', lambda e: self.next_segment())
        self.root.bind('<Key-Left>', lambda e: self.prev_segment())
        self.root.bind('<Key-space>', lambda e: self.play_current_segment())
        
        # Focus to capture keyboard events
        self.root.focus_set()
        
        self.update_status("Ready. Use keyboard: H=High Quality, L=Low Quality, N=Next Camera, P=Prev Camera")
    
    def setup_camera_info(self, parent):
        """Setup camera information display."""
        camera_frame = ttk.LabelFrame(parent, text="Camera Information", padding="5")
        camera_frame.grid(row=0, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(0, 10))
        camera_frame.columnconfigure(1, weight=1)
        
        # Camera ID and navigation
        ttk.Label(camera_frame, text="Camera ID:").grid(row=0, column=0, sticky=tk.W)
        self.camera_id_var = tk.StringVar()
        ttk.Label(camera_frame, textvariable=self.camera_id_var, font=('TkDefaultFont', 12, 'bold')).grid(row=0, column=1, sticky=tk.W, padx=(10, 0))
        
        # Navigation buttons
        nav_frame = ttk.Frame(camera_frame)
        nav_frame.grid(row=0, column=2, sticky=tk.E)
        ttk.Button(nav_frame, text="← Prev Camera (P)", command=self.prev_camera).pack(side=tk.LEFT, padx=(0, 5))
        ttk.Button(nav_frame, text="Next Camera (N) →", command=self.next_camera).pack(side=tk.LEFT)
        
        # Camera details
        ttk.Label(camera_frame, text="Roadway:").grid(row=1, column=0, sticky=tk.W)
        self.roadway_var = tk.StringVar()
        ttk.Label(camera_frame, textvariable=self.roadway_var).grid(row=1, column=1, sticky=tk.W, padx=(10, 0))
        
        ttk.Label(camera_frame, text="Region:").grid(row=2, column=0, sticky=tk.W)
        self.region_var = tk.StringVar()
        ttk.Label(camera_frame, textvariable=self.region_var).grid(row=2, column=1, sticky=tk.W, padx=(10, 0))
        
        # Current quality
        ttk.Label(camera_frame, text="Current Quality:").grid(row=1, column=2, sticky=tk.W, padx=(20, 0))
        self.quality_var = tk.StringVar()
        self.quality_label = ttk.Label(camera_frame, textvariable=self.quality_var, font=('TkDefaultFont', 10, 'bold'))
        self.quality_label.grid(row=1, column=3, sticky=tk.W, padx=(10, 0))
        
        # Progress
        ttk.Label(camera_frame, text="Progress:").grid(row=2, column=2, sticky=tk.W, padx=(20, 0))
        self.progress_var = tk.StringVar()
        ttk.Label(camera_frame, textvariable=self.progress_var).grid(row=2, column=3, sticky=tk.W, padx=(10, 0))
    
    def setup_video_segments(self, parent):
        """Setup video segments list and preview."""
        video_frame = ttk.LabelFrame(parent, text="Video Segments", padding="5")
        video_frame.grid(row=2, column=0, columnspan=3, sticky=(tk.W, tk.E, tk.N, tk.S), pady=(0, 10))
        video_frame.columnconfigure(0, weight=1)
        video_frame.rowconfigure(1, weight=1)
        
        # Segment navigation
        nav_frame = ttk.Frame(video_frame)
        nav_frame.grid(row=0, column=0, sticky=(tk.W, tk.E), pady=(0, 5))
        nav_frame.columnconfigure(2, weight=1)
        
        ttk.Button(nav_frame, text="← Prev Segment", command=self.prev_segment).grid(row=0, column=0, padx=(0, 5))
        ttk.Button(nav_frame, text="Next Segment →", command=self.next_segment).grid(row=0, column=1, padx=(0, 10))
        
        self.segment_info_var = tk.StringVar()
        ttk.Label(nav_frame, textvariable=self.segment_info_var, font=('TkDefaultFont', 10, 'bold')).grid(row=0, column=2, sticky=tk.W)
        
        ttk.Button(nav_frame, text="Play Current Segment (Space)", command=self.play_current_segment).grid(row=0, column=3, sticky=tk.E)
        
        # Segments listbox with scrollbar
        list_frame = ttk.Frame(video_frame)
        list_frame.grid(row=1, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        list_frame.columnconfigure(0, weight=1)
        list_frame.rowconfigure(0, weight=1)
        
        self.segments_listbox = tk.Listbox(list_frame, font=('Courier', 9))
        self.segments_listbox.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        scrollbar = ttk.Scrollbar(list_frame, orient=tk.VERTICAL, command=self.segments_listbox.yview)
        scrollbar.grid(row=0, column=1, sticky=(tk.N, tk.S))
        self.segments_listbox.configure(yscrollcommand=scrollbar.set)
        
        # Bind listbox selection
        self.segments_listbox.bind('<<ListboxSelect>>', self.on_segment_select)
    
    def setup_controls(self, parent):
        """Setup quality control buttons."""
        controls_frame = ttk.LabelFrame(parent, text="Quality Controls", padding="5")
        controls_frame.grid(row=1, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(0, 10))
        
        # Quality buttons
        ttk.Button(controls_frame, text="High Quality (H)", 
                  command=lambda: self.set_quality('high'), 
                  style='High.TButton').pack(side=tk.LEFT, padx=(0, 10))
        
        ttk.Button(controls_frame, text="Low Quality (L)", 
                  command=lambda: self.set_quality('low'),
                  style='Low.TButton').pack(side=tk.LEFT, padx=(0, 20))
        
        ttk.Button(controls_frame, text="Clear Quality", 
                  command=lambda: self.set_quality(None)).pack(side=tk.LEFT, padx=(0, 20))
        
        ttk.Button(controls_frame, text="Save Progress", 
                  command=self.save_progress).pack(side=tk.LEFT, padx=(0, 20))
        
        ttk.Button(controls_frame, text="Export Results", 
                  command=self.export_results).pack(side=tk.RIGHT)
    
    def load_camera(self):
        """Load current camera data."""
        if not self.cameras:
            return
        
        camera = self.cameras[self.current_camera_index]
        camera_id = camera['camera_id']
        
        # Update camera info
        self.camera_id_var.set(f"#{camera_id}")
        
        # Get camera details from video segments (they have more metadata)
        segments = self.video_segments.get(camera_id, [])
        if segments:
            sample_segment = segments[0]
            self.roadway_var.set(f"{sample_segment.get('camera_roadway', 'N/A')} - {sample_segment.get('camera_county', 'N/A')}")
            self.region_var.set(sample_segment.get('camera_region', 'N/A'))
        else:
            self.roadway_var.set("No video data available")
            self.region_var.set("N/A")
        
        # Update quality display
        quality = camera.get('quality')
        if quality == 'high':
            self.quality_var.set("HIGH QUALITY")
            self.quality_label.configure(foreground='green')
        elif quality == 'low':
            self.quality_var.set("LOW QUALITY")
            self.quality_label.configure(foreground='red')
        else:
            self.quality_var.set("NOT REVIEWED")
            self.quality_label.configure(foreground='gray')
        
        # Update progress
        total_cameras = len(self.cameras)
        reviewed_count = sum(1 for c in self.cameras if c.get('quality') is not None)
        self.progress_var.set(f"{self.current_camera_index + 1}/{total_cameras} ({reviewed_count} reviewed)")
        
        # Load segments
        self.load_segments()
        
        self.update_status(f"Loaded camera {camera_id} with {len(segments)} video segments")
    
    def load_segments(self):
        """Load video segments for current camera."""
        camera = self.cameras[self.current_camera_index]
        camera_id = camera['camera_id']
        segments = self.video_segments.get(camera_id, [])
        
        # Clear and populate listbox
        self.segments_listbox.delete(0, tk.END)
        
        for i, segment in enumerate(segments):
            filename = segment['segment_filename']
            date = segment.get('capture_timestamp', '')[:10] if segment.get('capture_timestamp') else 'Unknown'
            size_mb = round(int(segment.get('segment_size_bytes', 0)) / 1024 / 1024, 1)
            duration = float(segment.get('segment_duration', 0))
            
            display_text = f"{i+1:2d}. {filename:<30} {date} {size_mb:5.1f}MB {duration:5.1f}s"
            self.segments_listbox.insert(tk.END, display_text)
        
        # Reset segment selection
        self.current_segment_index = 0
        if segments:
            self.segments_listbox.selection_set(0)
            self.update_segment_info()
    
    def update_segment_info(self):
        """Update current segment information."""
        camera_id = self.cameras[self.current_camera_index]['camera_id']
        segments = self.video_segments.get(camera_id, [])
        
        if segments and 0 <= self.current_segment_index < len(segments):
            segment = segments[self.current_segment_index]
            self.segment_info_var.set(f"Segment {self.current_segment_index + 1}/{len(segments)}: {segment['segment_filename']}")
        else:
            self.segment_info_var.set("No segments available")
    
    def on_segment_select(self, event):
        """Handle segment selection from listbox."""
        selection = self.segments_listbox.curselection()
        if selection:
            self.current_segment_index = selection[0]
            self.update_segment_info()
    
    def convert_ts_to_mp4(self, ts_url: str) -> Optional[str]:
        """Convert .ts file to .mp4 for playback. Returns path to temp .mp4 file."""
        try:
            # Create temporary file
            temp_file = tempfile.NamedTemporaryFile(suffix='.mp4', delete=False)
            temp_path = temp_file.name
            temp_file.close()
            
            # Use ffmpeg to convert
            cmd = [
                'ffmpeg', '-y',  # -y to overwrite existing files
                '-i', ts_url,    # input URL
                '-c', 'copy',    # copy streams without re-encoding
                '-movflags', 'faststart',  # optimize for playback
                temp_path
            ]
            
            self.update_status("Converting video segment...")
            
            # Run conversion
            result = subprocess.run(cmd, capture_output=True, text=True)
            
            if result.returncode == 0:
                self.temp_video_files.append(temp_path)
                self.update_status("Video conversion completed")
                return temp_path
            else:
                self.update_status(f"Video conversion failed: {result.stderr}")
                os.unlink(temp_path)
                return None
                
        except Exception as e:
            self.update_status(f"Error converting video: {str(e)}")
            return None
    
    def play_current_segment(self):
        """Play the current video segment."""
        camera_id = self.cameras[self.current_camera_index]['camera_id']
        segments = self.video_segments.get(camera_id, [])
        
        if not segments or self.current_segment_index >= len(segments):
            messagebox.showwarning("No Segment", "No video segment selected")
            return
        
        segment = segments[self.current_segment_index]
        video_url = segment.get('storage_url')
        
        if not video_url:
            messagebox.showwarning("No URL", "No video URL available for this segment")
            return
        
        # Run conversion in thread to avoid blocking GUI
        def convert_and_play():
            mp4_path = self.convert_ts_to_mp4(video_url)
            if mp4_path:
                # Open with default video player
                try:
                    if os.name == 'nt':  # Windows
                        os.startfile(mp4_path)
                    elif os.name == 'posix':  # macOS/Linux
                        subprocess.run(['open', mp4_path] if sys.platform == 'darwin' 
                                     else ['xdg-open', mp4_path])
                except Exception as e:
                    self.update_status(f"Error opening video player: {str(e)}")
        
        threading.Thread(target=convert_and_play, daemon=True).start()
    
    def set_quality(self, quality: Optional[str]):
        """Set quality for current camera."""
        if not self.cameras:
            return
        
        self.cameras[self.current_camera_index]['quality'] = quality
        
        # Update display
        if quality == 'high':
            self.quality_var.set("HIGH QUALITY")
            self.quality_label.configure(foreground='green')
        elif quality == 'low':
            self.quality_var.set("LOW QUALITY")
            self.quality_label.configure(foreground='red')
        else:
            self.quality_var.set("NOT REVIEWED")
            self.quality_label.configure(foreground='gray')
        
        # Update progress
        reviewed_count = sum(1 for c in self.cameras if c.get('quality') is not None)
        total_cameras = len(self.cameras)
        self.progress_var.set(f"{self.current_camera_index + 1}/{total_cameras} ({reviewed_count} reviewed)")
        
        quality_text = quality.upper() if quality else "CLEARED"
        self.update_status(f"Set camera {self.cameras[self.current_camera_index]['camera_id']} quality to {quality_text}")
    
    def next_camera(self):
        """Navigate to next camera."""
        if self.current_camera_index < len(self.cameras) - 1:
            self.current_camera_index += 1
            self.load_camera()
        else:
            self.update_status("Already at last camera")
    
    def prev_camera(self):
        """Navigate to previous camera."""
        if self.current_camera_index > 0:
            self.current_camera_index -= 1
            self.load_camera()
        else:
            self.update_status("Already at first camera")
    
    def next_segment(self):
        """Navigate to next segment."""
        camera_id = self.cameras[self.current_camera_index]['camera_id']
        segments = self.video_segments.get(camera_id, [])
        
        if self.current_segment_index < len(segments) - 1:
            self.current_segment_index += 1
            self.segments_listbox.selection_clear(0, tk.END)
            self.segments_listbox.selection_set(self.current_segment_index)
            self.segments_listbox.see(self.current_segment_index)
            self.update_segment_info()
        else:
            self.update_status("Already at last segment")
    
    def prev_segment(self):
        """Navigate to previous segment."""
        if self.current_segment_index > 0:
            self.current_segment_index -= 1
            self.segments_listbox.selection_clear(0, tk.END)
            self.segments_listbox.selection_set(self.current_segment_index)
            self.segments_listbox.see(self.current_segment_index)
            self.update_segment_info()
        else:
            self.update_status("Already at first segment")
    
    def save_progress(self):
        """Save current progress to JSON file."""
        try:
            with open(self.camera_json_path, 'w') as f:
                json.dump(self.cameras, f, indent=2)
            
            reviewed_count = sum(1 for c in self.cameras if c.get('quality') is not None)
            self.update_status(f"Progress saved! {reviewed_count} cameras reviewed.")
        except Exception as e:
            messagebox.showerror("Save Error", f"Failed to save progress: {str(e)}")
    
    def export_results(self):
        """Export reviewed results to a new file."""
        reviewed_cameras = [c for c in self.cameras if c.get('quality') is not None]
        
        if not reviewed_cameras:
            messagebox.showinfo("No Data", "No cameras have been reviewed yet.")
            return
        
        filename = filedialog.asksaveasfilename(
            defaultextension=".json",
            filetypes=[("JSON files", "*.json")],
            title="Export Reviewed Cameras"
        )
        
        if filename:
            try:
                with open(filename, 'w') as f:
                    json.dump(reviewed_cameras, f, indent=2)
                messagebox.showinfo("Export Complete", f"Exported {len(reviewed_cameras)} reviewed cameras to {filename}")
            except Exception as e:
                messagebox.showerror("Export Error", f"Failed to export: {str(e)}")
    
    def update_status(self, message: str):
        """Update status bar message."""
        self.status_var.set(message)
        self.root.update_idletasks()
    
    def cleanup(self):
        """Clean up temporary files."""
        for temp_file in self.temp_video_files:
            try:
                if os.path.exists(temp_file):
                    os.unlink(temp_file)
            except Exception as e:
                print(f"Warning: Could not delete temp file {temp_file}: {e}")
    
    def run(self):
        """Run the application."""
        try:
            self.root.protocol("WM_DELETE_WINDOW", self.on_closing)
            self.root.mainloop()
        finally:
            self.cleanup()
    
    def on_closing(self):
        """Handle application closing."""
        # Ask to save if there are unsaved changes
        reviewed_count = sum(1 for c in self.cameras if c.get('quality') is not None)
        if reviewed_count > 0:
            if messagebox.askyesno("Save Progress", 
                                 f"You have reviewed {reviewed_count} cameras. Save progress before closing?"):
                self.save_progress()
        
        self.cleanup()
        self.root.destroy()


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
    
    # Check for ffmpeg
    try:
        subprocess.run(['ffmpeg', '-version'], capture_output=True)
    except FileNotFoundError:
        print("Error: ffmpeg is required but not found in PATH.")
        print("Please install ffmpeg to convert .ts files to .mp4 for playback.")
        print("On macOS: brew install ffmpeg")
        print("On Ubuntu: sudo apt install ffmpeg")
        return 1
    
    print(f"Loading cameras from: {camera_json}")
    print(f"Loading video segments from: {video_csv}")
    print("\nKeyboard shortcuts:")
    print("  H - Mark camera as High Quality")
    print("  L - Mark camera as Low Quality")
    print("  N - Next Camera")
    print("  P - Previous Camera")
    print("  → - Next Segment")
    print("  ← - Previous Segment")
    print("  Space - Play Current Segment")
    print("\nStarting GUI...")
    
    app = CameraQualityReviewer(camera_json, video_csv)
    return app.run()


if __name__ == '__main__':
    import sys
    sys.exit(main())