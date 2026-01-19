fx_version 'cerulean'
game 'gta5'

name 'as-target'
author 'AS Framework'
version '1.0.0'
description 'Custom Target System with Bridge Support for AS Framework'

lua54 'yes'

shared_scripts {
    '@as-core/shared/config.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/target.lua',
    'client/zones.lua',
    'client/bridge.lua',
    'client/api.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}