'use client';

import { XMarkIcon, MapPinIcon, ClockIcon } from '@heroicons/react/24/solid';
import { AlertsPanelProps, AlertCardProps, AlertSeverity } from '@/types/dashboard';

// Type-safe styling configuration
const SEVERITY_STYLES: Record<AlertSeverity, {
  container: string;
  badge: string;
}> = {
  info: {
    container: 'border-l-4 border-l-neutral-400 bg-neutral-50',
    badge: 'bg-neutral-100 text-neutral-800',
  },
  warning: {
    container: 'border-l-4 border-l-yellow-400 bg-yellow-50',
    badge: 'bg-yellow-100 text-yellow-800',
  },
  critical: {
    container: 'border-l-4 border-l-red-500 bg-red-50',
    badge: 'bg-red-100 text-red-800',
  },
};

function AlertCard({ alert, onClick }: AlertCardProps) {
  const styles = SEVERITY_STYLES[alert.severity];

  const handleCardClick = () => {
    if (onClick) {
      onClick(alert.id);
    }
  };

  return (
    <div 
      className={`mx-4 my-3 p-4 rounded-lg shadow-sm cursor-pointer transition-transform hover:scale-[1.02] ${styles.container}`}
      onClick={handleCardClick}
    >
      {/* Alert Header with Severity Badge */}
      <div className="flex items-start justify-between mb-2">
        <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${styles.badge}`}>
          {alert.severity.toUpperCase()}
        </span>
        <div className="flex items-center text-xs text-neutral-500">
          <ClockIcon className="h-3 w-3 mr-1" />
          {alert.timeAgo}
        </div>
      </div>
      
      {/* Location Information */}
      <div className="flex items-center mb-2">
        <MapPinIcon className="h-4 w-4 text-neutral-400 mr-1 flex-shrink-0" />
        <span className="text-sm font-medium text-neutral-700 truncate">{alert.location}</span>
      </div>
      
      {/* Alert Description */}
      <p className="text-sm text-neutral-600 leading-relaxed mb-3 line-clamp-3">
        {alert.description}
      </p>
      
      {/* Action Button */}
      <button 
        className="text-sm text-primary hover:text-primary/80 font-medium transition-colors"
        onClick={(e) => {
          e.stopPropagation(); // Prevent card click when button is clicked
          // Navigate to incident details
          console.log('View details clicked for alert:', alert.id);
        }}
      >
        View Details →
      </button>
    </div>
  );
}

export default function AlertsPanel({ isOpen, alerts, onClose }: AlertsPanelProps) {
  return (
    <>
      {/* Backdrop overlay */}
      {isOpen && (
        <div 
          className="fixed inset-0 bg-black bg-opacity-25 z-30 lg:hidden"
          onClick={onClose}
        />
      )}
      
      {/* Sliding Panel */}
      <div className={`fixed top-16 right-0 h-full w-96 bg-surface shadow-xl transform transition-transform duration-300 ease-in-out z-40 ${
        isOpen ? 'translate-x-0' : 'translate-x-full'
      }`}>
        
        {/* Panel Header */}
        <div className="flex items-center justify-between p-4 border-b border-neutral-200 bg-surface sticky top-0 z-10">
          <div className="flex items-center">
            <h2 className="text-lg font-semibold text-neutral-900">Live Alerts</h2>
            <span className="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary/10 text-primary">
              {alerts.length}
            </span>
          </div>
          <button 
            onClick={onClose}
            className="p-2 hover:bg-neutral-100 rounded-md transition-colors"
            aria-label="Close alerts panel"
          >
            <XMarkIcon className="h-5 w-5 text-neutral-400" />
          </button>
        </div>
        
        {/* Scrollable Alert Cards */}
        <div className="overflow-y-auto h-full pb-20">
          {alerts.length > 0 ? (
            alerts.map(alert => (
              <AlertCard 
                key={alert.id} 
                alert={alert}
                onClick={(alertId) => {
                  // Handle alert card click - could navigate to incident details
                  console.log('Alert clicked:', alertId);
                }}
              />
            ))
          ) : (
            <div className="flex items-center justify-center h-64 text-neutral-500">
              <div className="text-center">
                <div className="text-4xl mb-2">🎉</div>
                <p className="text-sm">No active alerts</p>
                <p className="text-xs text-neutral-400 mt-1">All systems running smoothly</p>
              </div>
            </div>
          )}
        </div>
      </div>
    </>
  );
}