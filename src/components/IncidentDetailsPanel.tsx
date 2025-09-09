'use client'

import * as React from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'
import { Text, Heading } from '@/components/ui/Typography'
import type { Incident, VideoSegment } from '@/types/labeling'
import { formatDistanceToNow, parseISO } from 'date-fns'

interface IncidentDetailsPanelProps {
  incident: Incident
  videoSegments: VideoSegment[]
  totalSegments: number
  camerasInvolved: string[]
}

export function IncidentDetailsPanel({ 
  incident, 
  videoSegments, 
  totalSegments, 
  camerasInvolved 
}: IncidentDetailsPanelProps) {
  const formatDateTime = (dateString: string) => {
    try {
      const date = parseISO(dateString)
      return {
        absolute: date.toLocaleString(),
        relative: formatDistanceToNow(date, { addSuffix: true })
      }
    } catch {
      return { absolute: dateString, relative: 'Unknown time' }
    }
  }

  const startDate = formatDateTime(incident.start_date)
  const lastUpdated = incident.last_updated ? formatDateTime(incident.last_updated) : null

  const getSeverityVariant = (severity?: string): 'danger' | 'secondary' | 'default' => {
    if (!severity) return 'secondary'
    switch (severity.toLowerCase()) {
      case 'major': return 'danger'
      case 'minor': return 'secondary'
      case 'moderate': return 'default'
      default: return 'secondary'
    }
  }

  const getIncidentTypeVariant = (type: string): 'danger' | 'warning' | 'secondary' => {
    const criticalTypes = ['accident', 'collision', 'fatal', 'hazmat']
    const warningTypes = ['construction', 'roadwork', 'debris']
    
    const lowerType = type.toLowerCase()
    if (criticalTypes.some(ct => lowerType.includes(ct))) return 'danger'
    if (warningTypes.some(wt => lowerType.includes(wt))) return 'warning'
    return 'secondary'
  }

  return (
    <div className="space-y-4">
      {/* Basic Incident Info */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center justify-between">
            Incident Details
            <Badge variant="outline">
              ID: {incident.incident_id}
            </Badge>
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          {/* Incident Type and Severity */}
          <div className="flex flex-wrap gap-2">
            <Badge variant={getIncidentTypeVariant(incident.incident_type)}>
              {incident.incident_type}
            </Badge>
            {incident.severity && (
              <Badge variant={getSeverityVariant(incident.severity)}>
                {incident.severity}
              </Badge>
            )}
          </div>

          {/* Description */}
          {incident.description && (
            <div>
              <Text variant="caption" className="font-medium text-neutral-300 mb-1">
                Description
              </Text>
              <Text variant="body2" className="text-sm">
                {incident.description}
              </Text>
            </div>
          )}

          {/* Location Information */}
          <div className="grid grid-cols-1 gap-3">
            <div>
              <Text variant="caption" className="font-medium text-neutral-300 mb-1">
                Location
              </Text>
              <Text variant="body2" className="text-sm">
                {incident.roadway_name}
                {incident.direction && ` (${incident.direction})`}
              </Text>
              {incident.county && (
                <Text variant="caption" className="text-neutral-400">
                  {incident.county}, {incident.region}
                </Text>
              )}
            </div>

            {incident.location_description && (
              <div>
                <Text variant="caption" className="font-medium text-neutral-300 mb-1">
                  Location Details
                </Text>
                <Text variant="body2" className="text-sm">
                  {incident.location_description}
                </Text>
              </div>
            )}
          </div>

          {/* Timing Information */}
          <div>
            <Text variant="caption" className="font-medium text-neutral-300 mb-1">
              Timeline
            </Text>
            <div className="text-sm space-y-1">
              <div>
                <span className="text-neutral-400">Started:</span>{' '}
                <span title={startDate.absolute}>{startDate.relative}</span>
              </div>
              {lastUpdated && (
                <div>
                  <span className="text-neutral-400">Last Updated:</span>{' '}
                  <span title={lastUpdated.absolute}>{lastUpdated.relative}</span>
                </div>
              )}
              {incident.end_date && (
                <div>
                  <span className="text-neutral-400">Ended:</span>{' '}
                  <span>{formatDateTime(incident.end_date).relative}</span>
                </div>
              )}
            </div>
          </div>

          {/* Source Information */}
          {incident.source && (
            <div>
              <Text variant="caption" className="font-medium text-neutral-300 mb-1">
                Source
              </Text>
              <Text variant="body2" className="text-sm">
                {incident.source}
                {incident.dot_district && ` (${incident.dot_district})`}
              </Text>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Video Coverage Info */}
      <Card>
        <CardHeader>
          <CardTitle>Video Coverage</CardTitle>
        </CardHeader>
        <CardContent className="space-y-3">
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <Text variant="caption" className="font-medium text-neutral-300 mb-1">
                Total Segments
              </Text>
              <Text variant="subtitle1" className="text-lg font-mono">
                {totalSegments}
              </Text>
            </div>
            <div>
              <Text variant="caption" className="font-medium text-neutral-300 mb-1">
                Cameras
              </Text>
              <Text variant="subtitle1" className="text-lg font-mono">
                {camerasInvolved.length}
              </Text>
            </div>
          </div>

          {/* Camera IDs */}
          <div>
            <Text variant="caption" className="font-medium text-neutral-300 mb-2">
              Camera IDs
            </Text>
            <div className="flex flex-wrap gap-1">
              {camerasInvolved.map(cameraId => (
                <Badge key={cameraId} variant="outline" className="text-xs">
                  {cameraId}
                </Badge>
              ))}
            </div>
          </div>

          {/* Capture Sessions */}
          {videoSegments.length > 0 && (
            <div>
              <Text variant="caption" className="font-medium text-neutral-300 mb-1">
                Capture Time
              </Text>
              <Text variant="body2" className="text-sm">
                {formatDateTime(videoSegments[0].capture_timestamp).relative}
              </Text>
            </div>
          )}

          {/* Version Info */}
          {videoSegments[0]?.avocado_version && (
            <div>
              <Text variant="caption" className="font-medium text-neutral-300 mb-1">
                Version
              </Text>
              <Badge variant="outline" className="text-xs">
                {videoSegments[0].avocado_version}
              </Badge>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Additional Details (if available) */}
      {(incident.lane_description || incident.detour_description) && (
        <Card>
          <CardHeader>
            <CardTitle>Additional Details</CardTitle>
          </CardHeader>
          <CardContent className="space-y-3">
            {incident.lane_description && (
              <div>
                <Text variant="caption" className="font-medium text-neutral-300 mb-1">
                  Lane Information
                </Text>
                <Text variant="body2" className="text-sm">
                  {incident.lane_description}
                </Text>
              </div>
            )}
            {incident.detour_description && (
              <div>
                <Text variant="caption" className="font-medium text-neutral-300 mb-1">
                  Detour Information
                </Text>
                <Text variant="body2" className="text-sm">
                  {incident.detour_description}
                </Text>
              </div>
            )}
          </CardContent>
        </Card>
      )}
    </div>
  )
}