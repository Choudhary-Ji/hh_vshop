resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description 'HH Car Dealership'

author 'ϟϟ Duce'

ui_page 'html/index.html'

client_script {
    "vehshop.lua"
}

server_script {
    "server.lua",
    "@mysql-async/lib/MySQL.lua"
}

files {
	'html/index.html',
	'html/assets/css/*.css',
	'html/assets/js/*.js',
	'html/assets/images/*.png'
}
