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
  AISuggestion,
  LocalLabelData,
  CSVDownloadData,
  BadVideoIncident
} from '@/types/labeling'
import { IncidentDetailsPanel } from '@/components/IncidentDetailsPanel'
import { VideoPlayerGrid } from '@/components/VideoPlayerGrid'
import { LabelingForm } from '@/components/LabelingForm'
import { LocalLabelingForm } from '@/components/LocalLabelingForm'
import labelConfig from '../../../label-types.json'

interface ReviewConfiguration {
  filters: ('crash_description' | 'accident_description' | 'disabled_vehicles' | 'accident_type' | 'other_events' | 'construction_zones' | 'incidents' | 'closures' | 'road_condition' | 'congestion')[]
  limit: number
  offset: number
}

export default function ReviewPage() {
  const [incidents, setIncidents] = useState<ReviewIncidentData[]>([])
  const [currentIncidentIndex, setCurrentIncidentIndex] = useState(0)
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState<string>('')
  
  // Configuration state
  const [isConfigured, setIsConfigured] = useState(false)
  const [config, setConfig] = useState<ReviewConfiguration>({
    filters: ['crash_description'],
    limit: 400,
    offset: 0
  })
  
  // Local labeling session state
  const [localLabelingData, setLocalLabelingData] = useState<LocalLabelData[]>([])
  const [showLocalLabeling, setShowLocalLabeling] = useState(true)
  
  // Bad video tracking state
  const [badVideoIncidents, setBadVideoIncidents] = useState<BadVideoIncident[]>([])

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

  // Note: Removed automatic fetching - now requires configuration

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
      
      const params = new URLSearchParams({
        limit: config.limit.toString(),
        offset: config.offset.toString(),
        filters: config.filters.join(',')
      })
      
      const response = await fetch(`/api/review/incidents?${params}`)
      if (!response.ok) {
        throw new Error('Failed to fetch incidents')
      }

      const data: GetIncidentsResponse = await response.json()
      setIncidents(data.incidents)
      
      if (data.incidents.length === 0) {
        setError('No incidents with video segments found for the selected criteria')
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
      selected: true, // Select all videos by default
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

  const handleLocalLabelSubmit = (data: LocalLabelData) => {
    setLocalLabelingData(prev => [...prev, data])
  }

  const handleLocalLabelComplete = () => {
    // Move to next incident after successful completion
    if (currentIncidentIndex < incidents.length - 1) {
      handleNextIncident()
    }
  }

  const handleBadVideoSkip = () => {
    const currentIncident = incidents[currentIncidentIndex]
    if (!currentIncident) return

    const badVideoData: BadVideoIncident = {
      incident_id: currentIncident.incident.incident_id,
      roadway_name: currentIncident.incident.roadway_name,
      incident_type: currentIncident.incident.incident_type,
      description: currentIncident.incident.description || '',
      reason: 'Bad video quality - skipped by user',
      timestamp: new Date().toISOString(),
      notes: 'Video quality was deemed too poor for accurate labeling'
    }

    setBadVideoIncidents(prev => [...prev, badVideoData])
    
    // Move to next incident
    if (currentIncidentIndex < incidents.length - 1) {
      handleNextIncident()
    }
  }

  const handleConfigSubmit = async () => {
    setIsConfigured(true)
    await fetchIncidents()
  }

  const handleReconfigure = () => {
    setIsConfigured(false)
    setIncidents([])
    setCurrentIncidentIndex(0)
    setError('')
  }

  const generateCSVData = () => {
    // Use imported label config to get all possible label types
    
    // Get all possible label types
    const allIncidentLabels = labelConfig.incidents.map((label: any) => label.label_type)
    const allActorLabels = labelConfig.actors.map((label: any) => label.label_type)
    const allLabels = [...allIncidentLabels, ...allActorLabels]

    // Create header rows
    const textHeaders = [
      'Incident ID', 'Roadway Name', 'Incident Type', 'Description', 'Video Quality',
      ...labelConfig.incidents.map((label: any) => label.category),
      ...labelConfig.actors.map((label: any) => label.category),
      'AI Labels JSON', 'Human Notes', 'Timestamp'
    ]
    
    const codeHeaders = [
      'incident_id', 'roadway_name', 'incident_type', 'description', 'video_quality',
      ...allIncidentLabels,
      ...allActorLabels,
      'ai_labels_json', 'human_notes', 'timestamp'
    ]

    // Generate data rows
    const dataRows = localLabelingData.map(data => {
      const incident = incidents.find(inc => inc.incident.incident_id === data.incident_id)?.incident
      
      // Create a row with basic info + binary columns for each label
      const row: any[] = [
        data.incident_id,
        incident?.roadway_name || '',
        incident?.incident_type || '',
        incident?.description || '',
        data.video_quality,
      ]
      
      // Add binary columns for each label (1 if human selected, 0 if not)
      allLabels.forEach(labelType => {
        row.push(data.selected_labels.includes(labelType) ? 1 : 0)
      })
      
      // Add AI labels as JSON and human notes
      row.push(JSON.stringify(data.ai_suggested_labels))
      row.push(data.notes || '')
      row.push(data.timestamp)
      
      return row
    })

    return {
      textHeaders,
      codeHeaders, 
      dataRows
    }
  }

  const downloadCSV = () => {
    const { textHeaders, codeHeaders, dataRows } = generateCSVData()
    if (dataRows.length === 0) return

    // Helper function to escape CSV values
    const escapeCsvValue = (value: any) => {
      const stringValue = String(value || '')
      if (stringValue.includes(',') || stringValue.includes('"') || stringValue.includes('\n')) {
        return `"${stringValue.replace(/"/g, '""')}"`
      }
      return stringValue
    }

    // Create CSV content with dual headers + data rows
    const csvContent = [
      // First header row (text descriptions)
      textHeaders.map(escapeCsvValue).join(','),
      // Second header row (code labels)
      codeHeaders.map(escapeCsvValue).join(','),
      // Data rows
      ...dataRows.map(row => 
        row.map(escapeCsvValue).join(',')
      )
    ].join('\n')

    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
    const link = document.createElement('a')
    const url = URL.createObjectURL(blob)
    link.setAttribute('href', url)
    link.setAttribute('download', `labeling-session-${new Date().toISOString().split('T')[0]}.csv`)
    link.style.visibility = 'hidden'
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
  }

  const downloadBadVideosCSV = () => {
    if (badVideoIncidents.length === 0) return

    // Helper function to escape CSV values
    const escapeCsvValue = (value: any) => {
      const stringValue = String(value || '')
      if (stringValue.includes(',') || stringValue.includes('"') || stringValue.includes('\n')) {
        return `"${stringValue.replace(/"/g, '""')}"`
      }
      return stringValue
    }

    // Create CSV headers
    const headers = [
      'Incident ID',
      'Roadway Name', 
      'Incident Type',
      'Description',
      'Skip Reason',
      'Notes',
      'Timestamp'
    ]

    // Create CSV content
    const csvContent = [
      // Header row
      headers.map(escapeCsvValue).join(','),
      // Data rows
      ...badVideoIncidents.map(incident => [
        incident.incident_id,
        incident.roadway_name,
        incident.incident_type,
        incident.description,
        incident.reason,
        incident.notes || '',
        incident.timestamp
      ].map(escapeCsvValue).join(','))
    ].join('\n')

    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
    const link = document.createElement('a')
    const url = URL.createObjectURL(blob)
    link.setAttribute('href', url)
    link.setAttribute('download', `bad-videos-${new Date().toISOString().split('T')[0]}.csv`)
    link.style.visibility = 'hidden'
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
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

  if (incidents.length === 0 && isConfigured) {
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

  // Configuration form filters
  const filterOptions = [
    { value: 'crash_description', label: 'Description contains "Crash" (case insensitive)' },
    // { value: 'accident_description', label: 'Description contains "Accident"' },
    { value: 'disabled_vehicles', label: 'Incident Type: Disabled Vehicles' },
    // { value: 'accident_type', label: 'Incident Type: Accident' },
    { value: 'other_events', label: 'Incident Type: Other Events' },
    { value: 'construction_zones', label: 'Incident Type: Construction Zones' },
    { value: 'incidents', label: 'Incident Type: Incidents' },
    { value: 'closures', label: 'Incident Type: Closures' },
    { value: 'road_condition', label: 'Incident Type: Road Condition' },
    { value: 'congestion', label: 'Incident Type: Congestion' }
  ]

  // Show configuration form if not configured yet
  if (!isConfigured) {
    return (
      <div className="min-h-screen  bg-background flex items-center justify-center">
        <Card className="w-96 max-w-lg">
          <CardHeader>
            <CardTitle>Review Configuration</CardTitle>
            <p className="text-neutral-400 text-sm">
              Configure filters and parameters before loading incidents
            </p>
          </CardHeader>
          <CardContent className="space-y-4">
            {/* Filter Selection */}
            <div className="space-y-2">
              <label className="text-sm font-medium">Incident Filters (Select Multiple)</label>
              <div className="space-y-2 max-h-112 overflow-y-auto">
                {filterOptions.map(option => (
                  <label key={option.value} className="flex items-center space-x-2 cursor-pointer">
                    <input
                      type="checkbox"
                      checked={config.filters.includes(option.value as any)}
                      onChange={(e) => {
                        if (e.target.checked) {
                          setConfig(prev => ({ 
                            ...prev, 
                            filters: [...prev.filters, option.value as any]
                          }))
                        } else {
                          setConfig(prev => ({ 
                            ...prev, 
                            filters: prev.filters.filter(f => f !== option.value)
                          }))
                        }
                      }}
                      className="rounded border-neutral-700 bg-surface"
                    />
                    <span className="text-sm">{option.label}</span>
                  </label>
                ))}
              </div>
              {config.filters.length === 0 && (
                <p className="text-red-400 text-xs">Please select at least one filter</p>
              )}
            </div>

            {/* Limit */}
            <div className="space-y-2">
              <label className="text-sm font-medium">Total Video Segments Limit</label>
              <input
                type="number"
                min="1"
                max="1000"
                value={config.limit}
                onChange={(e) => setConfig(prev => ({ ...prev, limit: parseInt(e.target.value) || 400 }))}
                className="w-full p-2 bg-surface border border-neutral-700 rounded text-sm"
              />
            </div>

            {/* Offset */}
            <div className="space-y-2">
              <label className="text-sm font-medium">Offset (Skip incidents)</label>
              <input
                type="number"
                min="0"
                value={config.offset}
                onChange={(e) => setConfig(prev => ({ ...prev, offset: parseInt(e.target.value) || 0 }))}
                className="w-full p-2 bg-surface border border-neutral-700 rounded text-sm"
              />
            </div>

            <Button
              onClick={handleConfigSubmit}
              disabled={isLoading || config.filters.length === 0}
              className="w-full"
            >
              {isLoading ? 'Loading Incidents...' : 'Load Incidents'}
            </Button>

            {error && (
              <div className="p-3 bg-red-500/10 rounded text-red-400 text-sm">
                {error}
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    )
  }

  const currentIncident = incidents[currentIncidentIndex]

  return (
    <div className="min-h-screen bg-background">
      <div className="container mx-auto px-4 py-6">
        {/* Header */}
        <div className="flex justify-between items-center mb-6">
          <div>
            <h1 className="text-3xl font-bold">Human-AI Validation Review</h1>
            <p className="text-neutral-400 mt-1">
              Incident {currentIncidentIndex + 1} of {incidents.length}
            </p>
            <p className="text-neutral-500 text-sm mt-1">
              Filters: {config.filters.map(f => 
                filterOptions.find(opt => opt.value === f)?.label
              ).join(', ')} | 
              Limit: {config.limit} | Offset: {config.offset}
            </p>
            <p className="text-neutral-500 text-sm mt-1">
              Bad videos skipped: {badVideoIncidents.length} | 
              <button 
                onClick={downloadBadVideosCSV}
                disabled={badVideoIncidents.length === 0}
                className="text-primary hover:text-primary/80 underline disabled:text-neutral-500 disabled:no-underline ml-1"
              >
                Download Bad Videos CSV
              </button>
            </p>
          </div>
          
          <div className="flex gap-2">
            <Button 
              variant="outline" 
              onClick={handleBadVideoSkip}
              className="bg-red-500/10 border-red-500/50 text-red-400 hover:bg-red-500/20"
            >
              Bad or irrelevant video, next
            </Button>
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
            <Button 
              variant="outline"
              onClick={handleReconfigure}
            >
              Reconfigure
            </Button>
          </div>
        </div>

        {/* Main Content Grid */}
        <div className="grid grid-cols-12 gap-3">
          {/* Left Panel - Incident Details (Narrower) */}
          <div className="col-span-3 -ml-6">
            <IncidentDetailsPanel 
              incident={currentIncident.incident}
              videoSegments={currentIncident.video_segments}
              totalSegments={currentIncident.total_segments}
              camerasInvolved={currentIncident.cameras_involved}
            />
          </div>

          {/* Center Panel - Video Players (Larger & Taller) */}
          <div className="col-span-6">
            <Card className="h-[86vh]">
              <CardHeader className="pb-2">
                <CardTitle>
                  Video Segments ({currentIncident.total_segments})
                </CardTitle>
              </CardHeader>
              <CardContent className="h-full pb-2">
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

          {/* Right Panel - Local Labeling Form (Taller) */}
          <div className="col-span-3">
            <div className="h-[86vh]">
              <LocalLabelingForm 
                incident={currentIncident.incident}
                videoSelections={formState.videoSelections}
                onVideoSelectionsChange={(selections) => 
                  handleFormStateChange({ videoSelections: selections })
                }
                onLabelSubmit={handleLocalLabelSubmit}
                localLabelingData={localLabelingData}
                onDownloadCSV={downloadCSV}
                onComplete={handleLocalLabelComplete}
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}