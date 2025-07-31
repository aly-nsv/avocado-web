'use client';

import { XMarkIcon, PlayIcon, PauseIcon } from '@heroicons/react/24/solid';
import { useState, useEffect, useRef } from 'react';
import Hls from 'hls.js';

interface Camera {
  id: string;
  state: string;
  coords: [number, number];
  road: string;
  milepost: number;
  status: 'online' | 'offline';
  stream_url: string | null;
  sourceId?: string | null;
  systemSource?: string | null;
}

interface VideoDrawerProps {
  cameras: Camera[];
  onClose: () => void;
}

// HLS Video Player Component with Authentication Support
function HLSVideoPlayer({ src, playing, onToggle, cameraId, camera }: { 
  src: string; 
  playing: boolean; 
  onToggle: () => void; 
  cameraId: string;
  camera?: Camera;
}) {
  const videoRef = useRef<HTMLVideoElement>(null);
  const hlsRef = useRef<Hls | null>(null);
  const [streamUrl, setStreamUrl] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Get authenticated stream URL
  useEffect(() => {
    const getAuthenticatedUrl = async () => {
      setLoading(true);
      setError(null);

      try {
        // Check if URL needs authentication (divas.cloud/dis-se domains)
        const needsAuth = src.includes('divas.cloud') || src.includes('dis-se');
        
        if (!needsAuth) {
          setStreamUrl(src);
          setLoading(false);
          return;
        }

        // Extract sourceId from camera metadata if available
        const urlParams = new URLSearchParams();
        urlParams.set('originalUrl', src);
        
        // Use sourceId from camera metadata, or extract from URL, or fallback to camera ID
        const sourceId = camera?.sourceId || extractSourceId(src) || cameraId;
        if (sourceId) {
          urlParams.set('sourceId', sourceId);
        }

        const proxyResponse = await fetch(`/api/video-proxy/${cameraId}?${urlParams}`);
        
        if (!proxyResponse.ok) {
          throw new Error(`Authentication failed: ${proxyResponse.status}`);
        }

        const proxyData = await proxyResponse.json();
        
        if (proxyData.secureUrl) {
          setStreamUrl(proxyData.secureUrl);
        } else {
          throw new Error(proxyData.error || 'No secure URL returned');
        }

      } catch (err) {
        console.error('Video authentication error:', err);
        setError(err instanceof Error ? err.message : 'Authentication failed');
        // Don't fallback to original URL since it will fail with CORS
        setStreamUrl(null);
      } finally {
        setLoading(false);
      }
    };

    getAuthenticatedUrl();
  }, [src, cameraId]);

  // Initialize HLS player when stream URL is available
  useEffect(() => {
    const video = videoRef.current;
    if (!video || !streamUrl) return;

    if (Hls.isSupported()) {
      const hls = new Hls({
        enableWorker: true,
        lowLatencyMode: true,
        backBufferLength: 90,
        xhrSetup: (xhr, url) => {
          // Add custom headers for authenticated requests
          xhr.setRequestHeader('Cache-Control', 'no-cache');
        }
      });
      hlsRef.current = hls;

      hls.loadSource(streamUrl);
      hls.attachMedia(video);

      hls.on(Hls.Events.MANIFEST_PARSED, () => {
        if (playing) {
          video.play().catch(console.error);
        }
      });

      hls.on(Hls.Events.ERROR, (event, data) => {
        console.warn('HLS error:', data);
        if (data.fatal) {
          console.error('HLS fatal error:', data);
          switch (data.type) {
            case Hls.ErrorTypes.NETWORK_ERROR:
              console.log('Network error, attempting reload...');
              hls.startLoad();
              break;
            case Hls.ErrorTypes.MEDIA_ERROR:
              console.log('Media error, attempting recovery...');
              hls.recoverMediaError();
              break;
            default:
              console.error('Unrecoverable HLS error, destroying player');
              setError('Stream playback failed');
              hls.destroy();
              break;
          }
        }
      });
    } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
      // Safari native HLS support
      video.src = streamUrl;
      if (playing) {
        video.play().catch(console.error);
      }
    }

    return () => {
      if (hlsRef.current) {
        hlsRef.current.destroy();
        hlsRef.current = null;
      }
    };
  }, [streamUrl]);

  // Control playback
  useEffect(() => {
    const video = videoRef.current;
    if (!video) return;

    if (playing) {
      video.play().catch(console.error);
    } else {
      video.pause();
    }
  }, [playing]);

  // Helper function to extract sourceId from URL
  function extractSourceId(url: string): string | null {
    // Try to extract channel ID from URL like "chan-9213_h"
    const channelMatch = url.match(/chan-(\d+)_/);
    if (channelMatch) {
      return channelMatch[1];
    }
    return null;
  }

  if (loading) {
    return (
      <div className="w-full h-full bg-neutral-800 flex items-center justify-center">
        <div className="text-center text-neutral-400">
          <div className="animate-spin w-8 h-8 border-2 border-neutral-600 border-t-white rounded-full mx-auto mb-2"></div>
          <div className="text-sm">Authenticating stream...</div>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="w-full h-full bg-neutral-800 flex items-center justify-center">
        <div className="text-center text-neutral-400 p-4">
          <div className="text-red-400 text-lg mb-2">⚠️</div>
          <div className="text-sm mb-2">Stream Unavailable</div>
          <div className="text-xs text-neutral-500">{error}</div>
          <button 
            onClick={() => window.location.reload()} 
            className="mt-2 px-3 py-1 bg-neutral-700 hover:bg-neutral-600 rounded text-xs"
          >
            Retry
          </button>
        </div>
      </div>
    );
  }

  return (
    <>
      <video
        ref={videoRef}
        className="w-full h-full object-cover"
        muted
        playsInline
        controls={false}
      />
      
      {/* Video Controls Overlay */}
      <div className="absolute inset-0 bg-black bg-opacity-0 hover:bg-opacity-30 transition-all duration-200 flex items-center justify-center">
        <button
          onClick={onToggle}
          className="bg-black bg-opacity-50 hover:bg-opacity-70 text-white rounded-full p-3 transition-all duration-200 opacity-0 hover:opacity-100"
        >
          {playing ? (
            <PauseIcon className="h-6 w-6" />
          ) : (
            <PlayIcon className="h-6 w-6" />
          )}
        </button>
      </div>
      
      {/* Live Indicator */}
      <div className="absolute top-2 left-2">
        <div className="bg-red-600 text-white text-xs font-bold px-2 py-1 rounded flex items-center">
          <div className="w-2 h-2 bg-white rounded-full mr-1 animate-pulse"></div>
          LIVE
        </div>
      </div>
    </>
  );
}

export default function VideoDrawer({ cameras, onClose }: VideoDrawerProps) {
  const [playingVideos, setPlayingVideos] = useState<Set<string>>(new Set());

  const toggleVideo = (cameraId: string) => {
    setPlayingVideos(prev => {
      const newSet = new Set(prev);
      if (newSet.has(cameraId)) {
        newSet.delete(cameraId);
      } else {
        newSet.add(cameraId);
      }
      return newSet;
    });
  };

  return (
    <div className="fixed top-16 right-0 h-full w-[480px] bg-surface shadow-xl border-l border-neutral-200 z-40 overflow-y-auto">
      {/* Header */}
      <div className="flex items-center justify-between p-4 border-b border-neutral-200 bg-surface sticky top-0 z-10">
        <div className="flex items-center">
          <h2 className="text-lg font-semibold text-neutral-900">Camera Feeds</h2>
          <span className="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary/10 text-primary">
            {cameras.length}
          </span>
        </div>
        <button 
          onClick={onClose}
          className="p-2 hover:bg-neutral-100 rounded-md transition-colors"
          aria-label="Close video drawer"
        >
          <XMarkIcon className="h-5 w-5 text-neutral-400" />
        </button>
      </div>

      {/* Video Feeds */}
      <div className="p-4 space-y-4">
        {cameras.length > 0 ? (
          cameras.map(camera => (
            <div key={camera.id} className="bg-background rounded-lg border border-neutral-200 overflow-hidden">
              {/* Camera Info Header */}
              <div className="px-4 py-3 border-b border-neutral-200">
                <div className="flex items-center justify-between">
                  <div>
                    <h3 className="font-medium text-neutral-900">{camera.road}</h3>
                    <p className="text-sm text-neutral-600">
                      MP {camera.milepost} • {camera.status.toUpperCase()}
                    </p>
                  </div>
                  <div className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${
                    camera.status === 'online' 
                      ? 'bg-green-100 text-green-800' 
                      : 'bg-red-100 text-red-800'
                  }`}>
                    {camera.status === 'online' ? '● LIVE' : '● OFFLINE'}
                  </div>
                </div>
              </div>

              {/* Video Container */}
              <div className="relative aspect-video bg-neutral-900">
                {camera.stream_url && camera.status === 'online' ? (
                  <>
                    {camera.stream_url.includes('.m3u8') ? (
                      // HLS Stream
                      <HLSVideoPlayer
                        src={camera.stream_url}
                        playing={playingVideos.has(camera.id)}
                        onToggle={() => toggleVideo(camera.id)}
                        cameraId={camera.id}
                        camera={camera}
                      />
                    ) : (
                      // Regular MP4 Video
                      <>
                        <video
                          className="w-full h-full object-cover"
                          muted
                          loop
                          autoPlay={playingVideos.has(camera.id)}
                          poster="/api/placeholder/400/225"
                        >
                          <source src={camera.stream_url} type="video/mp4" />
                          Your browser does not support the video tag.
                        </video>
                        
                        {/* Video Controls Overlay */}
                        <div className="absolute inset-0 bg-black bg-opacity-0 hover:bg-opacity-30 transition-all duration-200 flex items-center justify-center">
                          <button
                            onClick={() => toggleVideo(camera.id)}
                            className="bg-black bg-opacity-50 hover:bg-opacity-70 text-white rounded-full p-3 transition-all duration-200 opacity-0 hover:opacity-100"
                          >
                            {playingVideos.has(camera.id) ? (
                              <PauseIcon className="h-6 w-6" />
                            ) : (
                              <PlayIcon className="h-6 w-6" />
                            )}
                          </button>
                        </div>
                        
                        {/* Live Indicator */}
                        <div className="absolute top-2 left-2">
                          <div className="bg-red-600 text-white text-xs font-bold px-2 py-1 rounded flex items-center">
                            <div className="w-2 h-2 bg-white rounded-full mr-1 animate-pulse"></div>
                            LIVE
                          </div>
                        </div>
                      </>
                    )}
                  </>
                ) : (
                  // Offline State
                  <div className="w-full h-full bg-neutral-800 flex flex-col items-center justify-center text-neutral-400">
                    <div className="text-4xl mb-3">📹</div>
                    <div className="text-lg font-medium mb-1">Feed Offline</div>
                    <div className="text-sm text-center px-4">
                      Camera {camera.id} is currently unavailable
                    </div>
                  </div>
                )}
              </div>

              {/* Camera Details */}
              <div className="px-4 py-3 bg-neutral-50 text-xs text-neutral-600">
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <span className="font-medium">Camera ID:</span><br />
                    {camera.id}
                  </div>
                  <div>
                    <span className="font-medium">Location:</span><br />
                    {camera.coords[1].toFixed(4)}, {camera.coords[0].toFixed(4)}
                  </div>
                </div>
              </div>
            </div>
          ))
        ) : (
          <div className="flex items-center justify-center h-64 text-neutral-500">
            <div className="text-center">
              <div className="text-4xl mb-2">📹</div>
              <p className="text-sm">No cameras selected</p>
              <p className="text-xs text-neutral-400 mt-1">Click on camera pins to view feeds</p>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}