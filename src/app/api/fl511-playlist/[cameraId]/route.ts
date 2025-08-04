import { NextRequest, NextResponse } from 'next/server'
import { getFloridaCameraStreamInfo, type StreamInfo } from '@/lib/florida511-auth'

/**
 * FL511 Enhanced Playlist Endpoint
 * 
 * Returns an authenticated HLS playlist with segments proxied through our API
 * to handle authentication and SSL issues transparently
 */
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ cameraId: string }> }
) {
  try {
    const { cameraId } = await params
    const { searchParams } = new URL(request.url)
    const proxySegments = searchParams.get('proxy') === 'true'
    const originalUrl = searchParams.get('originalUrl')

    // Validate required parameters
    if (!cameraId) {
      return NextResponse.json({
        error: 'Camera ID is required'
      }, { status: 400 })
    }

    console.log(`FL511 Playlist API: Processing camera ${cameraId}`)
    console.log(`FL511 Playlist API: Original URL from query:`, originalUrl)
    console.log(`FL511 Playlist API: Proxy segments requested:`, proxySegments)

    // Use originalUrl if provided, otherwise try to get stored video URL
    let videoUrl = originalUrl;
    
    if (!videoUrl) {
      try {
        // Try to get camera data from the v2 API to get the stored video URL
        const cameraResponse = await fetch(`${request.nextUrl.origin}/api/cameras/v2/fl?limit=1000`);
        if (cameraResponse.ok) {
          const cameraData = await cameraResponse.json();
          const camera = cameraData.cameras?.find((cam: any) => cam.id === cameraId);
          if (camera?.videoUrl) {
            videoUrl = camera.videoUrl;
            console.log(`Found stored video URL for camera ${cameraId}: ${videoUrl}`);
          }
        }
      } catch (error) {
        console.warn('Could not fetch camera data for video URL:', error);
      }
    }

    if (!videoUrl) {
      return new NextResponse('Video URL not found - provide originalUrl parameter or ensure camera data exists', { status: 400 })
    }

    // Get complete stream information
    const streamInfo: StreamInfo | null = await getFloridaCameraStreamInfo(cameraId, videoUrl)

    if (!streamInfo) {
      return new NextResponse('Playlist not available', { status: 404 })
    }

    // Build a clean HLS playlist by parsing the original and reconstructing it properly
    let playlistContent = streamInfo.step3_playlist_info.playlist_content
    const lines = playlistContent.trim().split('\n')
    
    // Extract important metadata from original playlist
    let targetDuration = 10
    let mediaSequence = 0
    let playlistType = 'LIVE'
    let version = 3
    
    // Parse original playlist for metadata
    for (const line of lines) {
      if (line.startsWith('#EXT-X-TARGETDURATION:')) {
        targetDuration = parseInt(line.split(':')[1]) || 10
      } else if (line.startsWith('#EXT-X-MEDIA-SEQUENCE:')) {
        mediaSequence = parseInt(line.split(':')[1]) || 0
      } else if (line.startsWith('#EXT-X-PLAYLIST-TYPE:')) {
        playlistType = line.split(':')[1] || 'LIVE'
      } else if (line.startsWith('#EXT-X-VERSION:')) {
        version = parseInt(line.split(':')[1]) || 3
      }
    }

    // Build clean playlist content
    const segmentLines = []
    let currentExtinf = null
    let currentProgramDateTime = null
    
    for (const line of lines) {
      const trimmedLine = line.trim()
      
      if (trimmedLine.startsWith('#EXTINF:')) {
        currentExtinf = trimmedLine
      } else if (trimmedLine.startsWith('#EXT-X-PROGRAM-DATE-TIME:')) {
        currentProgramDateTime = trimmedLine
      } else if (trimmedLine.endsWith('.ts') || (trimmedLine.includes('.ts?token='))) {
        // This is a segment line
        if (currentProgramDateTime) {
          segmentLines.push(currentProgramDateTime)
        }
        if (currentExtinf) {
          segmentLines.push(currentExtinf)
        }
        
        // Handle segment URL proxying if requested
        let segmentUrl = trimmedLine
        if (proxySegments) {
          const baseUrl = new URL(request.url).origin
          const fullSegmentUrl = streamInfo.segments.find(seg => 
            seg.url.includes(trimmedLine.split('?')[0]) || 
            trimmedLine.includes(seg.filename)
          )?.url
          
          if (fullSegmentUrl) {
            segmentUrl = `${baseUrl}/api/fl511-segment?url=${encodeURIComponent(fullSegmentUrl)}`
          }
        }
        
        segmentLines.push(segmentUrl)
        
        // Reset for next segment
        currentExtinf = null
        currentProgramDateTime = null
      }
    }

    // Build the final clean playlist
    const enhancedPlaylist = `#EXTM3U
#EXT-X-VERSION:${version}
#EXT-X-TARGETDURATION:${targetDuration}
#EXT-X-MEDIA-SEQUENCE:${mediaSequence}
#EXT-X-PLAYLIST-TYPE:${playlistType}
${segmentLines.join('\n')}`

    return new NextResponse(enhancedPlaylist, {
      status: 200,
      headers: {
        'Content-Type': 'application/vnd.apple.mpegurl',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, HEAD, OPTIONS',
        'Access-Control-Allow-Headers': 'Range, Content-Range, Content-Length, Content-Type',
        'Access-Control-Expose-Headers': 'Content-Range, Content-Length, Accept-Ranges',
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Pragma': 'no-cache',
        'Expires': '0'
      }
    })

  } catch (error) {
    console.error('FL511 Playlist API error:', error)
    return new NextResponse('Playlist service error', { status: 500 })
  }
}

// Handle CORS preflight requests
export async function OPTIONS() {
  return new NextResponse(null, {
    status: 200,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, HEAD, OPTIONS',
      'Access-Control-Allow-Headers': 'Range, Content-Range, Content-Length, Content-Type',
    }
  })
}