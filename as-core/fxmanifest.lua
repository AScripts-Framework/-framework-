fx_version 'cerulean'
game 'gta5'

name 'as-core'
author 'AS Framework'
version '1.0.0'
description 'Optimized FiveM Framework with ox_lib integration'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

client_scripts {
    'client/*.lua',
}

files {
    'locales/*.json'
}

dependencies {
    'ox_lib',
    'oxmysql',
    'ox_inventory'
}