# Server Vars
########################################################

# Valet
VALET_DOMAIN="test"
VALET_PATH="${HOME}/.config/valet"
VALET_LOGS="${VALET_PATH}/Log"
VALET_CERTIFICATES="${VALET_PATH}/Certificates"
VALET_NGINX="${VALET_PATH}/Nginx"

# mysql
MYSQL_USERNAME="root"
MYSQL_PASSWORD="root"
MYSQL_DATABASES_PATH="${HOME}/var/lib/mariadb"

#postgres
POSTGRES_USERNAME="postgres"

# mongodb
MONGODB_URI="mongodb://localhost:27017"

# php
PHP_CONFIG_PATH="/etc/php/8.5/fpm"
PHP_INI="${PHP_CONFIG_PATH}/php.ini"

# nginx /etc/nginx
NGINX_CONFIG_PATH="/etc/nginx"
NGINX_CONFIG="${NGINX_CONFIG_PATH}/nginx.conf"
NGINX_SITES_AVAILABLE="${NGINX_CONFIG_PATH}/sites-available"
NGINX_SITES_ENABLED="${NGINX_CONFIG_PATH}/sites-enabled"