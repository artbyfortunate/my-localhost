echo "\n"
echo "Enter your App/Website's name : "
echo "=============================== "
read APPNAME_INPUT

local APPNAME="${(L)APPNAME_INPUT}"

if [[ -d "${APPNAME}" ]]; then

    clear

    echo "App/Website \"${APPNAME}\" already exists. Please choose a different name."

else

    echo "You typed : ${APPNAME}"

    # Create Website Folder
    echo "Create & Enter App's Folder"
    mkdir ${APPNAME} && cd ${APPNAME}

    # Download Wordpress
    echo "\n"
    echo "Download Wordpress"
    wp core download

    sleep 1
    echo "\n"

    # Create Config File
    echo "Create config file"
    mv wp-config-sample.php wp-config.php

    sleep 1
    echo "\n"

    # Edit Config File
    echo "Edit config file"
    sed_find_replace "define( 'DB_NAME', 'database_name_here' );" "define( 'DB_NAME', '${APPNAME}' );" "wp-config.php"
    sed_find_replace "define( 'DB_USER', 'username_here' );" "define( 'DB_USER', '${MYSQL_USERNAME}' );" "wp-config.php"
    sed_find_replace "define( 'DB_PASSWORD', 'password_here' );" "define( 'DB_PASSWORD', '${MYSQL_PASSWORD}' );" "wp-config.php"

    sleep 1
    echo "\n"

    echo "Create Database ${MYSQL_USERNAME}, ${MYSQL_PASSWORD}, ${APPNAME}"
    mysql -u "${MYSQL_USERNAME}" --password="${MYSQL_PASSWORD}" -e 'CREATE DATABASE '${APPNAME}';'

    sleep 1
    echo "\n"

    echo "Install Wordpress ${WP_USER_NAME} ${WP_USER_EMAIL} ${WP_USER_PASSWORD}"
    wp core install --url="https://${APPNAME}.${VALET_DOMAIN}" --title="${APPNAME}" --admin_user="${WP_USER_NAME}" --admin_email="${WP_USER_EMAIL}" --admin_password="${WP_USER_PASSWORD}" --skip-email

    sleep 1
    echo "\n"

    # Install SSL Certificate
    valet secure

    # Trust Certificate
    # sudo trust anchor --store ${VALET_CERTIFICATES}/${APPNAME}.${VALET_DOMAIN}.crt

    sleep 1
    echo "\n"

    echo "Create & Update Data file"
    cp ${RESOURCES_TEMPLATES_WORDPRESS}/wordpress.zsh ${DATA_APPS}/${APPNAME}.zsh

    sleep 1

    sed_find_replace 'function wordpress() {' "function ${APPNAME}() {" "${DATA_APPS}/${APPNAME}.zsh"
    sed_find_replace 'APPNAME="APPNAME"' "APPNAME='"${APPNAME}"'" "${DATA_APPS}/${APPNAME}.zsh"

    sed_find_replace 'FRAMEWORK="FRAMEWORK"' 'FRAMEWORK="WORDPRESS"' "${DATA_APPS}/${APPNAME}.zsh"

    sed_find_replace 'DBNAME="DBNAME"' "DBNAME='${APPNAME}'" "${DATA_APPS}/${APPNAME}.zsh"

    sed_find_replace 'DBUSER="DBUSER"' 'DBUSER="root"' "${DATA_APPS}/${APPNAME}.zsh"

    sed_find_replace 'DBPASS="DBPASS"' 'DBPASS="root"' "${DATA_APPS}/${APPNAME}.zsh"

    sed_find_replace 'DBTYPE="DBTYPE"' 'DBTYPE="MYSQL"' "${DATA_APPS}/${APPNAME}.zsh"

    sed_find_replace 'local DIR="${HOST_APPS}/wordpress"' "local DIR='"${HOST_APPS}/${APPNAME}"'" "${DATA_APPS}/${APPNAME}.zsh"

    source ~/.zshrc

    # Delete default plugins
    rm -rf "${HOST_APPS}/${APPNAME}/wp-content/plugins/hello.php"
    rm -rf "${HOST_APPS}/${APPNAME}/wp-content/plugins/akismet"

    source ~/.zshrc

fi