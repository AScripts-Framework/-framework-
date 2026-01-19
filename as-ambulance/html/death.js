// Death screen management
let lastStandTime = 60;
let deathTime = 300;
let lastStandInterval = null;
let deathInterval = null;

window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.action) {
        case 'showLastStand':
            showLastStand(data.time);
            break;
        case 'updateLastStandTimer':
            updateLastStandTimer(data.time);
            break;
        case 'hideLastStand':
            hideLastStand();
            break;
        case 'showDeathScreen':
            showDeathScreen(data.time, data.canRespawn);
            break;
        case 'updateDeathTimer':
            updateDeathTimer(data.time, data.canRespawn);
            break;
        case 'hideDeathScreen':
            hideDeathScreen();
            break;
    }
});

function showLastStand(time) {
    lastStandTime = time;
    const screen = document.getElementById('lastStandScreen');
    screen.style.display = 'flex';
    updateLastStandTimer(time);
}

function updateLastStandTimer(time) {
    lastStandTime = time;
    document.getElementById('lastStandTimer').textContent = time;
    
    // Update progress circle
    const circumference = 283;
    const offset = circumference - (time / 60) * circumference;
    document.getElementById('lastStandProgress').style.strokeDashoffset = offset;
}

function hideLastStand() {
    const screen = document.getElementById('lastStandScreen');
    screen.style.display = 'none';
}

function showDeathScreen(time, canRespawn) {
    deathTime = time;
    const screen = document.getElementById('deathScreen');
    const btn = document.getElementById('respawnBtn');
    
    screen.style.display = 'flex';
    btn.disabled = !canRespawn;
    
    updateDeathTimer(time, canRespawn);
}

function updateDeathTimer(time, canRespawn) {
    deathTime = time;
    document.getElementById('deathTimer').textContent = time;
    document.getElementById('respawnTime').textContent = time;
    
    const btn = document.getElementById('respawnBtn');
    const info = document.getElementById('respawnInfo');
    
    if (canRespawn || time <= 0) {
        btn.disabled = false;
        btn.innerHTML = '<i class="fas fa-hospital"></i> RESPAWN AT HOSPITAL';
        info.innerHTML = '<i class="fas fa-check-circle"></i> You can now respawn at the hospital';
    } else {
        btn.disabled = true;
        info.innerHTML = '<i class="fas fa-clock"></i> You can respawn in <span id="respawnTime">' + time + '</span> seconds';
    }
    
    // Update progress circle
    const circumference = 283;
    const offset = circumference - (time / 300) * circumference;
    document.getElementById('deathProgress').style.strokeDashoffset = offset;
}

function hideDeathScreen() {
    const screen = document.getElementById('deathScreen');
    screen.style.display = 'none';
}

// Respawn button click
document.getElementById('respawnBtn').addEventListener('click', function() {
    if (!this.disabled) {
        fetch(`https://${GetParentResourceName()}/respawn`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        });
    }
});
