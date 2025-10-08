import { NextRequest, NextResponse } from 'next/server';
import { Storage } from '@google-cloud/storage';

export async function GET() {
  console.log('🧪 Starting GCS authentication test...');
  
  // Check environment variables
  const envCheck = {
    GOOGLE_APPLICATION_CREDENTIALS_JSON: !!process.env.GOOGLE_APPLICATION_CREDENTIALS_JSON,
    GCP_PROJECT_ID: !!process.env.GCP_PROJECT_ID,
    GCP_PRIVATE_KEY: !!process.env.GCP_PRIVATE_KEY,
    GCP_CLIENT_EMAIL: !!process.env.GCP_CLIENT_EMAIL,
    GOOGLE_APPLICATION_CREDENTIALS: !!process.env.GOOGLE_APPLICATION_CREDENTIALS,
  };
  
  console.log('📋 Environment variables check:', envCheck);
  
  let storage: Storage | null = null;
  let authMethod = 'none';
  
  try {
    // Try different authentication methods - same priority as main API
    if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
      console.log('🔑 Attempting file-based credentials authentication...');
      storage = new Storage();
      authMethod = 'file';
    } else if (process.env.GOOGLE_APPLICATION_CREDENTIALS_JSON) {
      console.log('🔑 Attempting JSON credentials authentication...');
      const credentials = JSON.parse(process.env.GOOGLE_APPLICATION_CREDENTIALS_JSON);
      storage = new Storage({
        credentials,
        projectId: credentials.project_id,
      });
      authMethod = 'json';
    } else if (process.env.GCP_PROJECT_ID && process.env.GCP_PRIVATE_KEY && process.env.GCP_CLIENT_EMAIL) {
      console.log('🔑 Attempting individual credentials authentication...');
      storage = new Storage({
        credentials: {
          type: 'service_account',
          project_id: process.env.GCP_PROJECT_ID,
          private_key: process.env.GCP_PRIVATE_KEY.replace(/\\n/g, '\n'),
          client_email: process.env.GCP_CLIENT_EMAIL,
        },
        projectId: process.env.GCP_PROJECT_ID,
      });
      authMethod = 'individual';
    } else {
      console.log('🔑 Attempting default credentials...');
      storage = new Storage();
      authMethod = 'default';
    }
    
    if (!storage) {
      return NextResponse.json({
        error: 'Failed to initialize Storage client',
        envCheck
      }, { status: 500 });
    }
    
    console.log(`✅ Storage client created using ${authMethod} method`);
    
    // Test basic authentication
    console.log('🔍 Testing getProjectId...');
    const projectId = await storage.getProjectId();
    console.log(`✅ Project ID: ${projectId}`);
    
    // Test bucket access
    console.log('🪣 Testing bucket access...');
    const bucketName = 'avocado-fl511-video-fl511-video-segments';
    const bucket = storage.bucket(bucketName);
    
    console.log('📂 Checking bucket exists...');
    const [bucketExists] = await bucket.exists();
    console.log(`✅ Bucket exists: ${bucketExists}`);
    
    // Test file listing (just get first few files)
    console.log('📋 Testing file listing...');
    const [files] = await bucket.getFiles({ maxResults: 5 });
    console.log(`✅ Found ${files.length} files (showing first 5)`);
    
    const fileNames = files.map(f => f.name);
    
    return NextResponse.json({
      success: true,
      authMethod,
      projectId,
      bucketExists,
      fileCount: files.length,
      sampleFiles: fileNames,
      envCheck
    });
    
  } catch (error) {
    console.error('❌ GCS test failed:', error);
    return NextResponse.json({
      error: 'GCS authentication test failed',
      details: error instanceof Error ? error.message : String(error),
      authMethod,
      envCheck
    }, { status: 500 });
  }
}