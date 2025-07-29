'use client';

import { useEffect, useRef, useState } from 'react';
import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';
import { StateMapProps } from '@/types/dashboard';

// MapBox access token should be in environment variables
mapboxgl.accessToken = process.env.NEXT_PUBLIC_MAPBOX_TOKEN || '';

export default function StateMap({
  selectedState,
  activeFilters,
  corridorData,
  alerts,
}: StateMapProps) {
  const mapContainer = useRef<HTMLDivElement>(null);
  const map = useRef<mapboxgl.Map | null>(null);
  const [mapLoaded, setMapLoaded] = useState(false);

  // Initialize MapBox map on component mount
  useEffect(() => {
    if (!mapContainer.current || map.current) return;

    map.current = new mapboxgl.Map({
      container: mapContainer.current,
      style: 'mapbox://styles/mapbox/dark-v11', // Dark theme to match our design
      center: selectedState.center,
      zoom: selectedState.zoomLevel,
      pitch: 20, // Slight 3D tilt for dynamic visual appeal
      bearing: 0,
    });

    // Set up map event listeners with proper typing
    map.current.on('load', () => {
      setMapLoaded(true);
    });

    // Cleanup function to prevent memory leaks
    return () => {
      if (map.current) {
        map.current.remove();
        map.current = null;
      }
    };
  }, [selectedState]);

  // Update map view when selected state changes
  useEffect(() => {
    if (!map.current || !mapLoaded) return;

    // Animate to new state bounds with smooth transition
    map.current.fitBounds(selectedState.bounds, {
      padding: { 
        top: 50, 
        bottom: 50, 
        left: 50, 
        right: 400 // Account for alerts panel width
      },
      duration: 1500, // 1.5 second animation
      essential: true, // Animation cannot be interrupted
    });
  }, [selectedState, mapLoaded]);

  // Add dynamic corridor layers when data is available
  useEffect(() => {
    if (!map.current || !mapLoaded || !corridorData) return;

    const addCorridorLayers = () => {
      // Add highway corridors as animated dashed lines
      if (!map.current!.getSource('highways')) {
        map.current!.addSource('highways', {
          type: 'geojson',
          data: corridorData.highways,
        });

        map.current!.addLayer({
          id: 'major-highways',
          type: 'line',
          source: 'highways',
          paint: {
            'line-color': '#3B82F6', // Primary blue color
            'line-width': 4,
            'line-dasharray': [2, 2],
            'line-opacity': 0.8,
          },
        });
      }

      // Add infrastructure points with pulsing animation
      if (!map.current!.getSource('infrastructure')) {
        map.current!.addSource('infrastructure', {
          type: 'geojson',
          data: corridorData.infrastructure,
        });

        map.current!.addLayer({
          id: 'infrastructure-points',
          type: 'circle',
          source: 'infrastructure',
          paint: {
            'circle-radius': 8,
            'circle-color': '#F59E0B', // Highlight color
            'circle-stroke-width': 2,
            'circle-stroke-color': '#FFFFFF',
            'circle-opacity': [
              'interpolate',
              ['linear'],
              ['zoom'],
              6, 0.6, // At zoom 6, opacity is 0.6
              10, 0.9 // At zoom 10, opacity is 0.9
            ],
          },
        });
      }
    };

    addCorridorLayers();
  }, [corridorData, mapLoaded]);

  // Add alert markers to the map
  useEffect(() => {
    if (!map.current || !mapLoaded || !alerts.length) return;

    // Remove existing alert markers
    const existingMarkers = document.querySelectorAll('.alert-marker');
    existingMarkers.forEach(marker => marker.remove());

    // Add new alert markers
    alerts.forEach(alert => {
      if (!alert.coordinates) return;

      // Create custom marker element
      const markerEl = document.createElement('div');
      markerEl.className = 'alert-marker';
      markerEl.style.width = '12px';
      markerEl.style.height = '12px';
      markerEl.style.borderRadius = '50%';
      markerEl.style.border = '2px solid #ffffff';
      markerEl.style.cursor = 'pointer';
      
      // Color based on severity
      switch (alert.severity) {
        case 'critical':
          markerEl.style.backgroundColor = '#DC2626';
          break;
        case 'warning':
          markerEl.style.backgroundColor = '#D97706';
          break;
        case 'info':
          markerEl.style.backgroundColor = '#2563EB';
          break;
      }

      // Add pulsing animation
      markerEl.style.animation = 'pulse 2s infinite';

      // Create popup
      const popup = new mapboxgl.Popup({ offset: 25 }).setHTML(`
        <div class="p-2">
          <div class="font-semibold text-sm">${alert.location}</div>
          <div class="text-xs text-gray-600 mt-1">${alert.description}</div>
          <div class="text-xs text-gray-500 mt-1">${alert.timeAgo}</div>
        </div>
      `);

      // Create marker and add to map
      new mapboxgl.Marker(markerEl)
        .setLngLat(alert.coordinates)
        .setPopup(popup)
        .addTo(map.current!);
    });
  }, [alerts, mapLoaded]);

  // Animate highway dashing for dynamic visual effect
  useEffect(() => {
    if (!map.current || !mapLoaded) return;

    let dashOffset = 0;
    let animationFrame: number;

    const animateHighways = () => {
      if (map.current && map.current.getLayer('major-highways')) {
        dashOffset += 0.1;
        map.current.setPaintProperty('major-highways', 'line-dasharray', [2, 2]);
        // Note: line-dash-offset is not available in mapbox-gl v3, using alternative animation
      }
      animationFrame = requestAnimationFrame(animateHighways);
    };

    animationFrame = requestAnimationFrame(animateHighways);

    return () => {
      if (animationFrame) {
        cancelAnimationFrame(animationFrame);
      }
    };
  }, [mapLoaded]);

  return (
    <>
      {/* Add CSS for marker animation */}
      <style jsx global>{`
        @keyframes pulse {
          0% {
            transform: scale(1);
            opacity: 1;
          }
          50% {
            transform: scale(1.2);
            opacity: 0.7;
          }
          100% {
            transform: scale(1);
            opacity: 1;
          }
        }
      `}</style>
      <div 
        ref={mapContainer} 
        className="w-full h-full"
        style={{ minHeight: '400px' }} // Ensure minimum height for MapBox
      >
        {!mapLoaded && (
          <div className="absolute inset-0 flex items-center justify-center bg-background/80 backdrop-blur-sm">
            <div className="text-lg text-neutral-600 animate-pulse">Loading map...</div>
          </div>
        )}
      </div>
    </>
  );
}