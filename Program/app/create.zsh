# Enter Apps
folder enter ${HOST_APPS}



# shell_newline

# user input : select framework
echo "Available Frameworks : "
echo "====================== "

echo "1 = Blank"
echo "2 = Wordpress"
echo "3 = Laravel"
echo "4 = NodeJs"
echo "5 = Python"

# shell_newline

echo "\n"
echo "Select Framework by Typing Number : "
echo "=================================== "
read APPFRAMEWORK_INPUT

local APPFRAMEWORK="${APPFRAMEWORK_INPUT}"

# shell_clear

case "${APPFRAMEWORK}" in
    "1" )
        echo "You have selected : Blank "
        echo "========================= "
        . "${RESOURCES_SCRIPTS_BLANK}/blank_create.zsh"

    ;;
    "2" )

        echo "You have selected : WordPress "
        echo "============================= "
        echo "\n"
        . "${RESOURCES_SCRIPTS_WORDPRESS}/wordpress_create.zsh"

    ;;
    "3" )

        echo "You have selected : Laravel "
        echo "============================= "
        echo "\n"
        . "${RESOURCES_SCRIPTS_LARAVEL}/laravel_create.zsh"

    ;;
    "4" )

        echo "You have selected : NodeJs "
        echo "============================= "
        echo "\n"
        . "${RESOURCES_SCRIPTS_NODEJS}/node_create.zsh"

    ;;
    "5" )

        echo "You have selected : Python "
        echo "============================= "
        echo "\n"
        . "${RESOURCES_SCRIPTS_PYTHON}/python_create.zsh"

    ;;
    * )
        echo "Select a framework by typing a number : "
        echo "======================================= "
        echo "1. Blank"
        echo "2. Wordpress"
        echo "3. Laravel"
        echo "4. NodeJs"
        echo "5. Python"
    ;;
esac

# Python apps run their own dev server (uvicorn / runserver / pywebview),
# so Valet's PHP-FPM site setup doesn't apply to them.
if [[ "${APPFRAMEWORK}" != "5" ]]; then

    # generate ssl
    valet secure

    # Refresh Shell
    # shell_newline

    # shell_refresh


    # Read YesNo
    read -s -k "?[${APPNAME}] Created successfully. Open in browser? | [ Y / N ]" yn

    # Case yn
    case "${yn}" in
        "y" )

            valet open

        ;;

        "n" )

            echo "Okay, Enjoy Creating..."

        ;;

        * )
            clear
            echo "Enter [y] or [n]"
        ;;
    esac

else

    echo ""
    echo "Run it with:"
    echo "  ${APPNAME}"
    echo "  ${APPNAME} venv"
    echo "  ${APPNAME} run"

fi
