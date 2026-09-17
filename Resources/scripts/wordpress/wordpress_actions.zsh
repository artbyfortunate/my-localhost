case "${OPTION}" in
    "folder" )

        # done
        folder open ${DIR}

    ;;
    "browse" )

        # upgrade
        valet open

    ;;
    "update" )

        # upgrade
        wp core update

    ;;
    "database" )

        case "${2}" in

            "export" )

                database export ${3}

            ;;
            "import" )

                database import ${3}

            ;;
            * )
            ;;
        esac

    ;;
    * )

        echo "your options are : [ 
        init | upgrade |  ]"

    ;;
esac