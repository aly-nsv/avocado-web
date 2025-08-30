#!/usr/bin/env python3
"""
Systematically find working HLS streaming URLs for FL511 cameras
"""

import sys
sys.path.append('fl-video-auth')

from fl511_video_auth_revised import FL511VideoAuth
import requests
import warnings
warnings.filterwarnings('ignore')

def test_url_patterns():
    """Test different URL patterns to find one that works"""
    print("🔍 Finding working streaming URL patterns...")
    
    # Get fresh tokens
    auth_client = FL511VideoAuth()
    camera_id = "673"
    
    video_info = auth_client.step1_get_video_url(camera_id)
    if not video_info:
        return None
    
    token = video_info.get('token')
    source_id = video_info.get('sourceId')
    system_source_id = video_info.get('systemSourceId')
    
    token_info = auth_client.step2_get_secure_token_uri(token, source_id, system_source_id)
    if not token_info:
        return None
    
    streaming_token = token_info[7:] if token_info.startswith('?token=') else token_info
    
    # Test different URL patterns
    servers = ['dis-se1', 'dis-se2', 'dis-se3', 'dis-se14', 'dis-se15', 'dis-se16']
    ports = ['8200', '8201', '8202']
    patterns = [
        f'chan-{source_id}_h/index.m3u8',
        f'chan-{source_id}_h/xflow.m3u8', 
        f'chan-{source_id}_h/playlist.m3u8',
        f'chan-{source_id}_m/index.m3u8',
        f'chan-{source_id}_l/index.m3u8',
        f'chan-{camera_id}_h/index.m3u8',
        f'chan-{camera_id}_h/xflow.m3u8',
        f'{source_id}/index.m3u8',
        f'{source_id}/playlist.m3u8',
        f'{camera_id}/index.m3u8',
        f'stream/{source_id}/index.m3u8',
        f'hls/{source_id}/index.m3u8'
    ]
    
    session = requests.Session()
    headers = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
        'Accept': '*/*',
        'Referer': 'https://fl511.com/'
    }
    
    working_urls = []
    
    for server in servers:
        for port in ports:
            for pattern in patterns:
                url = f"https://{server}.divas.cloud:{port}/{pattern}?token={streaming_token}"
                try:
                    print(f"Testing: {server}:{port}/{pattern}", end='')
                    response = session.get(url, headers=headers, timeout=10, verify=False)
                    
                    if response.status_code == 200 and '#EXTM3U' in response.text:
                        print(" ✅ WORKS!")
                        working_urls.append({
                            'url': url,
                            'server': server,
                            'port': port,
                            'pattern': pattern,
                            'content_preview': response.text[:200]
                        })
                        
                        # Save the full playlist for inspection
                        with open(f'playlist_{server}_{port}_{pattern.replace("/", "_")}.m3u8', 'w') as f:
                            f.write(response.text)
                        
                        break  # Found working URL for this server
                    else:
                        print(f" ❌ ({response.status_code})")
                        
                except Exception as e:
                    print(f" ❌ (error)")
                
                if working_urls:
                    break
            if working_urls:
                break
        if working_urls:
            break  # Found working URL, stop searching
    
    return working_urls

def main():
    working_urls = test_url_patterns()
    
    if working_urls:
        print(f"\n🎯 Found {len(working_urls)} working streaming URLs!")
        for i, url_info in enumerate(working_urls):
            print(f"\n{i+1}. {url_info['server']}.divas.cloud:{url_info['port']}")
            print(f"   Pattern: {url_info['pattern']}")
            print(f"   URL: {url_info['url']}")
            print(f"   Content preview: {url_info['content_preview'][:100]}...")
        
        # Test with ffplay
        if working_urls:
            print(f"\n🎬 Testing with ffplay...")
            best_url = working_urls[0]['url']
            print(f"URL: {best_url}")
            return best_url
    else:
        print("\n❌ No working streaming URLs found")
        return None

if __name__ == "__main__":
    url = main()
    if url:
        print(f"\n✅ Ready to test with ffplay!")
        print(f"Run: ffplay -i '{url}'")