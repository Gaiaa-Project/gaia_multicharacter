fx_version 'cerulean'
game 'gta5'

author 'Chaos Studio'
description 'Multi-character system for Gaia Roleplay — character creation, selection, and lifecycle management built on top of gaia_core_roleplay.'
version '0.0.1'

name 'gaia_multicharacter'

lua54 'yes'

shared_scripts {
    '@gaia_core/init.lua',
    'config/*.lua',
    'shared/modules/locale.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/modules/spawn.lua',
    'server/modules/characters.lua',
    'server/init.lua',
}

client_scripts {
    'client/modules/camera.lua',
    'client/modules/spawn.lua',
}

ui_page 'web/dist/index.html'

files {
    'translations/*.lua',
    'web/dist/index.html',
    'web/dist/**/*',
}

dependencies {
    'gaia_core',
    'oxmysql'
}
