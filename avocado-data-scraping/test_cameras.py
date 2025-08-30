from fl511_video_auth_production import FL511VideoAuthProduction

print("Testing camera loading...")
auth = FL511VideoAuthProduction()
print(f'✅ Loaded {len(auth.cameras_data)} cameras')

i4_cameras = [c for c in auth.cameras_data if c.get('roadway') == 'I-4']
print(f'✅ I-4 cameras: {len(i4_cameras)}')

if i4_cameras:
    print(f'✅ First I-4 camera: {i4_cameras[0]["camera_id"]} - {i4_cameras[0]["description"]}')
    print(f'✅ Sample camera data keys: {list(i4_cameras[0].keys())}')
    
    # Test that we have the key fields needed
    required_fields = ['camera_id', 'image_id', 'video_url', 'description']
    missing = [field for field in required_fields if field not in i4_cameras[0]]
    if missing:
        print(f'❌ Missing fields: {missing}')
    else:
        print(f'✅ All required fields present')
else:
    print('❌ No I-4 cameras found!')