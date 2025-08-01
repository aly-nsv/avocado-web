import { NextRequest, NextResponse } from 'next/server'
import { getFloridaCameraStreamInfo } from '@/lib/florida511-auth'

/**
 * Enhanced Stream Proxy Endpoint
 * 
 * Uses the improved 4-step authentication flow to provide reliable streaming
 * with SSL verification disabled for divas.cloud endpoints
 */
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ cameraId: string }> }
) {
  try {
    const { cameraId } = await params

    console.log(`Stream Proxy: Processing camera ${cameraId}`)

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

    // Get complete stream information using enhanced authentication
    const streamInfo = await getFloridaCameraStreamInfo(cameraId, cameraVideoUrl)

    if (!streamInfo) {
      return new NextResponse('Stream not available - authentication failed', { status: 404 })
    }

    const secureUrl = streamInfo.streaming_url

    // Fetch the stream with proper headers and SSL verification disabled
    const streamResponse = await fetch(secureUrl, {
      headers: {
        'accept': '*/*',
        'accept-language': 'en-US,en;q=0.9',
        'origin': 'https://fl511.com',
        'priority': 'u=1, i',
        'referer': 'https://fl511.com/',
        'sec-ch-ua': '"Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"macOS"',
        'sec-fetch-dest': 'empty',
        'sec-fetch-mode': 'cors',
        'sec-fetch-site': 'cross-site',
        'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'
      },
      // SSL verification disabled for Node.js environment
      // @ts-ignore - Node.js specific
      agent: process.env.NODE_ENV === 'development' ? new (require('https')).Agent({ rejectUnauthorized: false }) : undefined
    })

    if (!streamResponse.ok) {
      console.error(`Upstream stream error: ${streamResponse.status}`)
      return new NextResponse(`Upstream stream error: ${streamResponse.status}`, { status: streamResponse.status })
    }

    // Get content type from upstream
    const contentType = streamResponse.headers.get('content-type') || 'application/vnd.apple.mpegurl'

    console.log(`Stream Proxy: Successfully proxying ${contentType} stream`)

    // Create response with proper CORS headers for video streaming
    const response = new NextResponse(streamResponse.body, {
      status: 200,
      headers: {
        'Content-Type': contentType,
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, HEAD, OPTIONS',
        'Access-Control-Allow-Headers': 'Range, Content-Range, Content-Length, Content-Type',
        'Access-Control-Expose-Headers': 'Content-Range, Content-Length, Accept-Ranges',
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Pragma': 'no-cache',
        'Expires': '0'
      }
    })

    return response

  } catch (error) {
    console.error('Enhanced stream proxy error:', error)
    return new NextResponse('Stream proxy error', { status: 500 })
  }
}

// Handle CORS preflight
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