let currentData = {}; // GUARDAR DATOS ACTUALES

window.addEventListener('message', function(event) {
    if (event.data.action === 'open') {
        openUI(event.data);
    } else if (event.data.action === 'close') {
        closeUI();
    }
});

function openUI(data) {
    currentData = data; // GUARDAR JOB Y LOCATION
    document.getElementById('container').style.display = 'flex';
    document.getElementById('formTitle').textContent = data.formTitle || 'RECEPCIÓN';
    document.getElementById('locationInfo').textContent = `${data.npcName} - ${data.locationName}`;
    document.getElementById('maxChars').textContent = data.maxLength;
    
    document.documentElement.style.setProperty('--primary-color', data.colors.primary);
    document.documentElement.style.setProperty('--secondary-color', data.colors.secondary);
    
    const textarea = document.getElementById('messageInput');
    textarea.value = '';
    textarea.focus();
    updateCharCount();
}

function closeUI() {
    document.getElementById('container').style.display = 'none';
    currentData = {}; // LIMPIAR DATOS
}

function updateCharCount() {
    const textarea = document.getElementById('messageInput');
    document.getElementById('charCount').textContent = textarea.value.length;
}

document.addEventListener('DOMContentLoaded', function() {
    const sendBtn = document.getElementById('sendBtn');
    const cancelBtn = document.getElementById('cancelBtn');
    const textarea = document.getElementById('messageInput');
    
    textarea.addEventListener('input', updateCharCount);
    
    sendBtn.addEventListener('click', function() {
        const message = textarea.value.trim();
        if (message.length > 0) {
            // ENVIAR CON JOB Y LOCATION
            fetch(`https://${GetParentResourceName()}/sendMessage`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ 
                    message: message,
                    job: currentData.job, // AÑADIR JOB
                    location: currentData.locationName // AÑADIR LOCATION
                })
            });
        }
    });
    
    cancelBtn.addEventListener('click', function() {
        fetch(`https://${GetParentResourceName()}/cancel`, { method: 'POST' });
    });
    
    textarea.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            sendBtn.click();
        }
    });
});