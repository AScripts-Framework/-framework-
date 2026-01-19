fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'as-police'
author 'AS Framework'
version '1.0.0'
description 'Comprehensive police job system with MDT, evidence, armory, and vehicle management'

shared_scripts {
    '@ox_lib/init.lua',
    '@as-core/shared/config.lua',
    'shared/config.lua'
}

client_scripts {
    'client/main.lua',
    'client/duty.lua',
    'client/armory.lua',
    'client/vehicles.lua',
    'client/interactions.lua',
    'client/evidence.lua',
    'client/mdt.lua',
    'client/radar.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/duty.lua',
    'server/armory.lua',
    'server/vehicles.lua',
    'server/jail.lua',
    'server/evidence.lua',
    'server/warrants.lua',
    'server/dispatch.lua',
    'server/interactions.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/preview.html'
}
