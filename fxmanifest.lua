fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'ender_daily_rewards'
author 'EnderDevelopment'
description 'A polished 30-day ESX daily rewards system'
version '1.0.0'

ui_page 'html/index.html'

shared_script 'config.lua'
client_script 'client.lua'
server_script '@oxmysql/lib/MySQL.lua'
server_script 'server.lua'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js'
}

dependencies {
    'es_extended',
    'oxmysql'
}
