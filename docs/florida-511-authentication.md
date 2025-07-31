# Florida 511 Camera Authentication System

## 🔐 **Authentication Flow**

Florida 511 traffic cameras require session-based authentication to access live video streams. The system implements a complete authentication proxy to handle this securely.

### **Problem Solved**
- **CORS Blocking**: Direct access to `divas.cloud` streams blocked by browser
- **Session Management**: FL511 requires cookies and verification tokens
- **Token Exchange**: Two-step process: FL511 → Divas API → Secure Stream URL

### **Architecture**

```
Client → Video Proxy API → FL511 Auth Service → Divas API → Authenticated Stream
```

## 🛠️ **Implementation**

### **1. Authentication Service** (`/src/lib/florida511-auth.ts`)
- **Session Management**: Handles FL511 cookies and verification tokens
- **Token Exchange**: Communicates with Divas API for secure URLs
- **Auto-retry**: Refreshes sessions automatically when expired

### **2. Proxy Endpoints**
- **`/api/video-proxy/[cameraId]`**: Returns authenticated URL as JSON
- **`/api/stream-proxy/[cameraId]`**: Proxies actual video stream with CORS headers

### **3. Enhanced Video Player** (`VideoDrawer.tsx`)
- **Smart Detection**: Automatically detects URLs needing authentication
- **Loading States**: Shows authentication progress to users
- **Error Handling**: Graceful fallbacks for offline cameras
- **Source ID Integration**: Uses camera metadata for authentication

## 📡 **API Usage**

### **Get Authenticated URL**
```javascript
const response = await fetch(`/api/video-proxy/1527?sourceId=574&originalUrl=${encodeURIComponent(originalUrl)}`);
const data = await response.json();
// Returns: { cameraId, secureUrl, authenticated: true, expiresIn: 1800 }
```

### **Stream Through Proxy**
```javascript
const streamUrl = `/api/stream-proxy/1527?sourceId=574`;
// Use this URL directly in HLS.js or video player
```

## 🔄 **Integration Points**

### **Camera Data Enhancement**
The v1 API now includes authentication metadata:

```javascript
{
  id: "1527",
  name: "I-95 Southbound @ SR-206",
  videoUrl: "https://dis-se6.divas.cloud:8200/chan-9213_h/index.m3u8",
  sourceId: "574",        // ← Required for authentication
  systemSource: "District 2"
}
```

### **Video Player Integration**
The `HLSVideoPlayer` component automatically:
1. **Detects** authentication-required URLs (`divas.cloud`, `dis-se`)
2. **Authenticates** through proxy API using source metadata
3. **Loads** authenticated stream with proper error handling
4. **Displays** loading/error states to user

## 🎯 **User Experience**

### **Loading Flow**
1. User clicks camera icon on map
2. VideoDrawer shows "Authenticating stream..." 
3. Background authentication with FL511/Divas APIs
4. Stream loads automatically when ready

### **Error Handling**
- **Authentication Failed**: Shows retry button and error message
- **Stream Offline**: Displays camera offline indicator
- **Network Issues**: Auto-retry with exponential backoff (HLS.js)

## 🔧 **Configuration**

### **Environment Variables**
No additional environment variables required - uses existing Next.js setup.

### **Headers Configuration**
The authentication service mimics browser headers:
- **User-Agent**: Chrome browser string
- **Referer**: FL511.com origin
- **Accept**: Proper content-type headers

## 🚨 **Security Considerations**

### **Server-Side Only**
- Authentication credentials never exposed to client
- Session tokens managed server-side
- CORS protection maintained

### **Rate Limiting**
- Session reuse prevents excessive FL511 requests
- 30-minute session lifetime matches FL511 expectations
- Automatic cleanup of expired sessions

## 🎛️ **Monitoring & Debugging**

### **Logs**
- Authentication attempts logged to console
- HLS.js errors captured and handled
- Proxy API errors returned with details

### **Debug Information**
```javascript
// Check authentication status in browser console
console.log('Camera requires auth:', needsAuthentication(videoUrl));

// View current stream URL
const video = document.querySelector('video');
console.log('Playing:', video?.src);
```

## 🚀 **Future Enhancements**

### **Planned Features**
- **Caching**: Store authenticated URLs temporarily
- **Batch Authentication**: Handle multiple cameras efficiently  
- **Health Monitoring**: Track authentication success rates
- **Failover**: Alternative stream sources when primary fails

### **Performance Optimizations**
- **Connection Pooling**: Reuse HTTP connections to FL511
- **Token Caching**: Store verification tokens longer
- **Stream Preloading**: Authenticate popular cameras proactively

---

## 🧪 **Testing**

### **Test Authentication**
1. Select Florida from state dropdown
2. Click any camera marker (green 📹 icon)
3. VideoDrawer should show authentication progress
4. Stream should load automatically when ready

### **Test Error Handling**
- **Offline Camera**: Should show "Stream Unavailable" message
- **Network Issues**: Should show loading spinner and retry option
- **Authentication Failure**: Should display error with retry button

The system is designed to be **transparent to users** - they just click cameras and videos load automatically! 🎥