fx_version 'cerulean'
game 'gta5'

author 'Ch00ky'
description 'Sistema de Recepcionista para ESX Legacy'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/*.*',
    'html/**/*.*'
}

dependencies {
    'es_extended',
    'ox_target',
    'ox_lib'
}