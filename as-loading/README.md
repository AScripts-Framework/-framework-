# AS Loading Screen 🎬

Modern FiveM loading screen with video background, track info display, and full media controls.

## Features

✅ **Video Background**
- Multiple WebM video playlist support
- Video audio playback (uses video's built-in audio)
- Seamless looping between videos
- Full-screen responsive

✅ **Track Information Display**
- Album artwork (45x45px)
- Song name display
- Artist name display
- Updates when switching videos

✅ **Media Controls**
- ▶️ Play/Pause toggle
- ⏪ Previous video in playlist
- ⏩ Next video in playlist
- 🎚️ Time scrubber/slider
- 🔊 Volume slider
- 🔇 Mute toggle
- ⏱️ Time display (current/duration)

✅ **Loading Progress**
- Real-time progress bar (bottom-right corner)
- Dynamic loading messages (bottom-center)
- Smooth animations
- FiveM integration with AS Framework

## Installation

1. **Place Resource**
   ```
   resources/[standalone]/as-loading/
   ```

2. **Add to server.cfg**
   ```bash
   ensure as-loading
   ```

3. **Add Media Files**
   
   Place your video files and album artwork in the `html/videos/` folder:
   ```
   as-loading/
   ├── html/
   │   ├── videos/
   │   │   ├── background1.webm
   │   │   ├── background2.webm
   │   │   ├── album1.jpg
   │   │   ├── album2.jpg
   │   │   └── ...
   │   └── ...
   ```
   
   Update the playlist in `html/config.js`:
   ```javascript
   videos: {
       playlist: [
           {
               url: 'videos/background1.webm',
               artist: 'Artist Name',
               song: 'Song Title',
               album: 'videos/album1.jpg'
           },
           {
               url: 'videos/background2.webm',
               artist: 'Another Artist',
               song: 'Another Song',
               album: 'videos/album2.jpg'
           },
       ],
       muted: false, // Use video's built-in audio
### Branding
```javascript
branding: {
    serverName: 'YOUR SERVER NAME',
    tagline: 'Your Server Tagline',
    logoPath: 'logo.png',
    showLogo: false, // Logo hidden by default
}
```

### Videos
```javascript
videos: {
    playlist: [
        {
            url: 'videos/background1.webm',
            artist: 'Artist Name',
            song: 'Song Title',
            album: 'videos/album1.jpg'
        },
        // Add more videos with metadata
    ],
    muted: false, // Use video's built-in audio
    autoPlay: true,
    loop: true,
}
```

### Audio
```javascript
audio: {
    enabled: false, // Separate audio disabled (using video audio)
    defaultVolume: 30, // 0-100
}
```

### Controls
```javascript
controls: {
    show: true,
    colors: {
        primary: '#8B5CF6',
        secondary: '#10B981',
    }
}
``` defaultVolume: 30, // 0-100
    loop: true,
}
```

### Controls
```javascript
controls: {
    show: true,
    skipAmount: 10, // seconds
    primaryColor: '#8B5CF6',
    secondaryColor: '#10B981',
}
```

### Progress
```javascript
progress: {
    show: true,
    messages: [
        'Custom message 1...',
        'Custom message 2...',
    ],
    shimmerEffect: true,
}
```

### Colors & Styling
```javascript
styling: {
    overlayGradient: 'linear-gradient(...)',
    serverNameGradient: 'linear-gradient(...)',
### Layout
```javascript
layout: {
    logoTopPosition: 15, // % from top
    progressBottomPosition: 20, // px from bottom (bottom-right corner)
    progressRightPosition: 20, // px from right
    progressWidth: 300, // px
    controlsBottomPosition: 30, // px from bottom (250px from left)
}
```

### Behavior
```javascript
behavior: {
    maxLoadTime: 300000, // 5 minutes
    shutdownDelay: 1000,
## Media File Requirements

### Video (WebM with Audio)
- **Format**: WebM (VP8/VP9 with Vorbis/Opus audio)
- **Resolution**: 1920x1080 recommended
- **Duration**: 2-5 minutes recommended
- **File Size**: Keep under 50MB for fast loading
- **Audio**: Include audio track in the video file

**Convert video to WebM with audio:**
```bash
ffmpeg -i input.mp4 -c:v libvpx-vp9 -b:v 2M -c:a libvorbis background.webm
```

### Album Artwork (JPG/PNG)
- **Format**: JPG or PNG
- **Size**: 500x500px recommended (displayed at 45x45px)
- **File Size**: Keep under 200KB

## Hosting Media Files

### Local Files (Current Setup)
Files are stored in the resource folder:
```
as-loading/html/videos/
├── background1.webm
├── background2.webm
├── album1.jpg
├── album2.jpg
└── ...
```

**Note:** Large video files will increase resource size and initial download time for players.
```
as-loading/html/
├── videos/
│   ├── background1.webm
│   ├── background2.webm
### Option 2: CDN (For Faster Loading)
1. Upload videos and album art to a CDN
2. Update paths in `html/config.js`:
   ```javascript
   videos: {
       playlist: [
           {
               url: 'https://your-cdn.com/background1.webm',
               artist: 'Artist Name',
               song: 'Song Title',
               album: 'https://your-cdn.com/album1.jpg'
           },
       ],
   }
   ```
3. Remove local files from `fxmanifest.lua`
   ```
3. Update audio in `html/index.html`:
   ```html
   <source src="https://your-cdn.com/music.webm" type="audio/webm">
   ```
4. Remove local files from `fxmanifest.lua`

## Controls Guide

## Controls Guide

| Control | Function |
|---------|----------|
| Play/Pause Button | Toggle video/audio playback |
| ⏪ Button | Previous video in playlist |
| ⏩ Button | Next video in playlist |
## Preview

Open `preview.html` in your browser to see how the loading screen looks. The preview includes:
- Animated gradient background (fallback when video isn't loaded)
- All media controls functional (demo mode)
- Loading progress simulation
- Sample track information display

**Note:** Update the video path in preview.html from `html/videos/background.webm` to your actual video file.

## Layout

- **Player Controls**: Bottom-left (250px from left, 30px from bottom)
- **Loading Progress**: Bottom-right corner (20px from edges, 300px wide)
### Change Control Position
```css
.controls-container {
    left: 250px; /* Distance from left edge */
    bottom: 30px; /* Distance from bottom */
}
```

### Change Loading Progress Position
### Disable Specific Controls

Remove unwanted buttons from `html/index.html`:
```html
<!-- Remove skip buttons, volume control, track info, etc. -->
```

## Troubleshooting

**Video not loading:**
- Check file path is correct (`html/videos/` for main, `html/videos/` for preview)
- Ensure WebM format with audio track
- Check browser console for errors (F12)
- Verify video file exists and isn't corrupted

**Audio not playing:**
- Make sure `videos.muted: false` in config.js
- Check volume isn't at 0
- Ensure video has audio track

**Track info not updating:**
- Verify playlist uses object format with artist/song/album properties
- Check album artwork paths are correct
- Ensure images exist in videos folder

**Controls not visible:**
- Check z-index values (controls should be 10+)
- Verify `controls.show: true` in config.js
- Clear browser cache

### Change Control Position
```css
.controls-container {
    bottom: 80px; /* Change this value */
}
```

### Disable Specific Controls

Remove unwanted buttons from `html/index.html`:
```html
<!-- Remove skip buttons, volume control, etc. -->
```

## Troubleshooting

**Video not loading:**
- Check file path/URL is correct
- Ensure WebM format compatibility
- Check console for errors

**Audio not playing:**
- Some browsers block autoplay
- User interaction may be required
- Check volume isn't at 0

**Controls not working:**
- Clear browser cache
- Check JavaScript console for errors
- Ensure media files are loaded

## Performance Tips

1. **Optimize video file size** - Smaller = faster loading
2. **Use CDN** - Better delivery speeds
3. **Compress assets** - Reduce file sizes
4. **Test on slow connections** - Ensure acceptable load times

## License

Part of AS Framework - See main framework license

## Credits

Developed by AS Development Team

---

**Need help?** Check the AS Framework documentation or join our Discord!
