import { NextRequest, NextResponse } from 'next/server'
import { getFloridaCameraVideoUrl } from '@/lib/florida511-auth'

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ cameraId: string }> }
) {
  try {
    const { cameraId } = await params
    const { searchParams } = new URL(request.url)
    const sourceId = searchParams.get('sourceId') || ''

    // Get the authenticated stream URL
    const secureUrl = await getFloridaCameraVideoUrl(cameraId, sourceId)

    if (!secureUrl) {
      return new NextResponse('Stream not available', { status: 404 })
    }

    // Fetch the stream with proper headers
    const streamResponse = await fetch(secureUrl, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
        'Accept': '*/*',
        'Origin': 'https://fl511.com',
        'Referer': 'https://fl511.com/'
      }
    })

    if (!streamResponse.ok) {
      return new NextResponse('Upstream stream error', { status: streamResponse.status })
    }

    // Get content type from upstream
    const contentType = streamResponse.headers.get('content-type') || 'application/vnd.apple.mpegurl'

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
    console.error('Stream proxy error:', error)
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