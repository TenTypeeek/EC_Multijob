fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'TenTypeeek & 100Kary'
description '[Eclipse Development] Multijob'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/locale.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/framework.lua',
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'locales/*.json',
}

dependencies {
    'ox_lib',
    'oxmysql',
}
