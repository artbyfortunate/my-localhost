case "${OPTION}" in
    "folder" )

        # done
        folder open ${DIR}

    ;;
    "browse" )

        # upgrade
        valet open

    ;;
    * )

        echo "your options are : [ 
        init | upgrade |  ]"

    ;;
esac