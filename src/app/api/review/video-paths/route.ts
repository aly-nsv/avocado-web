import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/lib/database';

export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    const limit = parseInt(searchParams.get('limit') || '1000');
    const offset = parseInt(searchParams.get('offset') || '0');

    // Query to get video paths with all filter types selected (OR logic)
    const videoPathsQuery = `
      SELECT DISTINCT
        v.segment_id,
        v.camera_id,
        v.segment_filename,
        v.storage_bucket,
        v.storage_path,
        v.storage_url,
        v.segment_duration,
        v.segment_size_bytes,
        v.capture_timestamp,
        v.camera_roadway,
        v.camera_county,
        i.incident_id,
        i.incident_type,
        i.description,
        i.roadway_name,
        i.county,
        i.region
      FROM incidents i
      JOIN video_segments v ON i.incident_id = v.incident_id
      WHERE v.avocado_version LIKE '%coffee%'
        AND i.labels IS NOT NULL
        AND i.labels != '[]'
        AND (
          -- All filter conditions combined with OR
          (i.description ILIKE '%Crash%' OR i.description ILIKE '%crash%') OR
          i.description ILIKE '%Accident%' OR
          i.incident_type ILIKE '%Disabled Vehicles%' OR
          i.incident_type ILIKE '%Accident%' OR
          i.incident_type ILIKE '%Other Events%' OR
          i.incident_type ILIKE '%Construction Zones%' OR
          i.incident_type ILIKE '%Incidents%' OR
          i.incident_type ILIKE '%Closures%' OR
          i.incident_type ILIKE '%Road Condition%' OR
          i.incident_type ILIKE '%Congestion%'
        )
      ORDER BY v.capture_timestamp DESC, v.segment_id
      LIMIT $1 OFFSET $2
    `;

    const result = await db.query(videoPathsQuery, [limit, offset]);

    // Get total count for pagination
    const countQuery = `
      SELECT COUNT(DISTINCT v.segment_id) as total
      FROM incidents i
      JOIN video_segments v ON i.incident_id = v.incident_id
      WHERE v.avocado_version LIKE '%coffee%'
        AND i.labels IS NOT NULL
        AND i.labels != '[]'
        AND (
          (i.description ILIKE '%Crash%' OR i.description ILIKE '%crash%') OR
          i.description ILIKE '%Accident%' OR
          i.incident_type ILIKE '%Disabled Vehicles%' OR
          i.incident_type ILIKE '%Accident%' OR
          i.incident_type ILIKE '%Other Events%' OR
          i.incident_type ILIKE '%Construction Zones%' OR
          i.incident_type ILIKE '%Incidents%' OR
          i.incident_type ILIKE '%Closures%' OR
          i.incident_type ILIKE '%Road Condition%' OR
          i.incident_type ILIKE '%Congestion%'
        )
    `;
    
    const countResult = await db.query(countQuery);
    const totalCount = parseInt(countResult.rows[0]?.total || '0');

    // Transform to simple video path format
    const videoPaths = result.rows.map(row => ({
      segment_id: row.segment_id,
      camera_id: row.camera_id,
      segment_filename: row.segment_filename,
      storage_bucket: row.storage_bucket,
      storage_path: row.storage_path,
      storage_url: row.storage_url,
      segment_duration: parseFloat(row.segment_duration) || 0,
      segment_size_bytes: parseInt(row.segment_size_bytes) || 0,
      capture_timestamp: row.capture_timestamp,
      camera_roadway: row.camera_roadway,
      camera_county: row.camera_county,
      incident_id: row.incident_id,
      incident_type: row.incident_type,
      description: row.description,
      roadway_name: row.roadway_name,
      county: row.county,
      region: row.region
    }));

    const response = {
      video_paths: videoPaths,
      total_count: totalCount,
      has_more: totalCount > offset + limit,
      filters_applied: [
        'crash_description',
        'accident_description', 
        'disabled_vehicles',
        'accident_type',
        'other_events',
        'construction_zones',
        'incidents',
        'closures',
        'road_condition',
        'congestion'
      ]
    };

    return NextResponse.json(response);
  } catch (error) {
    console.error('Error fetching video paths:', error);
    return NextResponse.json(
      { error: 'Failed to fetch video paths', details: error instanceof Error ? error.message : 'Unknown error' },
      { status: 500 }
    );
  }
}