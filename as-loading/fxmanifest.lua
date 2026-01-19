fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'AS Framework'
description 'Custom loading screen with video background and media controls'
version '1.0.0'

loadscreen 'html/index.html'
loadscreen_manual_shutdown 'yes'

client_script 'client.lua'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/config.js',
    'html/logo.png',
    'html/music.webm',
    'html/videos/*.webm',
    'html/videos/*.jpg',
    'html/videos/*.png'
}