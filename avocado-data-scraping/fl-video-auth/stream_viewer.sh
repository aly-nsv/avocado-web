#!/bin/bash

# FL-511 Stream Viewer Script
# This script gets fresh authentication and plays the video with optimal settings

echo "============================================================"
echo "FL-511 Live Camera Stream Viewer"
echo "============================================================"

# Activate virtual environment
source venv/bin/activate

# Get fresh authentication
echo "🔐 Getting fresh authentication..."
URL=$(python fl511_video_tester_cli.py --no-play 2>/dev/null | grep "Stream URL:" | tail -1 | cut -d' ' -f3-)

if [ -z "$URL" ]; then
    echo "❌ Failed to get stream URL"
    exit 1
fi

echo "✅ Got authenticated stream URL"
echo "🎥 Launching video player..."
echo ""
echo "💡 Video Tips:"
echo "   - Press 'q' to quit"
echo "   - Press 'f' for fullscreen"
echo "   - Press 'p' or SPACE to pause"
echo "   - Press 'm' to mute/unmute"
echo ""

# Launch ffplay with better settings
ffplay \
    -i "$URL" \
    -window_title "FL-511 Live Camera Feed" \
    -autoexit \
    -loglevel quiet \
    -hide_banner \
    -x 640 \
    -y 480 \
    -left 100 \
    -top 100

echo "Video playback finished."