function wordpress() {

    

	# Selector
    local OPTION=${1}

    case "${OPTION}" in
		"download" )

            # Download Wordpress
            if [ ! "${2}" ]; then

                # Inside a directory
                wordpress_core download

            else

                # Outside a directory
                wordpress_core download ${2}

            fi

		;;
		"install" )

			# Install Wordpress
            wp core install --url="https://${2}.${VALET_DOMAIN}" --title="${2}" --admin_user="${WP_USER_NAME}" --admin_email="${WP_USER_EMAIL}" --admin_password="${WP_USER_PASSWORD}" --skip-email

            shell_newline

            echo "username & password : "
            echo "===================== "
            echo "username : ${WP_USER_NAME}"
            echo "password : ${WP_USER_PASSWORD}"

		;;
		"update" )

			# Update Wordpress
            wordpress_core update

		;;
		* )

			echo "You've entered the wrong option"
			echo "Try one of the following options:"
			echo "\ndownload\ninstall\nupdate"

		;;
	esac

}
