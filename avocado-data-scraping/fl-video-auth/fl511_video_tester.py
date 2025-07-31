#!/usr/bin/env python3
"""
FL-511 Video Stream Authentication Tester

This script implements the authentication flow for FL-511 traffic camera video streams
and provides a GUI to test the video streaming functionality.
"""

import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext
import requests
import json
import threading
import subprocess
import sys
import os
from urllib.parse import urlparse, parse_qs
import time

class FL511VideoTester:
    def __init__(self, root):
        self.root = root
        self.root.title("FL-511 Video Stream Tester")
        self.root.geometry("800x600")
        
        # Authentication data extracted from the curl commands
        self.session_cookies = {
            'session-id': '23DC12AED6DEE4656DDC44EFD1CB01D72334AA1EDCCB689994E257801B1862455BD604F0B6B709DB9E212E6899C51A151B174EFA8EF5123F0D33D633B9BA1C2E40AD1BBCBCC7D77EADE87B661CF56291E053DC1EB5F79DC8DB018E2206323FFF9513FB7878C040E971787FBD29396438E13E24CA35392B2E774F744E7194A468',
            '_culture': 'en',
            'session': 'session',
            '__RequestVerificationToken': 'EiXaNABDvph_UtOy3s4I7xCwNI0BuCq5AB8ZvDsbEpEn_uaS9673UrHWjY1Q0obA-_sLU5iccz6lU3omN41ClPW4tXs1',
            '_gid': 'GA1.2.145556750.1753896432',
            '_region': 'ALL',
            '_ga_07ZPFGG911': 'GS2.1.s1753982363$o2$g1$t1753982363$j60$l0$h0',
            '_ga': 'GA1.1.129985649.1753896432',
            'map': '{"prevLatLng":[29.876387533219038,-81.53312194824218],"prevZoom":11,"selectedLayers":["TrafficSpeeds","Cameras"],"mapView":"2025-07-31T17:21:26.559Z","prevMapType":"google"}',
            '.AspNet.ApplicationCookie': 'gQjY0668zf96_k7iBP0qDDTYPhcYxOlSBxeevXy4K10db-A29uqMiGQJd-QA0wHKNZTqIAW8MR29s-HkbUqNWY_wfZylHBgPiH43rXGKdlW2nK3bXZD1c94j2hz5UqO1mtKJP3OqtU0q9VWLP18KZQJH5sz8MTpt8Zt9IwIoW_IZT2qz13IKPy40dKxVYFJijc7-1zwMF_hb497baEvJXTE5vnUpsmvD3GXrLMYDWOqgfkfNeTyKzWuSpGBGN06S1-LXcgdUC5SLNvdVgN_5QvvNh1Of59XQVUfROIPnW4ldLIap63L8vVDWnWfVjT6L1vnjdiQ6Vb3P5RyQZEr1ID4NzL1zfcv6DpiymtDbpp-GbSIc7tek-uOv6pMZb7ea7cJNm2wQhAJH1WT1s_excE7nT0nfFUllc9GN1Uonyi39zvCtpCCGE81CXjdSvguDa7M0VBhSmGJk2QEmyMNk4laacTPFbMpuYwLAEXjqBn0CR2UlmXvjgu9KIEu1E4PC1cBJHA'
        }
        
        self.request_verification_token = 'G1JaniFRF7zv-0WnyAqk0qOiR8plYN_4e7aW3y8S_Hx9N9g1KW6fokzdkvmqtwEw8UB5hwuQKKJqVR5FWHcuh3O5ngcFFqS1ftclpeA0lvihFolZHZI84U4wuwIIeN6-g6QIyw2'
        
        self.headers = {
            'Accept': '*/*',
            'Accept-Language': 'en-US,en;q=0.9',
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
            'Sec-Ch-Ua': '"Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"',
            'Sec-Ch-Ua-Mobile': '?0',
            'Sec-Ch-Ua-Platform': '"macOS"',
            'Sec-Fetch-Dest': 'empty',
            'Sec-Fetch-Mode': 'cors',
            'Sec-Fetch-Site': 'same-origin',
            'X-Requested-With': 'XMLHttpRequest'
        }
        
        self.setup_gui()
        
    def setup_gui(self):
        # Main frame
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Camera ID input
        ttk.Label(main_frame, text="Camera ID:").grid(row=0, column=0, sticky=tk.W, pady=5)
        self.camera_id_var = tk.StringVar(value="1248")  # Default from example
        ttk.Entry(main_frame, textvariable=self.camera_id_var, width=20).grid(row=0, column=1, sticky=tk.W, pady=5)
        
        # Test button
        ttk.Button(main_frame, text="Test Video Stream", command=self.test_video_stream).grid(row=1, column=0, columnspan=2, pady=10)
        
        # Status label
        self.status_var = tk.StringVar(value="Ready")
        ttk.Label(main_frame, textvariable=self.status_var).grid(row=2, column=0, columnspan=2, pady=5)
        
        # Log output
        ttk.Label(main_frame, text="Log Output:").grid(row=3, column=0, sticky=tk.W, pady=(10, 5))
        self.log_text = scrolledtext.ScrolledText(main_frame, width=80, height=20)
        self.log_text.grid(row=4, column=0, columnspan=2, pady=5, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Video controls frame
        video_frame = ttk.LabelFrame(main_frame, text="Video Controls", padding="5")
        video_frame.grid(row=5, column=0, columnspan=2, pady=10, sticky=(tk.W, tk.E))
        
        self.play_button = ttk.Button(video_frame, text="Play Video", command=self.play_video, state=tk.DISABLED)
        self.play_button.grid(row=0, column=0, padx=5)
        
        self.stop_button = ttk.Button(video_frame, text="Stop Video", command=self.stop_video, state=tk.DISABLED)
        self.stop_button.grid(row=0, column=1, padx=5)
        
        # Configure grid weights
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(1, weight=1)
        main_frame.rowconfigure(4, weight=1)
        
        self.current_stream_url = None
        self.video_process = None
        
    def log(self, message):
        """Add message to log output"""
        self.log_text.insert(tk.END, f"{time.strftime('%H:%M:%S')} - {message}\n")
        self.log_text.see(tk.END)
        self.root.update_idletasks()
        
    def test_video_stream(self):
        """Test the complete video stream authentication flow"""
        camera_id = self.camera_id_var.get().strip()
        if not camera_id:
            messagebox.showerror("Error", "Please enter a camera ID")
            return
            
        # Run in separate thread to avoid blocking GUI
        threading.Thread(target=self._test_video_stream_worker, args=(camera_id,), daemon=True).start()
        
    def _test_video_stream_worker(self, camera_id):
        """Worker method for testing video stream"""
        try:
            self.status_var.set("Testing authentication flow...")
            self.log(f"Starting authentication test for camera ID: {camera_id}")
            
            # Step 1: Get video URL from FL-511
            self.log("Step 1: Getting video URL from FL-511...")
            video_info = self._get_video_url(camera_id)
            if not video_info:
                self.status_var.set("Failed to get video URL")
                return
                
            self.log(f"Got video info: {json.dumps(video_info, indent=2)}")
            
            # Step 2: Get secure token from Divas
            self.log("Step 2: Getting secure token from Divas...")
            token_info = self._get_secure_token(video_info)
            if not token_info:
                self.status_var.set("Failed to get secure token")
                return
                
            self.log(f"Got token info: {json.dumps(token_info, indent=2)}")
            
            # Step 3: Test stream access
            self.log("Step 3: Testing stream access...")
            stream_url = self._test_stream_access(token_info)
            if not stream_url:
                self.status_var.set("Failed to access stream")
                return
                
            self.current_stream_url = stream_url
            self.log(f"Stream URL ready: {stream_url}")
            
            # Enable video controls
            self.play_button.config(state=tk.NORMAL)
            self.status_var.set("Stream ready - click Play Video to test")
            
        except Exception as e:
            self.log(f"Error in authentication flow: {str(e)}")
            self.status_var.set(f"Error: {str(e)}")
            
    def _get_video_url(self, camera_id):
        """Step 1: Get video URL from FL-511"""
        url = f"https://fl511.com/Camera/GetVideoUrl?imageId={camera_id}&_={int(time.time() * 1000)}"
        
        headers = self.headers.copy()
        headers['__requestverificationtoken'] = self.request_verification_token
        headers['Referer'] = 'https://fl511.com/map'
        
        try:
            response = requests.get(url, headers=headers, cookies=self.session_cookies, timeout=30)
            response.raise_for_status()
            
            data = response.json()
            if data.get('success'):
                return data.get('data', {})
            else:
                self.log(f"FL-511 returned error: {data.get('message', 'Unknown error')}")
                return None
                
        except requests.exceptions.RequestException as e:
            self.log(f"Request error getting video URL: {str(e)}")
            return None
        except json.JSONDecodeError as e:
            self.log(f"JSON decode error: {str(e)}")
            return None
            
    def _get_secure_token(self, video_info):
        """Step 2: Get secure token from Divas cloud"""
        url = "https://divas.cloud/VDS-API/SecureTokenUri/GetSecureTokenUriBySourceId"
        
        # Extract token and source info from video_info
        token = video_info.get('token')
        source_id = video_info.get('sourceId')
        system_source_id = video_info.get('systemSourceId', 'District 2')
        
        if not token or not source_id:
            self.log(f"Missing required data from video info: token={token}, sourceId={source_id}")
            return None
            
        payload = {
            "token": token,
            "sourceId": source_id,
            "systemSourceId": system_source_id
        }
        
        headers = {
            '__requestverificationtoken': self.request_verification_token,
            'Accept': '*/*',
            'Accept-Language': 'en-US,en;q=0.9',
            'Content-Type': 'application/json',
            'Origin': 'https://fl511.com',
            'Referer': 'https://fl511.com/',
            'User-Agent': self.headers['User-Agent']
        }
        
        try:
            response = requests.post(url, headers=headers, json=payload, timeout=30)
            response.raise_for_status()
            
            data = response.json()
            if data.get('success'):
                return data.get('data', {})
            else:
                self.log(f"Divas returned error: {data.get('message', 'Unknown error')}")
                return None
                
        except requests.exceptions.RequestException as e:
            self.log(f"Request error getting secure token: {str(e)}")
            return None
        except json.JSONDecodeError as e:
            self.log(f"JSON decode error: {str(e)}")
            return None
            
    def _test_stream_access(self, token_info):
        """Step 3: Test access to the HLS stream"""
        secure_uri = token_info.get('secureUri')
        if not secure_uri:
            self.log("No secure URI found in token info")
            return None
            
        headers = {
            'Accept': '*/*',
            'Accept-Language': 'en-US,en;q=0.9',
            'Origin': 'https://fl511.com',
            'Referer': 'https://fl511.com/',
            'User-Agent': self.headers['User-Agent']
        }
        
        try:
            # Test the main playlist
            response = requests.get(secure_uri, headers=headers, timeout=30)
            response.raise_for_status()
            
            self.log(f"Successfully accessed stream playlist ({len(response.content)} bytes)")
            self.log("Playlist content preview:")
            self.log(response.text[:500] + "..." if len(response.text) > 500 else response.text)
            
            return secure_uri
            
        except requests.exceptions.RequestException as e:
            self.log(f"Request error testing stream access: {str(e)}")
            return None
            
    def play_video(self):
        """Play the video stream using system video player"""
        if not self.current_stream_url:
            messagebox.showerror("Error", "No stream URL available")
            return
            
        self.log(f"Attempting to play video: {self.current_stream_url}")
        
        try:
            # Try to use ffplay first (part of ffmpeg)
            self.video_process = subprocess.Popen([
                'ffplay', 
                '-i', self.current_stream_url,
                '-window_title', 'FL-511 Camera Stream',
                '-autoexit'
            ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            
            self.play_button.config(state=tk.DISABLED)
            self.stop_button.config(state=tk.NORMAL)
            self.log("Video player started with ffplay")
            
        except FileNotFoundError:
            try:
                # Fallback to VLC if available
                self.video_process = subprocess.Popen([
                    'vlc', self.current_stream_url
                ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                
                self.play_button.config(state=tk.DISABLED)
                self.stop_button.config(state=tk.NORMAL)
                self.log("Video player started with VLC")
                
            except FileNotFoundError:
                messagebox.showerror(
                    "Error", 
                    "No video player found. Please install ffmpeg (with ffplay) or VLC.\n\n"
                    "Install ffmpeg: brew install ffmpeg\n"
                    "Or copy this URL to your browser or video player:\n\n"
                    f"{self.current_stream_url}"
                )
                self.log("No suitable video player found")
                
    def stop_video(self):
        """Stop the video player"""
        if self.video_process:
            self.video_process.terminate()
            self.video_process = None
            self.log("Video player stopped")
            
        self.play_button.config(state=tk.NORMAL)
        self.stop_button.config(state=tk.DISABLED)

def main():
    root = tk.Tk()
    app = FL511VideoTester(root)
    root.mainloop()

if __name__ == "__main__":
    main()