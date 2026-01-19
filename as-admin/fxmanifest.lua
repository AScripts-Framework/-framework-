fx_version 'cerulean'
game 'gta5'

author 'AS Framework'
description 'Admin Menu for AS Framework'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    'shared/config.lua'
}

server_scripts {
    'server/main.lua',
    'server/commands.lua',
    'server/actions.lua'
}

client_scripts {
    'client/main.lua',
    'client/actions.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

dependencies {
    'as-core',
    'oxmysql'
}
