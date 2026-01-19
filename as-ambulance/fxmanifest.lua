fx_version 'cerulean'
game 'gta5'

name 'as-ambulance'
author 'AS Framework'
version '1.0.0'
description 'Complete EMS/Medical System for AS Framework'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua', -- Required for AS Framework internal functions
    '@as-core/shared/config.lua',
    'shared/config.lua'
}

client_scripts {
    'client/main.lua',
    'client/death.lua',
    'client/job.lua',
    'client/hospital.lua',
    'client/vehicle.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/death.lua',
    'server/job.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/death.html',
    'html/death.css',
    'html/death.js'
}

lua54 'yes'
