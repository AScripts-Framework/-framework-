let currentOptions = [];
let selectedIndex = 0;
let isOpen = false;

window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.action) {
        case 'show':
            showTarget();
            break;
        case 'hide':
            hideTarget();
            break;
        case 'updateOptions':
            updateOptions(data.options, data.distance, data.label);
            break;
        case 'setActive':
            setActive(data.active);
            break;
    }
});

function showTarget() {
    document.getElementById('target-container').style.display = 'block';
    isOpen = true;
}

function hideTarget() {
    document.getElementById('target-container').style.display = 'none';
    document.getElementById('target-options').classList.remove('show');
    document.getElementById('distance-indicator').classList.remove('show');
    document.getElementById('entity-label').classList.remove('show');
    currentOptions = [];
    selectedIndex = 0;
    isOpen = false;
}

function setActive(active) {
    const eye = document.getElementById('target-eye');
    if (active) {
        eye.classList.add('active');
    } else {
        eye.classList.remove('active');
    }
}

function updateOptions(options, distance, label) {
    currentOptions = options || [];
    selectedIndex = 0;
    
    const optionsContainer = document.getElementById('target-options');
    const distanceIndicator = document.getElementById('distance-indicator');
    const entityLabel = document.getElementById('entity-label');
    
    // Clear existing options
    optionsContainer.innerHTML = '';
    
    if (currentOptions.length > 0) {
        // Show options
        optionsContainer.classList.add('show');
        setActive(true);
        
        // Add each option
        currentOptions.forEach((option, index) => {
            const optionDiv = document.createElement('div');
            optionDiv.className = 'target-option';
            if (index === selectedIndex) {
                optionDiv.classList.add('selected');
            }
            
            // Icon
            const iconDiv = document.createElement('div');
            iconDiv.className = 'option-icon';
            iconDiv.innerHTML = `<i class="${option.icon || 'fa-solid fa-hand-pointer'}"></i>`;
            
            // Label
            const labelDiv = document.createElement('div');
            labelDiv.className = 'option-label';
            labelDiv.textContent = option.label || 'Interact';
            
            // Keybind
            const keybindDiv = document.createElement('div');
            keybindDiv.className = 'option-keybind';
            keybindDiv.textContent = index === 0 ? 'E' : (index + 1).toString();
            
            optionDiv.appendChild(iconDiv);
            optionDiv.appendChild(labelDiv);
            optionDiv.appendChild(keybindDiv);
            
            // Click handler
            optionDiv.addEventListener('click', () => {
                selectOption(index);
            });
            
            // Add animation delay
            optionDiv.style.animationDelay = `${index * 0.05}s`;
            
            optionsContainer.appendChild(optionDiv);
        });
        
        // Show distance if provided
        if (distance) {
            distanceIndicator.textContent = `${distance.toFixed(1)}m`;
            distanceIndicator.classList.add('show');
        } else {
            distanceIndicator.classList.remove('show');
        }
        
        // Show entity label if provided
        if (label) {
            entityLabel.textContent = label;
            entityLabel.classList.add('show');
        } else {
            entityLabel.classList.remove('show');
        }
    } else {
        // Hide options
        optionsContainer.classList.remove('show');
        distanceIndicator.classList.remove('show');
        entityLabel.classList.remove('show');
        setActive(false);
    }
}

function updateSelection(newIndex) {
    if (currentOptions.length === 0) return;
    
    // Remove previous selection
    const options = document.querySelectorAll('.target-option');
    if (options[selectedIndex]) {
        options[selectedIndex].classList.remove('selected');
    }
    
    // Update index
    selectedIndex = newIndex;
    if (selectedIndex < 0) selectedIndex = currentOptions.length - 1;
    if (selectedIndex >= currentOptions.length) selectedIndex = 0;
    
    // Add new selection
    if (options[selectedIndex]) {
        options[selectedIndex].classList.add('selected');
    }
}

function selectOption(index) {
    if (!currentOptions[index]) return;
    
    // Send selection to client
    fetch(`https://${GetParentResourceName()}/selectOption`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            index: index
        })
    });
}

// Keyboard controls
document.addEventListener('keydown', function(event) {
    if (!isOpen || currentOptions.length === 0) return;
    
    switch(event.key) {
        case 'ArrowUp':
        case 'w':
        case 'W':
            event.preventDefault();
            updateSelection(selectedIndex - 1);
            break;
        case 'ArrowDown':
        case 's':
        case 'S':
            event.preventDefault();
            updateSelection(selectedIndex + 1);
            break;
        case 'e':
        case 'E':
            event.preventDefault();
            selectOption(selectedIndex);
            break;
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
            event.preventDefault();
            const numIndex = parseInt(event.key) - 1;
            if (numIndex < currentOptions.length) {
                selectOption(numIndex);
            }
            break;
    }
});

// Helper function for NUI callbacks
function GetParentResourceName() {
    if (window.GetParentResourceName) {
        return window.GetParentResourceName();
    }
    
    const query = window.location.search;
    const match = query.match(/resource=([^&]+)/);
    return match ? match[1] : 'as-target';
}
