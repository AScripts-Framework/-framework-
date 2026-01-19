fx_version 'cerulean'
game 'gta5'

name 'as-fuel'
author 'AS Framework'
version '1.0.0'
description 'Advanced Fuel System with Electric Vehicle Support for AS Framework'

lua54 'yes'

shared_scripts {
    '@as-core/shared/config.lua',
    'shared/config.lua'
}

client_scripts {
    'client/main.lua',
    'client/stations.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

dependencies {
    'as-core',
    'oxmysql'
}

exports {
    'GetFuel',
    'SetFuel',
    'RefuelVehicle',
    'GetFuelConfig'
}
