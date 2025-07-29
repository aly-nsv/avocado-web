import { NextResponse } from 'next/server';
import { CorridorData } from '@/types/dashboard';

// Mock corridor data generator
function generateCorridorData(stateCode: string): CorridorData {
  // This would typically come from a real GIS database
  // For now, we'll return empty collections that MapBox can handle
  return {
    highways: {
      type: 'FeatureCollection',
      features: [
        {
          type: 'Feature',
          properties: {
            name: `I-94 ${stateCode}`,
            type: 'interstate',
            lanes: 4,
          },
          geometry: {
            type: 'LineString',
            coordinates: stateCode === 'MI' ? [
              [-83.0458, 42.3314], // Detroit area
              [-84.5555, 42.3314], // Westward
            ] : [
              [-99.9018, 31.9686], // Default center coordinates
              [-99.0000, 32.0000],
            ],
          },
        },
        {
          type: 'Feature',
          properties: {
            name: `I-75 ${stateCode}`,
            type: 'interstate',
            lanes: 6,
          },
          geometry: {
            type: 'LineString',
            coordinates: stateCode === 'MI' ? [
              [-83.0458, 42.3314], // Detroit
              [-83.0458, 43.0000], // Northward
            ] : [
              [-99.9018, 31.9686], // Default center coordinates
              [-99.0000, 33.0000],
            ],
          },
        },
      ],
    },
    infrastructure: {
      type: 'FeatureCollection',
      features: [
        {
          type: 'Feature',
          properties: {
            name: `Traffic Camera ${stateCode}-001`,
            type: 'camera',
            status: 'active',
          },
          geometry: {
            type: 'Point',
            coordinates: stateCode === 'MI' ? [-83.0458, 42.3314] : [-99.9018, 31.9686],
          },
        },
        {
          type: 'Feature',
          properties: {
            name: `Weigh Station ${stateCode}-001`,
            type: 'weigh_station',
            status: 'operational',
          },
          geometry: {
            type: 'Point',
            coordinates: stateCode === 'MI' ? [-83.2000, 42.4000] : [-99.5000, 32.2000],
          },
        },
      ],
    },
  };
}

export async function GET(
  request: Request,
  { params }: { params: Promise<{ state: string }> }
) {
  const { state: stateCode } = await params;
  
  // Simulate API delay
  await new Promise(resolve => setTimeout(resolve, 200));
  
  const corridorData = generateCorridorData(stateCode);
  
  return NextResponse.json(corridorData);
}