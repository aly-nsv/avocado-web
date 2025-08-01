import { NextRequest, NextResponse } from 'next/server'
import { getVideoSegment } from '@/lib/florida511-auth'

/**
 * FL511 Video Segment Proxy Endpoint
 * 
 * Proxies individual video segments (.ts files) with proper authentication headers
 * and SSL verification disabled for divas.cloud endpoints
 */
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const segmentUrl = searchParams.get('url')

    // Validate required parameters
    if (!segmentUrl) {
      return NextResponse.json({
        error: 'Segment URL is required',
        usage: 'Use ?url=<segment_url> parameter'
      }, { status: 400 })
    }

    // Validate that this is a legitimate FL511/Divas segment URL
    if (!segmentUrl.includes('divas.cloud') && !segmentUrl.includes('dis-se')) {
      return NextResponse.json({
        error: 'Invalid segment URL',
        message: 'Only FL511/Divas cloud segment URLs are supported'
      }, { status: 400 })
    }

    console.log(`FL511 Segment API: Fetching segment from ${segmentUrl}`)

    // Get the video segment data
    const segmentData = await getVideoSegment(segmentUrl)

    if (!segmentData) {
      return NextResponse.json({
        error: 'Unable to retrieve video segment',
        segmentUrl,
        message: 'Segment may have expired or is no longer available'
      }, { status: 404 })
    }

    // Return the segment with proper headers for video streaming
    return new NextResponse(segmentData, {
      status: 200,
      headers: {
        'Content-Type': 'video/MP2T', // MPEG-2 Transport Stream
        'Content-Length': segmentData.byteLength.toString(),
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, HEAD, OPTIONS',
        'Access-Control-Allow-Headers': 'Range, Content-Range, Content-Length, Content-Type',
        'Access-Control-Expose-Headers': 'Content-Range, Content-Length, Accept-Ranges',
        'Cache-Control': 'public, max-age=30', // Cache for 30 seconds since segments expire
        'Accept-Ranges': 'bytes'
      }
    })

  } catch (error) {
    console.error('FL511 Segment API error:', error)
    return NextResponse.json({
      error: 'Video segment service unavailable',
      details: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 500 })
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