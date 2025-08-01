import { NextRequest, NextResponse } from 'next/server'
import { getFloridaCameraStreamInfo, type StreamInfo } from '@/lib/florida511-auth'

/**
 * Enhanced FL511 Authentication API Endpoint
 * 
 * Returns complete stream information including:
 * - Authenticated streaming URL
 * - Available video segments
 * - Playlist information
 * - Authentication metadata
 */
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ cameraId: string }> }
) {
  try {
    const { cameraId } = await params

    // Validate required parameters
    if (!cameraId) {
      return NextResponse.json({
        error: 'Camera ID is required'
      }, { status: 400 })
    }

    console.log(`FL511 Auth API: Processing camera ${cameraId}`)

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

    // Execute the complete 4-step authentication flow
    const streamInfo: StreamInfo | null = await getFloridaCameraStreamInfo(cameraId, cameraVideoUrl)

    if (!streamInfo) {
      return NextResponse.json({
        error: 'Unable to authenticate and retrieve stream information',
        cameraId,
        message: 'Camera may be offline, authentication failed, or no valid streaming servers found'
      }, { status: 404 })
    }

    // Return comprehensive streaming information
    return NextResponse.json({
      success: true,
      cameraId: streamInfo.camera_id,
      streamingUrl: streamInfo.streaming_url,
      segments: streamInfo.segments.map(segment => ({
        url: segment.url,
        filename: segment.filename,
        duration: segment.duration,
        programDateTime: segment.program_date_time
      })),
      metadata: {
        totalSegments: streamInfo.segments.length,
        baseUrl: streamInfo.step3_playlist_info.base_url,
        authenticatedAt: new Date().toISOString(),
        expiresIn: 1800, // 30 minutes typical for streaming tokens
        step1Info: {
          token: streamInfo.step1_video_info.token ? '[REDACTED]' : undefined,
          sourceId: streamInfo.step1_video_info.sourceId,
          systemSourceId: streamInfo.step1_video_info.systemSourceId,
          originalVideoUrl: streamInfo.step1_video_info.videoUrl || streamInfo.step1_video_info.url
        }
      }
    })

  } catch (error) {
    console.error('FL511 Auth API error:', error)
    return NextResponse.json({
      error: 'FL511 authentication service unavailable',
      details: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 500 })
  }
}

// Handle preflight CORS requests
export async function OPTIONS(request: NextRequest) {
  return new NextResponse(null, {
    status: 200,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    },
  })
}