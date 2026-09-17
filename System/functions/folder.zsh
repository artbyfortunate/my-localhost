function folder() {

	# Selector
    local OPTION=${1}
    local FOLDER=${2}

    case $OPTION in
		"create" )

			# Comment

            if [ ! -d "${1}" ]; then
                folder_create "$FOLDER"
            else
                echo "Folder already exists"
            fi

		;;
		"read" )

			# Comment
			# folder_read
			cd $FOLDER
			echo "Files :"
			echo "#######"
            print -l *(.)
            echo "\nDirectories :"
            echo "#############"
            print -l *(/)

		;;
		"open" )

			# Comment
			folder_open

		;;
		"edit" )

			# Comment
			folder_edit $FOLDER

		;;
		"delete" )

			# Comment
			folder_delete $FOLDER

		;;
		"enter" )

			# Comment
			folder_enter $FOLDER

		;;
		"exit" )

			# Comment
			folder_exit

		;;
		"copy" )

			# Comment
			# folder_copy ${2} ${3}

            # check if folder exists
            if [ ! -d "${2}" ]; then

                echo "Folder does not exist"

			# if destination exit
            elif [ -d "${3}" ]; then

                echo "Folder already exists"

            else

                folder_copy ${2} ${3}

            fi

		;;
		"move" )

            # check if folder exists
            if [ ! -d "${2}" ]; then

                echo "Folder does not exist"

			# if destination exit
            elif [ -d "${3}" ]; then

                echo "Folder already exists"

            else

                folder_move ${2} ${3}

            fi

		;;
		* )

			echo "You've entered a wrong option. Your options are : \ncreate\nread\nopen\nedit\ndelete\nenter\nexit\ncopy\nmove"

		;;
	esac

}
