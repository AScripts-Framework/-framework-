let currentSettings = {
    position: 'bottom-left',
    scale: 1.0,
    offsetX: 20,
    offsetY: 0,
    iconStyle: 'modern',
    colorTheme: 'purple',
    vehiclePosition: 'bottom-center',
    vehicleScale: 1.0,
    vehicleOffsetX: 0,
    vehicleOffsetY: 0
};

const icons = {
    modern: {
        health: 'fa-heart',
        armor: 'fa-shield-halved',
        stamina: 'fa-person-running'
    },
    classic: {
        health: 'fa-heart-pulse',
        armor: 'fa-shield',
        stamina: 'fa-gauge-high'
    },
    minimal: {
        health: 'fa-heart',
        armor: 'fa-shield',
        stamina: 'fa-circle'
    }
};

const colorThemes = {
    purple: {
        primary: '#8B5CF6',
        secondary: '#A78BFA',
        background: 'rgba(88, 28, 135, 0.4)',
        text: '#E9D5FF'
    },
    blue: {
        primary: '#3B82F6',
        secondary: '#60A5FA',
        background: 'rgba(30, 64, 175, 0.4)',
        text: '#DBEAFE'
    },
    red: {
        primary: '#EF4444',
        secondary: '#F87171',
        background: 'rgba(127, 29, 29, 0.4)',
        text: '#FEE2E2'
    },
    green: {
        primary: '#10B981',
        secondary: '#34D399',
        background: 'rgba(6, 78, 59, 0.4)',
        text: '#D1FAE5'
    }
};

// Apply current settings
function applySettings() {
    const hudContainer = document.getElementById('hud-container');
    const vehicleHud = document.getElementById('vehicle-hud');
    const root = document.documentElement;
    
    // Apply HUD container settings
    hudContainer.className = '';
    hudContainer.classList.add(currentSettings.position);
    hudContainer.style.transform = `scale(${currentSettings.scale})`;
    
    const positions = currentSettings.position.split('-');
    if (positions.includes('bottom')) {
        hudContainer.style.bottom = `${currentSettings.offsetY}px`;
        hudContainer.style.top = 'auto';
    } else {
        hudContainer.style.top = `${currentSettings.offsetY}px`;
        hudContainer.style.bottom = 'auto';
    }
    
    if (positions.includes('left')) {
        hudContainer.style.left = `${currentSettings.offsetX}px`;
        hudContainer.style.right = 'auto';
    } else {
        hudContainer.style.right = `${currentSettings.offsetX}px`;
        hudContainer.style.left = 'auto';
    }
    
    // Apply vehicle HUD settings
    if (vehicleHud) {
        vehicleHud.style.transform = `translateX(-50%) scale(${currentSettings.vehicleScale})`;
        
        const vPositions = currentSettings.vehiclePosition.split('-');
        
        // Handle vertical position
        if (vPositions.includes('bottom')) {
            vehicleHud.style.bottom = `${currentSettings.vehicleOffsetY}px`;
            vehicleHud.style.top = 'auto';
        } else {
            vehicleHud.style.top = `${currentSettings.vehicleOffsetY}px`;
            vehicleHud.style.bottom = 'auto';
        }
        
        // Handle horizontal position
        if (vPositions.includes('left')) {
            vehicleHud.style.left = `${currentSettings.vehicleOffsetX}px`;
            vehicleHud.style.transform = `translateX(0) scale(${currentSettings.vehicleScale})`;
            vehicleHud.style.right = 'auto';
        } else if (vPositions.includes('right')) {
            vehicleHud.style.right = `${currentSettings.vehicleOffsetX}px`;
            vehicleHud.style.left = 'auto';
            vehicleHud.style.transform = `translateX(0) scale(${currentSettings.vehicleScale})`;
        } else { // center
            vehicleHud.style.left = `calc(50% + ${currentSettings.vehicleOffsetX}px)`;
            vehicleHud.style.right = 'auto';
            vehicleHud.style.transform = `translateX(-50%) scale(${currentSettings.vehicleScale})`;
        }
    }
    
    // Apply color theme
    const theme = colorThemes[currentSettings.colorTheme];
    root.style.setProperty('--primary-color', theme.primary);
    root.style.setProperty('--secondary-color', theme.secondary);
    root.style.setProperty('--background-color', theme.background);
    root.style.setProperty('--text-color', theme.text);
    
    // Apply icon style
    updateIcons();
}

// Update icons based on style
function updateIcons() {
    const style = currentSettings.iconStyle;
    const healthIcon = document.querySelector('#health-stat .stat-icon i');
    const armorIcon = document.querySelector('#armor-stat .stat-icon i');
    const staminaIcon = document.querySelector('#stamina-stat .stat-icon i');
    
    healthIcon.className = `fa-solid ${icons[style].health}`;
    armorIcon.className = `fa-solid ${icons[style].armor}`;
    staminaIcon.className = `fa-solid ${icons[style].stamina}`;
}

// Update HUD data
function updateHUD(data) {
    // Health
    const healthValue = document.getElementById('health-value');
    const healthBar = document.getElementById('health-bar');
    healthValue.textContent = Math.round(data.health) + '%';
    healthBar.style.width = data.health + '%';
    
    // Armor
    const armorStat = document.getElementById('armor-stat');
    const armorValue = document.getElementById('armor-value');
    const armorBar = document.getElementById('armor-bar');
    
    if (data.armor > 0) {
        armorStat.style.display = 'flex';
        armorValue.textContent = Math.round(data.armor) + '%';
        armorBar.style.width = data.armor + '%';
    } else {
        armorStat.style.display = 'none';
    }
    
    // Stamina
    const staminaStat = document.getElementById('stamina-stat');
    const staminaValue = document.getElementById('stamina-value');
    const staminaBar = document.getElementById('stamina-bar');
    
    if (data.stamina < 100) {
        staminaStat.style.display = 'flex';
        staminaValue.textContent = Math.round(data.stamina) + '%';
        staminaBar.style.width = data.stamina + '%';
    } else {
        staminaStat.style.display = 'none';
    }
}

// Update vehicle HUD data
function updateVehicleHUD(data) {
    const vehicleHud = document.getElementById('vehicle-hud');
    
    if (data.inVehicle) {
        vehicleHud.style.display = 'flex';
        
        // Speed
        const speedValue = document.getElementById('speed-value');
        const speedArc = document.getElementById('speed-arc');
        speedValue.textContent = Math.floor(data.speed);
        
        // Calculate arc offset (220 is the arc length)
        const maxSpeed = 200;
        const speedPercent = Math.min(data.speed / maxSpeed, 1);
        const speedArcLength = 220;
        const speedOffset = speedArcLength - (speedArcLength * speedPercent);
        speedArc.style.strokeDashoffset = speedOffset;
        
        // RPM
        const rpmValue = document.getElementById('rpm-value');
        const rpmArc = document.getElementById('rpm-arc');
        const rpm = data.rpm || 0;
        rpmValue.textContent = Math.floor(rpm / 1000) + 'k';
        
        // Calculate RPM arc offset (172.7 is the arc length)
        const maxRPM = 8000;
        const rpmPercent = Math.min(rpm / maxRPM, 1);
        const rpmArcLength = 172.7;
        const rpmOffset = rpmArcLength - (rpmArcLength * rpmPercent);
        rpmArc.style.strokeDashoffset = rpmOffset;
        
        // Gear
        const gearValue = document.getElementById('gear-value');
        gearValue.textContent = data.gear || 'N';
        
        // Fuel/Battery
        const fuelValue = document.getElementById('fuel-value');
        const fuelArc = document.getElementById('fuel-arc');
        const fuelIcon = document.getElementById('fuel-icon');
        
        fuelValue.textContent = Math.round(data.fuel);
        
        // Calculate fuel arc offset (131.9 is the arc length)
        const fuelArcLength = 131.9;
        const fuelOffset = fuelArcLength - (fuelArcLength * (data.fuel / 100));
        fuelArc.style.strokeDashoffset = fuelOffset;
        
        // Change icon based on vehicle type
        if (data.isElectric) {
            fuelIcon.className = 'fa-solid fa-bolt';
        } else {
            fuelIcon.className = 'fa-solid fa-gas-pump';
        }
    } else {
        vehicleHud.style.display = 'none';
    }
}

// Settings menu functionality
document.addEventListener('DOMContentLoaded', () => {
    // Position buttons
    document.querySelectorAll('[data-setting="position"]').forEach(btn => {
        btn.addEventListener('click', () => {
            currentSettings.position = btn.dataset.value;
            updateActiveButtons('position', btn.dataset.value);
            applySettings();
            saveSettings();
        });
    });
    
    // Icon style buttons
    document.querySelectorAll('[data-setting="iconStyle"]').forEach(btn => {
        btn.addEventListener('click', () => {
            currentSettings.iconStyle = btn.dataset.value;
            updateActiveButtons('iconStyle', btn.dataset.value);
            applySettings();
            saveSettings();
        });
    });
    
    // Color theme buttons
    document.querySelectorAll('[data-setting="colorTheme"]').forEach(btn => {
        btn.addEventListener('click', () => {
            currentSettings.colorTheme = btn.dataset.value;
            updateActiveButtons('colorTheme', btn.dataset.value);
            applySettings();
            saveSettings();
        });
    });
    
    // Scale slider
    const scaleSlider = document.getElementById('scale-slider');
    const scaleDisplay = document.getElementById('scale-display');
    scaleSlider.addEventListener('input', (e) => {
        currentSettings.scale = e.target.value / 100;
        scaleDisplay.textContent = `${e.target.value}%`;
        applySettings();
    });
    scaleSlider.addEventListener('change', saveSettings);
    
    // Offset X slider
    const offsetXSlider = document.getElementById('offsetx-slider');
    const offsetXDisplay = document.getElementById('offsetx-display');
    offsetXSlider.addEventListener('input', (e) => {
        currentSettings.offsetX = parseInt(e.target.value);
        offsetXDisplay.textContent = `${e.target.value}px`;
        applySettings();
    });
    offsetXSlider.addEventListener('change', saveSettings);
    
    // Offset Y slider
    const offsetYSlider = document.getElementById('offsety-slider');
    const offsetYDisplay = document.getElementById('offsety-display');
    offsetYSlider.addEventListener('input', (e) => {
        currentSettings.offsetY = parseInt(e.target.value);
        offsetYDisplay.textContent = `${e.target.value}px`;
        applySettings();
    });
    offsetYSlider.addEventListener('change', saveSettings);
    
    // Vehicle Position buttons
    document.querySelectorAll('[data-setting="vehiclePosition"]').forEach(btn => {
        btn.addEventListener('click', () => {
            currentSettings.vehiclePosition = btn.dataset.value;
            updateActiveButtons('vehiclePosition', btn.dataset.value);
            applySettings();
            saveSettings();
        });
    });
    
    // Vehicle Scale slider
    const vehicleScaleSlider = document.getElementById('vehicle-scale-slider');
    const vehicleScaleDisplay = document.getElementById('vehicle-scale-display');
    if (vehicleScaleSlider) {
        vehicleScaleSlider.addEventListener('input', (e) => {
            currentSettings.vehicleScale = e.target.value / 100;
            vehicleScaleDisplay.textContent = `${e.target.value}%`;
            applySettings();
        });
        vehicleScaleSlider.addEventListener('change', saveSettings);
    }
    
    // Vehicle Offset X slider
    const vehicleOffsetXSlider = document.getElementById('vehicle-offsetx-slider');
    const vehicleOffsetXDisplay = document.getElementById('vehicle-offsetx-display');
    if (vehicleOffsetXSlider) {
        vehicleOffsetXSlider.addEventListener('input', (e) => {
            currentSettings.vehicleOffsetX = parseInt(e.target.value);
            vehicleOffsetXDisplay.textContent = `${e.target.value}px`;
            applySettings();
        });
        vehicleOffsetXSlider.addEventListener('change', saveSettings);
    }
    
    // Vehicle Offset Y slider
    const vehicleOffsetYSlider = document.getElementById('vehicle-offsety-slider');
    const vehicleOffsetYDisplay = document.getElementById('vehicle-offsety-display');
    if (vehicleOffsetYSlider) {
        vehicleOffsetYSlider.addEventListener('input', (e) => {
            currentSettings.vehicleOffsetY = parseInt(e.target.value);
            vehicleOffsetYDisplay.textContent = `${e.target.value}px`;
            applySettings();
        });
        vehicleOffsetYSlider.addEventListener('change', saveSettings);
    }
    
    // Close button
    document.getElementById('close-settings').addEventListener('click', () => {
        document.getElementById('settings-menu').style.display = 'none';
        fetch(`https://${GetParentResourceName()}/closeSettings`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });
    });
    
    // Reset button
    document.getElementById('reset-settings').addEventListener('click', () => {
        resetSettings();
    });
});

function updateActiveButtons(setting, value) {
    document.querySelectorAll(`[data-setting="${setting}"]`).forEach(btn => {
        btn.classList.remove('active');
        if (btn.dataset.value === value) {
            btn.classList.add('active');
        }
    });
}

function saveSettings() {
    fetch(`https://${GetParentResourceName()}/saveSettings`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(currentSettings)
    });
}

function resetSettings() {
    currentSettings = {
        position: 'bottom-left',
        scale: 1.0,
        offsetX: 20,
        offsetY: 0,
        iconStyle: 'modern',
        colorTheme: 'purple',
        vehiclePosition: 'bottom-center',
        vehicleScale: 1.0,
        vehicleOffsetX: 0,
        vehicleOffsetY: 0
    };
    
    // Update UI
    document.getElementById('scale-slider').value = 100;
    document.getElementById('scale-display').textContent = '100%';
    document.getElementById('offsetx-slider').value = 20;
    document.getElementById('offsetx-display').textContent = '20px';
    document.getElementById('offsety-slider').value = 0;
    document.getElementById('offsety-display').textContent = '0px';
    
    const vehicleScaleSlider = document.getElementById('vehicle-scale-slider');
    const vehicleOffsetXSlider = document.getElementById('vehicle-offsetx-slider');
    const vehicleOffsetYSlider = document.getElementById('vehicle-offsety-slider');
    
    if (vehicleScaleSlider) {
        vehicleScaleSlider.value = 100;
        document.getElementById('vehicle-scale-display').textContent = '100%';
    }
    if (vehicleOffsetXSlider) {
        vehicleOffsetXSlider.value = 0;
        document.getElementById('vehicle-offsetx-display').textContent = '0px';
    }
    if (vehicleOffsetYSlider) {
        vehicleOffsetYSlider.value = 0;
        document.getElementById('vehicle-offsety-display').textContent = '0px';
    }
    
    updateActiveButtons('position', 'bottom-left');
    updateActiveButtons('iconStyle', 'modern');
    updateActiveButtons('colorTheme', 'purple');
    updateActiveButtons('vehiclePosition', 'bottom-center');
    
    applySettings();
    saveSettings();
}

// Message handler
window.addEventListener('message', (event) => {
    const data = event.data;
    
    switch (data.action) {
        case 'show':
            document.getElementById('hud-container').style.display = 'flex';
            break;
            
        case 'hide':
            document.getElementById('hud-container').style.display = 'none';
            break;
            
        case 'update':
            updateHUD(data);
            break;
            
        case 'updateVehicle':
            updateVehicleHUD(data);
            break;
            
        case 'showSettings':
            document.getElementById('settings-menu').style.display = 'block';
            loadSettings(data.settings);
            break;
            
        case 'hideSettings':
            document.getElementById('settings-menu').style.display = 'none';
            break;
            
        case 'loadSettings':
            loadSettings(data.settings);
            break;
    }
});

function loadSettings(settings) {
    if (!settings) return;
    
    currentSettings = settings;
    
    // Update sliders
    document.getElementById('scale-slider').value = settings.scale * 100;
    document.getElementById('scale-display').textContent = `${Math.round(settings.scale * 100)}%`;
    document.getElementById('offsetx-slider').value = settings.offsetX;
    document.getElementById('offsetx-display').textContent = `${settings.offsetX}px`;
    document.getElementById('offsety-slider').value = settings.offsetY;
    document.getElementById('offsety-display').textContent = `${settings.offsetY}px`;
    
    // Update vehicle HUD settings
    const vehicleScaleSlider = document.getElementById('vehicle-scale-slider');
    const vehicleOffsetXSlider = document.getElementById('vehicle-offsetx-slider');
    const vehicleOffsetYSlider = document.getElementById('vehicle-offsety-slider');
    
    if (vehicleScaleSlider && settings.vehicleScale !== undefined) {
        vehicleScaleSlider.value = settings.vehicleScale * 100;
        document.getElementById('vehicle-scale-display').textContent = `${Math.round(settings.vehicleScale * 100)}%`;
    }
    if (vehicleOffsetXSlider && settings.vehicleOffsetX !== undefined) {
        vehicleOffsetXSlider.value = settings.vehicleOffsetX;
        document.getElementById('vehicle-offsetx-display').textContent = `${settings.vehicleOffsetX}px`;
    }
    if (vehicleOffsetYSlider && settings.vehicleOffsetY !== undefined) {
        vehicleOffsetYSlider.value = settings.vehicleOffsetY;
        document.getElementById('vehicle-offsety-display').textContent = `${settings.vehicleOffsetY}px`;
    }
    
    // Update active buttons
    updateActiveButtons('position', settings.position);
    updateActiveButtons('iconStyle', settings.iconStyle);
    updateActiveButtons('colorTheme', settings.colorTheme);
    if (settings.vehiclePosition) {
        updateActiveButtons('vehiclePosition', settings.vehiclePosition);
    }
    
    applySettings();
}

// ESC key to close settings
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        const settingsMenu = document.getElementById('settings-menu');
        if (settingsMenu.style.display === 'block') {
            settingsMenu.style.display = 'none';
            fetch(`https://${GetParentResourceName()}/closeSettings`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({})
            });
        }
    }
});
