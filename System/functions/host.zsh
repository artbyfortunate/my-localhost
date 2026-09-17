function host() {


	if [[ -z ${1} ]]; then

		cd "${HOME}/Host"
		echo "Welcome to your Host."

	else
    
		# Selector
		local OPTION=${1}

		case "${OPTION}" in
		
			"init" )
			# Host Initialize

				# Comment
				. "${PROGRAM_HOST}/initialize.zsh"

			;;
			"refresh" )
			# Host Refresh

				# Comment
				. "${PROGRAM_HOST}/refresh.zsh"

			;;
			"start" )
			# Host Start

				# Comment
				. "${PROGRAM_HOST}/start.zsh"

			;;
			"stop" )
			# Host Stop

				# Comment
				. "${PROGRAM_HOST}/stop.zsh"

			;;
			"domain" )
			# Host Stop

				# Comment
				valet_domain ${2}

			;;
			"remove" )
			# Host Stop

				# Remove domain ssl
				valet_unsecure

				# Remove current directory from valet's list of paths and domains
				valet_forget

			;;
			* )

				echo "You've entered the wrong option"
				echo "Try one of the following options:"
				echo "\ninit\nrefresh\nstart\nstop\ndomain\nremove"

			;;
		esac
	fi

}