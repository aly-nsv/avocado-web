#!/usr/bin/env tsx
/**
 * Florida 511 Camera Data Migration Pipeline (TypeScript)
 * ======================================================
 * 
 * Migrates camera data from JSON files to Supabase PostgreSQL database.
 * Uses the same Supabase client as the main application for consistency.
 * 
 * Usage:
 *   npx tsx supabase/pipelines/migrate-florida-cameras.ts --dry-run
 *   npx tsx supabase/pipelines/migrate-florida-cameras.ts --execute
 *   npx tsx supabase/pipelines/migrate-florida-cameras.ts --validate-only
 * 
 * Requirements:
 *   npm install tsx (for running TypeScript directly)
 */

import fs from 'fs/promises'
import path from 'path'
import { createClient } from '@supabase/supabase-js'
import type { Database } from '../../src/types/database.types'

// Configuration
const CONFIG = {
  batchSize: 50,
  dataSourcePath: path.join(process.cwd(), 'avocado-data-scraping'),
  logFile: path.join(process.cwd(), 'supabase/pipelines/migration.log'),
}

// Types
interface RawFloridaCamera {
  id: string
  name: string
  description?: string
  latitude: number
  longitude: number
  install_date?: string
  equipment_type?: string
  region?: string
  county?: string
  roadway?: string
  location?: string
  direction?: string
  sort_order?: number
  video_url?: string
  thumbnail_url?: string
  status?: string
  raw_data?: any
}

interface TransformedCamera {
  external_id: string
  name: string
  description?: string | null
  latitude: number
  longitude: number
  state_code: string
  region?: string | null
  county?: string | null
  roadway?: string | null
  direction?: string | null
  mile_marker?: string | null
  location_description?: string | null
  install_date?: string | null
  status: string
  video_url?: string | null
  thumbnail_url?: string | null
  equipment_metadata: any
  ownership_metadata: any
  raw_data: any
  data_source: string
}

interface MigrationStats {
  totalProcessed: number
  inserted: number
  updated: number
  errors: number
  startTime: Date
  endTime?: Date
}

class CameraMigrationPipeline {
  private supabase: ReturnType<typeof createClient<Database>>
  private stats: MigrationStats
  private logMessages: string[] = []

  constructor() {
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
    const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY

    if (!supabaseUrl || !supabaseKey) {
      throw new Error('Missing Supabase credentials. Set NEXT_PUBLIC_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY')
    }

    this.supabase = createClient<Database>(supabaseUrl, supabaseKey)
    this.stats = {
      totalProcessed: 0,
      inserted: 0,
      updated: 0,
      errors: 0,
      startTime: new Date()
    }
  }

  private log(message: string, level: 'INFO' | 'WARN' | 'ERROR' = 'INFO') {
    const timestamp = new Date().toISOString()
    const logMessage = `[${timestamp}] ${level}: ${message}`
    console.log(logMessage)
    this.logMessages.push(logMessage)
  }

  private async saveLog() {
    try {
      const logContent = this.logMessages.join('\n') + '\n'
      await fs.appendFile(CONFIG.logFile, logContent)
    } catch (error) {
      console.error('Failed to save log:', error)
    }
  }

  private async loadJsonFiles(): Promise<RawFloridaCamera[]> {
    this.log('Loading Florida camera JSON files...')
    
    try {
      const files = await fs.readdir(CONFIG.dataSourcePath)
      const jsonFiles = files.filter(file => 
        file.startsWith('fl511_cameras_') && file.endsWith('.json')
      )

      this.log(`Found ${jsonFiles.length} JSON files`)

      const allCameras: RawFloridaCamera[] = []

      for (const file of jsonFiles) {
        try {
          const filePath = path.join(CONFIG.dataSourcePath, file)
          const content = await fs.readFile(filePath, 'utf-8')
          const cameras: RawFloridaCamera[] = JSON.parse(content)
          
          this.log(`Loaded ${cameras.length} cameras from ${file}`)
          allCameras.push(...cameras)
        } catch (error) {
          this.log(`Failed to load ${file}: ${error}`, 'ERROR')
        }
      }

      this.log(`Total cameras loaded: ${allCameras.length}`)
      return allCameras

    } catch (error) {
      this.log(`Failed to load JSON files: ${error}`, 'ERROR')
      throw error
    }
  }

  private transformCamera(raw: RawFloridaCamera): TransformedCamera | null {
    try {
      // Validate required fields
      if (!raw.id || !raw.name || typeof raw.latitude !== 'number' || typeof raw.longitude !== 'number') {
        this.log(`Skipping camera with missing required fields: ${raw.id}`, 'WARN')
        return null
      }

      // Extract mile marker from location
      let mileMarker: string | null = null
      if (raw.location && raw.location.includes('MM')) {
        const mmMatch = raw.location.match(/MM\s*([\d.]+)/)
        if (mmMatch) {
          mileMarker = mmMatch[1]
        }
      }

      // Handle install date
      let installDate: string | null = null
      if (raw.install_date) {
        try {
          installDate = new Date(raw.install_date).toISOString()
        } catch {
          this.log(`Invalid install_date for camera ${raw.id}: ${raw.install_date}`, 'WARN')
        }
      }

      const transformed: TransformedCamera = {
        external_id: raw.id.toString(),
        name: raw.name.trim(),
        description: raw.description?.trim() || null,
        latitude: raw.latitude,
        longitude: raw.longitude,
        state_code: 'FL',
        region: raw.region?.trim() || null,
        county: raw.county?.trim() || null,
        roadway: raw.roadway?.trim() || null,
        direction: raw.direction?.trim() || null,
        mile_marker: mileMarker,
        location_description: raw.location?.trim() || null,
        install_date: installDate,
        status: raw.status === 'active' ? 'active' : 'inactive',
        video_url: raw.video_url?.trim() || null,
        thumbnail_url: raw.thumbnail_url?.trim() || null,
        equipment_metadata: {
          equipment_type: raw.equipment_type,
          sort_order: raw.sort_order || 0,
          video_type: raw.video_url?.includes('.m3u8') ? 'hls' : 'unknown',
          video_format: raw.equipment_type
        },
        ownership_metadata: {
          source_id: raw.raw_data?.sourceId,
          source: raw.raw_data?.source,
          area_id: raw.raw_data?.areaId,
          area: raw.raw_data?.area
        },
        raw_data: raw,
        data_source: 'fl511'
      }

      return transformed
    } catch (error) {
      this.log(`Failed to transform camera ${raw.id}: ${error}`, 'ERROR')
      return null
    }
  }

  private async cameraExists(externalId: string): Promise<string | null> {
    try {
      const { data, error } = await this.supabase
        .from('traffic_cameras')
        .select('id')
        .eq('external_id', externalId)
        .eq('data_source', 'fl511')
        .single()

      if (error && error.code !== 'PGRST116') { // PGRST116 is "not found"
        throw error
      }

      return data?.id || null
    } catch (error) {
      this.log(`Error checking camera existence for ${externalId}: ${error}`, 'ERROR')
      return null
    }
  }

  private async migrateBatch(cameras: TransformedCamera[], dryRun: boolean = false): Promise<void> {
    for (const camera of cameras) {
      try {
        this.stats.totalProcessed++
        
        const existingId = await this.cameraExists(camera.external_id)

        if (dryRun) {
          if (existingId) {
            this.log(`[DRY-RUN] Would update camera ${camera.external_id} - ${camera.name}`)
            this.stats.updated++
          } else {
            this.log(`[DRY-RUN] Would insert camera ${camera.external_id} - ${camera.name}`)
            this.stats.inserted++
          }
          continue
        }

        if (existingId) {
          // Update existing camera
          const updateData = { ...camera }
          delete (updateData as any).external_id // Can't update primary key
          
          const { error } = await this.supabase
            .from('traffic_cameras')
            .update({
              ...updateData,
              updated_at: new Date().toISOString()
            })
            .eq('id', existingId)

          if (error) {
            throw error
          }

          this.stats.updated++
          this.log(`Updated camera ${camera.external_id}`)
        } else {
          // Insert new camera
          const { error } = await this.supabase
            .from('traffic_cameras')
            .insert(camera)

          if (error) {
            throw error
          }

          this.stats.inserted++
          this.log(`Inserted camera ${camera.external_id}`)
        }

      } catch (error) {
        this.stats.errors++
        this.log(`Error processing camera ${camera.external_id}: ${error}`, 'ERROR')
      }
    }
  }

  private async validateMigration(): Promise<void> {
    this.log('Validating migration results...')

    try {
      // Get summary statistics
      const { data: totalCount } = await this.supabase
        .from('traffic_cameras')
        .select('*', { count: 'exact', head: true })
        .eq('data_source', 'fl511')

      const { data: activeCount } = await this.supabase
        .from('traffic_cameras')
        .select('*', { count: 'exact', head: true })
        .eq('data_source', 'fl511')
        .eq('status', 'active')

      const { data: withVideoCount } = await this.supabase
        .from('traffic_cameras')
        .select('*', { count: 'exact', head: true })
        .eq('data_source', 'fl511')
        .not('video_url', 'is', null)

      // Get regional breakdown
      const { data: regionData } = await this.supabase
        .from('traffic_cameras')
        .select('region')
        .eq('data_source', 'fl511')
        .not('region', 'is', null)

      const regionCounts = regionData?.reduce((acc: Record<string, number>, row) => {
        acc[row.region] = (acc[row.region] || 0) + 1
        return acc
      }, {}) || {}

      this.log('=== MIGRATION VALIDATION ===')
      this.log(`Total FL511 cameras in database: ${totalCount?.length || 0}`)
      this.log(`Active cameras: ${activeCount?.length || 0}`)
      this.log(`Cameras with video: ${withVideoCount?.length || 0}`)
      this.log('Regional breakdown:')
      Object.entries(regionCounts).forEach(([region, count]) => {
        this.log(`  ${region}: ${count}`)
      })

    } catch (error) {
      this.log(`Validation failed: ${error}`, 'ERROR')
    }
  }

  public async run(options: { dryRun?: boolean; validateOnly?: boolean } = {}): Promise<void> {
    try {
      this.log('Starting Florida camera migration pipeline...')
      this.log(`Options: ${JSON.stringify(options)}`)

      if (options.validateOnly) {
        await this.validateMigration()
        return
      }

      // Load camera data
      const rawCameras = await this.loadJsonFiles()
      
      if (rawCameras.length === 0) {
        this.log('No camera data found to migrate', 'WARN')
        return
      }

      // Transform cameras
      this.log('Transforming camera data...')
      const transformedCameras = rawCameras
        .map(camera => this.transformCamera(camera))
        .filter((camera): camera is TransformedCamera => camera !== null)

      this.log(`Transformed ${transformedCameras.length} cameras (${rawCameras.length - transformedCameras.length} skipped)`)

      // Process in batches
      const batches = []
      for (let i = 0; i < transformedCameras.length; i += CONFIG.batchSize) {
        batches.push(transformedCameras.slice(i, i + CONFIG.batchSize))
      }

      this.log(`Processing ${batches.length} batches of ${CONFIG.batchSize} cameras each...`)

      for (let i = 0; i < batches.length; i++) {
        this.log(`Processing batch ${i + 1}/${batches.length}...`)
        await this.migrateBatch(batches[i], options.dryRun)
      }

      this.stats.endTime = new Date()
      const duration = (this.stats.endTime.getTime() - this.stats.startTime.getTime()) / 1000

      this.log('=== MIGRATION COMPLETE ===')
      this.log(`Duration: ${duration}s`)
      this.log(`Total processed: ${this.stats.totalProcessed}`)
      this.log(`Inserted: ${this.stats.inserted}`)
      this.log(`Updated: ${this.stats.updated}`)
      this.log(`Errors: ${this.stats.errors}`)

      if (!options.dryRun) {
        await this.validateMigration()
      }

    } catch (error) {
      this.log(`Migration failed: ${error}`, 'ERROR')
      throw error
    } finally {
      await this.saveLog()
    }
  }
}

// CLI execution
async function main() {
  const args = process.argv.slice(2)
  const options = {
    dryRun: args.includes('--dry-run'),
    validateOnly: args.includes('--validate-only')
  }

  if (args.includes('--help')) {
    console.log(`
Florida 511 Camera Migration Pipeline

Usage:
  npx tsx supabase/pipelines/migrate-florida-cameras.ts [options]

Options:
  --dry-run        Perform migration without writing to database
  --validate-only  Only run validation queries on existing data
  --help           Show this help message

Environment Variables Required:
  NEXT_PUBLIC_SUPABASE_URL     - Supabase project URL
  SUPABASE_SERVICE_ROLE_KEY    - Supabase service role key
    `)
    process.exit(0)
  }

  try {
    const pipeline = new CameraMigrationPipeline()
    await pipeline.run(options)
    process.exit(0)
  } catch (error) {
    console.error('Pipeline failed:', error)
    process.exit(1)
  }
}

if (require.main === module) {
  main()
}

export { CameraMigrationPipeline }