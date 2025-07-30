import { ReactNode } from 'react';

// Geographic and state-related types
export interface StateInfo {
  code: string;
  name: string;
  center: [number, number]; // [longitude, latitude]
  bounds: [[number, number], [number, number]]; // [southwest, northeast]
  zoomLevel: number;
}

// Alert system types with strict severity levels
export type AlertSeverity = 'info' | 'warning' | 'critical';

export interface Alert {
  id: string;
  severity: AlertSeverity;
  location: string;
  description: string;
  timestamp: string; // ISO 8601 format
  timeAgo: string; // Human-readable relative time
  coordinates?: [number, number]; // Optional map positioning
}

// Filter system for map layers
export type FilterType = 'incidents' | 'commercial' | 'weather' | 'construction' | 'traffic' | 'cameras';

export interface FilterButton {
  id: FilterType;
  label: string;
  icon: React.ComponentType<{ className?: string }>; // Heroicon component type
  active: boolean;
}

// MapBox-specific geospatial data
export interface CorridorData {
  highways: GeoJSON.FeatureCollection;
  infrastructure: GeoJSON.FeatureCollection;
}

// Application state management
export interface AppState {
  selectedState: StateInfo;
  activeFilters: FilterType[];
  alerts: Alert[];
  isAlertsPanelOpen: boolean;
}

// Component Props interfaces
export interface FilterBarProps {
  selectedState: StateInfo;
  onStateChange: (state: StateInfo) => void;
  activeFilters: FilterType[];
  onFiltersChange: (filters: FilterType[]) => void;
  onToggleAlerts: () => void;
}

export interface StateMapProps {
  selectedState: StateInfo;
  activeFilters: FilterType[];
  corridorData: CorridorData;
  alerts: Alert[];
}

export interface FloridaCamera {
  id: string;
  name: string;
  lat: number;
  lng: number;
  region: string;
  county: string;
  roadway: string;
  direction: string;
  videoUrl: string;
  thumbnailUrl: string;
  status: 'active' | 'inactive' | 'maintenance' | 'offline';
}

export interface AlertsPanelProps {
  isOpen: boolean;
  alerts: Alert[];
  onClose: () => void;
}

export interface AlertCardProps {
  alert: Alert;
  onClick?: (alertId: string) => void;
}

// Context type for state management
export interface StateMapContextType {
  selectedState: StateInfo;
  setSelectedState: (state: StateInfo) => void;
  activeFilters: FilterType[];
  setActiveFilters: (filters: FilterType[]) => void;
  alerts: Alert[];
  setAlerts: (alerts: Alert[]) => void;
  isAlertsPanelOpen: boolean;
  setIsAlertsPanelOpen: (open: boolean) => void;
  toggleFilter: (filter: FilterType) => void;
  clearAllFilters: () => void;
}

// Provider props
export interface StateMapProviderProps {
  children: ReactNode;
}