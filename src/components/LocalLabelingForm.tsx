'use client'

import * as React from 'react'
import { useState } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/Card'
import { Button } from '@/components/ui/Button'
import { Badge } from '@/components/ui/Badge'
import { Text } from '@/components/ui/Typography'
import { Input } from '@/components/ui/Input'
import type { 
  Incident,
  LocalLabelData,
  AISuggestion,
  CSVDownloadData,
  VideoStreamSelection,
  LabelSelection
} from '@/types/labeling'
import { CheckCircle2, Circle, Sparkles, Download } from 'lucide-react'

interface LocalLabelingFormProps {
  incident: Incident
  videoSelections: VideoStreamSelection[]
  onVideoSelectionsChange: (selections: VideoStreamSelection[]) => void
  onLabelSubmit: (data: LocalLabelData) => void
  localLabelingData: LocalLabelData[]
  onDownloadCSV: () => void
  onComplete: () => void
}

// Import the label configuration
import labelConfig from '../../label-types.json'
import { Loader2, AlertCircle } from 'lucide-react'

export function LocalLabelingForm({ 
  incident, 
  videoSelections,
  onVideoSelectionsChange,
  onLabelSubmit,
  localLabelingData,
  onDownloadCSV,
  onComplete
}: LocalLabelingFormProps) {
  const [currentStep, setCurrentStep] = useState<'video_quality' | 'ai_suggestions' | 'incidents' | 'actors' | 'confidence_review' | 'complete'>('video_quality')
  const [videoQuality, setVideoQuality] = useState<'high' | 'medium' | 'low' | 'none' | null>(null)
  const [labelSelections, setLabelSelections] = useState<LabelSelection[]>([])
  const [notes, setNotes] = useState('')
  const [isLoadingAI, setIsLoadingAI] = useState(false)
  const [errors, setErrors] = useState<Record<string, string>>({})

  // Extract AI suggestions from incident labels JSON
  const aiSuggestions: AISuggestion[] = React.useMemo(() => {
    if (!incident.labels || !Array.isArray(incident.labels)) return []
    
    return incident.labels.map(label => ({
      label_type: label.label_type || '',
      confidence: label.confidence || 0,
      reasoning: label.metadata?.reasoning || 'AI suggested label'
    })).filter(suggestion => suggestion.label_type)
  }, [incident.labels])

  const handleVideoQualitySubmit = () => {
    if (videoQuality) {
      setCurrentStep('ai_suggestions')
    }
  }

  // Get current step configuration
  const getCurrentStepConfig = () => {
    if (currentStep === 'video_quality') return null
    return (labelConfig.question_flow as any)[currentStep]
  }

  // Get available labels for current step
  const getLabelsForStep = () => {
    const stepConfig = getCurrentStepConfig()
    if (!stepConfig?.categories) return []
    
    const allLabels = [
      ...labelConfig.incidents,
      ...labelConfig.actors
    ]

    return allLabels.filter(label => {
      // Filter by categories
      const inCategory = stepConfig.categories?.some((cat: string) => {
        if (cat === 'incidents') return labelConfig.incidents.includes(label)
        if (cat === 'actors') return labelConfig.actors.includes(label)
        return false
      })

      // Filter by priority if specified
      const inPriority = !stepConfig.priority_filter || 
        stepConfig.priority_filter.includes(label.priority)

      return inCategory && inPriority
    })
  }

  const handleLabelToggle = (labelType: string) => {
    const existing = labelSelections.find(ls => ls.label_type === labelType)
    
    if (existing) {
      // Remove the selection
      setLabelSelections(prev => prev.filter(ls => ls.label_type !== labelType))
    } else {
      // Add the selection
      const selectedSegmentIds = videoSelections
        .filter(vs => vs.selected)
        .map(vs => vs.segment_id)
      
      const newSelection: LabelSelection = {
        label_type: labelType,
        selected: true,
        confidence: 3, // Default middle confidence (1-5 scale)
        segment_ids: selectedSegmentIds
      }
      
      setLabelSelections(prev => [...prev, newSelection])
    }
  }

  const handleConfidenceChange = (labelType: string, confidence: number) => {
    setLabelSelections(prev => prev.map(ls => 
      ls.label_type === labelType 
        ? { ...ls, confidence }
        : ls
    ))
  }

  const handleNextStep = () => {
    const stepConfig = getCurrentStepConfig()
    setErrors({})

    // Navigate to next step
    if (currentStep === 'video_quality') {
      setCurrentStep('ai_suggestions')
    } else if (stepConfig?.next) {
      setCurrentStep(stepConfig.next as any)
    }
  }

  const handlePreviousStep = () => {
    // Navigate back through the flow
    const steps = ['video_quality', 'ai_suggestions', 'incidents', 'actors', 'confidence_review']
    const currentIndex = steps.indexOf(currentStep)
    if (currentIndex > 0) {
      setCurrentStep(steps[currentIndex - 1] as any)
    }
  }

  const handleSubmit = () => {
    if (!videoQuality) return

    const confidenceRatings = labelSelections.reduce((acc, selection) => {
      if (selection.confidence) {
        acc[selection.label_type] = selection.confidence
      }
      return acc
    }, {} as Record<string, number>)

    const labelData: LocalLabelData = {
      incident_id: incident.incident_id,
      video_quality: videoQuality,
      selected_labels: labelSelections.map(ls => ls.label_type),
      ai_suggested_labels: aiSuggestions,
      confidence_ratings: confidenceRatings,
      notes: notes.trim() || undefined,
      timestamp: new Date().toISOString()
    }

    onLabelSubmit(labelData)
    
    // Reset form
    setCurrentStep('video_quality')
    setVideoQuality(null)
    setLabelSelections([])
    setNotes('')
    setErrors({})
    
    // Trigger completion callback to move to next incident
    onComplete()
  }

  const renderCurrentStep = () => {
    switch (currentStep) {
      case 'video_quality':
        return (
          <div className="space-y-4">
            <Text variant="body2" className="text-sm font-medium">
              What is the video quality for this incident?
            </Text>
            
            <div className="space-y-2">
              {(['high', 'medium', 'low', 'none'] as const).map(quality => (
                <div
                  key={quality}
                  className={`p-3 rounded border cursor-pointer transition-all ${
                    videoQuality === quality
                      ? 'bg-primary/10 border-primary'
                      : 'bg-surface border-neutral-700 hover:border-neutral-600'
                  }`}
                  onClick={() => setVideoQuality(quality)}
                >
                  <div className="flex items-center gap-2">
                    {videoQuality === quality ? (
                      <CheckCircle2 className="w-4 h-4 text-primary" />
                    ) : (
                      <Circle className="w-4 h-4 text-neutral-400" />
                    )}
                    <Text variant="caption" className="font-medium capitalize">
                      {quality}
                    </Text>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )


      case 'ai_suggestions':
        return (
          <div className="space-y-4">
            <div className="flex items-center gap-2">
              <Sparkles className="w-4 h-4 text-yellow-400" />
              <Text variant="body2" className="text-sm">
                AI Suggested Labels
              </Text>
            </div>

            {isLoadingAI ? (
              <div className="flex items-center gap-2 p-4">
                <Loader2 className="w-4 h-4 animate-spin" />
                <Text variant="caption">Loading AI suggestions...</Text>
              </div>
            ) : (
              <div className="space-y-2">
                {aiSuggestions.map((suggestion) => (
                  <div key={suggestion.label_type} className="p-2 bg-surface rounded border-l-4 border-yellow-400">
                    <div className="flex items-center justify-between">
                      <Text variant="caption" className="font-medium">
                        {suggestion.label_type.replace(/_/g, ' ')}
                      </Text>
                      <Badge variant="outline" className="text-xs">
                        {Math.round(suggestion.confidence * 100)}% confident
                      </Badge>
                    </div>
                    <Text variant="caption" className="text-neutral-400 text-xs mt-1">
                      {suggestion.reasoning}
                    </Text>
                  </div>
                ))}
                
                {aiSuggestions.length === 0 && (
                  <Text variant="caption" className="text-neutral-400">
                    No AI suggestions available for this incident.
                  </Text>
                )}
              </div>
            )}
          </div>
        )

      case 'incidents':
      case 'actors':
        const availableLabels = getLabelsForStep()
        const categoryName = currentStep === 'incidents' ? 'Incident Types' : 'Actors'
        
        return (
          <div className="space-y-4">
            <Text variant="body2" className="text-sm">
              Select any {categoryName.toLowerCase()} you observe in the selected video streams.
            </Text>

            <div className="space-y-2 max-h-60 overflow-y-auto">
              {availableLabels.map((label) => {
                const isSelected = labelSelections.some(ls => ls.label_type === label.label_type)
                const isAISuggested = aiSuggestions.some(ai => ai.label_type === label.label_type)
                
                return (
                  <div 
                    key={label.label_type}
                    className={`p-3 rounded border cursor-pointer transition-all ${
                      isSelected 
                        ? 'bg-primary/10 border-primary' 
                        : 'bg-surface border-neutral-700 hover:border-neutral-600'
                    }`}
                    onClick={() => handleLabelToggle(label.label_type)}
                  >
                    <div className="flex items-start justify-between">
                      <div className="flex items-center gap-2">
                        {isSelected ? (
                          <CheckCircle2 className="w-4 h-4 text-primary" />
                        ) : (
                          <Circle className="w-4 h-4 text-neutral-400" />
                        )}
                        <div>
                          <div className="flex items-center gap-2">
                            <Text variant="caption" className="font-medium">
                              {label.category}
                            </Text>
                            {isAISuggested && (
                              <Sparkles className="w-3 h-3 text-yellow-400" />
                            )}
                            <Badge variant="outline" className="text-xs">
                              P{label.priority}
                            </Badge>
                          </div>
                          <Text variant="caption" className="text-neutral-400 text-xs mt-1">
                            {label.description}
                          </Text>
                        </div>
                      </div>
                    </div>
                  </div>
                )
              })}
            </div>
          </div>
        )

      case 'confidence_review':
        return (
          <div className="space-y-4">
            <Text variant="body2" className="text-sm">
              Rate your confidence for each selected label (1-5 scale).
            </Text>

            <div className="space-y-3">
              {labelSelections.map((selection) => (
                <div key={selection.label_type} className="p-3 bg-surface rounded">
                  <Text variant="caption" className="font-medium mb-2">
                    {selection.label_type.replace(/_/g, ' ')}
                  </Text>
                  
                  <div className="flex items-center gap-2">
                    <Text variant="caption" className="text-xs text-neutral-400 w-16">
                      Low (1)
                    </Text>
                    <Input
                      type="range"
                      min="1"
                      max="5"
                      step="1"
                      value={selection.confidence || 3}
                      onChange={(e) => handleConfidenceChange(
                        selection.label_type, 
                        parseInt(e.target.value)
                      )}
                      className="flex-1"
                    />
                    <Text variant="caption" className="text-xs text-neutral-400 w-16">
                      High (5)
                    </Text>
                    <Badge variant="outline" className="w-8 text-xs">
                      {selection.confidence || 3}
                    </Badge>
                  </div>
                </div>
              ))}
              
              {labelSelections.length === 0 && (
                <Text variant="caption" className="text-neutral-400">
                  No labels selected to rate.
                </Text>
              )}
            </div>

            {/* Notes */}
            <div className="space-y-2">
              <Text variant="caption" className="font-medium text-sm">
                Additional Notes (Optional)
              </Text>
              <textarea
                className="w-full p-2 bg-surface border border-neutral-700 rounded resize-none text-sm"
                rows={3}
                placeholder="Any additional observations or comments..."
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
              />
            </div>
          </div>
        )

      case 'complete':
        return (
          <div className="space-y-4">
            <div className="flex items-center gap-2 text-green-400">
              <CheckCircle2 className="w-5 h-5" />
              <Text variant="body2" className="text-sm">
                Ready to Submit
              </Text>
            </div>

            <div className="space-y-2">
              <Text variant="caption" className="text-neutral-400">
                Summary:
              </Text>
              <ul className="text-xs space-y-1 text-neutral-300">
                <li>• Video quality: {videoQuality}</li>
                <li>• Video streams: {videoSelections.filter(vs => vs.selected).length}</li>
                <li>• Labels selected: {labelSelections.length}</li>
                <li>• AI suggestions: {aiSuggestions.length}</li>
              </ul>
            </div>

            {errors.submit && (
              <div className="flex items-center gap-2 p-2 bg-red-500/10 rounded text-red-400 text-sm">
                <AlertCircle className="w-4 h-4" />
                {errors.submit}
              </div>
            )}
          </div>
        )

      default:
        return (
          <div className="text-center py-4">
            <Text variant="caption" className="text-neutral-400">
              Unknown step: {currentStep}
            </Text>
          </div>
        )
    }
  }

  // Get step info for display
  const getStepInfo = () => {
    const steps = ['video_quality', 'ai_suggestions', 'incidents', 'actors', 'confidence_review', 'complete']
    const currentIndex = steps.indexOf(currentStep)
    return { currentIndex: currentIndex + 1, totalSteps: steps.length }
  }

  const { currentIndex, totalSteps } = getStepInfo()

  return (
    <Card className="h-full flex flex-col">
      <CardHeader className="flex-shrink-0">
        <div className="flex items-center justify-between">
          <CardTitle className="text-lg">Local Labeling Process</CardTitle>
          <div className="flex items-center gap-2">
            <Badge variant="outline" className="text-xs">
              Step {currentIndex}/{totalSteps}
            </Badge>
            <Badge variant="outline" className="text-xs">
              {localLabelingData.length} completed
            </Badge>
            <Button
              variant="outline"
              size="sm"
              onClick={onDownloadCSV}
              disabled={localLabelingData.length === 0}
              className="flex items-center gap-1"
            >
              <Download className="w-3 h-3" />
              CSV
            </Button>
          </div>
        </div>
      </CardHeader>
      
      <CardContent className="flex-1 flex flex-col space-y-6">
        {/* Current Step Content */}
        <div className="flex-1 overflow-y-auto">
          {renderCurrentStep()}
        </div>

        {/* Navigation Buttons */}
        <div className="flex justify-between pt-4 border-t flex-shrink-0">
          <Button
            variant="outline"
            onClick={handlePreviousStep}
            disabled={currentStep === 'video_quality'}
          >
            Previous
          </Button>

          {currentStep === 'complete' ? (
            <Button
              onClick={handleSubmit}
              className="flex items-center gap-2"
            >
              Submit & Next Incident
            </Button>
          ) : (
            <Button 
              onClick={handleNextStep}
              disabled={currentStep === 'video_quality' && !videoQuality}
            >
              {currentStep === 'confidence_review' ? 'Complete' : 'Next'}
            </Button>
          )}
        </div>
      </CardContent>
    </Card>
  )
}