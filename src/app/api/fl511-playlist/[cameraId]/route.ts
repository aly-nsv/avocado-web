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

    // Validate required parameters
    if (!cameraId) {
      return NextResponse.json({
        error: 'Camera ID is required'
      }, { status: 400 })
    }

    console.log(`FL511 Playlist API: Processing camera ${cameraId}`)

    // Get camera data to obtain the stored video URL
    let cameraVideoUrl: string | undefined;
    try {
      // Try to get camera data from the v2 API to get the stored video URL
      const cameraResponse = await fetch(`${request.nextUrl.origin}/api/cameras/v2/fl?limit=1000`);
      if (cameraResponse.ok) {
        const cameraData = await cameraResponse.json();
        const camera = cameraData.cameras?.find((cam: any) => cam.id === cameraId);
        if (camera?.videoUrl) {
          cameraVideoUrl = camera.videoUrl;
          console.log(`Found stored video URL for camera ${cameraId}: ${cameraVideoUrl}`);
        }
      }
    } catch (error) {
      console.warn('Could not fetch camera data for video URL:', error);
    }

    // Get complete stream information
    const streamInfo: StreamInfo | null = await getFloridaCameraStreamInfo(cameraId, cameraVideoUrl)

    if (!streamInfo) {
      return new NextResponse('Playlist not available', { status: 404 })
    }

    // Build an enhanced HLS playlist
    let playlistContent = streamInfo.step3_playlist_info.playlist_content

    // If proxy is requested, replace segment URLs with our proxy endpoints
    if (proxySegments) {
      const baseUrl = new URL(request.url).origin
      
      for (const segment of streamInfo.segments) {
        const originalUrl = segment.url
        const proxyUrl = `${baseUrl}/api/fl511-segment?url=${encodeURIComponent(originalUrl)}`
        playlistContent = playlistContent.replace(originalUrl, proxyUrl)
      }
    }

    // Add custom headers for better client compatibility
    const enhancedPlaylist = `#EXTM3U
#EXT-X-VERSION:3
#EXT-X-TARGETDURATION:10
#EXT-X-MEDIA-SEQUENCE:0
#EXT-X-PLAYLIST-TYPE:LIVE
${playlistContent.split('\n').filter(line => !line.startsWith('#EXTM3U')).join('\n')}`

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