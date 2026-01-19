// Load configuration
const config = window.LoadingConfig || {};

// Media Elements
const bgVideo = document.getElementById('bgVideo');

// Controls
const playPauseBtn = document.getElementById('playPauseBtn');
const playIcon = document.getElementById('playIcon');
const pauseIcon = document.getElementById('pauseIcon');
const skipBackBtn = document.getElementById('skipBackBtn');
const skipForwardBtn = document.getElementById('skipForwardBtn');
const timeSlider = document.getElementById('timeSlider');
const currentTimeDisplay = document.getElementById('currentTime');
const durationDisplay = document.getElementById('duration');
const muteBtn = document.getElementById('muteBtn');
const volumeIcon = document.getElementById('volumeIcon');
const muteIcon = document.getElementById('muteIcon');
const volumeSlider = document.getElementById('volumeSlider');

// Track Info
const albumArt = document.getElementById('albumArt');
const trackSong = document.getElementById('trackSong');
const trackArtist = document.getElementById('trackArtist');

// Progress
const progressFill = document.getElementById('progressFill');
const progressText = document.getElementById('progressText');

// State
let isPlaying = true;
let isMuted = config.videos?.muted || false;

// Multiple Videos Configuration
const videoPlaylist = config.videos?.playlist || [
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
];

let currentVideoIndex = 0;
let totalDuration = 0;
let videoStartTimes = [];

// Video Configuration
const defaultVolume = config.audio?.defaultVolume || 30;
const skipAmount = config.controls?.skipAmount || 10;

// Format time (seconds to MM:SS)
function formatTime(seconds) {
    if (isNaN(seconds)) return '0:00';
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins}:${secs.toString().padStart(2, '0')}`;
}

// Debug log helper
function debugLog(...args) {
    if (config.advanced?.debug) {
        console.log('[AS-Loading]', ...args);
    }
}

// Calculate total duration and start times for each video
function calculateTotalDuration() {
    videoStartTimes = [0];
    return 0;
}

// Load video by index
function loadVideo(index) {
    if (index < 0 || index >= videoPlaylist.length) return;
    
    const video = videoPlaylist[index];
    const videoUrl = typeof video === 'string' ? video : video.url;
    
    debugLog('Loading video:', videoUrl);
    
    const source = document.createElement('source');
    source.src = videoUrl;
    source.type = 'video/webm';
    
    bgVideo.innerHTML = '';
    bgVideo.appendChild(source);
    bgVideo.load();
    
    // Update track info if video has metadata
    if (typeof video === 'object') {
        if (albumArt && video.album) {
            albumArt.src = video.album;
            albumArt.style.display = 'block';
        }
        if (trackSong && video.song) {
            trackSong.textContent = video.song;
        }
        if (trackArtist && video.artist) {
            trackArtist.textContent = video.artist;
        }
    }
    
    if (config.advanced?.showMediaErrors) {
        bgVideo.addEventListener('error', (e) => {
            console.error('Video load error:', videoUrl, e);
        });
    }
}

// Play next video in playlist
function playNextVideo() {
    if (config.videos?.loop) {
        currentVideoIndex = (currentVideoIndex + 1) % videoPlaylist.length;
    } else {
        currentVideoIndex = Math.min(currentVideoIndex + 1, videoPlaylist.length - 1);
    }
    
    loadVideo(currentVideoIndex);
    
    if (isPlaying && config.videos?.autoPlay) {
        bgVideo.play().catch(err => {
            debugLog('Video play error:', err);
            if (config.advanced?.showMediaErrors) console.error(err);
        });
    }
}

// Play previous video in playlist
function playPreviousVideo() {
    if (config.videos?.loop) {
        currentVideoIndex = (currentVideoIndex - 1 + videoPlaylist.length) % videoPlaylist.length;
    } else {
        currentVideoIndex = Math.max(currentVideoIndex - 1, 0);
    }
    
    loadVideo(currentVideoIndex);
    
    if (isPlaying && config.videos?.autoPlay) {
        bgVideo.play().catch(err => {
            debugLog('Video play error:', err);
            if (config.advanced?.showMediaErrors) console.error(err);
        });
    }
}

// When current video ends, play next one
bgVideo.addEventListener('ended', () => {
    playNextVideo();
});

// Initialize
function init() {
    debugLog('Initializing loading screen with config:', config);
    
    // Set initial volume for video
    bgVideo.volume = defaultVolume / 100;
    volumeSlider.value = defaultVolume;
    bgVideo.muted = isMuted;
    
    // Update mute button state
    if (isMuted) {
        volumeIcon.style.display = 'none';
        muteIcon.style.display = 'block';
    }
    
    // Update branding if configured
    if (config.branding && config.branding.showLogo) {
        const logoContainer = document.querySelector('.logo-container');
        if (logoContainer) logoContainer.style.display = 'block';
        
        const serverNameEl = document.querySelector('.server-name');
        const taglineEl = document.querySelector('.server-tagline');
        const logoEl = document.querySelector('.logo');
        
        if (serverNameEl && config.branding.serverName) {
            serverNameEl.textContent = config.branding.serverName;
        }
        if (taglineEl && config.branding.tagline) {
            taglineEl.textContent = config.branding.tagline;
        }
        if (logoEl && config.branding.logoPath) {
            logoEl.src = config.branding.logoPath;
        }
    }
    
    // Update bottom message
    if (config.bottomMessage) {
        const messageEl = document.getElementById('loadingMessages');
        if (messageEl && config.bottomMessage.text) {
            messageEl.innerHTML = `<p>${config.bottomMessage.text}</p>`;
        }
        if (messageEl && !config.bottomMessage.show) {
            messageEl.style.display = 'none';
        }
    }
    
    // Hide controls if disabled
    if (config.controls && !config.controls.show) {
        const controlsEl = document.querySelector('.controls-container');
        if (controlsEl) controlsEl.style.display = 'none';
    }
    
    // Hide progress if disabled
    if (config.progress && !config.progress.show) {
        const progressEl = document.querySelector('.loading-container');
        if (progressEl) progressEl.style.display = 'none';
    }
    
    // Load first video
    loadVideo(0);
    
    // Auto-play video when ready
    bgVideo.addEventListener('loadedmetadata', () => {
        durationDisplay.textContent = formatTime(bgVideo.duration);
        timeSlider.max = bgVideo.duration;
        debugLog('Video loaded, duration:', bgVideo.duration);
    });
}

// Play/Pause Toggle
playPauseBtn.addEventListener('click', () => {
    if (isPlaying) {
        bgVideo.pause();
        playIcon.style.display = 'block';
        pauseIcon.style.display = 'none';
        isPlaying = false;
    } else {
        bgVideo.play();
        playIcon.style.display = 'none';
        pauseIcon.style.display = 'block';
        isPlaying = true;
    }
});

// Skip Back (Previous Video)
skipBackBtn.addEventListener('click', () => {
    playPreviousVideo();
});

// Skip Forward (Next Video)
skipForwardBtn.addEventListener('click', () => {
    playNextVideo();
});

// Time Slider
timeSlider.addEventListener('input', (e) => {
    const time = e.target.value;
    bgVideo.currentTime = time;
    currentTimeDisplay.textContent = formatTime(time);
});

// Update time slider as video plays
bgVideo.addEventListener('timeupdate', () => {
    if (!timeSlider.matches(':active')) {
        timeSlider.value = bgVideo.currentTime;
        currentTimeDisplay.textContent = formatTime(bgVideo.currentTime);
    }
});

// Mute Toggle
muteBtn.addEventListener('click', () => {
    if (isMuted) {
        bgVideo.muted = false;
        volumeIcon.style.display = 'block';
        muteIcon.style.display = 'none';
        isMuted = false;
    } else {
        bgVideo.muted = true;
        volumeIcon.style.display = 'none';
        muteIcon.style.display = 'block';
        isMuted = true;
    }
});

// Volume Slider
volumeSlider.addEventListener('input', (e) => {
    const volume = e.target.value / 100;
    bgVideo.volume = volume;
    
    if (volume === 0) {
        volumeIcon.style.display = 'none';
        muteIcon.style.display = 'block';
    } else {
        volumeIcon.style.display = 'block';
        muteIcon.style.display = 'none';
    }
});

// Loading Progress Simulation
let progress = 0;
const messages = config.progress?.messages || [
    'Connecting to server...',
    'Loading game assets...',
    'Preparing your experience...',
    'Syncing with server...',
    'Loading player data...',
    'Almost ready...',
    'Welcome to AS Framework!'
];

function updateProgress() {
    if (progress < 100) {
        progress += Math.random() * (config.behavior?.simulateSpeed || 2);
        progress = Math.min(progress, 100);
        progressFill.style.width = progress + '%';
        
        const messageIndex = Math.min(Math.floor(progress / (100 / messages.length)), messages.length - 1);
        progressText.textContent = messages[messageIndex];
        
        setTimeout(updateProgress, 100 + Math.random() * 200);
    } else {
        progressText.textContent = 'Loaded!';
        if (window.invokeNative) {
            window.invokeNative('shutdown');
        }
    }
}

// Listen for FiveM loading events
window.addEventListener('message', (event) => {
    if (event.data.eventName === 'loadProgress') {
        const loadProgress = event.data;
        progress = (loadProgress.loadFraction || 0) * 100;
        progressFill.style.width = progress + '%';
        
        if (loadProgress.label) {
            progressText.textContent = loadProgress.label;
        }
    }
    
    if (event.data.action === 'playerLoaded' || event.data.eventName === 'playerLoaded') {
        debugLog('Player loaded event received');
        progressFill.style.width = '100%';
        progressText.textContent = 'Welcome! Loading complete.';
        
        setTimeout(() => {
            debugLog('Shutting down loading screen');
            if (window.invokeNative) {
                window.invokeNative('shutdown');
            }
        }, config.behavior?.shutdownDelay || 1000);
    }
});

// Start progress simulation if enabled
if (config.behavior?.simulateProgress) {
    setTimeout(updateProgress, 500);
}

// Initialize on load
init();
