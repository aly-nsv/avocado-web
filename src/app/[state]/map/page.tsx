'use client';

import { useState, useEffect, useCallback } from 'react';
import { useParams, useRouter } from 'next/navigation';
import dynamic from 'next/dynamic';
import Link from 'next/link';
import FilterBar from '@/components/FilterBar';
import AlertsPanel from '@/components/AlertsPanel';
import VideoDrawer from '@/components/VideoDrawer';
import IncidentDrawer from '@/components/IncidentDrawer';
import { useStateMap } from '@/components/providers/StateMapProvider';
import { Alert, CorridorData } from '@/types/dashboard';
import { US_STATES } from '@/data/states';
import { MapIcon, TruckIcon, ExclamationTriangleIcon, ChartBarIcon } from '@heroicons/react/24/solid';

// Network Map interfaces
interface Camera {
  id: string;
  state: string;
  coords: [number, number];
  road: string;
  milepost: number;
  status: 'online' | 'offline';
  stream_url: string | null;
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

// Dynamic import prevents SSR issues with MapBox
const StateMap = dynamic(() => import('@/components/StateMap'), {
  ssr: false,
  loading: () => (
    <div className="flex items-center justify-center h-full bg-neutral-900">
      <div className="text-lg text-neutral-400 animate-pulse">Loading Network Map...</div>
    </div>
  ),
});

export default function StateMapPage() {
  const params = useParams();
  const router = useRouter();
  const stateCode = params.state as string;
  
  const {
    selectedState,
    setSelectedState,
    activeFilters,
    setActiveFilters,
    alerts,
    setAlerts,
    isAlertsPanelOpen,
    setIsAlertsPanelOpen,
  } = useStateMap();

  const [corridorData, setCorridorData] = useState<CorridorData | null>(null);
  const [mockData, setMockData] = useState<{
    cameras: Camera[];
    mapAlerts: MapAlert[];
    incidents: Incident[];
  }>({ cameras: [], mapAlerts: [], incidents: [] });
  
  // Drawer states
  const [selectedCameras, setSelectedCameras] = useState<Camera[]>([]);
  const [selectedIncident, setSelectedIncident] = useState<Incident | null>(null);
  const [isVideoDrawerOpen, setIsVideoDrawerOpen] = useState(false);
  const [isIncidentDrawerOpen, setIsIncidentDrawerOpen] = useState(false);

  // Set selected state based on route parameter
  useEffect(() => {
    const stateInfo = US_STATES.find((state: any) => state.code.toLowerCase() === stateCode?.toLowerCase());
    if (stateInfo && stateInfo.code !== selectedState.code) {
      setSelectedState(stateInfo);
    } else if (!stateInfo) {
      // Invalid state code, redirect to default
      router.replace('/FULL/map');
    }
  }, [stateCode, selectedState.code, setSelectedState, router]);

  // Update route when state changes
  const handleStateChange = useCallback((newState: typeof selectedState) => {
    setSelectedState(newState);
    router.push(`/${newState.code}/map`);
  }, [setSelectedState, router]);

  // URL hash management for camera selection
  useEffect(() => {
    const handleHashChange = () => {
      const hash = window.location.hash;
      const camMatch = hash.match(/#cam=(.+)/);
      
      if (camMatch && mockData.cameras.length > 0) {
        const cameraId = camMatch[1];
        const camera = mockData.cameras.find(cam => cam.id === cameraId);
        
        if (camera) {
          setSelectedCameras([camera]);
          setIsVideoDrawerOpen(true);
          setIsAlertsPanelOpen(false);
          setIsIncidentDrawerOpen(false);
        }
      }
    };

    // Handle initial load
    handleHashChange();
    
    // Listen for hash changes
    window.addEventListener('hashchange', handleHashChange);
    
    return () => {
      window.removeEventListener('hashchange', handleHashChange);
    };
  }, [mockData.cameras, setIsAlertsPanelOpen]);

  // Update URL hash when camera is selected
  const updateCameraHash = (cameraId: string | null) => {
    if (cameraId) {
      window.history.replaceState(null, '', `#cam=${cameraId}`);
    } else {
      window.history.replaceState(null, '', window.location.pathname);
    }
  };

  // Load initial data on component mount
  useEffect(() => {
    const loadInitialData = async () => {
      try {
        // Load API alerts (existing)
        const alertsResponse = await fetch('/api/alerts');
        if (alertsResponse.ok) {
          const alertsData: Alert[] = await alertsResponse.json();
          setAlerts(alertsData);
        }

        // Load mock network data
        const [camerasRes, mapAlertsRes, incidentsRes] = await Promise.all([
          fetch('/mock/map/cameras.json'),
          fetch('/mock/map/alerts.json'),
          fetch('/mock/map/incidents.json')
        ]);

        const cameras = await camerasRes.json();
        const mapAlerts = await mapAlertsRes.json();
        const incidents = await incidentsRes.json();

        setMockData({ cameras, mapAlerts, incidents });

        // Set mock corridor data for now
        setCorridorData({
          highways: { type: 'FeatureCollection', features: [] },
          infrastructure: { type: 'FeatureCollection', features: [] },
        });
      } catch (error) {
        console.error('Failed to load initial data:', error);
        setCorridorData({
          highways: { type: 'FeatureCollection', features: [] },
          infrastructure: { type: 'FeatureCollection', features: [] },
        });
      }
    };

    loadInitialData();
  }, [selectedState.code, setAlerts]);

  // Calculate nearest cameras for alert
  const findNearestCameras = (alertCoords: [number, number], count: number = 2): Camera[] => {
    const isFullView = selectedState.code === 'FULL';
    const stateCameras = mockData.cameras.filter(cam => 
      isFullView || cam.state === selectedState.code
    );
    
    const camerasWithDistance = stateCameras.map(camera => {
      const distance = Math.sqrt(
        Math.pow(camera.coords[0] - alertCoords[0], 2) + 
        Math.pow(camera.coords[1] - alertCoords[1], 2)
      );
      return { camera, distance };
    });

    return camerasWithDistance
      .sort((a, b) => a.distance - b.distance)
      .slice(0, count)
      .map(item => item.camera);
  };

  // Handler functions for map interactions
  const handleCameraClick = useCallback((camera: Camera) => {
    setSelectedCameras([camera]);
    setIsVideoDrawerOpen(true);
    setIsAlertsPanelOpen(false);
    setIsIncidentDrawerOpen(false);
    updateCameraHash(camera.id);
  }, []);

  const handleAlertClick = useCallback((alert: MapAlert) => {
    const nearestCameras = findNearestCameras(alert.coords);
    setSelectedCameras(nearestCameras);
    setIsVideoDrawerOpen(true);
    setIsAlertsPanelOpen(false);
    setIsIncidentDrawerOpen(false);
  }, [mockData.cameras, selectedState.code]);

  const handleIncidentClick = useCallback((incident: Incident) => {
    setSelectedIncident(incident);
    setIsIncidentDrawerOpen(true);
    setIsAlertsPanelOpen(false);
    setIsVideoDrawerOpen(false);
  }, []);

  return (
    <div className="flex flex-col h-screen bg-background">
      {/* Navigation Header */}
      <nav className="bg-surface shadow-sm border-b border-neutral-200 px-6 py-3">
        <div className="flex items-center space-x-8">
          <div className="flex items-center space-x-3">
            <div className="h-8 w-8 bg-gradient-to-r from-primary to-highlight rounded-lg flex items-center justify-center">
              <MapIcon className="h-5 w-5 text-white" />
            </div>
            <h1 className="text-xl font-bold text-primary">AVocado Network Map</h1>
          </div>
          <div className="flex space-x-6">
            <Link href={`/${selectedState.code}/map`} className="text-primary font-medium flex items-center space-x-1">
              <MapIcon className="h-4 w-4" />
              <span>Network Map</span>
            </Link>
            {/* <Link href={`/${selectedState.code}/incidents` as any} className="text-neutral-600 hover:text-neutral-900 flex items-center space-x-1 transition-colors">
              <ExclamationTriangleIcon className="h-4 w-4" />
              <span>Incidents</span>
            </Link>
            <Link href={`/${selectedState.code}/analytics` as any} className="text-neutral-600 hover:text-neutral-900 flex items-center space-x-1 transition-colors">
              <ChartBarIcon className="h-4 w-4" />
              <span>Analytics</span>
            </Link> */}
            <Link href={"/review" as any} className="text-neutral-600 hover:text-neutral-900 flex items-center space-x-1 transition-colors">
              <TruckIcon className="h-4 w-4" />
              <span>Historical Review</span>
            </Link>
          </div>
        </div>
      </nav>

      {/* Filter Bar */}
      <FilterBar
        selectedState={selectedState}
        onStateChange={handleStateChange}
        activeFilters={activeFilters}
        onFiltersChange={setActiveFilters}
        onToggleAlerts={() => {
          setIsAlertsPanelOpen(!isAlertsPanelOpen);
          setIsVideoDrawerOpen(false);
          setIsIncidentDrawerOpen(false);
        }}
      />

      {/* Main Content Area */}
      <div className="flex-1 relative overflow-hidden">
        {/* Map Container */}
        <div className={`h-full transition-all duration-300 ${
          isAlertsPanelOpen || isVideoDrawerOpen || isIncidentDrawerOpen ? 'mr-[480px]' : 'mr-0'
        }`}>
          {corridorData && (
            <StateMap
              selectedState={selectedState}
              activeFilters={activeFilters}
              corridorData={corridorData}
              alerts={alerts}
              onCameraClick={handleCameraClick}
              onAlertClick={handleAlertClick}
              onIncidentClick={handleIncidentClick}
            />
          )}
        </div>

        {/* Right-side Drawers */}
        {isAlertsPanelOpen && (
          <AlertsPanel
            isOpen={isAlertsPanelOpen}
            alerts={alerts}
            onClose={() => setIsAlertsPanelOpen(false)}
          />
        )}

        {isVideoDrawerOpen && (
          <VideoDrawer
            cameras={selectedCameras}
            onClose={() => {
              setIsVideoDrawerOpen(false);
              updateCameraHash(null);
            }}
          />
        )}

        {isIncidentDrawerOpen && selectedIncident && (
          <IncidentDrawer
            incident={selectedIncident}
            cameras={mockData.cameras}
            onClose={() => setIsIncidentDrawerOpen(false)}
          />
        )}
      </div>
    </div>
  );
}