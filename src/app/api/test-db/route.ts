import { NextResponse } from 'next/server';
import { db } from '@/lib/database';

export async function GET() {
  try {
    // Test database connection
    const isConnected = await db.testConnection();
    
    if (!isConnected) {
      return NextResponse.json({ 
        success: false, 
        message: 'Database connection failed' 
      }, { status: 500 });
    }

    // Test a simple query to check if our tables exist
    const tablesResult = await db.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      AND table_name IN ('incidents', 'video_segments')
      ORDER BY table_name
    `);

    // Test if we can query incidents with video segments
    const sampleQuery = `
      SELECT COUNT(DISTINCT i.incident_id) as incident_count,
             COUNT(v.segment_id) as segment_count
      FROM incidents i
      LEFT JOIN video_segments v ON i.incident_id = v.incident_id
      WHERE v.avocado_version LIKE '%coffee%'
    `;
    
    const sampleResult = await db.query(sampleQuery);
    
    return NextResponse.json({
      success: true,
      message: 'Database connection successful',
      tables: tablesResult.rows.map(r => r.table_name),
      data_summary: sampleResult.rows[0]
    });

  } catch (error) {
    console.error('Database test error:', error);
    return NextResponse.json({
      success: false,
      message: 'Database test failed',
      error: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 500 });
  }
}