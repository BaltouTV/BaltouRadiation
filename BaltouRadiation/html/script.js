window.addEventListener('message', function(event) {
    if (event.data.type === 'updateRadiation') {
        var percentage = event.data.percentage;
        var showIcon = event.data.showIcon;
        var radiationBar = document.getElementById('radiation-bar');
        var radiationIcon = document.getElementById('radiation-icon-container');
        var radiationContainer = document.getElementById('radiation-container');

        radiationBar.style.width = percentage + '%';
        if (showIcon) {
            radiationIcon.style.display = 'block';
            radiationContainer.style.display = 'block';
        } else {
            radiationIcon.style.display = 'none';
            radiationContainer.style.display = 'none';
        }
    } else if (event.data.type === 'playSound') {
        var sound = document.getElementById('radiation-sound');
        sound.play();
    } else if (event.data.type === 'stopSound') {
        var sound = document.getElementById('radiation-sound');
        sound.pause();
        sound.currentTime = 0; // Reset the sound to the beginning
    }
});
