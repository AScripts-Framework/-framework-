// ====================================
// AS LOADING SCREEN - CONFIGURATION
// ====================================

const Config = {
    // ====================================
    // BRANDING
    // ====================================
    branding: {
        serverName: 'AS FRAMEWORK',
        tagline: 'Advanced Roleplay Experience',
        logoPath: 'logo.png', // Set to null to hide logo
        showLogo: false, // Disabled - no logo/branding shown
    },

    // ====================================
    // VIDEO PLAYLIST
    // ====================================
    videos: {
        // List of background videos (will play in sequence)
        playlist: [
            {
                url: 'videos/background.webm',
                artist: 'Artist Name',
                song: 'Song Title',
                album: 'videos/album1.jpg' // Album cover image
            },
            {
                url: 'videos/background2.webm',
                artist: 'Another Artist',
                song: 'Another Song',
                album: 'videos/album2.jpg'
            },
            {
                url: 'videos/background3.webm',
                artist: 'Third Artist',
                song: 'Third Song',
                album: 'videos/album3.jpg'
            },
            {
                url: 'videos/background4.webm',
                artist: 'Fourth Artist',
                song: 'Fourth Song',
                album: 'videos/album4.jpg'
            },
        ],
        
        // Video settings
        autoPlay: true,
        muted: false, // Use video audio instead of separate music
        loop: true, // Loop entire playlist
        
        // Transition settings
        transitionDuration: 500, // ms - fade between videos
    },

    // ====================================
    // AUDIO
    // ====================================
    audio: {
        enabled: false, // Disabled - using video audio instead
        musicPath: 'music.webm',
        defaultVolume: 30, // 0-100
        loop: true,
    },

    // ====================================
    // MEDIA CONTROLS
    // ====================================
    controls: {
        show: true,
        
        // Individual control visibility
        playPause: true,
        skipBack: true,
        skipForward: true,
        timeSlider: true,
        volumeControl: true,
        muteButton: true,
        
        // Skip amount in seconds
        skipAmount: 10,
        
        // Control colors
        primaryColor: '#8B5CF6', // Purple
        secondaryColor: '#10B981', // Green
        backgroundColor: 'rgba(0, 0, 0, 0.7)',
    },

    // ====================================
    // LOADING PROGRESS
    // ====================================
    progress: {
        show: true,
        
        // Progress messages (will cycle based on progress %)
        messages: [
            'Connecting to server...',
            'Loading game assets...',
            'Preparing your experience...',
            'Syncing with server...',
            'Loading player data...',
            'Almost ready...',
            'Welcome to AS!'
        ],
        
        // Progress bar colors
        barColor: 'linear-gradient(90deg, #8B5CF6, #10B981)',
        backgroundColor: 'rgba(255, 255, 255, 0.1)',
        
        // Show shimmer effect on progress bar
        shimmerEffect: true,
    },

    // ====================================
    // LOADING MESSAGES
    // ====================================
    bottomMessage: {
        show: true,
        text: '🌐 Welcome to AS Framework | Built with ❤️ by AS Development Team',
    },

    // ====================================
    // COLORS & STYLING
    // ====================================
    styling: {
        // Background overlay gradient
        overlayGradient: 'linear-gradient(135deg, rgba(139, 92, 246, 0.3) 0%, rgba(0, 0, 0, 0.6) 50%, rgba(16, 185, 129, 0.3) 100%)',
        
        // Server name gradient
        serverNameGradient: 'linear-gradient(135deg, #8B5CF6, #10B981)',
        
        // Text colors
        primaryTextColor: '#FFFFFF',
        secondaryTextColor: 'rgba(255, 255, 255, 0.8)',
        
        // Logo glow color
        logoGlowColor: 'rgba(139, 92, 246, 0.5)',
    },

    // ====================================
    // ANIMATIONS
    // ====================================
    animations: {
        // Enable/disable animations
        enabled: true,
        
        // Logo pulse animation
        logoPulse: true,
        logoPulseSpeed: 2, // seconds
        
        // Fade in animations
        fadeInDuration: 1, // seconds
        
        // Shimmer animation on progress bar
        shimmerSpeed: 2, // seconds
    },

    // ====================================
    // LAYOUT
    // ====================================
    layout: {
        // Logo position (% from top)
        logoTopPosition: 15,
        
        // Progress bar position - bottom right corner
        progressBottomPosition: 20, // px from bottom
        progressRightPosition: 20, // px from right
        progressWidth: 300, // px
        
        // Controls position (px from bottom) - center
        controlsBottomPosition: 30,
        
        // Bottom message position (px from bottom)
        messageBottomPosition: 10,
    },

    // ====================================
    // LOADING BEHAVIOR
    // ====================================
    behavior: {
        // Auto-shutdown after max time (milliseconds)
        maxLoadTime: 300000, // 5 minutes
        
        // Delay before shutdown after player loaded (milliseconds)
        shutdownDelay: 1000,
        
        // Simulate progress (if FiveM doesn't send loadProgress events)
        simulateProgress: true,
        simulateSpeed: 2, // Lower = slower
        
        // Enable cursor during loading
        enableCursor: true,
    },

    // ====================================
    // ADVANCED
    // ====================================
    advanced: {
        // Enable debug logging
        debug: false,
        
        // Video preload strategy ('auto', 'metadata', 'none')
        videoPreload: 'auto',
        
        // Show video/audio errors in console
        showMediaErrors: true,
    }
};

// Make config available globally
window.LoadingConfig = Config;
