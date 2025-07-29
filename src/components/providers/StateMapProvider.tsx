'use client';

import { createContext, useContext, useState, useCallback } from 'react';
import { StateInfo, FilterType, Alert, StateMapContextType, StateMapProviderProps } from '@/types/dashboard';
import { US_STATES } from '@/data/states';

const StateMapContext = createContext<StateMapContextType | undefined>(undefined);

export function StateMapProvider({ children }: StateMapProviderProps) {
  // Initialize with Full View as default state
  const [selectedState, setSelectedState] = useState<StateInfo>(
    US_STATES.find(state => state.code === 'FULL') || US_STATES[0]
  );
  
  const [activeFilters, setActiveFilters] = useState<FilterType[]>(['incidents']);
  const [alerts, setAlerts] = useState<Alert[]>([]);
  const [isAlertsPanelOpen, setIsAlertsPanelOpen] = useState(false);

  // Utility function to toggle individual filters
  const toggleFilter = useCallback((filter: FilterType) => {
    setActiveFilters(prev => 
      prev.includes(filter)
        ? prev.filter(f => f !== filter)
        : [...prev, filter]
    );
  }, []);

  // Utility function to clear all active filters
  const clearAllFilters = useCallback(() => {
    setActiveFilters([]);
  }, []);

  const value: StateMapContextType = {
    selectedState,
    setSelectedState,
    activeFilters,
    setActiveFilters,
    alerts,
    setAlerts,
    isAlertsPanelOpen,
    setIsAlertsPanelOpen,
    toggleFilter,
    clearAllFilters,
  };

  return (
    <StateMapContext.Provider value={value}>
      {children}
    </StateMapContext.Provider>
  );
}

// Custom hook for accessing state map context
export function useStateMap() {
  const context = useContext(StateMapContext);
  if (context === undefined) {
    throw new Error('useStateMap must be used within a StateMapProvider');
  }
  return context;
}