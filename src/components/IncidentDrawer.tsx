'use client';

import { XMarkIcon, ClockIcon, ExclamationTriangleIcon } from '@heroicons/react/24/solid';
import { format } from 'date-fns';

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

interface Camera {
  id: string;
  state: string;
  coords: [number, number];
  road: string;
  milepost: number;
  status: 'online' | 'offline';
  stream_url: string | null;
}

interface IncidentDrawerProps {
  incident: Incident;
  cameras: Camera[];
  onClose: () => void;
}

export default function IncidentDrawer({ incident, cameras, onClose }: IncidentDrawerProps) {
  // Find upstream and downstream cameras
  const upstreamCamera = cameras.find(cam => cam.id === incident.camera_upstream);
  const downstreamCamera = cameras.find(cam => cam.id === incident.camera_downstream);

  // Sort insights by timestamp
  const sortedInsights = [...incident.insights].sort((a, b) => 
    new Date(a.t).getTime() - new Date(b.t).getTime()
  );

  // Get latest insight for highlighting
  const latestInsight = sortedInsights[sortedInsights.length - 1];

  const getStatusBadge = (status: string) => {
    const styles = {
      open: 'bg-red-100 text-red-800',
      monitoring: 'bg-yellow-100 text-yellow-800',
      responding: 'bg-blue-100 text-blue-800',
      scheduled: 'bg-purple-100 text-purple-800',
    };
    return styles[status as keyof typeof styles] || 'bg-gray-100 text-gray-800';
  };

  const getSeverityBadge = (severity: string) => {
    const styles = {
      major: 'bg-red-100 text-red-800',
      minor: 'bg-orange-100 text-orange-800',
    };
    return styles[severity as keyof typeof styles] || 'bg-gray-100 text-gray-800';
  };

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
    <div className="fixed top-16 right-0 h-full w-[480px] bg-surface shadow-xl border-l border-neutral-200 z-40 overflow-y-auto">
      {/* Header */}
      <div className="flex items-center justify-between p-4 border-b border-neutral-200 bg-surface sticky top-0 z-10">
        <div className="flex items-center space-x-3">
          <ExclamationTriangleIcon className="h-6 w-6 text-red-500" />
          <div>
            <h2 className="text-lg font-semibold text-neutral-900">Incident {incident.id}</h2>
            <div className="flex items-center space-x-2 mt-1">
              <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${getSeverityBadge(incident.severity)}`}>
                {incident.severity.toUpperCase()}
              </span>
              <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${getStatusBadge(incident.status)}`}>
                {incident.status.toUpperCase()}
              </span>
            </div>
          </div>
        </div>
        <button 
          onClick={onClose}
          className="p-2 hover:bg-neutral-100 rounded-md transition-colors"
          aria-label="Close incident drawer"
        >
          <XMarkIcon className="h-5 w-5 text-neutral-400" />
        </button>
      </div>

      {/* Incident Content */}
      <div className="p-4">
        {/* Incident Summary */}
        <div className="bg-background rounded-lg border border-neutral-200 p-4 mb-4">
          <h3 className="font-medium text-neutral-900 mb-2">Incident Summary</h3>
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <span className="text-neutral-600">Primary Alert:</span>
              <br /><span className="font-mono">{incident.primary_alert_id}</span>
            </div>
            <div>
              <span className="text-neutral-600">Actors:</span>
              <br /><span>{incident.actors.length || 'None identified'}</span>
            </div>
            <div>
              <span className="text-neutral-600">Location:</span>
              <br /><span>{incident.coords[1].toFixed(4)}, {incident.coords[0].toFixed(4)}</span>
            </div>
            <div>
              <span className="text-neutral-600">Events:</span>
              <br /><span>{incident.insights.length} timeline events</span>
            </div>
          </div>
        </div>

        {/* Vertical Timeline */}
        <div className="bg-background rounded-lg border border-neutral-200 p-4 mb-4">
          <h3 className="font-medium text-neutral-900 mb-4 flex items-center">
            <ClockIcon className="h-4 w-4 mr-2" />
            Incident Timeline
          </h3>
          
          <div className="relative">
            {/* Timeline line */}
            <div className="absolute left-6 top-0 bottom-0 w-0.5 bg-neutral-300"></div>
            
            {/* Timeline events */}
            <ul className="space-y-4">
              {sortedInsights.map((insight, index) => {
                const isLatest = insight === latestInsight;
                return (
                  <li key={index} className="relative flex items-start">
                    {/* Timeline dot */}
                    <div className={`flex-shrink-0 w-3 h-3 rounded-full border-2 border-white z-10 ${
                      isLatest 
                        ? 'bg-red-500 ring-2 ring-red-200' 
                        : 'bg-neutral-400'
                    }`}></div>
                    
                    {/* Event content */}
                    <div className="ml-4 flex-1">
                      <div className="flex items-center space-x-2 mb-1">
                        <span className={`text-sm font-medium ${
                          isLatest ? 'text-red-600' : 'text-neutral-900'
                        }`}>
                          {formatTime(insight.t)}
                        </span>
                        <span className="text-xs text-neutral-500">
                          {formatDate(insight.t)}
                        </span>
                        {isLatest && (
                          <span className="inline-flex items-center px-1.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                            LATEST
                          </span>
                        )}
                      </div>
                      <p className={`text-sm ${
                        isLatest ? 'font-medium text-neutral-900' : 'text-neutral-700'
                      }`}>
                        {insight.description}
                      </p>
                      <p className="text-xs text-neutral-500 mt-1 capitalize">
                        {insight.type.replace(/_/g, ' ')}
                      </p>
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

        {/* Camera Feeds */}
        <div className="space-y-4">
          {/* Upstream Camera */}
          {upstreamCamera && (
            <div className="bg-background rounded-lg border border-neutral-200 overflow-hidden">
              <div className="px-4 py-3 border-b border-neutral-200">
                <h4 className="font-medium text-neutral-900">
                  📹 Upstream Camera
                </h4>
                <p className="text-sm text-neutral-600">
                  {upstreamCamera.road} • MP {upstreamCamera.milepost}
                </p>
              </div>
              <div className="relative aspect-video bg-neutral-900">
                {upstreamCamera.stream_url && upstreamCamera.status === 'online' ? (
                  <>
                    <video
                      className="w-full h-full object-cover"
                      muted
                      loop
                      autoPlay
                      poster="/api/placeholder/400/225"
                    >
                      <source src={upstreamCamera.stream_url} type="video/mp4" />
                    </video>
                    <div className="absolute top-2 left-2">
                      <div className="bg-red-600 text-white text-xs font-bold px-2 py-1 rounded flex items-center">
                        <div className="w-2 h-2 bg-white rounded-full mr-1 animate-pulse"></div>
                        LIVE
                      </div>
                    </div>
                  </>
                ) : (
                  <div className="w-full h-full bg-neutral-800 flex flex-col items-center justify-center text-neutral-400">
                    <div className="text-3xl mb-2">📹</div>
                    <div className="text-sm">Feed Offline</div>
                  </div>
                )}
              </div>
            </div>
          )}

          {/* Downstream Camera */}
          {downstreamCamera && (
            <div className="bg-background rounded-lg border border-neutral-200 overflow-hidden">
              <div className="px-4 py-3 border-b border-neutral-200">
                <h4 className="font-medium text-neutral-900">
                  📹 Downstream Camera
                </h4>
                <p className="text-sm text-neutral-600">
                  {downstreamCamera.road} • MP {downstreamCamera.milepost}
                </p>
              </div>
              <div className="relative aspect-video bg-neutral-900">
                {downstreamCamera.stream_url && downstreamCamera.status === 'online' ? (
                  <>
                    <video
                      className="w-full h-full object-cover"
                      muted
                      loop
                      autoPlay
                      poster="/api/placeholder/400/225"
                    >
                      <source src={downstreamCamera.stream_url} type="video/mp4" />
                    </video>
                    <div className="absolute top-2 left-2">
                      <div className="bg-red-600 text-white text-xs font-bold px-2 py-1 rounded flex items-center">
                        <div className="w-2 h-2 bg-white rounded-full mr-1 animate-pulse"></div>
                        LIVE
                      </div>
                    </div>
                  </>
                ) : (
                  <div className="w-full h-full bg-neutral-800 flex flex-col items-center justify-center text-neutral-400">
                    <div className="text-3xl mb-2">📹</div>
                    <div className="text-sm">Feed Offline</div>
                  </div>
                )}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}