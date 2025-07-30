import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@supabase/supabase-js'

interface SupabaseCameraQuery {
  id: string
  external_id: string
  name: string
  description: string | null
  latitude: number
  longitude: number
  state_code: string
  region: string | null
  county: string | null
  roadway: string | null
  direction: string | null
  mile_marker: string | null
  location_description: string | null
  status: string
  video_url: string | null
  thumbnail_url: string | null
  equipment_metadata: any
  created_at: string
  updated_at: string
}

interface TransformedCameraV2 {
  id: string
  externalId: string
  name: string
  description: string | null
  lat: number
  lng: number
  state: string
  region: string | null
  county: string | null
  roadway: string | null
  direction: string | null
  mileMarker: string | null
  locationDescription: string | null
  status: 'active' | 'inactive' | 'maintenance' | 'offline'
  videoUrl: string | null
  thumbnailUrl: string | null
  equipmentType: string | null
  lastUpdated: string
}

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ state: string }> }
) {
  try {
    const { state } = await params
    const { searchParams } = new URL(request.url)
    const region = searchParams.get('region')
    const limit = parseInt(searchParams.get('limit') || '50', 10)
    const offset = parseInt(searchParams.get('offset') || '0', 10)
    const status = searchParams.get('status') || 'active'

    // Validate state code
    const stateCode = state.toUpperCase()
    if (stateCode.length !== 2) {
      return NextResponse.json({ 
        error: 'Invalid state code. Please provide a 2-letter state code.',
        cameras: [] 
      }, { status: 400 })
    }

    // Use service role key for admin access to database
    const supabase = createClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.SUPABASE_SERVICE_ROLE_KEY!
    )

    // Build query
    let query = supabase
      .from('traffic_cameras')
      .select(`
        id,
        external_id,
        name,
        description,
        latitude,
        longitude,
        state_code,
        region,
        county,
        roadway,
        direction,
        mile_marker,
        location_description,
        status,
        video_url,
        thumbnail_url,
        equipment_metadata,
        created_at,
        updated_at
      `)
      .eq('state_code', stateCode)
      .eq('status', status)
      .order('name', { ascending: true })

    // Add region filter if specified
    if (region) {
      query = query.ilike('region', `%${region}%`)
    }

    // Add pagination
    query = query.range(offset, offset + limit - 1)

    const { data: cameras, error, count } = await query

    if (error) {
      console.error('Supabase query error:', error)
      return NextResponse.json({
        error: 'Failed to fetch camera data from database',
        details: error.message,
        cameras: []
      }, { status: 500 })
    }

    if (!cameras || cameras.length === 0) {
      return NextResponse.json({
        cameras: [],
        total: 0,
        state: stateCode,
        region: region || 'All',
        message: `No cameras found for ${stateCode}${region ? ` in ${region} region` : ''}`,
        metadata: {
          dataSource: 'supabase',
          version: 'v2',
          pagination: {
            limit,
            offset,
            hasMore: false
          }
        }
      })
    }

    // Transform data to consistent API format
    const transformedCameras: TransformedCameraV2[] = cameras.map((camera: SupabaseCameraQuery) => ({
      id: camera.id,
      externalId: camera.external_id,
      name: camera.name,
      description: camera.description,
      lat: camera.latitude,
      lng: camera.longitude,
      state: camera.state_code,
      region: camera.region,
      county: camera.county,
      roadway: camera.roadway,
      direction: camera.direction,
      mileMarker: camera.mile_marker,
      locationDescription: camera.location_description,
      status: camera.status as 'active' | 'inactive' | 'maintenance' | 'offline',
      videoUrl: camera.video_url,
      thumbnailUrl: camera.thumbnail_url,
      equipmentType: camera.equipment_metadata?.equipment_type || null,
      lastUpdated: camera.updated_at
    }))

    return NextResponse.json({
      cameras: transformedCameras,
      total: transformedCameras.length,
      state: stateCode,
      region: region || 'All',
      metadata: {
        dataSource: 'supabase',
        version: 'v2',
        pagination: {
          limit,
          offset,
          hasMore: transformedCameras.length === limit
        },
        query: {
          state: stateCode,
          region,
          status,
          filters_applied: !!region
        }
      }
    })

  } catch (error) {
    console.error('API v2 error:', error)
    return NextResponse.json({
      error: 'Internal server error',
      cameras: []
    }, { status: 500 })
  }
}