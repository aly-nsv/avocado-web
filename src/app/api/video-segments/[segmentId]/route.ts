// @ts-nocheck
import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/lib/database';
import { Storage } from '@google-cloud/storage';

// Initialize Google Cloud Storage client
let storage: Storage | null = null;
// example commit #2 

try {
  // Priority order: File-based > JSON > Individual > Default
  if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
    try {
      console.log('🔑 Using file-based credentials:', process.env.GOOGLE_APPLICATION_CREDENTIALS);
      storage = new Storage();
      console.log('✅ Using file-based credentials for GCS');
    } catch (fileError) {
      console.error('❌ Failed to use file-based credentials:', fileError);
    }
  } else if (process.env.GOOGLE_APPLICATION_CREDENTIALS_JSON) {
    try {
      // Parse service account JSON from environment variable
      const credentials = JSON.parse(process.env.GOOGLE_APPLICATION_CREDENTIALS_JSON);
      storage = new Storage({
        credentials,
        projectId: credentials.project_id,
      });
      console.log('✅ Using JSON credentials for GCS');
    } catch (jsonError) {
      console.error('❌ Failed to parse GOOGLE_APPLICATION_CREDENTIALS_JSON:', jsonError);
    }
  } else if (process.env.GCP_PROJECT_ID && process.env.GCP_PRIVATE_KEY && process.env.GCP_CLIENT_EMAIL) {
    try {
      // Use individual environment variables
      storage = new Storage({
        credentials: {
          type: 'service_account',
          project_id: process.env.GCP_PROJECT_ID,
          private_key: process.env.GCP_PRIVATE_KEY.replace(/\\n/g, '\n'),
          client_email: process.env.GCP_CLIENT_EMAIL,
        },
        projectId: process.env.GCP_PROJECT_ID,
      });
      console.log('✅ Using individual credentials for GCS');
    } catch (credError) {
      console.error('❌ Failed to create GCS with individual credentials:', credError);
    }
  } else {
    console.warn('⚠️  No GCP credentials found in environment, falling back to default');
    // Only use default credentials if we're in a local development environment
    if (process.env.NODE_ENV === 'development') {
      storage = new Storage();
      console.log('✅ Using default credentials for local development');
    } else {
      console.error('❌ No GCP credentials available for production');
      storage = null;
    }
  }
  
  if (storage) {
    console.log('✅ Google Cloud Storage client initialized successfully');
  }
} catch (error) {
  console.error('❌ Failed to initialize GCS client:', error);
  storage = null;
}

// FFmpeg conversion disabled - assuming all files are MP4
// Convert MPEG-2 Transport Stream to MP4 using FFmpeg
// async function convertTsToMp4(inputBuffer: Buffer): Promise<Buffer> {
//   return new Promise((resolve, reject) => {
//     const chunks: Buffer[] = [];
//     const errorChunks: Buffer[] = [];
//     
//     // FFmpeg command to convert TS to MP4 with optimized settings
//     const ffmpeg = spawn('ffmpeg', [
//       '-i', 'pipe:0',                    // Read from stdin
//       '-c:v', 'copy',                    // Copy video codec (no re-encoding for speed)
//       '-c:a', 'copy',                    // Copy audio codec if possible
//       '-avoid_negative_ts', 'make_zero', // Fix timestamp issues
//       '-f', 'mp4',                       // Output format MP4
//       '-movflags', 'faststart+frag_keyframe', // Enable progressive download
//       '-y',                              // Overwrite output
//       'pipe:1'                           // Write to stdout
//     ], {
//       stdio: ['pipe', 'pipe', 'pipe']
//     });

//     // Set a timeout for the conversion (30 seconds)
//     const timeout = setTimeout(() => {
//       ffmpeg.kill('SIGKILL');
//       reject(new Error('FFmpeg conversion timed out after 30 seconds'));
//     }, 30000);

//     // Handle FFmpeg output
//     ffmpeg.stdout.on('data', (chunk) => {
//       chunks.push(chunk);
//     });

//     ffmpeg.stderr.on('data', (data) => {
//       errorChunks.push(data);
//     });

//     ffmpeg.on('close', (code) => {
//       clearTimeout(timeout);
//       
//       if (code === 0) {
//         const result = Buffer.concat(chunks);
//         if (result.length === 0) {
//           reject(new Error('FFmpeg produced empty output'));
//         } else {
//           console.log(`✅ Video conversion successful: ${inputBuffer.length} bytes → ${result.length} bytes`);
//           resolve(result);
//         }
//       } else {
//         const errorOutput = Buffer.concat(errorChunks).toString();
//         console.error(`❌ FFmpeg conversion failed with code ${code}:`, errorOutput);
//         reject(new Error(`FFmpeg exited with code ${code}: ${errorOutput}`));
//       }
//     });

//     ffmpeg.on('error', (error) => {
//       clearTimeout(timeout);
//       console.error('❌ FFmpeg spawn error:', error);
//       reject(error);
//     });

//     // Write input buffer to FFmpeg stdin
//     try {
//       ffmpeg.stdin.write(inputBuffer);
//       ffmpeg.stdin.end();
//     } catch (error) {
//       clearTimeout(timeout);
//       reject(error);
//     }
//   });
// }

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

    if (result.rows.length === 0) {
      return NextResponse.json({
        error: 'Video segment not found'
      }, { status: 404 });
    }

    const segment = result.rows[0];
    console.log('=========SEGMENT=========', segment);

    // If GCS client is not available, return error immediately
    if (!storage) {
      console.error('❌ Storage client is not initialized - check GCP credentials');
      return NextResponse.json({
        error: 'Google Cloud Storage not available',
        details: 'GCS client failed to initialize - check environment variables',
        suggestions: [
          'Ensure GOOGLE_APPLICATION_CREDENTIALS_JSON is set correctly',
          'Or set GCP_PROJECT_ID, GCP_PRIVATE_KEY, and GCP_CLIENT_EMAIL',
          'Check that credentials have storage.objects.get permission'
        ]
      }, { status: 500 });
    }

    // Use authenticated GCS client to get the file
    try {
      console.log(`🔍 Original segment path: ${segment.storage_path}`);
      
      const bucket = storage.bucket(segment.storage_bucket);
      console.log(`✅ Got bucket reference: ${segment.storage_bucket}`);
      
      // Assume all files are MP4 - if path ends with .ts, replace with .mp4
      let targetPath = segment.storage_path;
      if (segment.segment_filename.endsWith('.ts')) {
        targetPath = segment.storage_path.replace(/\.ts$/, '.mp4');
        console.log(`🔄 Converting path: ${segment.storage_path} → ${targetPath}`);
      }
      
      console.log(`📁 Attempting to access file: ${targetPath}`);
      const targetFile = bucket.file(targetPath);
      console.log(`✅ Got file reference`);

      console.log(`🔍 Checking if file exists...`);
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
      const range = request.headers.get('range');
      
      if (range) {
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
            'Content-Type': 'video/mp4',
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
        
        const buffer = Buffer.concat(chunks);
        
        // Return MP4 file directly
        return new NextResponse(buffer, {
          status: 200,
          headers: {
            'Content-Type': 'video/mp4',
            'Content-Length': buffer.length.toString(),
            'Accept-Ranges': 'bytes',
            'Access-Control-Allow-Origin': '*',
            'Cache-Control': 'public, max-age=3600',
          },
        });
      }

    } catch (gcsError) {
      // Calculate the target path for error reporting
      let targetPath = segment.storage_path;
      if (segment.segment_filename.endsWith('.ts')) {
        targetPath = segment.storage_path.replace(/\.ts$/, '.mp4');
      }
      
      console.error('❌ GCS access error:', {
        error: gcsError instanceof Error ? gcsError.message : gcsError,
        code: (gcsError as any)?.code,
        library: (gcsError as any)?.library,
        reason: (gcsError as any)?.reason,
        bucket: segment.storage_bucket,
        originalPath: segment.storage_path,
        targetPath: targetPath
      });
      
      // Fallback: try to generate a signed URL
      try {
        const bucket = storage.bucket(segment.storage_bucket);
        
        // Get signed URL for MP4 version
        let fallbackPath = segment.storage_path;
        if (segment.segment_filename.endsWith('.ts')) {
          fallbackPath = segment.storage_path.replace(/\.ts$/, '.mp4');
        }
        const fallbackFile = bucket.file(fallbackPath);
        
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