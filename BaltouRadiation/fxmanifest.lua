fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Baltou'
description 'Script de zones de radiation pour FiveM'
version '1.0.0'

-- Scripts client
client_scripts {
    'client.lua',
    'config.lua',
}

server_scripts {
    'server.lua',
}

-- Fichiers NUI
ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/style.css',
    'html/script.js',
    'html/radiation.png',
    'html/radiation_sound.ogg'
}