/**
 * Florida 511 Authentication & Video Stream Service
 * ================================================
 * 
 * Handles authentication flow and secure video URL retrieval for FL511 cameras.
 * Based on the curl requests showing session cookies and request verification tokens.
 */

interface FL511Session {
  sessionId: string;
  requestVerificationToken: string;
  aspNetCookie: string;
  expires: Date;
}

interface VideoTokenRequest {
  token: string;
  sourceId: string;
  systemSourceId: string;
}

interface VideoTokenResponse {
  secureUrl?: string;
  error?: string;
}

class Florida511AuthService {
  private session: FL511Session | null = null;
  private readonly baseUrl = 'https://fl511.com';
  private readonly divasUrl = 'https://divas.cloud';

  /**
   * Initialize a session with FL511 by visiting the main page and extracting tokens
   */
  async initializeSession(): Promise<FL511Session> {
    try {
      // Step 1: Get initial page to establish session
      const response = await fetch(`${this.baseUrl}/map`, {
        method: 'GET',
        headers: {
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8',
          'Accept-Language': 'en-US,en;q=0.9'
        }
      });

      if (!response.ok) {
        throw new Error(`Failed to initialize FL511 session: ${response.status}`);
      }

      // Extract cookies from response
      const setCookieHeaders = response.headers.get('set-cookie');
      const cookies = this.parseCookies(setCookieHeaders || '');
      
      // Get the page content to extract request verification token
      const html = await response.text();
      const tokenMatch = html.match(/name="__RequestVerificationToken"[^>]*value="([^"]+)"/);
      
      if (!tokenMatch) {
        throw new Error('Could not extract request verification token from FL511');
      }

      const session: FL511Session = {
        sessionId: cookies['session-id'] || '',
        requestVerificationToken: tokenMatch[1],
        aspNetCookie: cookies['.AspNet.ApplicationCookie'] || '',
        expires: new Date(Date.now() + 30 * 60 * 1000) // 30 minutes
      };

      this.session = session;
      return session;

    } catch (error) {
      console.error('Florida 511 session initialization failed:', error);
      throw error;
    }
  }

  /**
   * Get secure video URL for a camera
   */
  async getSecureVideoUrl(imageId: string, sourceId: string): Promise<string | null> {
    try {
      // Ensure we have a valid session
      if (!this.session || this.session.expires < new Date()) {
        await this.initializeSession();
      }

      if (!this.session) {
        throw new Error('Failed to establish FL511 session');
      }

      // Step 1: Get video URL from FL511
      const videoUrlResponse = await fetch(`${this.baseUrl}/Camera/GetVideoUrl?imageId=${imageId}&_=${Date.now()}`, {
        method: 'GET',
        headers: {
          '__requestverificationtoken': this.session.requestVerificationToken,
          'Accept': '*/*',
          'Accept-Language': 'en-US,en;q=0.9',
          'Cookie': this.buildCookieString(),
          'Referer': `${this.baseUrl}/map`,
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
          'X-Requested-With': 'XMLHttpRequest'
        }
      });

      if (!videoUrlResponse.ok) {
        console.warn(`FL511 video URL request failed for camera ${imageId}: ${videoUrlResponse.status}`);
        return null;
      }

      const videoData = await videoUrlResponse.json();
      
      // Step 2: Get secure token from Divas API
      const tokenRequest: VideoTokenRequest = {
        token: videoData.token || '',
        sourceId: sourceId,
        systemSourceId: 'District 2' // Based on curl request
      };

      const secureTokenResponse = await fetch(`${this.divasUrl}/VDS-API/SecureTokenUri/GetSecureTokenUriBySourceId`, {
        method: 'POST',
        headers: {
          '__requestverificationtoken': this.session.requestVerificationToken,
          'Accept': '*/*',
          'Accept-Language': 'en-US,en;q=0.9',
          'Content-Type': 'application/json',
          'Origin': this.baseUrl,
          'Referer': `${this.baseUrl}/`,
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'
        },
        body: JSON.stringify(tokenRequest)
      });

      if (!secureTokenResponse.ok) {
        console.warn(`Divas secure token request failed for camera ${imageId}: ${secureTokenResponse.status}`);
        return null;
      }

      const tokenData: VideoTokenResponse = await secureTokenResponse.json();
      
      return tokenData.secureUrl || null;

    } catch (error) {
      console.error(`Error getting secure video URL for camera ${imageId}:`, error);
      return null;
    }
  }

  /**
   * Parse Set-Cookie headers into a cookie object
   */
  private parseCookies(cookieHeader: string): Record<string, string> {
    const cookies: Record<string, string> = {};
    
    cookieHeader.split(',').forEach(cookie => {
      const [nameValue] = cookie.split(';');
      const [name, value] = nameValue.split('=');
      if (name && value) {
        cookies[name.trim()] = value.trim();
      }
    });

    return cookies;
  }

  /**
   * Build cookie string for requests
   */
  private buildCookieString(): string {
    if (!this.session) return '';

    const cookies = [
      `session-id=${this.session.sessionId}`,
      `__RequestVerificationToken=${this.session.requestVerificationToken}`,
      `.AspNet.ApplicationCookie=${this.session.aspNetCookie}`,
      '_culture=en',
      'session=session',
      '_region=ALL'
    ];

    return cookies.join('; ');
  }

  /**
   * Clear current session
   */
  clearSession(): void {
    this.session = null;
  }
}

// Singleton instance
export const florida511Auth = new Florida511AuthService();

/**
 * Simplified function to get a camera's authenticated video URL
 */
export async function getFloridaCameraVideoUrl(cameraId: string, sourceId: string): Promise<string | null> {
  try {
    return await florida511Auth.getSecureVideoUrl(cameraId, sourceId);
  } catch (error) {
    console.error(`Failed to get video URL for camera ${cameraId}:`, error);
    return null;
  }
}

/**
 * Check if a video URL needs authentication (is from divas.cloud domain)
 */
export function needsAuthentication(videoUrl: string): boolean {
  return videoUrl.includes('divas.cloud') || videoUrl.includes('dis-se');
}