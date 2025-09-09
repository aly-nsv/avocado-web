'use client'

import * as React from 'react'
import { useEffect, useState } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/Card'
import { Button } from '@/components/ui/Button'
import type { 
  ReviewIncidentData, 
  GetIncidentsResponse,
  LabelingFormState,
  VideoStreamSelection,
  LabelSelection,
  AISuggestion
} from '@/types/labeling'
import { IncidentDetailsPanel } from '@/components/IncidentDetailsPanel'
import { VideoPlayerGrid } from '@/components/VideoPlayerGrid'
import { LabelingForm } from '@/components/LabelingForm'

export default function ReviewPage() {
  const [incidents, setIncidents] = useState<ReviewIncidentData[]>([])
  const [currentIncidentIndex, setCurrentIncidentIndex] = useState(0)
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState<string>('')

  // Form state for the current incident
  const [formState, setFormState] = useState<LabelingFormState>({
    currentStep: 'video_visibility',
    videoSelections: [],
    labelSelections: [],
    aiSuggestions: [],
    sessionId: '',
    isSubmitting: false,
    errors: {},
  })

  // Fetch incidents on component mount
  useEffect(() => {
    fetchIncidents()
  }, [])

  // Initialize form state when incident changes
  useEffect(() => {
    if (incidents.length > 0 && currentIncidentIndex < incidents.length) {
      initializeFormState(incidents[currentIncidentIndex])
    }
  }, [currentIncidentIndex, incidents])

  const fetchIncidents = async () => {
    try {
      setIsLoading(true)
      setError('')
      
      const response = await fetch('/api/review/incidents?limit=10')
      if (!response.ok) {
        throw new Error('Failed to fetch incidents')
      }

      const data: GetIncidentsResponse = await response.json()
      setIncidents(data.incidents)
      
      if (data.incidents.length === 0) {
        setError('No incidents with video segments found')
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load incidents')
    } finally {
      setIsLoading(false)
    }
  }

  const initializeFormState = (incident: ReviewIncidentData) => {
    const videoSelections: VideoStreamSelection[] = incident.video_segments.map(segment => ({
      segment_id: segment.segment_id,
      selected: false,
    }))

    const sessionId = `session_${Date.now()}_${incident.incident.incident_id}`

    setFormState({
      currentStep: 'video_visibility',
      videoSelections,
      labelSelections: [],
      aiSuggestions: [],
      sessionId,
      isSubmitting: false,
      errors: {},
    })
  }

  const handleNextIncident = () => {
    if (currentIncidentIndex < incidents.length - 1) {
      setCurrentIncidentIndex(prev => prev + 1)
    }
  }

  const handlePreviousIncident = () => {
    if (currentIncidentIndex > 0) {
      setCurrentIncidentIndex(prev => prev - 1)
    }
  }

  const handleFormStateChange = (newState: Partial<LabelingFormState>) => {
    setFormState(prev => ({ ...prev, ...newState }))
  }

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <Card className="w-96">
          <CardContent className="p-6">
            <div className="flex items-center justify-center">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
              <span className="ml-3">Loading incidents...</span>
            </div>
          </CardContent>
        </Card>
      </div>
    )
  }

  if (error) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <Card className="w-96">
          <CardContent className="p-6">
            <div className="text-center">
              <p className="text-red-500 mb-4">{error}</p>
              <Button onClick={fetchIncidents}>
                Try Again
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    )
  }

  if (incidents.length === 0) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <Card className="w-96">
          <CardContent className="p-6">
            <div className="text-center">
              <p className="text-neutral-400 mb-4">No incidents available for review</p>
              <Button onClick={fetchIncidents}>
                Refresh
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    )
  }

  const currentIncident = incidents[currentIncidentIndex]

  return (
    <div className="min-h-screen bg-background">
      <div className="container mx-auto p-6">
        {/* Header */}
        <div className="flex justify-between items-center mb-6">
          <div>
            <h1 className="text-3xl font-bold">Human-AI Validation Review</h1>
            <p className="text-neutral-400 mt-1">
              Incident {currentIncidentIndex + 1} of {incidents.length}
            </p>
          </div>
          
          <div className="flex gap-2">
            <Button 
              variant="outline" 
              onClick={handlePreviousIncident}
              disabled={currentIncidentIndex === 0}
            >
              Previous
            </Button>
            <Button 
              variant="outline"
              onClick={handleNextIncident}
              disabled={currentIncidentIndex === incidents.length - 1}
            >
              Next
            </Button>
            <Button 
              variant="outline"
              onClick={fetchIncidents}
            >
              Refresh
            </Button>
          </div>
        </div>

        {/* Main Content Grid */}
        <div className="grid grid-cols-12 gap-6">
          {/* Left Panel - Incident Details */}
          <div className="col-span-4">
            <IncidentDetailsPanel 
              incident={currentIncident.incident}
              videoSegments={currentIncident.video_segments}
              totalSegments={currentIncident.total_segments}
              camerasInvolved={currentIncident.cameras_involved}
            />
          </div>

          {/* Center Panel - Video Players */}
          <div className="col-span-5">
            <Card>
              <CardHeader>
                <CardTitle>
                  Video Segments ({currentIncident.total_segments})
                </CardTitle>
              </CardHeader>
              <CardContent>
                <VideoPlayerGrid 
                  videoSegments={currentIncident.video_segments}
                  videoSelections={formState.videoSelections}
                  onSelectionChange={(selections) => 
                    handleFormStateChange({ videoSelections: selections })
                  }
                />
              </CardContent>
            </Card>
          </div>

          {/* Right Panel - Labeling Form */}
          <div className="col-span-3">
            <LabelingForm 
              incident={currentIncident.incident}
              formState={formState}
              onStateChange={handleFormStateChange}
              onComplete={() => {
                // Move to next incident after successful completion
                if (currentIncidentIndex < incidents.length - 1) {
                  handleNextIncident()
                }
              }}
            />
          </div>
        </div>
      </div>
    </div>
  )
}