cd ${HOME}

mkdir ${HOST}
mkdir ${HOST_APPS}
mkdir ${HOST_DATA}
mkdir ${HOST_FRAMEWORKS}

cd ${HOST_APPS}

valet park

cd ${HOST_FRAMEWORKS}

mkdir Blank && cd Blank

valet link && valet secure


cd ${HOME}

# fix nginx config file
sed_find_replace "text/x-component;" "text/x-component;\n\nclient_max_body_size 2048M;\nclient_body_buffer_size 1024k;\nclient_body_timeout 240s;" ${NGINX_CONFIG}

# fix php.ini file
sed_find_replace "max_execution_time = 30" "max_execution_time = 7200" ${PHP_INI}
sed_find_replace "max_input_time = 60" "max_input_time = 7200" ${PHP_INI}
sed_find_replace "memory_limit = 128M" "memory_limit = 512M" ${PHP_INI}
sed_find_replace "post_max_size = 8M" "post_max_size = 2048M" ${PHP_INI}
sed_find_replace "upload_max_filesize = 2M" "upload_max_filesize = 2048M" ${PHP_INI}
sed_find_replace "max_file_uploads = 20" "max_file_uploads = 2000" ${PHP_INI}
sed_find_replace "default_socket_timeout = 60" "default_socket_timeout = 7200" ${PHP_INI}

echo "Done. Host Setup Successfully!!!"