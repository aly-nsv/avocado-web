/**
 * Florida 511 Authentication & Video Stream Service
 * ================================================
 * 
 * Implements the complete 4-step FL511 authentication process:
 * 1. GET video URL from FL511 (imageId -> token, sourceId, systemSourceId)  
 * 2. POST to Divas SecureTokenUri API (get streaming URL with token)
 * 3. GET HLS playlist (m3u8 file with segment list)
 * 4. GET video segments (.ts files for streaming)
 * 
 * Based on the proven Python implementation with SSL verification disabled.
 */

// Disable SSL verification globally for Node.js
process.env["NODE_TLS_REJECT_UNAUTHORIZED"] = "0";

// Standard headers for FL511 requests
const FL511_HEADERS = {
  'accept': '*/*',
  'accept-language': 'en-US,en;q=0.9',
  'priority': 'u=1, i',
  'referer': 'https://fl511.com/map',
  'sec-ch-ua': '"Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"',
  'sec-ch-ua-mobile': '?0',
  'sec-ch-ua-platform': '"macOS"',
  'sec-fetch-dest': 'empty',
  'sec-fetch-mode': 'cors',
  'sec-fetch-site': 'same-origin',
  'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
  'x-requested-with': 'XMLHttpRequest'
}

// Headers for Divas cloud requests
const DIVAS_HEADERS = {
  'accept': '*/*',
  'accept-language': 'en-US,en;q=0.9',
  'content-type': 'application/json',
  'origin': 'https://fl511.com',
  'priority': 'u=1, i',
  'referer': 'https://fl511.com/',
  'sec-ch-ua': '"Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"',
  'sec-ch-ua-mobile': '?0',
  'sec-ch-ua-platform': '"macOS"',
  'sec-fetch-dest': 'empty',
  'sec-fetch-mode': 'cors',
  'sec-fetch-site': 'cross-site',
  'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'
}

// Headers for streaming requests
const STREAM_HEADERS = {
  'accept': '*/*',
  'accept-language': 'en-US,en;q=0.9',
  'origin': 'https://fl511.com',
  'priority': 'u=1, i',
  'referer': 'https://fl511.com/',
  'sec-ch-ua': '"Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"',
  'sec-ch-ua-mobile': '?0',
  'sec-ch-ua-platform': '"macOS"',
  'sec-fetch-dest': 'empty',
  'sec-fetch-mode': 'cors',
  'sec-fetch-site': 'cross-site',
  'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'
}

interface Step1Response {
  token?: string;
  sourceId?: string;
  systemSourceId?: string;
  videoUrl?: string;
  url?: string;
}

interface Step2Response {
  secureUri?: string;
  // Response can also be a string with token parameter
}

interface VideoSegment {
  url: string;
  filename: string;
  duration?: number;
  program_date_time?: string;
}

interface PlaylistInfo {
  playlist_content: string;
  segments: VideoSegment[];
  base_url: string;
}

interface StreamInfo {
  camera_id: string;
  step1_video_info: Step1Response;
  step2_token_info: Step2Response | string;
  step3_playlist_info: PlaylistInfo;
  streaming_url: string;
  segments: VideoSegment[];
}

class Florida511AuthService {
  private readonly baseUrl = 'https://fl511.com';
  private readonly divasUrl = 'https://divas.cloud';
  private lastAuthTime: number = 0;
  private readonly minAuthInterval = 500; // Minimum 500ms between auth requests

  /**
   * Step 1: Get video URL from FL511
   */
  async step1GetVideoUrl(cameraId: string, retryCount: number = 0): Promise<Step1Response | null> {
    const url = `${this.baseUrl}/Camera/GetVideoUrl?imageId=${cameraId}`;
    const maxRetries = 3;
    
    try {
      console.log(`Step 1: Getting video URL for camera ${cameraId}... (attempt ${retryCount + 1}/${maxRetries + 1})`);
      const response = await fetch(url, {
        method: 'GET',
        headers: FL511_HEADERS,
        // SSL verification disabled - comprehensive bypass
        // @ts-ignore - Node.js specific
        agent: new (require('https')).Agent({ 
          rejectUnauthorized: false,
          checkServerIdentity: () => undefined,
          secureProtocol: 'TLSv1_2_method'
        })
      });

      if (!response.ok) {
        // Handle rate limiting specifically
        if (response.status === 429) {
          console.warn(`⚠️ Step 1 rate limited (429) for camera ${cameraId}`);
          if (retryCount < maxRetries) {
            const backoffDelay = Math.min(1000 * Math.pow(2, retryCount), 5000); // Exponential backoff, max 5s
            console.log(`🔄 Retrying after ${backoffDelay}ms...`);
            await new Promise(resolve => setTimeout(resolve, backoffDelay));
            return this.step1GetVideoUrl(cameraId, retryCount + 1);
          } else {
            console.error(`❌ Step 1 failed after ${maxRetries + 1} attempts - rate limited`);
            return null;
          }
        }
        
        console.warn(`Step 1 failed: ${response.status}`);
        return null;
      }

      const data = await response.json();
      console.log('✅ Step 1 successful');
      return data;
      
    } catch (error) {
      console.error('Step 1 failed:', error);
      if (retryCount < maxRetries) {
        console.log(`🔄 Retrying after network error...`);
        await new Promise(resolve => setTimeout(resolve, 2000));
        return this.step1GetVideoUrl(cameraId, retryCount + 1);
      }
      return null;
    }
  }

  /**
   * Step 2: Get secure token URI from Divas cloud
   */
  async step2GetSecureTokenUri(token: string, sourceId: string, systemSourceId: string = "District 2", retryCount: number = 0): Promise<Step2Response | string | null> {
    const url = `${this.divasUrl}/VDS-API/SecureTokenUri/GetSecureTokenUriBySourceId`;
    const maxRetries = 3;
    
    const payload = {
      token,
      sourceId,
      systemSourceId
    };
    
    try {
      console.log(`Step 2: Getting secure token URI... (attempt ${retryCount + 1}/${maxRetries + 1})`);
      const response = await fetch(url, {
        method: 'POST',
        headers: DIVAS_HEADERS,
        body: JSON.stringify(payload),
        // SSL verification disabled - comprehensive bypass
        // @ts-ignore - Node.js specific
        agent: new (require('https')).Agent({ 
          rejectUnauthorized: false,
          checkServerIdentity: () => undefined,
          secureProtocol: 'TLSv1_2_method'
        })
      });

      if (!response.ok) {
        // Handle rate limiting specifically
        if (response.status === 429) {
          console.warn(`⚠️ Step 2 rate limited (429)`);
          if (retryCount < maxRetries) {
            const backoffDelay = Math.min(1000 * Math.pow(2, retryCount), 5000); // Exponential backoff, max 5s
            console.log(`🔄 Retrying after ${backoffDelay}ms...`);
            await new Promise(resolve => setTimeout(resolve, backoffDelay));
            return this.step2GetSecureTokenUri(token, sourceId, systemSourceId, retryCount + 1);
          } else {
            console.error(`❌ Step 2 failed after ${maxRetries + 1} attempts - rate limited`);
            return null;
          }
        }
        
        console.warn(`Step 2 failed: ${response.status}`);
        return null;
      }

      const data = await response.json();
      console.log('✅ Step 2 successful');
      return data;
      
    } catch (error) {
      console.error('Step 2 failed:', error);
      if (retryCount < maxRetries) {
        console.log(`🔄 Retrying after network error...`);
        await new Promise(resolve => setTimeout(resolve, 2000));
        return this.step2GetSecureTokenUri(token, sourceId, systemSourceId, retryCount + 1);
      }
      return null;
    }
  }

  /**
   * Step 3: Call the index.m3u8 endpoint to initialize the playlist
   */
  async step3GetHlsPlaylist(secureUri: string, silentFail: boolean = false): Promise<PlaylistInfo | null> {
    try {
      if (!silentFail) console.log('Step 3: Hitting index.m3u8 endpoint...');
      
      const response = await fetch(secureUri, {
        method: 'GET',
        headers: STREAM_HEADERS,
        // SSL verification disabled - comprehensive bypass
        // @ts-ignore - Node.js specific
        agent: new (require('https')).Agent({ 
          rejectUnauthorized: false,
          checkServerIdentity: () => undefined,
          secureProtocol: 'TLSv1_2_method'
        })
      });

      if (!response.ok) {
        if (!silentFail) console.warn(`Step 3 failed: ${response.status}`);
        return null;
      }

      const playlistContent = response.text();
      if (!silentFail) console.log('✅ Step 3 successful');
      
      // Parse the playlist to extract segments
      const segments = this.parseM3u8Playlist(await playlistContent, secureUri);
      
      return {
        playlist_content: await playlistContent,
        segments,
        base_url: this.getBaseUrl(secureUri)
      };
      
    } catch (error) {
      if (!silentFail) console.error('Step 3 failed:', error);
      return null;
    }
  }

  /**
   * Step 4: Get HLS playlist (m3u8) with current segments
   */
  async step4GetHlsPlaylist(secureUri: string, silentFail: boolean = false): Promise<PlaylistInfo | null> {
    try {
      if (!silentFail) console.log('Step 4: Getting HLS playlist...');
      
      const response = await fetch(secureUri, {
        method: 'GET',
        headers: STREAM_HEADERS,
        // SSL verification disabled - comprehensive bypass
        // @ts-ignore - Node.js specific
        agent: new (require('https')).Agent({ 
          rejectUnauthorized: false,
          checkServerIdentity: () => undefined,
          secureProtocol: 'TLSv1_2_method'
        })
      });

      if (!response.ok) {
        if (!silentFail) console.warn(`Step 3 failed: ${response.status}`);
        return null;
      }

      const playlistContent = response.text();
      if (!silentFail) console.log('✅ Step 3 successful');
      
      // Parse the playlist to extract segments
      const segments = this.parseM3u8Playlist(await playlistContent, secureUri);
      
      return {
        playlist_content: await playlistContent,
        segments,
        base_url: this.getBaseUrl(secureUri)
      };
      
    } catch (error) {
      if (!silentFail) console.error('Step 3 failed:', error);
      return null;
    }
  }

  /**
   * Step 4: Get individual video segment (.ts file)
   */
  async step4GetVideoSegment(segmentUrl: string): Promise<ArrayBuffer | null> {
    try {
      console.log('Step 4: Getting video segment...');
      
      const response = await fetch(segmentUrl, {
        method: 'GET',
        headers: STREAM_HEADERS,
        // SSL verification disabled - comprehensive bypass
        // @ts-ignore - Node.js specific
        agent: new (require('https')).Agent({ 
          rejectUnauthorized: false,
          checkServerIdentity: () => undefined,
          secureProtocol: 'TLSv1_2_method'
        })
      });

      if (!response.ok) {
        console.warn(`Step 4 failed: ${response.status}`);
        return null;
      }

      const segmentData = await response.arrayBuffer();
      console.log(`✅ Step 4 successful (${segmentData.byteLength} bytes)`);
      
      return segmentData;
      
    } catch (error) {
      console.error('Step 4 failed:', error);
      return null;
    }
  }

  /**
   * Complete authentication flow - get streaming info for a camera
   */
  async getVideoStreamInfo(cameraId: string, indexVideoUrl: string): Promise<StreamInfo | null> {
    // Rate limiting: ensure minimum time between authentication requests
    const now = Date.now();
    const timeSinceLastAuth = now - this.lastAuthTime;
    if (timeSinceLastAuth < this.minAuthInterval) {
      const delayNeeded = this.minAuthInterval - timeSinceLastAuth;
      console.log(`⏱️ Rate limiting: waiting ${delayNeeded}ms before authentication...`);
      await new Promise(resolve => setTimeout(resolve, delayNeeded));
    }
    this.lastAuthTime = Date.now();
    
    console.log('='.repeat(60));
    console.log(`FL-511 Video Authentication Flow - Camera ${cameraId}`);
    console.log(`🔗 Auth Service - Received video URL: ${indexVideoUrl}`);
    console.log('='.repeat(60));
    
    // Validate videoUrl parameter
    if (!indexVideoUrl || indexVideoUrl === 'undefined' || indexVideoUrl === 'null' || indexVideoUrl.trim() === '') {
      console.error(`❌ Auth Service - Invalid video URL provided: ${indexVideoUrl}`);
      return null;
    }
    const videoUrl = indexVideoUrl.split('?')[0].replace(/index\.m3u8$/, '')
    // Remove 'index.m3u8' from the end of the URL and add '/xflow.m3u8' instead
    const xflowVideoUrl = videoUrl + 'xflow.m3u8';
    
    // Step 1: Get video URL
    const videoInfo = await this.step1GetVideoUrl(cameraId);
    if (!videoInfo) {
      return null;
    }
    
    // Extract required data from step 1
    const token = videoInfo.token;
    const sourceId = videoInfo.sourceId;
    const systemSourceId = videoInfo.systemSourceId;
    
    if (!token || !sourceId || !systemSourceId) {
      console.error(`Missing required data from step 1: token=${token}, sourceId=${sourceId}, systemSourceId=${systemSourceId}`);
      return null;
    }
    
    // Step 2: Get secure token URI
    const tokenInfo = await this.step2GetSecureTokenUri(token, sourceId, systemSourceId);
    if (!tokenInfo) {
      return null;
    }
    
    // Handle different response formats from step 2
    let xflowSecureUri: string;
    let indexSecureUri: string;
    let finalPlaylistInfo: PlaylistInfo;
    
    if (typeof tokenInfo === 'string') {
      // Response is a token parameter string like "?token=..."
      let tokenValue: string;
      if (tokenInfo.startsWith('?token=')) {
        tokenValue = tokenInfo.substring(7); // Remove "?token="
      } else {
        tokenValue = tokenInfo;
      }
      
      console.log(`Extracted token value: ${tokenValue}`);
      
      // Step 3: Append token to provided video URL
      xflowSecureUri = xflowVideoUrl + `?token=${tokenValue}`;
      indexSecureUri = indexVideoUrl + `?token=${tokenValue}`;
      console.log(`Using provided video URL: ${xflowVideoUrl}`);
      const initialPlaylistInfo = await this.step3GetHlsPlaylist(indexSecureUri, false);
      const playlistInfo = await this.step4GetHlsPlaylist(xflowSecureUri, false);
      if (!playlistInfo) {
        // Log the actual type and value of secureUri for debugging serialization issues
        console.error(
          `❌ Failed to authenticate with provided video URL:`,
          {
            secureUri: xflowSecureUri,
            type: typeof xflowSecureUri,
            isString: typeof xflowSecureUri === 'string',
            urlIsValid: (() => {
              try { new URL(xflowSecureUri); return true; } catch { return false; }
            })()
          }
        );
        return null;
      }
      
      finalPlaylistInfo = playlistInfo;
      console.log(`✅ Successfully authenticated with provided video URL`);
      
    } else if (typeof tokenInfo === 'object' && tokenInfo.secureUri) {
      // Response is a JSON object with secureUri
      xflowSecureUri = tokenInfo.secureUri;
      indexSecureUri = indexVideoUrl;
      const initialPlaylistInfo = await this.step3GetHlsPlaylist(indexSecureUri, false);
      const playlistInfo = await this.step4GetHlsPlaylist(xflowSecureUri);
      if (!playlistInfo) {
        return null;
      }
      finalPlaylistInfo = playlistInfo;
    } else {
      console.error('Unexpected response format from step 2');
      return null;
    }
    
    const result: StreamInfo = {
      camera_id: cameraId,
      step1_video_info: videoInfo,
      step2_token_info: tokenInfo,
      step3_playlist_info: finalPlaylistInfo,
      streaming_url: xflowSecureUri,
      segments: finalPlaylistInfo.segments
    };
    
    console.log('='.repeat(60));
    console.log('✅ Authentication flow completed successfully!');
    console.log(`📺 Streaming URL: ${xflowSecureUri}`);
    console.log(`🎬 Available segments: ${finalPlaylistInfo.segments.length}`);
    console.log('='.repeat(60));
    
    return result;
  }

  /**
   * Parse m3u8 playlist to extract segment information
   */
  private parseM3u8Playlist(playlistContent: string, baseUrl: string): VideoSegment[] {
    const segments: VideoSegment[] = [];
    const lines = playlistContent.trim().split('\n');
    
    const baseUrlParsed = new URL(baseUrl);
    const basePath = baseUrlParsed.pathname.split('/').slice(0, -1).join('/') + '/';
    const baseDomain = `${baseUrlParsed.protocol}//${baseUrlParsed.host}`;
    
    let currentDuration: number | undefined;
    let currentDate: string | undefined;
    
    for (const line of lines) {
      const trimmedLine = line.trim();
      
      // Parse segment duration
      if (trimmedLine.startsWith('#EXTINF:')) {
        const durationMatch = trimmedLine.match(/#EXTINF:([\d.]+)/);
        if (durationMatch) {
          currentDuration = parseFloat(durationMatch[1]);
        }
      }
      
      // Parse program date time
      else if (trimmedLine.startsWith('#EXT-X-PROGRAM-DATE-TIME:')) {
        currentDate = trimmedLine.replace('#EXT-X-PROGRAM-DATE-TIME:', '');
      }
      
      // Parse segment URL
      else if (trimmedLine.endsWith('.ts') || (trimmedLine.includes('?token=') && trimmedLine.includes('.ts'))) {
        if (!trimmedLine || trimmedLine.startsWith('#')) {
          continue;
        }
        
        // Handle relative URLs
        let fullUrl: string;
        if (trimmedLine.startsWith('http')) {
          fullUrl = trimmedLine;
        } else {
          fullUrl = baseDomain + basePath + trimmedLine;
        }
        
        const segmentInfo: VideoSegment = {
          url: fullUrl,
          filename: trimmedLine.split('?')[0].split('/').pop() || '',
          duration: currentDuration,
          program_date_time: currentDate
        };
        segments.push(segmentInfo);
        
        // Reset for next segment
        currentDuration = undefined;
        currentDate = undefined;
      }
    }
    
    return segments;
  }

  /**
   * Extract base URL from full URL
   */
  private getBaseUrl(fullUrl: string): string {
    const parsed = new URL(fullUrl);
    return `${parsed.protocol}//${parsed.host}`;
  }

  /**
   * Test downloading a specific video segment
   */
  async testSegmentDownload(streamInfo: StreamInfo, segmentIndex: number = 0): Promise<boolean> {
    const segments = streamInfo.segments;
    if (!segments.length) {
      console.error('No segments available');
      return false;
    }
    
    if (segmentIndex >= segments.length) {
      segmentIndex = 0;
    }
    
    const segment = segments[segmentIndex];
    const segmentData = await this.step4GetVideoSegment(segment.url);
    
    if (segmentData) {
      console.log(`✅ Successfully downloaded segment ${segmentIndex}: ${segment.filename}`);
      console.log(`   Size: ${segmentData.byteLength} bytes`);
      console.log(`   Duration: ${segment.duration || 'unknown'} seconds`);
      return true;
    } else {
      return false;
    }
  }
}

// Singleton instance
export const florida511Auth = new Florida511AuthService();

/**
 * Simplified function to get a camera's authenticated video URL (backward compatibility)
 */
export async function getFloridaCameraVideoUrl(cameraId: string, videoUrl: string): Promise<string | null> {
  try {
    const streamInfo = await florida511Auth.getVideoStreamInfo(cameraId, videoUrl);
    return streamInfo?.streaming_url || null;
  } catch (error) {
    console.error(`Failed to get video URL for camera ${cameraId}:`, error);
    return null;
  }
}

/**
 * Get complete streaming information for a camera (new enhanced function)
 */
export async function getFloridaCameraStreamInfo(cameraId: string, videoUrl: string): Promise<StreamInfo | null> {
  try {
    return await florida511Auth.getVideoStreamInfo(cameraId, videoUrl);
  } catch (error) {
    console.error(`Failed to get stream info for camera ${cameraId}:`, error);
    return null;
  }
}

/**
 * Get video segment data for streaming
 */
export async function getVideoSegment(segmentUrl: string): Promise<ArrayBuffer | null> {
  try {
    return await florida511Auth.step4GetVideoSegment(segmentUrl);
  } catch (error) {
    console.error('Failed to get video segment:', error);
    return null;
  }
}

/**
 * Check if a video URL needs authentication (is from divas.cloud domain)
 */
export function needsAuthentication(videoUrl: string): boolean {
  return videoUrl.includes('divas.cloud') || videoUrl.includes('dis-se');
}

/**
 * Export types for use in API routes
 */
export type { StreamInfo, VideoSegment, PlaylistInfo, Step1Response, Step2Response };