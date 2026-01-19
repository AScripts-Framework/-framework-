let mdtOpen = false;
let radarOpen = false;

// NUI Message Handler
window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.action) {
        case 'openMDT':
            openMDT();
            break;
        case 'closeMDT':
            closeMDT();
            break;
        case 'toggleRadar':
            toggleRadar(data.show);
            break;
        case 'updateRadar':
            updateRadar(data.front, data.rear, data.speedLimit);
            break;
        case 'loadWarrants':
            loadWarrants(data.warrants);
            break;
        case 'newDispatch':
            addDispatch(data.alert);
            break;
    }
});

// ESC Key Handler
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape' && mdtOpen) {
        closeMDT();
    }
});

// MDT Functions
function openMDT() {
    document.getElementById('mdt').style.display = 'flex';
    mdtOpen = true;
}

function closeMDT() {
    document.getElementById('mdt').style.display = 'none';
    mdtOpen = false;
    
    fetch(`https://${GetParentResourceName()}/closeMDT`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

// Tab Navigation
document.querySelectorAll('.nav-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        // Remove active class from all
        document.querySelectorAll('.nav-btn').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
        
        // Add active to clicked
        this.classList.add('active');
        const tabId = this.getAttribute('data-tab') + '-tab';
        document.getElementById(tabId).classList.add('active');
        
        // Load data for tab
        if (tabId === 'warrants-tab') {
            loadWarrantsData();
        }
    });
});

// Close MDT
document.getElementById('closeMDT').addEventListener('click', closeMDT);

// Radar Functions
function toggleRadar(show) {
    document.getElementById('radar').style.display = show ? 'block' : 'none';
    radarOpen = show;
}

function updateRadar(front, rear, speedLimit) {
    const frontEl = document.getElementById('frontSpeed');
    const rearEl = document.getElementById('rearSpeed');
    
    frontEl.textContent = front;
    rearEl.textContent = rear;
    
    // Add speeding class if over limit
    if (front > speedLimit) {
        frontEl.classList.add('speeding');
    } else {
        frontEl.classList.remove('speeding');
    }
    
    if (rear > speedLimit) {
        rearEl.classList.add('speeding');
    } else {
        rearEl.classList.remove('speeding');
    }
    
    document.getElementById('speedLimit').textContent = speedLimit;
}

// Warrant Functions
function loadWarrantsData() {
    fetch(`https://${GetParentResourceName()}/getWarrants`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function loadWarrants(warrants) {
    const list = document.getElementById('warrants-list');
    list.innerHTML = '';
    
    if (warrants.length === 0) {
        list.innerHTML = '<div class="empty-state">No active warrants</div>';
        return;
    }
    
    warrants.forEach(warrant => {
        const item = document.createElement('div');
        item.className = 'warrant-item';
        item.innerHTML = `
            <h3>Warrant #${warrant.id}</h3>
            <p><strong>Suspect:</strong> ${warrant.identifier}</p>
            <p><strong>Reason:</strong> ${warrant.reason}</p>
            <p><strong>Issued By:</strong> ${warrant.issued_by}</p>
            <p><strong>Expires:</strong> ${new Date(warrant.expires_at).toLocaleString()}</p>
        `;
        list.appendChild(item);
    });
}

// Create Warrant Modal
document.getElementById('createWarrant').addEventListener('click', function() {
    document.getElementById('warrantModal').style.display = 'flex';
});

document.getElementById('cancelWarrant').addEventListener('click', function() {
    document.getElementById('warrantModal').style.display = 'none';
});

document.getElementById('warrantForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const data = {
        identifier: document.getElementById('warrantIdentifier').value,
        reason: document.getElementById('warrantReason').value,
        expires: parseInt(document.getElementById('warrantExpires').value)
    };
    
    fetch(`https://${GetParentResourceName()}/createWarrant`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    });
    
    document.getElementById('warrantModal').style.display = 'none';
    this.reset();
});

// Dispatch Functions
function addDispatch(alert) {
    const list = document.getElementById('dispatch-list');
    
    // Remove empty state
    const emptyState = list.querySelector('.empty-state');
    if (emptyState) {
        emptyState.remove();
    }
    
    const item = document.createElement('div');
    item.className = 'dispatch-item';
    item.innerHTML = `
        <h3>[${alert.code}] ${alert.label}</h3>
        <p><strong>Message:</strong> ${alert.message}</p>
        <p><strong>Time:</strong> ${alert.time}</p>
        <p><strong>Location:</strong> ${alert.coords.x.toFixed(2)}, ${alert.coords.y.toFixed(2)}</p>
    `;
    
    // Add to top
    list.insertBefore(item, list.firstChild);
    
    // Remove after blip time
    setTimeout(() => {
        item.remove();
        if (list.children.length === 0) {
            list.innerHTML = '<div class="empty-state">No active calls</div>';
        }
    }, alert.blipTime * 1000);
}

// Helper function to get resource name
function GetParentResourceName() {
    return 'as-police';
}
