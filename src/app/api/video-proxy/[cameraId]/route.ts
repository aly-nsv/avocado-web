import { NextRequest, NextResponse } from 'next/server'
import { getFloridaCameraStreamInfo, needsAuthentication, isAuthServiceInCooldown } from '@/lib/florida511-auth'

interface CameraVideoRequest {
  cameraId: string
  sourceId?: string
  originalUrl?: string
}

/**
 * Enhanced Video Proxy Endpoint
 * 
 * Returns comprehensive stream information using the improved authentication flow
 */
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ cameraId: string }> }
) {
  try {
    const { cameraId } = await params
    const { searchParams } = new URL(request.url)
    const originalUrl = searchParams.get('originalUrl')

    // Validate required parameters
    if (!cameraId) {
      return NextResponse.json({
        error: 'Camera ID is required'
      }, { status: 400 })
    }

    // If we have an original URL, check if it needs authentication
    if (originalUrl && !needsAuthentication(originalUrl)) {
      // URL doesn't need auth, redirect directly
      return NextResponse.redirect(originalUrl)
    }

    console.log(`🎬 Video Proxy: Processing camera ${cameraId}`)
    console.log(`📹 Video Proxy: Original URL parameter:`, originalUrl)

    // Use the originalUrl parameter passed from the client
    if (!originalUrl) {
      return NextResponse.json({
        error: 'Original URL is required for authentication',
        cameraId
      }, { status: 400 })
    }

    console.log(`✅ Video Proxy: Using provided video URL: ${originalUrl}`)

    // Check if we're in a rate limit cooldown before attempting authentication
    const cooldownStatus = isAuthServiceInCooldown();
    if (cooldownStatus.inCooldown) {
      return NextResponse.json({
        error: 'FL511 rate limit cooldown active',
        cameraId,
        message: `Please wait ${cooldownStatus.remainingSeconds} seconds before trying again. FL511 is temporarily limiting requests.`,
        remainingCooldownSeconds: cooldownStatus.remainingSeconds
      }, { status: 429 })
    }

    // For Florida 511 cameras that need authentication, use enhanced flow
    const streamInfo = await getFloridaCameraStreamInfo(cameraId, originalUrl)

    if (!streamInfo) {
      return NextResponse.json({
        error: 'Unable to retrieve authenticated video stream',
        cameraId,
        message: 'Camera may be offline, authentication failed, or no valid streaming servers found'
      }, { status: 404 })
    }

    // Return comprehensive stream information for client-side handling
    return NextResponse.json({
      cameraId: streamInfo.camera_id,
      secureUrl: streamInfo.streaming_url,
      originalUrl,
      authenticated: true,
      expiresIn: 1800, // 30 minutes typical for streaming tokens
      metadata: {
        totalSegments: streamInfo.segments.length,
        sourceId: streamInfo.step1_video_info.sourceId,
        systemSourceId: streamInfo.step1_video_info.systemSourceId,
        baseUrl: streamInfo.step3_playlist_info.base_url,
        authenticatedAt: new Date().toISOString()
      },
      alternativeEndpoints: {
        streamProxy: `/api/stream-proxy/${cameraId}`,
        playlist: `/api/fl511-playlist/${cameraId}`,
        playlistWithProxy: `/api/fl511-playlist/${cameraId}?proxy=true`,
        authInfo: `/api/fl511-auth/${cameraId}`
      }
    })

  } catch (error) {
    console.error('Enhanced video proxy error:', error)
    return NextResponse.json({
      error: 'Video proxy service unavailable',
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