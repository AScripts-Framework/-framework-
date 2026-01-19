let accountData = null;
let currentAction = null;

// Update time
setInterval(() => {
    const now = new Date();
    document.getElementById('atmTime').textContent = now.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });
}, 1000);

// NUI Message Handler
window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'openATM') {
        accountData = data.data;
        document.getElementById('atmContainer').style.display = 'flex';
        updateDisplay();
    }
});

// Update Display
function updateDisplay() {
    if (!accountData) return;
    
    document.getElementById('accountName').textContent = accountData.name;
    document.getElementById('atmBalance').textContent = '$' + accountData.balance.toLocaleString();
}

// Menu Buttons
document.querySelectorAll('.menu-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        const action = this.getAttribute('data-action');
        
        if (action === 'exit') {
            closeATM();
        } else if (action === 'balance') {
            // Just show balance (already shown)
            return;
        } else {
            openAction(action);
        }
    });
});

// Open Action Screen
function openAction(action) {
    currentAction = action;
    document.getElementById('welcomeScreen').style.display = 'none';
    document.getElementById('menuOptions').style.display = 'none';
    document.getElementById('actionScreen').style.display = 'block';
    
    const title = action.charAt(0).toUpperCase() + action.slice(1);
    document.getElementById('actionTitle').textContent = title;
    
    // Clear input
    document.getElementById('customAmount').value = '';
}

// Back Button
document.getElementById('backBtn').addEventListener('click', function() {
    document.getElementById('welcomeScreen').style.display = 'block';
    document.getElementById('menuOptions').style.display = 'grid';
    document.getElementById('actionScreen').style.display = 'none';
    currentAction = null;
});

// Quick Amount Buttons
document.querySelectorAll('.amount-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        const amount = parseInt(this.getAttribute('data-amount'));
        processTransaction(amount);
    });
});

// Submit Button
document.getElementById('submitBtn').addEventListener('click', function() {
    const amount = parseInt(document.getElementById('customAmount').value);
    if (amount && amount > 0) {
        processTransaction(amount);
    }
});

// Process Transaction
function processTransaction(amount) {
    if (!currentAction) return;
    
    fetch(`https://${GetParentResourceName()}/${currentAction}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
            amount: amount,
            isATM: true 
        })
    }).then(resp => resp.json()).then(success => {
        if (success) {
            // Go back to main screen
            document.getElementById('backBtn').click();
        }
    });
}

// Keypad (disabled for ATM, mainly decorative)
document.querySelectorAll('.key-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        // Just visual feedback
        this.style.transform = 'scale(0.95)';
        setTimeout(() => {
            this.style.transform = 'scale(1)';
        }, 100);
    });
});

// Close ATM
function closeATM() {
    document.getElementById('atmContainer').style.display = 'none';
    accountData = null;
    currentAction = null;
    
    // Reset to main screen
    document.getElementById('welcomeScreen').style.display = 'block';
    document.getElementById('menuOptions').style.display = 'grid';
    document.getElementById('actionScreen').style.display = 'none';
    
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

// ESC Key
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeATM();
    }
});

// Helper
function GetParentResourceName() {
    return 'as-banking';
}
