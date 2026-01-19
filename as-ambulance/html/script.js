let menuOpen = false;

window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.action) {
        case 'openMenu':
            openMenu(data);
            break;
        case 'closeMenu':
            closeMenu();
            break;
        case 'updateStatus':
            updateStatus(data);
            break;
    }
});

function openMenu(data) {
    menuOpen = true;
    const menu = document.getElementById('ambulanceMenu');
    menu.style.display = 'flex';
    
    // Update status if provided
    if (data.dutyStatus !== undefined) {
        document.getElementById('dutyStatus').textContent = data.dutyStatus ? 'Yes' : 'No';
    }
    if (data.emsCount !== undefined) {
        document.getElementById('emsCount').textContent = data.emsCount;
    }
    if (data.callCount !== undefined) {
        document.getElementById('callCount').textContent = data.callCount;
    }
}

function closeMenu() {
    menuOpen = false;
    const menu = document.getElementById('ambulanceMenu');
    menu.style.display = 'none';
    
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
}

function updateStatus(data) {
    if (data.dutyStatus !== undefined) {
        document.getElementById('dutyStatus').textContent = data.dutyStatus ? 'Yes' : 'No';
    }
    if (data.emsCount !== undefined) {
        document.getElementById('emsCount').textContent = data.emsCount;
    }
    if (data.callCount !== undefined) {
        document.getElementById('callCount').textContent = data.callCount;
    }
}

function action(type) {
    fetch(`https://${GetParentResourceName()}/menuAction`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            action: type
        })
    });
}

// ESC key to close
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape' && menuOpen) {
        closeMenu();
    }
});
