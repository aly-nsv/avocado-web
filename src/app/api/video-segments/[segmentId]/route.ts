import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/lib/database';
import { Storage } from '@google-cloud/storage';
import { spawn } from 'child_process';
import { pipeline } from 'stream/promises';
import { PassThrough } from 'stream';

// Initialize Google Cloud Storage client
// This will use default credentials from the environment
let storage: Storage | null = null;

try {
  storage = new Storage();
} catch (error) {
  console.error('Failed to initialize GCS client:', error);
}

// Convert MPEG-2 Transport Stream to MP4 using FFmpeg
async function convertTsToMp4(inputBuffer: Buffer): Promise<Buffer> {
  return new Promise((resolve, reject) => {
    const chunks: Buffer[] = [];
    const errorChunks: Buffer[] = [];
    
    // FFmpeg command to convert TS to MP4 with optimized settings
    const ffmpeg = spawn('ffmpeg', [
      '-i', 'pipe:0',                    // Read from stdin
      '-c:v', 'copy',                    // Copy video codec (no re-encoding for speed)
      '-c:a', 'copy',                    // Copy audio codec if possible
      '-avoid_negative_ts', 'make_zero', // Fix timestamp issues
      '-f', 'mp4',                       // Output format MP4
      '-movflags', 'faststart+frag_keyframe', // Enable progressive download
      '-y',                              // Overwrite output
      'pipe:1'                           // Write to stdout
    ], {
      stdio: ['pipe', 'pipe', 'pipe']
    });

    // Set a timeout for the conversion (30 seconds)
    const timeout = setTimeout(() => {
      ffmpeg.kill('SIGKILL');
      reject(new Error('FFmpeg conversion timed out after 30 seconds'));
    }, 30000);

    // Handle FFmpeg output
    ffmpeg.stdout.on('data', (chunk) => {
      chunks.push(chunk);
    });

    ffmpeg.stderr.on('data', (data) => {
      errorChunks.push(data);
    });

    ffmpeg.on('close', (code) => {
      clearTimeout(timeout);
      
      if (code === 0) {
        const result = Buffer.concat(chunks);
        if (result.length === 0) {
          reject(new Error('FFmpeg produced empty output'));
        } else {
          console.log(`✅ Video conversion successful: ${inputBuffer.length} bytes → ${result.length} bytes`);
          resolve(result);
        }
      } else {
        const errorOutput = Buffer.concat(errorChunks).toString();
        console.error(`❌ FFmpeg conversion failed with code ${code}:`, errorOutput);
        reject(new Error(`FFmpeg exited with code ${code}: ${errorOutput}`));
      }
    });

    ffmpeg.on('error', (error) => {
      clearTimeout(timeout);
      console.error('❌ FFmpeg spawn error:', error);
      reject(error);
    });

    // Write input buffer to FFmpeg stdin
    try {
      ffmpeg.stdin.write(inputBuffer);
      ffmpeg.stdin.end();
    } catch (error) {
      clearTimeout(timeout);
      reject(error);
    }
  });
}

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ segmentId: string }> }
) {
  try {
    const { segmentId } = await params;
    
    if (!segmentId) {
      return NextResponse.json({
        error: 'Segment ID is required'
      }, { status: 400 });
    }

    // // Debug (non-sensitive): Print storage client status without leaking credentials
    // try {
    //   if (storage) {
    //     const projectId = await storage.getProjectId().catch(() => undefined);
    //     console.log('GCS Storage client ready', {
    //       projectId: projectId || 'unknown',
    //       hasCredentialsFile: Boolean(process.env.GOOGLE_APPLICATION_CREDENTIALS),
    //       credentialsPath: process.env.GOOGLE_APPLICATION_CREDENTIALS ? 'placeholder' : undefined,
    //       envProject: process.env.GCLOUD_PROJECT || process.env.GCP_PROJECT || 'unset'
    //     });
    //   } else {
    //     console.log('GCS Storage client not initialized');
    //   }
    // } catch (dbgErr) {
    //   console.warn('Could not print GCS debug info:', dbgErr instanceof Error ? dbgErr.message : dbgErr);
    // }

    // Get segment details from database
    const result = await db.query(
      'SELECT storage_bucket, storage_path, segment_filename FROM video_segments WHERE segment_id = $1',
      [parseInt(segmentId)]
    );
    console.log('=========RESULT=========', result);

    if (result.rows.length === 0) {
      return NextResponse.json({
        error: 'Video segment not found'
      }, { status: 404 });
    }

    const segment = result.rows[0];
    console.log('=========SEGMENT=========', segment);

    // If GCS client is not available, try direct URL access
    if (!storage) {
      console.error('Storage is not initialized');
      const directUrl = `https://storage.googleapis.com/${segment.storage_bucket}/${segment.storage_path}`;
      
      try {
        const response = await fetch(directUrl);
        if (!response.ok) {
          return NextResponse.json({
            error: 'Video segment not accessible via direct URL',
            details: `HTTP ${response.status}`,
            suggestion: 'GCS authentication may be required'
          }, { status: 502 });
        }

        const videoBuffer = await response.arrayBuffer();
        return new NextResponse(videoBuffer, {
          status: 200,
          headers: {
            'Content-Type': 'video/mp2t',
            'Content-Length': videoBuffer.byteLength.toString(),
            'Cache-Control': 'public, max-age=3600',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, OPTIONS',
            'Accept-Ranges': 'bytes',
          },
        });
      } catch (fetchError) {
        return NextResponse.json({
          error: 'Failed to fetch video segment',
          details: 'Neither GCS client nor direct URL access worked',
          directUrl: `https://storage.googleapis.com/${segment.storage_bucket}/${segment.storage_path}`
        }, { status: 502 });
      }
    }

    // Use authenticated GCS client to get the file
    try {
      const bucket = storage.bucket(segment.storage_bucket);
      
      // First, try to find an MP4 version by replacing .ts with .mp4 in the path
      let targetFile = bucket.file(segment.storage_path);
      let isConvertedMp4 = false;
      
      if (segment.segment_filename.endsWith('.ts')) {
        
        const mp4Path = segment.storage_path.replace(/\.ts$/, '.mp4');
        console.log('=========MP4 PATH=========', mp4Path);
        const mp4File = bucket.file(mp4Path);
        console.log('=========MP4 FILE=========', mp4File);
        // Check if MP4 version exists
        const [mp4Exists] = await mp4File.exists();
        
        if (mp4Exists) {
          console.log(`Found MP4 version: ${mp4Path}, using instead of ${segment.storage_path}`);
          targetFile = mp4File;
          isConvertedMp4 = true;
        }
      }

      // Check if target file exists
      const [exists] = await targetFile.exists();
      if (!exists) {
        return NextResponse.json({
          error: 'Video segment file not found in GCS',
          bucket: segment.storage_bucket,
          path: targetFile.name
        }, { status: 404 });
      }

      // Get file metadata
      const [metadata] = await targetFile.getMetadata();
      const contentLength = parseInt(metadata.size as string) || 0;

      // Handle range requests for video streaming
      // Note: We disable range requests for .ts files since they get converted
      const range = request.headers.get('range');
      const needsConversion = segment.segment_filename.endsWith('.ts') && !isConvertedMp4;
      
      if (range && !needsConversion) {
        // Parse range header
        const parts = range.replace(/bytes=/, "").split("-");
        const start = parseInt(parts[0], 10);
        const end = parts[1] ? parseInt(parts[1], 10) : contentLength - 1;
        const chunksize = (end - start) + 1;

        // Create read stream with range
        const stream = targetFile.createReadStream({
          start,
          end
        });

        const chunks: Buffer[] = [];
        
        for await (const chunk of stream) {
          chunks.push(chunk);
        }
        
        const buffer = Buffer.concat(chunks);

        return new NextResponse(buffer, {
          status: 206, // Partial Content
          headers: {
            'Content-Range': `bytes ${start}-${end}/${contentLength}`,
            'Accept-Ranges': 'bytes',
            'Content-Length': chunksize.toString(),
            'Content-Type': isConvertedMp4 || !segment.segment_filename.endsWith('.ts') ? 'video/mp4' : 'video/mp2t',
            'Access-Control-Allow-Origin': '*',
            'Cache-Control': 'public, max-age=3600',
          },
        });
      } else {
        // Return full file
        const stream = targetFile.createReadStream();
        const chunks: Buffer[] = [];
        
        for await (const chunk of stream) {
          chunks.push(chunk);
        }
        
        const originalBuffer = Buffer.concat(chunks);
        
        // Only convert if we have a .ts file and no MP4 version was found
        if (needsConversion) {
          try {
            console.log(`Converting .ts file to MP4: ${segment.segment_filename}`);
            const convertedBuffer = await convertTsToMp4(originalBuffer);
            
            return new NextResponse(convertedBuffer, {
              status: 200,
              headers: {
                'Content-Type': 'video/mp4',
                'Content-Length': convertedBuffer.length.toString(),
                'Accept-Ranges': 'bytes',
                'Access-Control-Allow-Origin': '*',
                'Cache-Control': 'public, max-age=3600',
              },
            });
          } catch (conversionError) {
            console.error('Video conversion failed:', conversionError);
            // Fall back to original .ts file
            return new NextResponse(originalBuffer, {
              status: 200,
              headers: {
                'Content-Type': 'video/mp2t',
                'Content-Length': originalBuffer.length.toString(),
                'Accept-Ranges': 'bytes',
                'Access-Control-Allow-Origin': '*',
                'Cache-Control': 'public, max-age=3600',
              },
            });
          }
        } else {
          // Return original file (either MP4 version was found, or it's already an MP4)
          return new NextResponse(originalBuffer, {
            status: 200,
            headers: {
              'Content-Type': 'video/mp4',
              'Content-Length': originalBuffer.length.toString(),
              'Accept-Ranges': 'bytes',
              'Access-Control-Allow-Origin': '*',
              'Cache-Control': 'public, max-age=3600',
            },
          });
        }
      }

    } catch (gcsError) {
      console.error('GCS access error:', gcsError);
      
      // Fallback: try to generate a signed URL
      try {
        const bucket = storage.bucket(segment.storage_bucket);
        
        // Try to get signed URL for MP4 version first, then fall back to original
        let fallbackFile = bucket.file(segment.storage_path);
        if (segment.segment_filename.endsWith('.ts')) {
          const mp4Path = segment.storage_path.replace(/\.ts$/, '.mp4');
          const mp4File = bucket.file(mp4Path);
          const [mp4Exists] = await mp4File.exists();
          if (mp4Exists) {
            fallbackFile = mp4File;
          }
        }
        
        const [signedUrl] = await fallbackFile.getSignedUrl({
          version: 'v4',
          action: 'read',
          expires: Date.now() + 30 * 60 * 1000, // 30 minutes
        });

        return NextResponse.redirect(signedUrl);
        
      } catch (signedUrlError) {
        return NextResponse.json({
          error: 'Failed to access video segment',
          gcsError: gcsError instanceof Error ? gcsError.message : 'Unknown GCS error',
          signedUrlError: signedUrlError instanceof Error ? signedUrlError.message : 'Unknown signed URL error'
        }, { status: 500 });
      }
    }

  } catch (error) {
    console.error('Video segment proxy error:', error);
    return NextResponse.json({
      error: 'Video segment proxy service error',
      details: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 500 });
  }
}

// Handle preflight CORS requests
export async function OPTIONS() {
  return new NextResponse(null, {
    status: 200,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, OPTIONS',
      'Access-Control-Allow-Headers': 'Range, Content-Type, Authorization',
      'Access-Control-Max-Age': '86400',
    },
  });
}