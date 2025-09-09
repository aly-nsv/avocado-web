import { NextRequest, NextResponse } from 'next/server';
import type { GetAISuggestionsRequest, GetAISuggestionsResponse, AISuggestion } from '@/types/labeling';

export async function POST(request: NextRequest) {
  try {
    const body: GetAISuggestionsRequest = await request.json();
    const { incident_description, incident_type } = body;

    if (!incident_description || !incident_type) {
      return NextResponse.json(
        { error: 'Missing required fields: incident_description, incident_type' },
        { status: 400 }
      );
    }

    const openaiApiKey = process.env.OPENAI_API_KEY;
    if (!openaiApiKey) {
      return NextResponse.json(
        { error: 'OpenAI API key not configured' },
        { status: 500 }
      );
    }

    const startTime = Date.now();

    // Create the prompt for OpenAI
    const systemPrompt = `You are an AI assistant helping to label traffic incidents in video footage for machine learning dataset creation. 

Given an incident description and type, suggest which of these label types are most likely to be visible in video footage of the incident:

INCIDENT TYPES:
- collision: Vehicle-to-vehicle or vehicle-to-object impacts
- stationary_vehicle: Stopped vehicles in travel lanes
- impediment: Objects blocking traffic flow
- vru_incident: Incidents involving pedestrians, cyclists, motorcyclists
- fod_hazardous_material: Chemical spills or hazardous materials
- fod_generic_debris: Non-hazardous debris on roadway
- fatal: Incidents likely involving fatalities
- roadway_departure: Vehicles leaving the roadway
- queue_present: Lines of stopped/slow vehicles
- congestion: Heavy traffic conditions
- harsh_braking: Sudden braking events
- swerving: Erratic vehicle movements
- cmv_involved: Commercial vehicles involved
- speeding: Excessive speed violations

ACTOR TYPES:
- passenger_vehicle: Cars, SUVs, personal vehicles
- commercial_vehicle: Trucks, delivery vans, semi-trailers
- emergency_vehicle: Police, fire, ambulance
- motorcycle: Two/three-wheeled motorized vehicles
- pedestrian: People on foot
- debris_generic: Objects on roadway
- hazmat_presence: Hazardous material indicators
- disabled_vehicle: Broken down vehicles
- bus: Transit, school, or coach buses
- bicycle: Pedal or e-bikes
- trailer: Towed units
- tire: Loose tires or tire debris
- channelizing_device: Traffic cones, barrels
- heavy_equipment: Construction equipment
- unspecified_actor: Unidentifiable objects

Respond with a JSON array of suggested labels, each with a label_type, confidence (0.0-1.0), and brief reasoning.`;

    const userPrompt = `Incident Type: ${incident_type}
Description: ${incident_description}

Please suggest relevant labels that would likely be visible in video footage of this incident.`;

    try {
      const response = await fetch('https://api.openai.com/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${openaiApiKey}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          model: 'gpt-4o-mini', // Use the more cost-effective model
          messages: [
            { role: 'system', content: systemPrompt },
            { role: 'user', content: userPrompt }
          ],
          temperature: 0.3, // Low temperature for more consistent results
          max_tokens: 1000,
          response_format: { type: 'json_object' }
        }),
      });

      if (!response.ok) {
        const errorText = await response.text();
        console.error('OpenAI API error:', response.status, errorText);
        return NextResponse.json(
          { error: 'OpenAI API request failed' },
          { status: 500 }
        );
      }

      const openaiResult = await response.json();
      const content = openaiResult.choices[0]?.message?.content;

      if (!content) {
        return NextResponse.json(
          { error: 'No response from OpenAI' },
          { status: 500 }
        );
      }

      // Parse the JSON response
      let suggestions: AISuggestion[];
      try {
        const parsed = JSON.parse(content);
        suggestions = parsed.suggestions || parsed.labels || [];
      } catch (parseError) {
        console.error('Failed to parse OpenAI response:', content);
        return NextResponse.json(
          { error: 'Invalid response format from OpenAI' },
          { status: 500 }
        );
      }

      // Validate and sanitize suggestions
      const validSuggestions: AISuggestion[] = suggestions
        .filter(s => s.label_type && typeof s.confidence === 'number' && s.reasoning)
        .map(s => ({
          label_type: s.label_type,
          confidence: Math.max(0, Math.min(1, s.confidence)), // Clamp between 0-1
          reasoning: s.reasoning
        }))
        .slice(0, 10); // Limit to 10 suggestions max

      const processingTime = Date.now() - startTime;

      const response_data: GetAISuggestionsResponse = {
        suggestions: validSuggestions,
        model_used: 'gpt-4o-mini',
        processing_time_ms: processingTime,
      };

      return NextResponse.json(response_data);

    } catch (fetchError) {
      console.error('Error calling OpenAI API:', fetchError);
      return NextResponse.json(
        { error: 'Failed to get AI suggestions' },
        { status: 500 }
      );
    }

  } catch (error) {
    console.error('Unexpected error in AI suggestions API:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}