import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/lib/database';
import type { GetIncidentsResponse, ReviewIncidentData } from '@/types/labeling';

export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    const limit = parseInt(searchParams.get('limit') || '100');
    const offset = parseInt(searchParams.get('offset') || '0');
    const filtersParam = searchParams.get('filters') || 'crash_description';
    const filters = filtersParam.split(',').filter(f => f.trim());

    // Generate individual filter condition
    const getSingleFilterCondition = (filterType: string) => {
      switch (filterType) {
        case 'crash_description':
          return `(i.description ILIKE '%Crash%' OR i.description ILIKE '%crash%')`;
        case 'accident_description':
          return `i.description ILIKE '%Accident%'`;
        case 'disabled_vehicles':
          return `i.incident_type ILIKE '%Disabled Vehicles%'`;
        case 'accident_type':
          return `i.incident_type ILIKE '%Accident%'`;
        case 'other_events':
          return `i.incident_type ILIKE '%Other Events%'`;
        case 'construction_zones':
          return `i.incident_type ILIKE '%Construction Zones%'`;
        case 'incidents':
          return `i.incident_type ILIKE '%Incidents%'`;
        case 'closures':
          return `i.incident_type ILIKE '%Closures%'`;
        case 'road_condition':
          return `i.incident_type ILIKE '%Road Condition%'`;
        case 'congestion':
          return `i.incident_type ILIKE '%Congestion%'`;
        default:
          return `(i.description ILIKE '%Crash%' OR i.description ILIKE '%crash%')`;
      }
    };

    // Generate combined filter condition with OR logic for multiple filters
    const getMultipleFilterCondition = (filterTypes: string[]) => {
      if (filterTypes.length === 0) {
        return 'AND (i.description ILIKE \'%Crash%\' OR i.description ILIKE \'%crash%\')';
      }
      
      const conditions = filterTypes.map(filterType => getSingleFilterCondition(filterType));
      return `AND (${conditions.join(' OR ')})`;
    };

    // Query to get incidents with their video segments (coffee version only)
    // Using the exact query structure from the user's requirements
    const incidentsQuery = `
      SELECT 
        i.incident_id,
        i.dt_row_id,
        i.source_id,
        i.roadway_name,
        i.county,
        i.region,
        i.incident_type,
        i.severity,
        i.direction,
        i.description,
        i.start_date,
        i.last_updated,
        i.end_date,
        i.source,
        i.dot_district,
        i.location_description,
        i.detour_description,
        i.lane_description,
        i.scraped_at,
        i.created_at,
        i.updated_at,
        i.labels,
        v.segment_id,
        v.camera_id,
        v.segment_filename,
        v.storage_bucket,
        v.storage_path,
        v.storage_url,
        v.segment_duration,
        v.segment_size_bytes,
        v.segment_index,
        v.program_date_time,
        v.capture_timestamp,
        v.capture_session_id,
        v.camera_latitude,
        v.camera_longitude,
        v.camera_roadway,
        v.camera_region,
        v.camera_county,
        v.avocado_version,
        v.labels as video_labels,
        v.created_at as video_created_at
      FROM incidents i
      JOIN video_segments v ON i.incident_id = v.incident_id
      WHERE v.avocado_version LIKE '%coffee%'
        AND i.labels IS NOT NULL
        AND i.labels != '[]'
        ${getMultipleFilterCondition(filters)}
        AND i.updated_at > '2025-09-14'::timestamp
      ORDER BY i.incident_id, v.segment_id
      LIMIT $1 OFFSET $2
    `;

    const result = await db.query(incidentsQuery, [limit, offset]);
    console.log('=========LENGTH=========', result.rows.length);

    // Group results by incident_id
    const incidentMap = new Map<number, any>();
    let count = 0;
    
    result.rows.forEach((row: any) => {
      
      const incidentId = row.incident_id;
      
      if (!incidentMap.has(incidentId)) {
        count++;
        incidentMap.set(incidentId, {
          incident: {
            incident_id: row.incident_id,
            dt_row_id: row.dt_row_id,
            source_id: row.source_id,
            roadway_name: row.roadway_name,
            county: row.county,
            region: row.region,
            incident_type: row.incident_type,
            severity: row.severity,
            direction: row.direction,
            description: row.description,
            start_date: row.start_date,
            last_updated: row.last_updated,
            end_date: row.end_date,
            source: row.source,
            dot_district: row.dot_district,
            location_description: row.location_description,
            detour_description: row.detour_description,
            lane_description: row.lane_description,
            scraped_at: row.scraped_at,
            created_at: row.created_at,
            updated_at: row.updated_at,
            labels: row.labels || [],
          },
          video_segments: [],
          cameras_involved: new Set<string>()
        });
      }

      const incident = incidentMap.get(incidentId);
      
      // Add video segment
      incident.video_segments.push({
        segment_id: row.segment_id,
        camera_id: row.camera_id,
        segment_filename: row.segment_filename,
        storage_bucket: row.storage_bucket,
        storage_path: row.storage_path,
        storage_url: row.storage_url,
        segment_duration: parseFloat(row.segment_duration) || 0,
        segment_size_bytes: parseInt(row.segment_size_bytes) || 0,
        segment_index: row.segment_index,
        program_date_time: row.program_date_time,
        capture_timestamp: row.capture_timestamp,
        capture_session_id: row.capture_session_id,
        camera_latitude: parseFloat(row.camera_latitude) || 0,
        camera_longitude: parseFloat(row.camera_longitude) || 0,
        camera_roadway: row.camera_roadway,
        camera_region: row.camera_region,
        camera_county: row.camera_county,
        incident_id: row.incident_id,
        avocado_version: row.avocado_version,
        labels: row.labels || [],
        created_at: row.video_created_at,
      });

      // Track camera
      incident.cameras_involved.add(row.camera_id);
    });

    // Transform to final format
    const reviewIncidents: ReviewIncidentData[] = Array.from(incidentMap.values()).map(incident => ({
      ...incident,
      cameras_involved: Array.from(incident.cameras_involved),
      total_segments: incident.video_segments.length
    }));

    // Get total count for pagination
    const countQuery = `
      SELECT COUNT(DISTINCT i.incident_id) as total
      FROM incidents i
      JOIN video_segments v ON i.incident_id = v.incident_id
      WHERE v.avocado_version LIKE '%coffee%'
        AND i.labels IS NOT NULL
        AND i.labels != '[]'
        ${getMultipleFilterCondition(filters)}
    `;
    
    const countResult = await db.query(countQuery);
    const totalCount = parseInt(countResult.rows[0]?.total || '0');
    console.log('=========TOTAL COUNT=========', totalCount);

    const response: GetIncidentsResponse = {
      incidents: reviewIncidents,
      total_count: totalCount,
      has_more: totalCount > offset + limit,
    };

    return NextResponse.json(response);
  } catch (error) {
    console.error('Error fetching incidents:', error);
    return NextResponse.json(
      { error: 'Failed to fetch incidents', details: error instanceof Error ? error.message : 'Unknown error' },
      { status: 500 }
    );
  }
}