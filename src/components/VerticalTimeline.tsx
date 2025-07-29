'use client';

import { useEffect, useRef } from 'react';
import { ClockIcon } from '@heroicons/react/24/outline';
import { format } from 'date-fns';

interface TimelineEvent {
  t: string;
  label: string;
  description?: string;
  type?: string;
  active?: boolean;
}

interface VerticalTimelineProps {
  events: TimelineEvent[];
  title?: string;
  className?: string;
}

export default function VerticalTimeline({ 
  events, 
  title = "Timeline",
  className = "" 
}: VerticalTimelineProps) {
  const lastEventRef = useRef<HTMLLIElement>(null);

  // Auto-scroll to last event on mount or when events change
  useEffect(() => {
    if (lastEventRef.current && events.length > 0) {
      lastEventRef.current.scrollIntoView({ 
        behavior: 'smooth', 
        block: 'nearest' 
      });
    }
  }, [events]);

  const formatTime = (timestamp: string) => {
    try {
      return format(new Date(timestamp), 'HH:mm');
    } catch {
      return timestamp.split('T')[1]?.split(':').slice(0, 2).join(':') || '--:--';
    }
  };

  const formatDate = (timestamp: string) => {
    try {
      return format(new Date(timestamp), 'MMM dd');
    } catch {
      return timestamp.split('T')[0] || 'Unknown';
    }
  };

  return (
    <div className={`bg-background rounded-lg border border-neutral-200 p-4 ${className}`}>
      <h3 className="font-medium text-neutral-900 mb-4 flex items-center">
        <ClockIcon className="h-4 w-4 mr-2" />
        {title}
      </h3>
      
      <div className="relative">
        {/* Timeline line */}
        <div className="absolute left-6 top-0 bottom-0 w-0.5 bg-neutral-300"></div>
        
        {/* Timeline events */}
        <ul className="space-y-4">
          {events.map((event, index) => {
            const isLast = index === events.length - 1;
            const isActive = event.active || isLast;
            
            return (
              <li 
                key={index} 
                className="relative flex items-start"
                ref={isLast ? lastEventRef : null}
              >
                {/* Timeline dot */}
                <div className={`flex-shrink-0 w-3 h-3 rounded-full border-2 border-white z-10 ${
                  isActive 
                    ? 'bg-primary ring-2 ring-primary/20' 
                    : 'bg-neutral-400'
                }`}></div>
                
                {/* Event content */}
                <div className="ml-4 flex-1">
                  <div className="flex items-center space-x-2 mb-1">
                    <span className={`text-sm font-medium ${
                      isActive ? 'text-primary' : 'text-neutral-900'
                    }`}>
                      {formatTime(event.t)}
                    </span>
                    <span className="text-xs text-neutral-500">
                      {formatDate(event.t)}
                    </span>
                    {isActive && (
                      <span className="inline-flex items-center px-1.5 py-0.5 rounded-full text-xs font-medium bg-primary/10 text-primary">
                        ACTIVE
                      </span>
                    )}
                  </div>
                  <p className={`text-sm ${
                    isActive ? 'font-medium text-neutral-900' : 'text-neutral-700'
                  }`}>
                    {event.label}
                  </p>
                  {event.description && (
                    <p className="text-xs text-neutral-600 mt-1">
                      {event.description}
                    </p>
                  )}
                  {event.type && (
                    <p className="text-xs text-neutral-500 mt-1 capitalize">
                      {event.type.replace(/_/g, ' ')}
                    </p>
                  )}
                </div>
              </li>
            );
          })}
          
          {/* Future event placeholder */}
          <li className="relative flex items-start opacity-50">
            <div className="flex-shrink-0 w-3 h-3 rounded-full border-2 border-neutral-300 bg-white z-10"></div>
            <div className="ml-4 flex-1">
              <div className="flex items-center space-x-2 mb-1">
                <span className="text-sm font-medium text-neutral-400">--:--</span>
              </div>
              <p className="text-sm text-neutral-400 italic">
                Monitoring for updates...
              </p>
            </div>
          </li>
        </ul>
      </div>
    </div>
  );
}