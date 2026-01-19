// Currently all UI is handled through ox_lib context menus
// This file is kept for future UI extensions

window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'show') {
        document.getElementById('container').style.display = 'block';
        document.getElementById('container').classList.add('show');
    } else if (data.action === 'hide') {
        document.getElementById('container').classList.remove('show');
        setTimeout(() => {
            document.getElementById('container').style.display = 'none';
        }, 300);
    }
});

document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        fetch(`https://${GetParentResourceName()}/close`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        });
    }
});
