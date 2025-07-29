'use client';

import { Fragment } from 'react';
import { Listbox, Transition } from '@headlessui/react';
import {
  ChevronUpDownIcon,
  CheckIcon,
  ExclamationTriangleIcon,
  TruckIcon,
  BoltIcon,
  WrenchScrewdriverIcon,
  SignalIcon,
  CameraIcon,
  BellIcon,
} from '@heroicons/react/24/solid';
import { FilterBarProps, FilterType, StateInfo } from '@/types/dashboard';
import { US_STATES } from '@/data/states';
import { Button } from './ui/Button';

// Define filter configuration with proper typing
const FILTER_CONFIG: Record<FilterType, { 
  label: string; 
  icon: React.ComponentType<{ className?: string }> 
}> = {
  incidents: { label: 'Incidents', icon: ExclamationTriangleIcon },
  commercial: { label: 'Commercial', icon: TruckIcon },
  weather: { label: 'Weather', icon: BoltIcon },
  construction: { label: 'Construction', icon: WrenchScrewdriverIcon },
  traffic: { label: 'Traffic', icon: SignalIcon },
  cameras: { label: 'Cameras', icon: CameraIcon },
};

export default function FilterBar({
  selectedState,
  onStateChange,
  activeFilters,
  onFiltersChange,
  onToggleAlerts,
}: FilterBarProps) {
  
  const toggleFilter = (filterId: FilterType) => {
    const updatedFilters = activeFilters.includes(filterId)
      ? activeFilters.filter(f => f !== filterId) // Remove if active
      : [...activeFilters, filterId]; // Add if inactive
    
    onFiltersChange(updatedFilters);
  };

  return (
    <div className="bg-surface shadow-sm border-b border-neutral-200 px-6 py-4">
      <div className="flex items-center justify-between">
        {/* Left Side: State Selector and Filter Buttons */}
        <div className="flex items-center space-x-4">
          {/* State Dropdown using Headless UI for accessibility */}
          <Listbox value={selectedState} onChange={onStateChange}>
            <div className="relative w-48">
              <Listbox.Button className="relative w-full cursor-default rounded-lg bg-background py-2 pl-3 pr-10 text-left shadow-md focus:outline-none border border-neutral-300 hover:border-neutral-400 transition-colors">
                <span className="block truncate font-medium text-neutral-900">{selectedState.name}</span>
                <span className="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-2">
                  <ChevronUpDownIcon className="h-5 w-5 text-neutral-400" aria-hidden="true" />
                </span>
              </Listbox.Button>
              
              <Transition
                as={Fragment}
                leave="transition ease-in duration-100"
                leaveFrom="opacity-100"
                leaveTo="opacity-0"
              >
                <Listbox.Options className="absolute z-50 mt-1 max-h-60 w-full overflow-auto rounded-md bg-background py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none">
                  {US_STATES.map((state: StateInfo) => (
                    <Listbox.Option
                      key={state.code}
                      className={({ active }) =>
                        `relative cursor-default select-none py-2 pl-10 pr-4 ${
                          active ? 'bg-primary/10 text-primary' : 'text-neutral-900'
                        }`
                      }
                      value={state}
                    >
                      {({ selected }) => (
                        <>
                          <span className={`block truncate ${selected ? 'font-medium' : 'font-normal'}`}>
                            {state.name}
                          </span>
                          {selected && (
                            <span className="absolute inset-y-0 left-0 flex items-center pl-3 text-primary">
                              <CheckIcon className="h-5 w-5" aria-hidden="true" />
                            </span>
                          )}
                        </>
                      )}
                    </Listbox.Option>
                  ))}
                </Listbox.Options>
              </Transition>
            </div>
          </Listbox>

          {/* Hero Icon Filter Buttons */}
          <div className="flex items-center space-x-2 border-l border-neutral-300 pl-4">
            {Object.entries(FILTER_CONFIG).map(([filterId, config]) => {
              const isActive = activeFilters.includes(filterId as FilterType);
              const Icon = config.icon;
              
              return (
                <button
                  key={filterId}
                  onClick={() => toggleFilter(filterId as FilterType)}
                  className={`inline-flex items-center px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                    isActive
                      ? 'bg-primary/10 text-primary border border-primary/20'
                      : 'text-neutral-500 hover:text-neutral-700 hover:bg-neutral-50 border border-transparent'
                  }`}
                >
                  <Icon className="h-4 w-4 mr-2" />
                  {config.label}
                </button>
              );
            })}
          </div>
        </div>

        {/* Right Side: Alerts Panel Toggle */}
        <Button
          variant="secondary"
          size="sm"
          onClick={onToggleAlerts}
          leftIcon={<BellIcon className="h-4 w-4" />}
        >
          Alerts
        </Button>
      </div>
    </div>
  );
}