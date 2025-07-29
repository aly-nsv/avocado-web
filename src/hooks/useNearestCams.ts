import { useMemo } from 'react';

interface Camera {
  id: string;
  state: string;
  coords: [number, number];
  road: string;
  road_class: 'motorway' | 'trunk' | 'primary' | 'secondary' | 'tertiary';
  functional_class: number;
  milepost: number;
  status: 'online' | 'offline';
  stream_url: string | null;
  priority: 'high' | 'medium' | 'low';
}

// Haversine distance formula
function haversineDistance(
  lat1: number,
  lon1: number,
  lat2: number,
  lon2: number
): number {
  const R = 3959; // Earth's radius in miles
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLon = ((lon2 - lon1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

// Helper to determine if a camera is upstream or downstream based on milepost
function isUpstream(alertCoords: [number, number], camera: Camera, referencePoint?: [number, number]): boolean {
  // Simple logic: if we have reference point, use that to determine direction
  // Otherwise, use milepost as a proxy (lower milepost = upstream)
  if (referencePoint) {
    const alertToRef = haversineDistance(alertCoords[1], alertCoords[0], referencePoint[1], referencePoint[0]);
    const camToRef = haversineDistance(camera.coords[1], camera.coords[0], referencePoint[1], referencePoint[0]);
    return camToRef < alertToRef;
  }
  // Fallback to milepost-based logic
  return true; // For now, just return the closest cameras
}

export function useNearestCams(
  alertCoords: [number, number] | null,
  road: string | null,
  cameras: Camera[]
): { camUp: Camera | null; camDown: Camera | null } {
  return useMemo(() => {
    if (!alertCoords || !road || cameras.length === 0) {
      return { camUp: null, camDown: null };
    }

    // Filter cameras on the same road (fuzzy matching)
    const samRoadCameras = cameras.filter(camera => 
      camera.road.toLowerCase().includes(road.toLowerCase()) ||
      road.toLowerCase().includes(camera.road.toLowerCase())
    );

    if (samRoadCameras.length === 0) {
      // If no cameras on same road, get closest 2 cameras overall
      const allCameraDistances = cameras
        .map(camera => ({
          camera,
          distance: haversineDistance(
            alertCoords[1], // lat
            alertCoords[0], // lon
            camera.coords[1], // lat
            camera.coords[0]  // lon
          )
        }))
        .sort((a, b) => a.distance - b.distance);

      return {
        camUp: allCameraDistances[0]?.camera || null,
        camDown: allCameraDistances[1]?.camera || null
      };
    }

    // Calculate distances for same-road cameras
    const cameraDistances = samRoadCameras
      .map(camera => ({
        camera,
        distance: haversineDistance(
          alertCoords[1], // lat
          alertCoords[0], // lon
          camera.coords[1], // lat
          camera.coords[0]  // lon
        )
      }))
      .sort((a, b) => a.distance - b.distance);

    // Get the two closest cameras
    const closest = cameraDistances[0]?.camera || null;
    const secondClosest = cameraDistances[1]?.camera || null;

    // For now, assign upstream/downstream based on milepost
    // In a real implementation, you'd use road geometry and direction
    if (closest && secondClosest) {
      if (closest.milepost < secondClosest.milepost) {
        return { camUp: closest, camDown: secondClosest };
      } else {
        return { camUp: secondClosest, camDown: closest };
      }
    }

    // If only one camera found
    if (closest) {
      return { camUp: closest, camDown: null };
    }

    return { camUp: null, camDown: null };
  }, [alertCoords, road, cameras]);
}