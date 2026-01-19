fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'AS Framework'
description 'Banking system with ATMs and banks'
version '1.0.0'

dependencies {
    'as-core',
    'oxmysql'
}

shared_scripts {
    'shared/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/atm.html',
    'html/atm.css',
    'html/atm.js',
    'html/bank.html',
    'html/bank.css',
    'html/bank.js'
}

dependencies {
    'ox_lib',
    'oxmysql',
    'as-core'
}
