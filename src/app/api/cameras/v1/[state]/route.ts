import { NextRequest, NextResponse } from 'next/server'
import fs from 'fs'
import path from 'path'

interface CameraData {
  id: string
  name: string
  description: string
  latitude: number
  longitude: number
  install_date: string
  equipment_type: string
  region: string
  county: string
  roadway: string
  location: string
  direction: string
  sort_order: number
  video_url: string
  thumbnail_url: string
  status: string
  raw_data: any
}

interface TransformedCamera {
  id: string
  name: string
  lat: number
  lng: number
  region: string
  county: string
  roadway: string
  direction: string
  videoUrl: string
  thumbnailUrl: string
  status: 'active' | 'inactive' | 'maintenance' | 'offline'
  sourceId: string | null
  systemSource: string | null
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
    const minZoom = parseInt(searchParams.get('minZoom') || '8', 10)

    if (state.toLowerCase() !== 'florida' && state.toLowerCase() !== 'fl') {
      return NextResponse.json({ 
        cameras: [], 
        message: 'Only Florida camera data is currently available' 
      })
    }

    const dataPath = path.join(process.cwd(), 'avocado-data-scraping', 'fl511_cameras_complete_florida_20250730_135338.json')
    
    if (!fs.existsSync(dataPath)) {
      return NextResponse.json({ 
        error: 'Camera data file not found',
        cameras: [] 
      }, { status: 404 })
    }

    const rawData = fs.readFileSync(dataPath, 'utf8')
    const cameras: CameraData[] = JSON.parse(rawData)

    let filteredCameras = cameras.filter(camera => 
      camera.status === 'active' && 
      camera.latitude && 
      camera.longitude
    )

    if (region) {
      filteredCameras = filteredCameras.filter(camera => 
        camera.region?.toLowerCase().includes(region.toLowerCase())
      )
    }

    filteredCameras = filteredCameras.slice(0, limit)

    const transformedCameras: TransformedCamera[] = filteredCameras.map(camera => ({
      id: camera.id,
      name: camera.name,
      lat: camera.latitude,
      lng: camera.longitude,
      region: camera.region,
      county: camera.county,
      roadway: camera.roadway,
      direction: camera.direction,
      videoUrl: camera.video_url,
      thumbnailUrl: camera.thumbnail_url,
      status: 'active',
      sourceId: camera.raw_data?.sourceId || null,
      systemSource: camera.raw_data?.source || null
    }))

    return NextResponse.json({
      cameras: transformedCameras,
      total: transformedCameras.length,
      state: 'Florida',
      region: region || 'All',
      metadata: {
        dataSource: 'fl511',
        lastUpdated: '2025-07-30T13:53:38.000Z',
        minZoomLevel: minZoom
      }
    })

  } catch (error) {
    console.error('Error fetching camera data:', error)
    return NextResponse.json({
      error: 'Failed to fetch camera data',
      cameras: []
    }, { status: 500 })
  }
}