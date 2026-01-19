fx_version 'cerulean'
game 'gta5'

name 'as-hud'
author 'AS Framework'
version '1.0.0'
description 'Modern Purple HUD for AS Framework'

lua54 'yes'

shared_scripts {
    '@as-core/shared/config.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/minimap.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/assets/*.png'
}

dependencies {
    'as-core'
}
