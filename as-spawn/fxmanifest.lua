fx_version 'cerulean'
game 'gta5'

name 'as-spawn'
author 'AS Framework'
version '1.0.0'
description 'Spawn and Multicharacter System for AS Framework'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    '@as-core/shared/config.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/characters.lua'
}

client_scripts {
    'client/main.lua',
    'client/spawn.lua',
    'client/characters.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

dependencies {
    'as-core',
    -- 'fivem-appearance' -- Or some appearance system that uses fivem-appearance exports.
}
