# Voxel Engine 3D - Project Specs

## Overview
Voxel-based Minecraft-like game built with Three.js + Capacitor for Android.

## Stack
- **Engine**: Three.js (WebGL), single-file game in `www/index.html` (and a copy `Opencraft.html`)
- **Mobile**: Capacitor v8 (Android), WebView rendering
- **Build**: Gradle (`android/`), `./gradlew assembleDebug`
- **Audio**: Web Audio API (procedural synth, no assets)

## Architecture
- **Terrain**: Chunk-based (`CHUNK_SIZE=16`, `CHUNK_HEIGHT=64`), simplex noise generation
- **Rendering**: Greedy mesh per chunk with AO, texture atlas (128x128 with 8px padding)
- **Shadows**: Directional light with cascaded shadow snap
- **Water**: ShaderMaterial plane with wave animation
- **Clouds**: Voxel-based volumetric clouds with custom ShaderMaterial
- **Physics**: AABB collision, step-up, gravity, swimming

## Key Controls
- **Desktop**: WASD + mouse (pointer lock), left click break, right click place
- **Mobile**: Joystick (left) + touch look (right), on-screen buttons

## Known Issues & Fixes
- **Camera stuck while walking (mobile)**: Fixed in `touchstart` handler by removing `!touchJoystickId` condition so look touch registers independently of joystick.

## Build APK
```bash
npx cap copy
cd android && ./gradlew assembleDebug
# Output: android/app/build/outputs/apk/debug/app-debug.apk
```

## Files
- `www/index.html` - Main game (all-in-one HTML/JS/CSS ~3200 lines)
- `Opencraft.html` - Copy of the game (sync changes to both)
- `www/js/three.min.js` - Three.js r152+
- `android/` - Capacitor Android project
- `capacitor.config.json` - App config (appId: com.voxelengine.app)
