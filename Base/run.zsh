
SOURCEFILE "${RESOURCES_GLOBAL}" "header"


if [ ! ${1} ]; then

    # Run my.zsh script if no argument is passed
    . "${BASE}/my.zsh"

elif [ ! ${2} ]; then

    # Run the script based on the argument passed
    . "${BASE_CORE}/${1}.zsh"

else

    # Run the script based on the argument passed
    . "${PROGRAM}/${1}/${2}.zsh"
    # case "${1}" in
    #     "app" )
            
    #         # Call the app script

    #     ;;
    #     "host" )
            
    #         # Call the host script
    #         SOURCEFILE "${PROGRAM_HOST}" "${2}"

    #     ;;
    #     * )
    #         echo "Usage : my [ Create | Delete ]"
    #     ;;
    # esac

fi

SOURCEFILE "${RESOURCES_GLOBAL}" "footer"