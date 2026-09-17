function goto() {

	# Selector
    local OPTION=${1}

    case "${OPTION}" in
		"host" )

			# Comment
			folder enter ${HOST}

		;;
		"apps" )

			# Comment
			folder enter ${HOST_APPS}

		;;
		* )

			echo "Your options are : [ 
			First | Second ] (* Edit)"

		;;
	esac
}
