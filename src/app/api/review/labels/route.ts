import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/lib/database';
import type { SubmitLabelsRequest, SubmitLabelsResponse, VideoSegmentLabel } from '@/types/labeling';

export async function POST(request: NextRequest) {
  try {
    const body: SubmitLabelsRequest = await request.json();
    const { session_id, incident_id, labels, video_selections } = body;

    if (!session_id || !incident_id || !labels || !Array.isArray(labels)) {
      return NextResponse.json(
        { error: 'Missing required fields: session_id, incident_id, labels' },
        { status: 400 }
      );
    }

    // Group labels by segment_id
    const labelsBySegment: Record<number, VideoSegmentLabel[]> = {};
    
    labels.forEach(label => {
      // Find which segments this label applies to based on video selections
      const selectedSegments = video_selections
        .filter(vs => vs.selected)
        .map(vs => vs.segment_id);
      
      selectedSegments.forEach(segmentId => {
        if (!labelsBySegment[segmentId]) {
          labelsBySegment[segmentId] = [];
        }
        labelsBySegment[segmentId].push(label);
      });
    });

    let labelsCreated = 0;
    const errors: string[] = [];

    // Use a transaction to ensure atomicity
    await db.transaction(async (client) => {
      // Update each video segment's labels column
      for (const [segmentIdStr, segmentLabels] of Object.entries(labelsBySegment)) {
        const segment_id = parseInt(segmentIdStr);

        try {
          // First, get current labels to merge with new ones
          const currentResult = await client.query(
            'SELECT labels FROM video_segments WHERE segment_id = $1',
            [segment_id]
          );

          if (currentResult.rows.length === 0) {
            errors.push(`Segment ${segment_id} not found`);
            continue;
          }

          // Merge existing labels with new ones
          const existingLabels = currentResult.rows[0]?.labels || [];
          const allLabels = [...existingLabels, ...segmentLabels];

          // Update the segment with new labels
          const updateResult = await client.query(
            `UPDATE video_segments 
             SET labels = $1, updated_at = CURRENT_TIMESTAMP
             WHERE segment_id = $2`,
            [JSON.stringify(allLabels), segment_id]
          );

          if (updateResult.rowCount === 0) {
            errors.push(`Failed to update segment ${segment_id}`);
            continue;
          }

          labelsCreated += segmentLabels.length;

        } catch (error) {
          const errorMessage = error instanceof Error ? error.message : 'Unknown error';
          errors.push(`Error processing segment ${segment_id}: ${errorMessage}`);
        }
      }
    });

    // Return results
    if (labelsCreated > 0) {
      const response: SubmitLabelsResponse = {
        success: errors.length === 0,
        labels_created: labelsCreated,
        session_id,
        errors: errors.length > 0 ? errors : undefined,
      };

      return NextResponse.json(response, { 
        status: errors.length > 0 ? 207 : 200 // 207 Multi-Status for partial success
      });
    }

    // Complete failure
    return NextResponse.json({
      success: false,
      labels_created: 0,
      session_id,
      errors: errors.length > 0 ? errors : ['Unknown error occurred'],
    }, { status: 500 });

  } catch (error) {
    console.error('Error submitting labels:', error);
    return NextResponse.json({
      success: false,
      labels_created: 0,
      session_id: '',
      errors: [error instanceof Error ? error.message : 'Internal server error'],
    }, { status: 500 });
  }
}