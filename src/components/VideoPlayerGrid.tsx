'use client'

import * as React from 'react'
import { useState, useRef, useEffect } from 'react'
import { Card, CardContent } from '@/components/ui/Card'
import { Button } from '@/components/ui/Button'
import { Badge } from '@/components/ui/Badge'
import { Text, Heading } from '@/components/ui/Typography'
import type { VideoSegment, VideoStreamSelection } from '@/types/labeling'
import { Play, Pause, Volume2, VolumeX, CheckCircle2, Circle, Maximize2, X } from 'lucide-react'

interface VideoPlayerGridProps {
  videoSegments: VideoSegment[]
  videoSelections: VideoStreamSelection[]
  onSelectionChange: (selections: VideoStreamSelection[]) => void
}

interface VideoPlayerProps {
  segment: VideoSegment
  isSelected: boolean
  onSelectionToggle: () => void
  onEnlarge?: () => void
}

function VideoPlayer({ segment, isSelected, onSelectionToggle, onEnlarge }: VideoPlayerProps) {
  const videoRef = useRef<HTMLVideoElement>(null)
  const [isPlaying, setIsPlaying] = useState(false)
  const [isMuted, setIsMuted] = useState(true)
  const [hasError, setHasError] = useState(false)
  const [isLoading, setIsLoading] = useState(true)
  const [currentTime, setCurrentTime] = useState(0)
  const [duration, setDuration] = useState(0)

  // Generate the video URL using our proxy endpoint to handle authentication
  const getVideoUrl = () => {
    // Use our proxy endpoint to handle GCS authentication and CORS
    return `/api/video-segments/${segment.segment_id}`
  }

  const togglePlay = async () => {
    if (!videoRef.current) return
    
    try {
      if (isPlaying) {
        videoRef.current.pause()
        setIsPlaying(false)
      } else {
        await videoRef.current.play()
        setIsPlaying(true)
      }
    } catch (error) {
      console.error('Error playing video:', error)
      setHasError(true)
    }
  }

  const toggleMute = () => {
    if (!videoRef.current) return
    
    videoRef.current.muted = !isMuted
    setIsMuted(!isMuted)
  }

  const handleTimeUpdate = () => {
    if (videoRef.current) {
      setCurrentTime(videoRef.current.currentTime)
    }
  }

  const handleLoadedMetadata = () => {
    if (videoRef.current) {
      setDuration(videoRef.current.duration)
      setIsLoading(false)
    }
  }

  const handleError = () => {
    setHasError(true)
    setIsLoading(false)
  }

  const formatTime = (time: number) => {
    const minutes = Math.floor(time / 60)
    const seconds = Math.floor(time % 60)
    return `${minutes}:${seconds.toString().padStart(2, '0')}`
  }

  const formatFileSize = (bytes: number) => {
    const mb = bytes / (1024 * 1024)
    return `${mb.toFixed(1)} MB`
  }

  return (
    <Card
      className={`relative ${isSelected ? 'ring-2 ring-primary bg-blue-100 dark:bg-blue-900/40' : ''}`}
      style={isSelected ? { backgroundColor: 'rgba(59,130,246,0.15)' } : undefined} // fallback for blue-100
    >
      <CardContent className="p-1">
        {/* Top Controls */}
        <div className="absolute top-2 right-2 z-10 flex gap-1">
          <Button
            size="sm"
            variant="outline"
            className="w-7 h-7 p-0 bg-background/80"
            onClick={onEnlarge}
            title="Enlarge video"
          >
            <Maximize2 className="w-3 h-3" />
          </Button>
          <Button
            size="sm"
            variant={isSelected ? 'primary' : 'outline'}
            className="w-7 h-7 p-0 bg-background/80"
            onClick={onSelectionToggle}
          >
            {isSelected ? (
              <CheckCircle2 className="w-3 h-3" />
            ) : (
              <Circle className="w-3 h-3" />
            )}
          </Button>
        </div>

        {/* Video Element - Larger */}
        <div className="relative aspect-video bg-surface rounded mb-0.5 overflow-hidden">
          {hasError ? (
            <div className="absolute inset-0 flex flex-col items-center justify-center bg-surface text-neutral-400">
              <Text variant="caption" className="text-center">
                Failed to load video
              </Text>
              <Text variant="caption" className="text-xs text-neutral-500 mt-1">
                {segment.segment_filename}
              </Text>
            </div>
          ) : (
            <>
              <video
                ref={videoRef}
                className="w-full h-full object-cover"
                muted={isMuted}
                onTimeUpdate={handleTimeUpdate}
                onLoadedMetadata={handleLoadedMetadata}
                onError={handleError}
                onEnded={() => setIsPlaying(false)}
                preload="metadata"
              >
                <source src={getVideoUrl()} type="video/mp4" />
                Your browser does not support the video tag.
              </video>
              
              {isLoading && (
                <div className="absolute inset-0 flex items-center justify-center bg-surface/80">
                  <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-primary"></div>
                </div>
              )}
            </>
          )}
        </div>

        {/* Video Controls - Compact */}
        {!hasError && (
          <div className="space-y-1">
            <div className="flex items-center gap-1">
              <Button
                size="sm"
                variant="outline"
                className="w-6 h-6 p-0"
                onClick={togglePlay}
                disabled={isLoading}
              >
                {isPlaying ? (
                  <Pause className="w-2.5 h-2.5" />
                ) : (
                  <Play className="w-2.5 h-2.5" />
                )}
              </Button>

              <Button
                size="sm"
                variant="outline"
                className="w-6 h-6 p-0"
                onClick={toggleMute}
              >
                {isMuted ? (
                  <VolumeX className="w-2.5 h-2.5" />
                ) : (
                  <Volume2 className="w-2.5 h-2.5" />
                )}
              </Button>

              <div className="flex-1 text-xs text-neutral-400">
                {formatTime(currentTime)} / {formatTime(duration)}
              </div>
            </div>

            {/* Progress Bar */}
            <div className="w-full bg-surface rounded-full h-0.5">
              <div
                className="bg-primary h-0.5 rounded-full transition-all"
                style={{ width: duration > 0 ? `${(currentTime / duration) * 100}%` : '0%' }}
              />
            </div>
          </div>
        )}

        {/* Video Info - Compressed */}
        <div className="mt-1 space-y-0.5">
          <div className="flex items-center justify-between">
            <Badge variant="outline" className="text-xs h-4 px-1">
              Cam {segment.camera_id}
            </Badge>
            <div className="flex items-center gap-1 text-xs text-neutral-500">
              <span>{formatFileSize(segment.segment_size_bytes)}</span>
              <span>•</span>
              <span>
                {typeof segment.segment_duration === 'number' 
                  ? segment.segment_duration.toFixed(1) 
                  : parseFloat(segment.segment_duration || '0').toFixed(1)
                }s
              </span>
            </div>
          </div>
          
          <Text variant="caption" className="text-xs text-neutral-500 truncate">
            {segment.camera_roadway}
          </Text>
        </div>
      </CardContent>
    </Card>
  )
}

export function VideoPlayerGrid({ 
  videoSegments, 
  videoSelections, 
  onSelectionChange 
}: VideoPlayerGridProps) {
  const [enlargedSegment, setEnlargedSegment] = useState<VideoSegment | null>(null)

  const formatFileSize = (bytes: number) => {
    const mb = bytes / (1024 * 1024)
    return `${mb.toFixed(1)} MB`
  }

  const handleSelectionToggle = (segmentId: number) => {
    const newSelections = videoSelections.map(selection => 
      selection.segment_id === segmentId 
        ? { ...selection, selected: !selection.selected }
        : selection
    )
    onSelectionChange(newSelections)
  }

  const handleEnlarge = (segment: VideoSegment) => {
    setEnlargedSegment(segment)
  }

  const selectedCount = videoSelections.filter(s => s.selected).length
  const allSelected = selectedCount === videoSegments.length

  if (videoSegments.length === 0) {
    return (
      <div className="text-center py-8">
        <Text variant="body2" className="text-neutral-400">
          No video segments available
        </Text>
      </div>
    )
  }

  return (
    <div className="space-y-4">
      {/* Selection Summary */}
      <div className="flex items-center justify-between">
        <Text variant="caption" className="text-neutral-400">
          {selectedCount} of {videoSegments.length} streams selected
        </Text>
        
        <div className="flex gap-2">
          <Button
            size="sm"
            variant={allSelected ? "primary" : "outline"}
            onClick={() => {
              const allSelectedState = videoSelections.map(s => ({ ...s, selected: true }))
              onSelectionChange(allSelectedState)
            }}
          >
            Select All
          </Button>
          <Button
            size="sm"
            variant="outline"
            onClick={() => {
              const allUnselected = videoSelections.map(s => ({ ...s, selected: false }))
              onSelectionChange(allUnselected)
            }}
          >
            Clear All
          </Button>
        </div>
      </div>

      {/* Video Grid - Taller and More Responsive */}
      <div className="grid grid-cols-2 gap-1 h-[calc(100vh-20rem)] overflow-y-auto">
        {videoSegments.map((segment) => {
          const selection = videoSelections.find(s => s.segment_id === segment.segment_id)
          return (
            <VideoPlayer
              key={segment.segment_id}
              segment={segment}
              isSelected={selection?.selected || false}
              onSelectionToggle={() => handleSelectionToggle(segment.segment_id)}
              onEnlarge={() => handleEnlarge(segment)}
            />
          )
        })}
      </div>

      {/* Enlarged Video Modal */}
      {enlargedSegment && (
        <div className="fixed inset-0 bg-black/90 z-50 flex items-center justify-center p-4">
          <div className="relative w-full max-w-6xl max-h-full">
            {/* Close Button */}
            <Button
              variant="outline"
              className="absolute top-4 right-4 z-10 w-10 h-10 p-0 bg-background/80"
              onClick={() => setEnlargedSegment(null)}
            >
              <X className="w-5 h-5" />
            </Button>
            
            {/* Enlarged Video */}
            <div className="bg-background rounded-lg p-6">
              <div className="flex items-center justify-between mb-4">
                <Heading variant="h3">
                  Camera {enlargedSegment.camera_id} - {enlargedSegment.camera_roadway}
                </Heading>
                <Badge variant="outline">
                  {formatFileSize(enlargedSegment.segment_size_bytes)} • {
                    typeof enlargedSegment.segment_duration === 'number' 
                      ? enlargedSegment.segment_duration.toFixed(1) 
                      : parseFloat(enlargedSegment.segment_duration || '0').toFixed(1)
                  }s
                </Badge>
              </div>
              
              <div className="aspect-video bg-surface rounded overflow-hidden">
                <video
                  className="w-full h-full object-cover"
                  controls
                  autoPlay
                  preload="metadata"
                >
                  <source src={`/api/video-segments/${enlargedSegment.segment_id}`} type="video/mp4" />
                  Your browser does not support the video tag.
                </video>
              </div>
              
              <div className="mt-4 text-sm text-neutral-400">
                <p>Segment: {enlargedSegment.segment_filename}</p>
                <p>Captured: {new Date(enlargedSegment.capture_timestamp).toLocaleString()}</p>
                <p>Location: {enlargedSegment.camera_roadway}, {enlargedSegment.camera_county}</p>
              </div>
            </div>
          </div>
        </div>
      )}

      {videoSegments.length > 4 && (
        <Text variant="caption" className="text-neutral-500 text-center">
          Scroll to see all {videoSegments.length} video segments
        </Text>
      )}
    </div>
  )
}