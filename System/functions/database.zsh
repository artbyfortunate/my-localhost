function database() {
    
	# Selector
    local OPTION=${1}
    local DBNAME=${2}

    case $OPTION in
		"create" )

			# Comment
			mysql_create "$DBNAME"

		;;
		"delete" )

			# Comment
			mysql_delete "$DBNAME"

		;;
		"export" )

			# Export database if it exist in mysql
			if [ -d "${MYSQL_DATABASES_PATH}/${2}" ]; then

				wp db export "./${2}.sql"

			else

				echo "Database does not exist..."

			fi

		;;
		"import" )

			wp db import "./${2}.sql"

		;;
		* )

			echo "Your Folders are : [ 
			First | Second ] (* Edit)"

		;;
	esac
}

