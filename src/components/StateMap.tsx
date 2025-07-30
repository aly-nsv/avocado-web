'use client';

import { useEffect, useRef, useState } from 'react';
import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';
import { StateMapProps, FloridaCamera } from '@/types/dashboard';

// MapBox access token should be in environment variables
mapboxgl.accessToken = process.env.NEXT_PUBLIC_MAPBOX_TOKEN || '';

// Network Map interfaces
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

interface MapAlert {
  id: string;
  type: string;
  subtype?: string;
  coords: [number, number];
  timestamp: string;
  source: 'Waze' | 'ConnectedVehicle';
  confidence: number;
  speed?: number;
  road: string;
  road_class: 'motorway' | 'trunk' | 'primary' | 'secondary' | 'tertiary';
  functional_class: number;
  impact_score: number;
}

interface Incident {
  id: string;
  primary_alert_id: string;
  camera_upstream: string;
  camera_downstream: string;
  actors: string[];
  insights: Array<{
    t: string;
    type: string;
    description: string;
  }>;
  status: 'open' | 'monitoring' | 'responding' | 'scheduled';
  severity: 'minor' | 'major';
  coords: [number, number];
}

export default function StateMap({
  selectedState,
  activeFilters,
  corridorData,
  alerts,
  onCameraClick,
  onAlertClick,
  onIncidentClick,
}: StateMapProps & { 
  onCameraClick?: (camera: Camera) => void;
  onAlertClick?: (alert: MapAlert) => void;
  onIncidentClick?: (incident: Incident) => void;
}) {
  const mapContainer = useRef<HTMLDivElement>(null);
  const map = useRef<mapboxgl.Map | null>(null);
  const [mapLoaded, setMapLoaded] = useState(false);
  const [mockData, setMockData] = useState<{
    highways: any;
    cameras: Camera[];
    alerts: MapAlert[];
    incidents: Incident[];
    videoFootage: any[];
    mlInsights: any[];
    gapZones: any[];
  }>({ highways: null, cameras: [], alerts: [], incidents: [], videoFootage: [], mlInsights: [], gapZones: [] });
  
  const [floridaCameras, setFloridaCameras] = useState<FloridaCamera[]>([]);
  const [selectedHighway, setSelectedHighway] = useState<string | null>(null);
  const [showAllStates, setShowAllStates] = useState(false);

  // Load mock data on mount
  useEffect(() => {
    const loadMockData = async () => {
      try {
        const [highwaysRes, camerasRes, alertsRes, incidentsRes, videoRes, mlRes, gapRes] = await Promise.all([
          fetch('/mock/map/major_highways.geojson'),
          fetch('/mock/map/cameras.json'),
          fetch('/mock/map/alerts.json'),
          fetch('/mock/map/incidents.json'),
          fetch('/mock/map/video_footage.json'),
          fetch('/mock/map/ml_insights.json'),
          fetch('/mock/map/gap_zones.json')
        ]);

        // Check if all requests were successful
        const responses = [highwaysRes, camerasRes, alertsRes, incidentsRes, videoRes, mlRes, gapRes];
        const failedRequests = responses.filter(res => !res.ok);
        
        if (failedRequests.length > 0) {
          console.error(`Failed to fetch ${failedRequests.length} mock data files`);
          failedRequests.forEach((res, index) => {
            const fileNames = ['major_highways.geojson', 'cameras.json', 'alerts.json', 'incidents.json', 'video_footage.json', 'ml_insights.json', 'gap_zones.json'];
            console.error(`Failed to fetch ${fileNames[responses.indexOf(res)]}: ${res.status} ${res.statusText}`);
          });
        }

        const highways = highwaysRes.ok ? await highwaysRes.json() : { features: [] };
        const cameras = camerasRes.ok ? await camerasRes.json() : [];
        const alerts = alertsRes.ok ? await alertsRes.json() : [];
        const incidents = incidentsRes.ok ? await incidentsRes.json() : [];
        const videoFootage = videoRes.ok ? await videoRes.json() : [];
        const mlInsights = mlRes.ok ? await mlRes.json() : [];
        const gapZones = gapRes.ok ? await gapRes.json() : [];

        setMockData({ highways, cameras, alerts, incidents, videoFootage, mlInsights, gapZones });
      } catch (error) {
        console.error('Failed to load mock data:', error);
        // Set empty fallback data to prevent app crashes
        setMockData({ 
          highways: { features: [] }, 
          cameras: [], 
          alerts: [], 
          incidents: [], 
          videoFootage: [], 
          mlInsights: [], 
          gapZones: [] 
        });
      }
    };

    loadMockData();
  }, []);

  // Load Florida cameras when Florida is selected
  useEffect(() => {
    const loadFloridaCameras = async () => {
      if (selectedState.code !== 'FL') {
        setFloridaCameras([]);
        return;
      }

      try {
        const response = await fetch(`/api/cameras/v1/florida?limit=100&minZoom=8`);
        if (response.ok) {
          const data = await response.json();
          setFloridaCameras(data.cameras || []);
          console.log(`Loaded ${data.cameras?.length || 0} Florida cameras`);
        } else {
          console.error('Failed to fetch Florida cameras:', response.statusText);
          setFloridaCameras([]);
        }
      } catch (error) {
        console.error('Error loading Florida cameras:', error);
        setFloridaCameras([]);
      }
    };

    loadFloridaCameras();
  }, [selectedState.code]);

  // Initialize MapBox map on component mount
  useEffect(() => {
    if (!mapContainer.current || map.current) return;

    map.current = new mapboxgl.Map({
      container: mapContainer.current,
      style: 'mapbox://styles/mapbox/dark-v11',
      center: selectedState.center,
      zoom: selectedState.zoomLevel,
      pitch: 0, // Flat view for better pin visibility
      bearing: 0,
    });

    // Set up map event listeners
    map.current.on('load', () => {
      setMapLoaded(true);
    });

    // Also listen for style loading to ensure all map resources are ready
    map.current.on('styledata', () => {
      if (map.current?.isStyleLoaded()) {
        setMapLoaded(true);
      }
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

    map.current.fitBounds(selectedState.bounds, {
      padding: { top: 50, bottom: 50, left: 50, right: 480 }, // Account for video drawer
      duration: 1500,
      essential: true,
    });
  }, [selectedState, mapLoaded]);

  // Add intelligent highway highlighting with state filtering
  useEffect(() => {
    if (!map.current || !mapLoaded || !map.current.isStyleLoaded()) return;

    // Create state boundary filter - only apply geographic filtering if not Full View
    const isFullView = selectedState.code === 'FULL';
    const stateFilter = showAllStates || isFullView ? 
      ['has', 'class'] : // Show all roads for full view or when showAllStates is true
      [
        'all',
        ['has', 'class']
        // Note: Mapbox Streets doesn't have precise state boundary data
        // For proper state filtering, we would need to use state polygon geometries
        // For now, geographic bounds filtering is disabled as it's not accurate enough
      ];

    // Primary highways (motorways & trunks) - highest importance
    if (!map.current.getLayer('major-highways-primary-border')) {
      // Highway border (darker yellow)
      map.current.addLayer({
        id: 'major-highways-primary-border',
        type: 'line',
        source: 'composite',
        'source-layer': 'road',
        filter: ['all', ['in', 'class', 'motorway', 'trunk']],
        paint: {
          'line-color': '#E6C200', // Darker yellow for border
          'line-width': [
            'interpolate', ['linear'], ['zoom'],
            5, 2.2,    // Thin at low zoom
            10, 3.2,   // Medium at mid zoom  
            14, 5.2    // Thicker at high zoom
          ],
          'line-opacity': 0.9,
        },
      });

      // Highway fill (lighter, semi-transparent yellow)
      map.current.addLayer({
        id: 'major-highways-primary',
        type: 'line',
        source: 'composite',
        'source-layer': 'road',
        filter: ['all', ['in', 'class', 'motorway', 'trunk']],
        paint: {
          'line-color': '#FFF176', // Lighter yellow for fill
          'line-width': [
            'interpolate', ['linear'], ['zoom'],
            5, 1.8,    // Thinner at low zoom
            10, 2.6,   // Medium at mid zoom  
            14, 4.2    // Thinner at high zoom
          ],
          'line-opacity': 0.7, // More transparent
        },
      });

      // Edge dashes for major highways at high zoom (Palantir "vein" effect)
      map.current.addLayer({
        id: 'major-highways-primary-outline',
        type: 'line',
        source: 'composite',
        'source-layer': 'road',
        minzoom: 10,
        filter: ['all', ['in', 'class', 'motorway', 'trunk']],
        paint: {
          'line-color': '#E6C200',
          'line-width': [
            'interpolate', ['linear'], ['zoom'],
            10, 3.8,   // Slightly wider than base
            14, 6      // Maintains proportion
          ],
          'line-dasharray': [2, 2],
          'line-opacity': 0.5,
        },
      });
    }

    // Selected highway layer (dotted style)
    if (!map.current.getLayer('selected-highway')) {
      map.current.addLayer({
        id: 'selected-highway',
        type: 'line',
        source: 'composite',
        'source-layer': 'road',
        filter: ['all', 
          ['in', 'class', 'motorway', 'trunk'],
          selectedHighway ? ['==', 'name', selectedHighway] : ['==', 'name', '']
        ],
        paint: {
          'line-color': '#FF6B35', // Orange for selected highway
          'line-width': [
            'interpolate', ['linear'], ['zoom'],
            5, 4,
            10, 6,
            14, 10
          ],
          'line-dasharray': [3, 3], // Dotted pattern
          'line-opacity': 0.9,
        },
      });
    }

    // Update filters when state or selection changes
    if (map.current.getLayer('major-highways-primary-border')) {
      const baseFilter = ['in', 'class', 'motorway', 'trunk'];
      const stateFilteredFilter = showAllStates ? baseFilter : ['all', baseFilter, stateFilter];
      
      map.current.setFilter('major-highways-primary-border', stateFilteredFilter);
      map.current.setFilter('major-highways-primary', stateFilteredFilter);
      map.current.setFilter('major-highways-primary-outline', stateFilteredFilter);
    }

    // Update selected highway filter
    if (map.current.getLayer('selected-highway')) {
      map.current.setFilter('selected-highway', [
        'all',
        ['in', 'class', 'motorway', 'trunk'],
        selectedHighway ? ['==', 'name', selectedHighway] : ['==', 'name', '']
      ]);
    }

    // Interactive cursors and click handlers
    const highwayLayers = ['major-highways-primary-border', 'major-highways-primary'];
    
    highwayLayers.forEach(layerId => {
      // Remove existing handlers - no need to remove, just add new ones
      // map.current!.off('mouseenter', layerId);
      // map.current!.off('mouseleave', layerId);
      // map.current!.off('click', layerId);

      map.current!.on('mouseenter', layerId, () => {
        if (map.current) {
          map.current.getCanvas().style.cursor = 'pointer';
        }
      });

      map.current!.on('mouseleave', layerId, () => {
        if (map.current) {
          map.current.getCanvas().style.cursor = '';
        }
      });

      map.current!.on('click', layerId, (e) => {
        const roadName = e.features?.[0]?.properties?.name;
        const roadClass = e.features?.[0]?.properties?.class;
        
        if (roadName) {
          console.log(`Highway selected: ${roadName} (${roadClass})`);
          setSelectedHighway(roadName === selectedHighway ? null : roadName);
        }
      });
    });

  }, [mapLoaded, selectedState, showAllStates, selectedHighway]);

  // Add all pins when highway is selected
  useEffect(() => {
    if (!map.current || !mapLoaded || !map.current.isStyleLoaded() || !selectedHighway) return;

    // Remove all existing markers when highway changes
    const existingMarkers = document.querySelectorAll('.pin-marker');
    existingMarkers.forEach(marker => marker.remove());

    if (!selectedHighway) return;

    // Filter data by selected state and highway proximity
    const isFullView = selectedState.code === 'FULL';
    
    const stateCameras = mockData.cameras.filter(cam => 
      (isFullView || cam.state === selectedState.code) && 
      (cam.road.includes(selectedHighway) || isNearHighway(cam.coords, selectedHighway))
    );
    
    const stateAlerts = mockData.alerts.filter(alert =>
      alert.road.includes(selectedHighway) || isNearHighway(alert.coords, selectedHighway)
    );
    
    const stateIncidents = mockData.incidents.filter(incident =>
      isNearHighway(incident.coords, selectedHighway)
    );
    
    const stateVideoFootage = mockData.videoFootage.filter(video =>
      video.road.includes(selectedHighway) || isNearHighway(video.coords, selectedHighway)
    );
    
    const stateMlInsights = mockData.mlInsights.filter(insight =>
      insight.road.includes(selectedHighway) || isNearHighway(insight.coords, selectedHighway)
    );
    
    const stateGapZones = mockData.gapZones.filter(gap =>
      gap.road.includes(selectedHighway) || isNearHighway(gap.coords, selectedHighway)
    );

    // Helper function to check if coordinates are near the selected highway
    function isNearHighway(coords: [number, number], highway: string): boolean {
      // Simple proximity check - in real implementation, would use proper geometry matching
      return true; // For now, show all pins when highway is selected
    }

    // Render camera pins

    // Render Florida 511 cameras for Florida state
    if (selectedState.code === 'FL' && floridaCameras.length > 0) {
      floridaCameras.forEach(camera => {
        const markerEl = document.createElement('div');
        markerEl.className = 'pin-marker florida-camera-marker';
        markerEl.style.cursor = 'pointer';
        markerEl.style.borderRadius = '4px';
        markerEl.style.display = 'flex';
        markerEl.style.alignItems = 'center';
        markerEl.style.justifyContent = 'center';
        markerEl.style.fontSize = '12px';
        markerEl.style.border = '2px solid white';
        markerEl.style.width = '24px';
        markerEl.style.height = '24px';
        markerEl.style.backgroundColor = '#059669'; // Green for live cameras
        markerEl.innerHTML = '📹';
        markerEl.style.opacity = '1';

        // Click handler for Florida cameras
        markerEl.addEventListener('click', () => {
          console.log('Florida camera clicked:', camera);
          // Transform to expected Camera format for onCameraClick
          const transformedCamera: Camera = {
            id: camera.id,
            state: 'FL',
            coords: [camera.lng, camera.lat],
            road: camera.roadway || 'Unknown',
            road_class: 'motorway',
            functional_class: 1,
            milepost: 0,
            status: 'online',
            stream_url: camera.videoUrl,
            priority: 'high'
          };
          onCameraClick?.(transformedCamera);
        });

        // Create popup for Florida cameras
        const popup = new mapboxgl.Popup({ offset: 25 }).setHTML(`
          <div class="p-2">
            <div class="font-semibold text-sm">${camera.name}</div>
            <div class="text-xs text-gray-600 mt-1">
              <span class="font-medium">Road:</span> ${camera.roadway}
              <span class="ml-2 font-medium">Direction:</span> ${camera.direction}
            </div>
            <div class="text-xs text-gray-500 mt-1">
              <span class="font-medium">Region:</span> ${camera.region}
              <span class="ml-2 font-medium">County:</span> ${camera.county}
            </div>
            <div class="text-xs text-blue-600 mt-2 cursor-pointer hover:underline">
              Click to view live stream
            </div>
          </div>
        `);

        new mapboxgl.Marker(markerEl)
          .setLngLat([camera.lng, camera.lat])
          .setPopup(popup)
          .addTo(map.current!);
      });
    }

    // Render camera pins
    stateCameras.forEach(camera => {
      const markerEl = document.createElement('div');
      markerEl.className = 'pin-marker camera-marker';
      markerEl.style.cursor = 'pointer';

      // Set camera icon based on status and road importance
      markerEl.style.borderRadius = '4px';
      markerEl.style.display = 'flex';
      markerEl.style.alignItems = 'center';
      markerEl.style.justifyContent = 'center';
      markerEl.style.fontSize = '12px';
      markerEl.style.border = '2px solid white';

      // Color and size based on road class importance
      let bgColor = '#6B7280'; // Default grey
      let size = '18px';
      
      if (camera.road_class === 'motorway') {
        bgColor = '#059669'; // Green for interstate cameras
        size = '22px';
      } else if (camera.road_class === 'trunk') {
        bgColor = '#0D9488'; // Teal for major highways
        size = '20px';
      } else if (camera.road_class === 'primary') {
        bgColor = '#6B7280'; // Grey for arterials
        size = '18px';
      }

      markerEl.style.width = size;
      markerEl.style.height = size;

      if (camera.status === 'online') {
        markerEl.style.backgroundColor = bgColor;
        markerEl.innerHTML = '📹';
        markerEl.style.opacity = '1';
      } else {
        markerEl.style.backgroundColor = bgColor;
        markerEl.innerHTML = '🚫';
        markerEl.style.opacity = '0.6';
      }

      // Click handler
      markerEl.addEventListener('click', () => {
        console.log('Camera clicked:', camera);
        onCameraClick?.(camera);
      });

      // Create popup with road class information
      const popup = new mapboxgl.Popup({ offset: 25 }).setHTML(`
        <div class="p-2">
          <div class="font-semibold text-sm">${camera.road} - MP ${camera.milepost}</div>
          <div class="text-xs text-gray-600 mt-1">
            <span class="font-medium">Status:</span> ${camera.status}
            <span class="ml-2 font-medium">Class:</span> ${camera.road_class}
          </div>
          <div class="text-xs text-gray-500 mt-1">
            <span class="font-medium">Priority:</span> ${camera.priority} 
            <span class="ml-2">FC-${camera.functional_class}</span>
          </div>
          <div class="text-xs text-gray-500 mt-1">${camera.id}</div>
        </div>
      `);

      new mapboxgl.Marker(markerEl)
        .setLngLat(camera.coords)
        .setPopup(popup)
        .addTo(map.current!);
    });

    // Render video footage pins
    stateVideoFootage.forEach(video => {
      const markerEl = document.createElement('div');
      markerEl.className = 'pin-marker video-marker';
      markerEl.style.width = '24px';
      markerEl.style.height = '24px';
      markerEl.style.cursor = 'pointer';
      markerEl.style.borderRadius = '4px';
      markerEl.style.display = 'flex';
      markerEl.style.alignItems = 'center';
      markerEl.style.justifyContent = 'center';
      markerEl.style.fontSize = '12px';
      markerEl.style.border = '2px solid white';

      // Style based on video type
      switch (video.type) {
        case 'dash_cam':
          markerEl.style.backgroundColor = '#3B82F6'; // Blue
          markerEl.innerHTML = '🚗';
          break;
        case 'aerial_drone':
          markerEl.style.backgroundColor = '#059669'; // Green
          markerEl.innerHTML = '🚁';
          break;
        case 'security_cam':
          markerEl.style.backgroundColor = '#6B7280'; // Grey
          markerEl.innerHTML = '🔒';
          break;
        case 'helicopter_cam':
          markerEl.style.backgroundColor = '#DC2626'; // Red
          markerEl.innerHTML = '🚁';
          break;
      }

      markerEl.addEventListener('click', () => {
        console.log('Video footage clicked:', video);
        // TODO: Open video player
      });

      const popup = new mapboxgl.Popup({ offset: 25 }).setHTML(`
        <div class="p-2">
          <div class="font-semibold text-sm">${video.type} - ${video.quality}</div>
          <div class="text-xs text-gray-600 mt-1">
            <span class="font-medium">Road:</span> ${video.road}
            <span class="ml-2 font-medium">Duration:</span> ${video.duration}s
          </div>
          <div class="text-xs text-gray-500 mt-1">
            <span class="font-medium">Source:</span> ${video.source}
            ${video.incident_related ? ' • <span class="text-red-600">Incident Related</span>' : ''}
          </div>
        </div>
      `);

      new mapboxgl.Marker(markerEl)
        .setLngLat(video.coords)
        .setPopup(popup)
        .addTo(map.current!);
    });

    // Render ML insight pins
    stateMlInsights.forEach(insight => {
      const markerEl = document.createElement('div');
      markerEl.className = 'pin-marker ml-marker';
      markerEl.style.width = '20px';
      markerEl.style.height = '20px';
      markerEl.style.cursor = 'pointer';
      markerEl.style.borderRadius = '0';
      markerEl.style.transform = 'rotate(45deg)';
      markerEl.style.display = 'flex';
      markerEl.style.alignItems = 'center';
      markerEl.style.justifyContent = 'center';
      markerEl.style.fontSize = '10px';
      markerEl.style.border = '2px solid white';
      markerEl.style.backgroundColor = '#DC2626'; // Red diamond

      // Inner content rotated back
      const innerEl = document.createElement('div');
      innerEl.style.transform = 'rotate(-45deg)';
      innerEl.innerHTML = '🤖';
      innerEl.style.fontSize = '8px';
      markerEl.appendChild(innerEl);

      // Pulsing for high confidence
      if (insight.confidence > 0.85) {
        markerEl.style.animation = 'pulse 2s infinite';
      }

      markerEl.addEventListener('click', () => {
        console.log('ML insight clicked:', insight);
        // TODO: Open insight details
      });

      const popup = new mapboxgl.Popup({ offset: 25 }).setHTML(`
        <div class="p-2">
          <div class="font-semibold text-sm">${insight.type}</div>
          <div class="text-xs text-gray-600 mt-1">
            <span class="font-medium">Confidence:</span> ${(insight.confidence * 100).toFixed(0)}%
            <span class="ml-2 font-medium">Road:</span> ${insight.road}
          </div>
          <div class="text-xs text-gray-500 mt-1">
            ${Object.entries(insight.insight_data).map(([key, value]) => 
              `<span class="font-medium">${key.replace(/_/g, ' ')}:</span> ${value}`
            ).join(' • ')}
          </div>
        </div>
      `);

      new mapboxgl.Marker(markerEl)
        .setLngLat(insight.coords)
        .setPopup(popup)
        .addTo(map.current!);
    });

    // Render gap zone pins
    stateGapZones.forEach(gap => {
      const markerEl = document.createElement('div');
      markerEl.className = 'pin-marker gap-marker';
      markerEl.style.width = '18px';
      markerEl.style.height = '18px';
      markerEl.style.cursor = 'pointer';
      markerEl.style.borderRadius = '50%';
      markerEl.style.display = 'flex';
      markerEl.style.alignItems = 'center';
      markerEl.style.justifyContent = 'center';
      markerEl.style.fontSize = '10px';
      markerEl.style.border = '3px solid #FFD84D'; // Yellow border
      markerEl.style.backgroundColor = 'transparent'; // Hollow
      markerEl.innerHTML = '⚠️';

      // Risk level styling
      switch (gap.gap_data.risk_level) {
        case 'high':
          markerEl.style.borderColor = '#DC2626';
          markerEl.style.animation = 'pulse 2s infinite';
          break;
        case 'medium':
          markerEl.style.borderColor = '#F59E0B';
          break;
        case 'low':
          markerEl.style.borderColor = '#10B981';
          break;
      }

      markerEl.addEventListener('click', () => {
        console.log('Gap zone clicked:', gap);
        // TODO: Open gap analysis
      });

      const popup = new mapboxgl.Popup({ offset: 25 }).setHTML(`
        <div class="p-2">
          <div class="font-semibold text-sm">${gap.type} - ${gap.gap_data.coverage_type}</div>
          <div class="text-xs text-gray-600 mt-1">
            <span class="font-medium">Road:</span> ${gap.road}
            <span class="ml-2 font-medium">Risk:</span> ${gap.gap_data.risk_level}
          </div>
          <div class="text-xs text-gray-500 mt-1">
            <span class="font-medium">Last:</span> ${gap.gap_data.last_coverage}
            <span class="ml-2 font-medium">Next:</span> ${gap.gap_data.next_coverage}
          </div>
          <div class="text-xs text-gray-500 mt-1">
            <span class="font-medium">Crash Density:</span> ${gap.gap_data.crash_density}/mile
          </div>
        </div>
      `);

      new mapboxgl.Marker(markerEl)
        .setLngLat(gap.coords)
        .setPopup(popup)
        .addTo(map.current!);
    });

  }, [mockData, floridaCameras, mapLoaded, selectedState.code, selectedHighway]);

  // Legacy alert and incident effects removed - now handled in consolidated pin logic above

  return (
    <>
      {/* Add CSS for marker animations */}
      <style jsx global>{`
        @keyframes pulse {
          0% { transform: scale(1); opacity: 1; }
          50% { transform: scale(1.2); opacity: 0.7; }
          100% { transform: scale(1); opacity: 1; }
        }
        
        @keyframes pulse-ring {
          0% { 
            transform: scale(1); 
            box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.7);
          }
          50% { 
            transform: scale(1.1); 
            box-shadow: 0 0 0 10px rgba(239, 68, 68, 0);
          }
          100% { 
            transform: scale(1); 
            box-shadow: 0 0 0 0 rgba(239, 68, 68, 0);
          }
        }
      `}</style>
      <div 
        ref={mapContainer} 
        className="w-full h-full"
        style={{ minHeight: '400px' }}
      >
        {!mapLoaded && (
          <div className="absolute inset-0 flex items-center justify-center bg-background/80 backdrop-blur-sm">
            <div className="text-lg text-neutral-600 animate-pulse">Loading Network Map...</div>
          </div>
        )}
      </div>
    </>
  );
}