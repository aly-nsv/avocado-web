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
  const [currentStep, setCurrentStep] = useState<'video_quality' | 'video_visibility' | 'ai_suggestions' | 'incidents' | 'actors' | 'confidence_review' | 'complete'>('video_quality')
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
      setCurrentStep('video_visibility')
    }
  }

  const handleLabelToggle = (labelType: string) => {
    setSelectedLabels(prev => {
      if (prev.includes(labelType)) {
        const newLabels = prev.filter(l => l !== labelType)
        // Remove confidence rating for unselected label
        const newRatings = { ...confidenceRatings }
        delete newRatings[labelType]
        setConfidenceRatings(newRatings)
        return newLabels
      } else {
        // Add default confidence rating
        setConfidenceRatings(prev => ({ ...prev, [labelType]: 3 }))
        return [...prev, labelType]
      }
    })
  }

  const handleConfidenceChange = (labelType: string, confidence: number) => {
    setConfidenceRatings(prev => ({ ...prev, [labelType]: confidence }))
  }

  const handleSubmit = () => {
    if (!videoQuality) return

    const labelData: LocalLabelData = {
      incident_id: incident.incident_id,
      video_quality: videoQuality,
      selected_labels: selectedLabels,
      ai_suggested_labels: aiSuggestions,
      confidence_ratings: confidenceRatings,
      notes: notes.trim() || undefined,
      timestamp: new Date().toISOString()
    }

    onLabelSubmit(labelData)
    
    // Reset form
    setCurrentStep('video_quality')
    setVideoQuality(null)
    setSelectedLabels([])
    setConfidenceRatings({})
    setNotes('')
  }

  const renderVideoQualityStep = () => (
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

      <Button 
        onClick={handleVideoQualitySubmit}
        disabled={!videoQuality}
        className="w-full"
      >
        Continue to Labeling
      </Button>
    </div>
  )

  const renderLabelingStep = () => (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <Text variant="body2" className="text-sm font-medium">
          Label Selection
        </Text>
        <Badge variant="outline" className="text-xs">
          Quality: {videoQuality}
        </Badge>
      </div>

      {/* AI Suggestions */}
      {aiSuggestions.length > 0 && (
        <div className="space-y-2">
          <div className="flex items-center gap-2">
            <Sparkles className="w-4 h-4 text-yellow-400" />
            <Text variant="caption" className="font-medium text-sm">
              AI Suggested Labels
            </Text>
          </div>
          
          <div className="space-y-2 max-h-40 overflow-y-auto">
            {aiSuggestions.map((suggestion) => {
              const isSelected = selectedLabels.includes(suggestion.label_type)
              
              return (
                <div
                  key={suggestion.label_type}
                  className={`p-2 rounded border cursor-pointer transition-all ${
                    isSelected
                      ? 'bg-primary/10 border-primary'
                      : 'bg-surface border-neutral-700 hover:border-neutral-600'
                  }`}
                  onClick={() => handleLabelToggle(suggestion.label_type)}
                >
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      {isSelected ? (
                        <CheckCircle2 className="w-4 h-4 text-primary" />
                      ) : (
                        <Circle className="w-4 h-4 text-neutral-400" />
                      )}
                      <Text variant="caption" className="font-medium">
                        {suggestion.label_type.replace(/_/g, ' ')}
                      </Text>
                      <Sparkles className="w-3 h-3 text-yellow-400" />
                    </div>
                    <Badge variant="outline" className="text-xs">
                      {Math.round(suggestion.confidence * 100)}%
                    </Badge>
                  </div>
                  <Text variant="caption" className="text-neutral-400 text-xs mt-1">
                    {suggestion.reasoning}
                  </Text>
                </div>
              )
            })}
          </div>
        </div>
      )}

      {/* Confidence Ratings */}
      {selectedLabels.length > 0 && (
        <div className="space-y-3">
          <Text variant="caption" className="font-medium text-sm">
            Confidence Ratings (1-5)
          </Text>
          
          {selectedLabels.map(labelType => (
            <div key={labelType} className="p-3 bg-surface rounded">
              <Text variant="caption" className="font-medium mb-2">
                {labelType.replace(/_/g, ' ')}
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
                  value={confidenceRatings[labelType] || 3}
                  onChange={(e) => handleConfidenceChange(
                    labelType,
                    parseInt(e.target.value)
                  )}
                  className="flex-1"
                />
                <Text variant="caption" className="text-xs text-neutral-400 w-16">
                  High (5)
                </Text>
                <Badge variant="outline" className="w-8 text-xs">
                  {confidenceRatings[labelType] || 3}
                </Badge>
              </div>
            </div>
          ))}
        </div>
      )}

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

      <div className="flex gap-2">
        <Button
          variant="outline"
          onClick={() => setCurrentStep('video_quality')}
          className="flex-1"
        >
          Back
        </Button>
        <Button
          onClick={handleSubmit}
          className="flex-1"
        >
          Submit
        </Button>
      </div>
    </div>
  )

  return (
    <Card className="h-full flex flex-col">
      <CardHeader className="flex-shrink-0">
        <div className="flex items-center justify-between">
          <CardTitle className="text-lg">Local Labeling</CardTitle>
          <div className="flex items-center gap-2">
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
      
      <CardContent className="flex-1 flex flex-col">
        <div className="flex-1 overflow-y-auto">
          {currentStep === 'video_quality' && renderVideoQualityStep()}
          {currentStep === 'labeling' && renderLabelingStep()}
        </div>
      </CardContent>
    </Card>
  )
}