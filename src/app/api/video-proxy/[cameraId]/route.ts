import { NextRequest, NextResponse } from 'next/server'
import { getFloridaCameraVideoUrl, needsAuthentication } from '@/lib/florida511-auth'

interface CameraVideoRequest {
  cameraId: string
  sourceId?: string
  originalUrl?: string
}

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ cameraId: string }> }
) {
  try {
    const { cameraId } = await params
    const { searchParams } = new URL(request.url)
    const sourceId = searchParams.get('sourceId')
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

    // For Florida 511 cameras that need authentication
    const secureUrl = await getFloridaCameraVideoUrl(cameraId, sourceId || '')

    if (!secureUrl) {
      return NextResponse.json({
        error: 'Unable to retrieve authenticated video URL',
        cameraId,
        message: 'Camera may be offline or authentication failed'
      }, { status: 404 })
    }

    // Return the secure URL in JSON format for client-side handling
    return NextResponse.json({
      cameraId,
      secureUrl,
      originalUrl,
      authenticated: true,
      expiresIn: 1800 // 30 minutes typical for streaming tokens
    })

  } catch (error) {
    console.error('Video proxy error:', error)
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