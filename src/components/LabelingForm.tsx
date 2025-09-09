'use client'

import * as React from 'react'
import { useState, useEffect } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/Card'
import { Button } from '@/components/ui/Button'
import { Badge } from '@/components/ui/Badge'
import { Text, Heading } from '@/components/ui/Typography'
import { Input } from '@/components/ui/Input'
import type { 
  LabelingFormState, 
  Incident, 
  LabelSelection, 
  AISuggestion,
  VideoSegmentLabel,
  SubmitLabelsRequest,
  SubmitLabelsResponse,
  GetAISuggestionsRequest,
  GetAISuggestionsResponse
} from '@/types/labeling'
import { CheckCircle2, Circle, Sparkles, AlertCircle, Loader2 } from 'lucide-react'

// Import the label configuration
import labelConfig from '../../label-types.json'

interface LabelingFormProps {
  incident: Incident
  formState: LabelingFormState
  onStateChange: (newState: Partial<LabelingFormState>) => void
  onComplete: () => void
}

export function LabelingForm({ 
  incident, 
  formState, 
  onStateChange, 
  onComplete 
}: LabelingFormProps) {
  const [isLoadingAI, setIsLoadingAI] = useState(false)

  // Get current step configuration with proper typing
  const currentStepConfig = (labelConfig.question_flow as any)[formState.currentStep]

  // Get available labels for current step
  const getLabelsForStep = () => {
    if (!currentStepConfig?.categories) return []
    
    const allLabels = [
      ...labelConfig.incidents,
      ...labelConfig.actors
    ]

    return allLabels.filter(label => {
      // Filter by categories
      const inCategory = currentStepConfig.categories?.some((cat: string) => {
        if (cat === 'incidents') return labelConfig.incidents.includes(label)
        if (cat === 'actors') return labelConfig.actors.includes(label)
        return false
      })

      // Filter by priority if specified
      const inPriority = !currentStepConfig.priority_filter || 
        currentStepConfig.priority_filter.includes(label.priority)

      return inCategory && inPriority
    })
  }

  // Load AI suggestions when we reach the ai_suggestions step
  useEffect(() => {
    if (formState.currentStep === 'ai_suggestions' && 
        formState.aiSuggestions.length === 0 && 
        !isLoadingAI) {
      loadAISuggestions()
    }
  }, [formState.currentStep])

  const loadAISuggestions = async () => {
    if (!incident.description || !incident.incident_type) return

    setIsLoadingAI(true)
    
    try {
      const request: GetAISuggestionsRequest = {
        incident_description: incident.description,
        incident_type: incident.incident_type
      }

      const response = await fetch('/api/review/ai-suggestions', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(request)
      })

      if (response.ok) {
        const data: GetAISuggestionsResponse = await response.json()
        onStateChange({ aiSuggestions: data.suggestions })
      }
    } catch (error) {
      console.error('Failed to load AI suggestions:', error)
    } finally {
      setIsLoadingAI(false)
    }
  }

  const handleLabelToggle = (labelType: string) => {
    const existing = formState.labelSelections.find(ls => ls.label_type === labelType)
    
    if (existing) {
      // Remove the selection
      const newSelections = formState.labelSelections.filter(ls => ls.label_type !== labelType)
      onStateChange({ labelSelections: newSelections })
    } else {
      // Add the selection
      const selectedSegmentIds = formState.videoSelections
        .filter(vs => vs.selected)
        .map(vs => vs.segment_id)
      
      const newSelection: LabelSelection = {
        label_type: labelType,
        selected: true,
        confidence: 3, // Default middle confidence (1-5 scale)
        segment_ids: selectedSegmentIds
      }
      
      const newSelections = [...formState.labelSelections, newSelection]
      onStateChange({ labelSelections: newSelections })
    }
  }

  const handleConfidenceChange = (labelType: string, confidence: number) => {
    const newSelections = formState.labelSelections.map(ls => 
      ls.label_type === labelType 
        ? { ...ls, confidence }
        : ls
    )
    onStateChange({ labelSelections: newSelections })
  }

  const handleNextStep = () => {
    if (!currentStepConfig) return

    // Validation
    if (currentStepConfig.required) {
      if (formState.currentStep === 'video_visibility') {
        const hasSelected = formState.videoSelections.some(vs => vs.selected)
        if (!hasSelected) {
          onStateChange({ 
            errors: { video_visibility: 'Please select at least one video stream' }
          })
          return
        }
      }
    }

    // Clear errors and move to next step
    onStateChange({ 
      errors: {},
      currentStep: currentStepConfig.next 
    })
  }

  const handlePreviousStep = () => {
    // Navigate back through the flow
    const steps = Object.keys(labelConfig.question_flow)
    const currentIndex = steps.indexOf(formState.currentStep)
    if (currentIndex > 0) {
      onStateChange({ currentStep: steps[currentIndex - 1] })
    }
  }

  const handleSubmit = async () => {
    onStateChange({ isSubmitting: true, errors: {} })

    try {
      // Convert confidence from 1-5 scale to 0-1 scale and create labels
      const labels: VideoSegmentLabel[] = formState.labelSelections.map(selection => ({
        label_type: selection.label_type,
        confidence: selection.confidence ? (selection.confidence - 1) / 4 : 0.6, // Convert 1-5 to 0-1
        source: 'human' as const,
        user_id: 'anonymous', // Would be replaced with actual user ID
        timestamp: new Date().toISOString(),
        metadata: {
          question_id: formState.currentStep,
          review_session_id: formState.sessionId,
          ai_suggested: formState.aiSuggestions.some(ai => ai.label_type === selection.label_type)
        }
      }))

      const request: SubmitLabelsRequest = {
        session_id: formState.sessionId,
        incident_id: incident.incident_id,
        labels,
        video_selections: formState.videoSelections
      }

      const response = await fetch('/api/review/labels', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(request)
      })

      const result: SubmitLabelsResponse = await response.json()

      if (result.success) {
        onComplete()
      } else {
        onStateChange({ 
          errors: { submit: result.errors?.join(', ') || 'Failed to submit labels' }
        })
      }
    } catch (error) {
      onStateChange({ 
        errors: { submit: error instanceof Error ? error.message : 'Failed to submit' }
      })
    } finally {
      onStateChange({ isSubmitting: false })
    }
  }

  const renderCurrentStep = () => {
    switch (formState.currentStep) {
      case 'video_visibility':
        return (
          <div className="space-y-4">
            <Text variant="body2" className="text-sm">
              Select the video streams where you can clearly see the footage.
            </Text>
            
            <div className="text-sm text-neutral-400">
              Selected: {formState.videoSelections.filter(vs => vs.selected).length} streams
            </div>
            
            {formState.errors.video_visibility && (
              <div className="flex items-center gap-2 p-2 bg-red-500/10 rounded text-red-400 text-sm">
                <AlertCircle className="w-4 h-4" />
                {formState.errors.video_visibility}
              </div>
            )}
            
            <Text variant="caption" className="text-neutral-500">
              Use the video grid on the left to select streams with clear, visible footage.
            </Text>
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
                {formState.aiSuggestions.map((suggestion) => (
                  <div key={suggestion.label_type} className="p-2 bg-surface rounded border-l-4 border-yellow-400">
                    <div className="flex items-center justify-between">
                      <Text variant="caption" className="font-medium">
                        {suggestion.label_type.replace('_', ' ')}
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
                
                {formState.aiSuggestions.length === 0 && (
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
        const categoryName = formState.currentStep === 'incidents' ? 'Incident Types' : 'Actors'
        
        return (
          <div className="space-y-4">
            <Text variant="body2" className="text-sm">
              Select any {categoryName.toLowerCase()} you observe in the selected video streams.
            </Text>

            <div className="space-y-2 max-h-60 overflow-y-auto">
              {availableLabels.map((label) => {
                const isSelected = formState.labelSelections.some(ls => ls.label_type === label.label_type)
                const isAISuggested = formState.aiSuggestions.some(ai => ai.label_type === label.label_type)
                
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
              {formState.labelSelections.map((selection) => (
                <div key={selection.label_type} className="p-3 bg-surface rounded">
                  <Text variant="caption" className="font-medium mb-2">
                    {selection.label_type.replace('_', ' ')}
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
              
              {formState.labelSelections.length === 0 && (
                <Text variant="caption" className="text-neutral-400">
                  No labels selected to rate.
                </Text>
              )}
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
                <li>• Video streams: {formState.videoSelections.filter(vs => vs.selected).length}</li>
                <li>• Labels selected: {formState.labelSelections.length}</li>
                <li>• AI suggestions: {formState.aiSuggestions.length}</li>
              </ul>
            </div>

            {formState.errors.submit && (
              <div className="flex items-center gap-2 p-2 bg-red-500/10 rounded text-red-400 text-sm">
                <AlertCircle className="w-4 h-4" />
                {formState.errors.submit}
              </div>
            )}
          </div>
        )

      default:
        return (
          <div className="text-center py-4">
            <Text variant="caption" className="text-neutral-400">
              Unknown step: {formState.currentStep}
            </Text>
          </div>
        )
    }
  }

  if (!currentStepConfig && formState.currentStep !== 'complete') {
    return (
      <Card>
        <CardContent className="p-6">
          <Text variant="body2" className="text-red-400">
            Invalid step: {formState.currentStep}
          </Text>
        </CardContent>
      </Card>
    )
  }

  return (
    <Card className="h-full flex flex-col">
      <CardHeader className="flex-shrink-0">
        <CardTitle className="flex items-center justify-between">
          <span>Labeling Process</span>
          <Badge variant="outline" className="text-xs">
            Step {Object.keys(labelConfig.question_flow).indexOf(formState.currentStep) + 1}
          </Badge>
        </CardTitle>
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
            disabled={formState.currentStep === 'video_visibility'}
          >
            Previous
          </Button>

          {formState.currentStep === 'complete' ? (
            <Button
              onClick={handleSubmit}
              disabled={formState.isSubmitting}
              className="flex items-center gap-2"
            >
              {formState.isSubmitting ? (
                <>
                  <Loader2 className="w-4 h-4 animate-spin" />
                  Submitting...
                </>
              ) : (
                'Submit Labels'
              )}
            </Button>
          ) : (
            <Button onClick={handleNextStep}>
              {formState.currentStep === 'confidence_review' ? 'Complete' : 'Next'}
            </Button>
          )}
        </div>
      </CardContent>
    </Card>
  )
}