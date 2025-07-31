# FL-511 Video Stream Tester

This tool tests the authentication flow for accessing FL-511 traffic camera video streams.

## ✅ WORKING AUTHENTICATION FLOW

The authentication flow has been successfully tested and is working! The script can:
- ✅ Exchange tokens with FL-511 API
- ✅ Get secure tokens from Divas cloud
- ✅ Access authenticated HLS video streams
- ✅ Extract working video URLs with valid tokens

## Setup

1. Create and activate virtual environment:
```bash
python3 -m venv venv
source venv/bin/activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Install video player (optional, for video playback):
```bash
# On macOS with Homebrew
brew install ffmpeg

# Or install VLC from https://www.videolan.org/vlc/
```

## Usage

### 🎥 Quick Video Player (Recommended)
```bash
# Simple one-command video player
./stream_viewer.sh

# Or with Python (gets fresh auth and plays immediately)
source venv/bin/activate && python play_live_stream.py
```

### Command Line Interface
```bash
# Activate virtual environment
source venv/bin/activate

# Test authentication only
python fl511_video_tester_cli.py --no-play

# Test authentication and prompt to play video
python fl511_video_tester_cli.py

# Test with different camera ID
python fl511_video_tester_cli.py --camera-id 1234

# Auto-play video if authentication succeeds
python fl511_video_tester_cli.py --play
```

### GUI Interface (if tkinter available)
```bash
python fl511_video_tester.py
```

## Authentication Flow

The tool implements the complete FL-511 video authentication process:

1. **Get Video URL**: Requests video metadata from FL-511 API using camera ID
2. **Get Secure Token**: Exchanges credentials with Divas cloud for stream access
3. **Test Stream Access**: Validates the HLS stream URL with the secure token
4. **Play Video**: Opens the authenticated stream in a video player

## Example Output

```
============================================================
FL-511 Video Stream Authentication Tester
============================================================
[13:37:37] INFO: Starting authentication test for camera ID: 1248
[13:37:37] INFO: Step 1: Getting video URL from FL-511...
[13:37:38] INFO: Step 2: Getting secure token from Divas...
[13:37:38] INFO: Step 3: Testing stream access...
[13:37:38] INFO: Successfully accessed stream playlist (236 bytes)
[13:37:38] INFO: SUCCESS: Stream URL ready

============================================================
AUTHENTICATION SUCCESSFUL!
============================================================
Stream URL: https://dis-se14.divas.cloud:8200/chan-1013_h/index.m3u8?token=...
```

## Technical Details

- **Session Management**: Uses FL-511 session cookies and verification tokens
- **Token Exchange**: Implements Divas cloud token authentication
- **HLS Streaming**: Supports HTTP Live Streaming video format
- **SSL Handling**: Bypasses SSL verification for streaming servers
- **Error Handling**: Comprehensive error handling and logging

## Files

- `fl511_video_tester_cli.py` - Command-line interface (recommended)
- `fl511_video_tester.py` - GUI interface (requires tkinter)
- `test_camera_info.py` - Helper script for camera information
- `requirements.txt` - Python dependencies
- `venv/` - Virtual environment (created after setup)

## 🔧 Troubleshooting Video Playback

If you don't see the video window:

1. **Check if ffplay is installed**: `which ffplay` should return a path
2. **Look for the video window**: It might be behind other windows or on a different desktop/space
3. **Check system permissions**: macOS might ask for permission to run the video player
4. **Token expiry**: Tokens expire quickly - always get fresh authentication before playing
5. **Manual playback**: Copy the stream URL and paste it into VLC or another video player

### Video Player Controls
- Press `q` to quit
- Press `f` for fullscreen  
- Press `p` or `SPACE` to pause
- Press `m` to mute/unmute

## Notes

- ✅ Authentication flow is **fully working**
- 🔐 Uses real FL-511 session cookies and tokens
- 🎥 Generates valid authenticated video stream URLs
- 📺 Stream URLs can be opened in any HLS-compatible video player
- ⏰ Tokens have limited validity (~5-10 minutes) and will expire
- 🎯 Video player launches successfully - check if window opened on different desktop