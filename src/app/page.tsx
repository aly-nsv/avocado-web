'use client';

import { useState, useEffect } from 'react';
import dynamic from 'next/dynamic';
import Link from 'next/link';
import FilterBar from '@/components/FilterBar';
import AlertsPanel from '@/components/AlertsPanel';
import { useStateMap } from '@/components/providers/StateMapProvider';
import { Alert, CorridorData } from '@/types/dashboard';
import { MapIcon, TruckIcon, ExclamationTriangleIcon, ChartBarIcon } from '@heroicons/react/24/solid';

// Dynamic import prevents SSR issues with MapBox
const StateMap = dynamic(() => import('@/components/StateMap'), {
  ssr: false,
  loading: () => (
    <div className="flex items-center justify-center h-full bg-neutral-900">
      <div className="text-lg text-neutral-400 animate-pulse">Loading map...</div>
    </div>
  ),
});

export default function HomePage() {
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

  // Load initial data on component mount
  useEffect(() => {
    const loadInitialData = async () => {
      try {
        // Load corridor data for the selected state
        const corridorResponse = await fetch(`/api/corridors/${selectedState.code}`);
        if (corridorResponse.ok) {
          const corridors: CorridorData = await corridorResponse.json();
          setCorridorData(corridors);
        }

        // Load current alerts
        const alertsResponse = await fetch('/api/alerts');
        if (alertsResponse.ok) {
          const alertsData: Alert[] = await alertsResponse.json();
          setAlerts(alertsData);
        }
      } catch (error) {
        console.error('Failed to load initial data:', error);
        // Set mock data for development
        setCorridorData({
          highways: {
            type: 'FeatureCollection',
            features: [],
          },
          infrastructure: {
            type: 'FeatureCollection',
            features: [],
          },
        });
      }
    };

    loadInitialData();
  }, [selectedState.code, setAlerts]);

  return (
    <div className="flex flex-col h-screen bg-background">
      {/* Navigation Header */}
      <nav className="bg-surface shadow-sm border-b border-neutral-200 px-6 py-3">
        <div className="flex items-center space-x-8">
          <div className="flex items-center space-x-3">
            <div className="h-8 w-8 bg-gradient-to-r from-primary to-highlight rounded-lg flex items-center justify-center">
              <MapIcon className="h-5 w-5 text-white" />
            </div>
            <h1 className="text-xl font-bold text-neutral-900">AVocado Dashboard</h1>
          </div>
          <div className="flex space-x-6">
            <Link href="/" className="text-primary font-medium flex items-center space-x-1">
              <MapIcon className="h-4 w-4" />
              <span>Dashboard</span>
            </Link>
            <Link href={"/incidents" as any} className="text-neutral-600 hover:text-neutral-900 flex items-center space-x-1 transition-colors">
              <ExclamationTriangleIcon className="h-4 w-4" />
              <span>Incidents</span>
            </Link>
            <Link href={"/analytics/traffic" as any} className="text-neutral-600 hover:text-neutral-900 flex items-center space-x-1 transition-colors">
              <ChartBarIcon className="h-4 w-4" />
              <span>Analytics</span>
            </Link>
            <Link href={"/about" as any} className="text-neutral-600 hover:text-neutral-900 flex items-center space-x-1 transition-colors">
              <TruckIcon className="h-4 w-4" />
              <span>About</span>
            </Link>
          </div>
        </div>
      </nav>

      {/* Filter Bar */}
      <FilterBar
        selectedState={selectedState}
        onStateChange={setSelectedState}
        activeFilters={activeFilters}
        onFiltersChange={setActiveFilters}
        onToggleAlerts={() => setIsAlertsPanelOpen(!isAlertsPanelOpen)}
      />

      {/* Main Content Area */}
      <div className="flex-1 relative">
        {/* Map Container */}
        <div className={`h-full transition-all duration-300 ${
          isAlertsPanelOpen ? 'mr-96' : 'mr-0'
        }`}>
          {corridorData && (
            <StateMap
              selectedState={selectedState}
              activeFilters={activeFilters}
              corridorData={corridorData}
              alerts={alerts}
            />
          )}
        </div>

        {/* Sliding Alerts Panel */}
        <AlertsPanel
          isOpen={isAlertsPanelOpen}
          alerts={alerts}
          onClose={() => setIsAlertsPanelOpen(false)}
        />
      </div>
    </div>
  );
}