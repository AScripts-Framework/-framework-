let adminLevel = 0;
let players = [];
let currentPlayer = null;

// Teleport locations mapping
const teleportLocations = {
    'LSPD': { x: 425.1, y: -979.5, z: 30.7 },
    'Hospital': { x: 298.7, y: -584.5, z: 43.3 },
    'Garage': { x: -340.7, y: -874.1, z: 31.3 },
    'Airport': { x: -1037.8, y: -2738.3, z: 13.8 },
    'Beach': { x: -1388.8, y: -1465.0, z: 1.5 },
    'LifeInvader': { x: -1082.5, y: -247.5, z: 37.8 },
    'MazeBank': { x: -75.0, y: -818.6, z: 326.2 },
    'Casino': { x: 925.3, y: 46.5, z: 81.1 }
};

// NUI Messages
window.addEventListener('message', (event) => {
    const data = event.data;
    
    switch(data.action) {
        case 'openMenu':
            adminLevel = data.adminLevel;
            $('#menu').removeClass('hidden');
            break;
        case 'closeMenu':
            $('#menu').addClass('hidden');
            break;
        case 'updatePlayers':
            players = data.players;
            updatePlayerList();
            break;
    }
});

// Close menu
function closeMenu() {
    $.post('https://as-admin/close', JSON.stringify({}));
}

// Tab switching
function switchTab(tabName) {
    $('.tab').removeClass('active');
    $(`.tab[data-tab="${tabName}"]`).addClass('active');
    
    $('.tab-content').removeClass('active');
    $(`#${tabName}-tab`).addClass('active');
}

// Player list
function updatePlayerList() {
    const list = $('#player-list');
    list.empty();
    
    const searchTerm = $('#player-search').val().toLowerCase();
    
    players.filter(p => {
        if (!searchTerm) return true;
        return p.name.toLowerCase().includes(searchTerm) || 
               p.id.toString().includes(searchTerm);
    }).forEach(player => {
        const card = $(`
            <div class="player-card" onclick="openPlayerModal(${player.id})">
                <div class="player-info-inline">
                    <span class="player-name">${player.name}</span>
                    <span class="player-details">ID: ${player.id} | Job: ${player.job?.label || 'Unemployed'} | Money: $${player.money || 0}</span>
                </div>
            </div>
        `);
        list.append(card);
    });
}

function searchPlayers() {
    updatePlayerList();
}

function refreshPlayers() {
    $.post('https://as-admin/refreshPlayers', JSON.stringify({}));
}

// Player modal
function openPlayerModal(playerId) {
    const player = players.find(p => p.id === playerId);
    if (!player) return;
    
    currentPlayer = player;
    
    $('#modal-player-name').text(player.name);
    $('#modal-player-id').text(player.id);
    $('#modal-player-job').text(player.job?.label || 'Unemployed');
    $('#modal-player-money').text(player.money || 0);
    
    $('#player-modal').removeClass('hidden');
}

function closePlayerModal() {
    $('#player-modal').addClass('hidden');
    currentPlayer = null;
}

// Player actions
function teleportToPlayer() {
    if (!currentPlayer) return;
    $.post('https://as-admin/teleportToPlayer', JSON.stringify({ id: currentPlayer.id }));
    closePlayerModal();
}

function bringPlayer() {
    if (!currentPlayer) return;
    $.post('https://as-admin/bringPlayer', JSON.stringify({ id: currentPlayer.id }));
    closePlayerModal();
}

function spectatePlayer() {
    if (!currentPlayer) return;
    $.post('https://as-admin/spectatePlayer', JSON.stringify({ id: currentPlayer.id }));
    closePlayerModal();
}

function freezePlayer() {
    if (!currentPlayer) return;
    const frozen = confirm('Freeze this player?');
    $.post('https://as-admin/freezePlayer', JSON.stringify({ 
        id: currentPlayer.id,
        freeze: frozen
    }));
}

function healPlayer() {
    if (!currentPlayer) return;
    $.post('https://as-admin/healPlayer', JSON.stringify({ id: currentPlayer.id }));
    closePlayerModal();
}

function revivePlayer() {
    if (!currentPlayer) return;
    $.post('https://as-admin/revivePlayer', JSON.stringify({ id: currentPlayer.id }));
    closePlayerModal();
}

function warnPlayerModal() {
    if (!currentPlayer) return;
    const message = prompt('Enter warning message:');
    if (!message) return;
    
    $.post('https://as-admin/warnPlayer', JSON.stringify({ 
        id: currentPlayer.id,
        message: message
    }));
    closePlayerModal();
}

function notifyPlayerModal() {
    if (!currentPlayer) return;
    const message = prompt('Enter notification message:');
    if (!message) return;
    
    const type = prompt('Enter type (success/error/info/warning):') || 'info';
    
    $.post('https://as-admin/notifyPlayer', JSON.stringify({ 
        id: currentPlayer.id,
        message: message,
        type: type
    }));
    closePlayerModal();
}

function giveMoneyModal() {
    if (!currentPlayer) return;
    const account = prompt('Enter account (cash/bank):') || 'cash';
    const amount = prompt('Enter amount:');
    if (!amount || isNaN(amount)) return;
    
    $.post('https://as-admin/giveMoney', JSON.stringify({ 
        id: currentPlayer.id,
        account: account,
        amount: parseInt(amount)
    }));
    closePlayerModal();
}

function removeMoneyModal() {
    if (!currentPlayer) return;
    const account = prompt('Enter account (cash/bank):') || 'cash';
    const amount = prompt('Enter amount:');
    if (!amount || isNaN(amount)) return;
    
    $.post('https://as-admin/removeMoney', JSON.stringify({ 
        id: currentPlayer.id,
        account: account,
        amount: parseInt(amount)
    }));
    closePlayerModal();
}

function setJobModal() {
    if (!currentPlayer) return;
    const job = prompt('Enter job name:');
    if (!job) return;
    
    const grade = prompt('Enter grade (0-10):') || '0';
    
    $.post('https://as-admin/setJob', JSON.stringify({ 
        id: currentPlayer.id,
        job: job,
        grade: parseInt(grade)
    }));
    closePlayerModal();
}

function kickPlayerModal() {
    if (!currentPlayer) return;
    const reason = prompt('Enter kick reason:');
    if (!reason) return;
    
    $.post('https://as-admin/kickPlayer', JSON.stringify({ 
        id: currentPlayer.id,
        reason: reason
    }));
    closePlayerModal();
}

function banPlayerModal() {
    if (!currentPlayer) return;
    const reason = prompt('Enter ban reason:');
    if (!reason) return;
    
    $.post('https://as-admin/kickPlayer', JSON.stringify({ 
        id: currentPlayer.id,
        reason: reason
    }));
    closePlayerModal();
}

function banPlayerModal() {
    if (!currentPlayer) return;
    const reason = prompt('Enter ban reason:');
    if (!reason) return;
    
    const duration = prompt('Enter ban duration (days, 0 for permanent):');
    if (duration === null) return;
    
    $.post('https://as-admin/banPlayer', JSON.stringify({ 
        id: currentPlayer.id,
        reason: reason,
        duration: parseInt(duration) || 0
    }));
    closePlayerModal();
}

// Teleport actions
function teleportToLocation(location) {
    const coords = teleportLocations[location];
    if (!coords) return;
    
    $.post('https://as-admin/teleportToLocation', JSON.stringify({ coords: coords }));
}

// Vehicle actions
function spawnVehicle() {
    const model = $('#vehicle-model').val();
    if (!model) return;
    
    $.post('https://as-admin/spawnVehicle', JSON.stringify({ model: model }));
    $('#vehicle-model').val('');
}

function quickSpawnVehicle(model) {
    $.post('https://as-admin/spawnVehicle', JSON.stringify({ model: model }));
}

function deleteVehicle() {
    $.post('https://as-admin/deleteVehicle', JSON.stringify({}));
}

function repairVehicle() {
    $.post('https://as-admin/repairVehicle', JSON.stringify({}));
}

// Server actions
function setWeather(weather) {
    $.post('https://as-admin/setWeather', JSON.stringify({ weather: weather }));
}

function setTime() {
    const hour = parseInt($('#time-hour').val()) || 12;
    const minute = parseInt($('#time-minute').val()) || 0;
    
    $.post('https://as-admin/setTime', JSON.stringify({ 
        hour: hour,
        minute: minute
    }));
}

function sendAnnouncement() {
    const message = $('#announcement-text').val();
    if (!message) return;
    
    $.post('https://as-admin/announcement', JSON.stringify({ message: message }));
    $('#announcement-text').val('');
}

// Self actions
function toggleNoclip() {
    $.post('https://as-admin/toggleNoclip', JSON.stringify({}));
}

function toggleGod() {
    $.post('https://as-admin/toggleGod', JSON.stringify({}));
}

function toggleInvisible() {
    $.post('https://as-admin/toggleInvisible', JSON.stringify({}));
}

function healSelf() {
    $.post('https://as-admin/healPlayer', JSON.stringify({ id: -1 }));
}

function reviveSelf() {
    $.post('https://as-admin/revivePlayer', JSON.stringify({ id: -1 }));
}

// ESC key to close
$(document).keyup(function(e) {
    if (e.key === "Escape") {
        if (!$('#player-modal').hasClass('hidden')) {
            closePlayerModal();
        } else if (!$('#menu').hasClass('hidden')) {
            closeMenu();
        }
    }
});
