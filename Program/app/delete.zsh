cd "${HOST_APPS}"
echo "Enter your App/Website's name : "
echo "=============================== "
read APPNAME_INPUT

local APPNAME="${(L)APPNAME_INPUT}"

local DATAFILE="${DATA_APPS}/${APPNAME}.zsh"
local THIS_FRAMEWORK=$(grep 'local FRAMEWORK=' "$DATAFILE" | sed "s/.*FRAMEWORK=['\"]//;s/['\"].*//")
local THIS_DATABASE=$(grep 'local DBTYPE=' "$DATAFILE" | sed "s/.*DBTYPE=['\"]//;s/['\"].*//")




echo "\n"

echo "This will delete ${APPNAME} from your Apps folder. This action is irreversible. Do you want to continue? (y/n) : "

read CONTINUE

echo "\n"

if [[ "${CONTINUE}" == "y" ]]; then

    cd "${HOST_APPS}"

    # Delete by Framework
    if [[ "$THIS_FRAMEWORK" == "WORDPRESS" ]]; then

        # WordPress Deletion
        echo "Deleting WordPress App ${APPNAME}..."

    elif [[ "$THIS_FRAMEWORK" == "LARAVEL" ]]; then

        # Laravel Deletion
        echo "Deleting Laravel App ${APPNAME}..."

    elif [[ "$THIS_FRAMEWORK" == "BLANK" ]]; then

        # Blank Deletion
        echo "Deleting Blank App ${APPNAME}..."

    elif [[ "$THIS_FRAMEWORK" == "NODEJS" ]]; then

        # NodeJS Deletion
        echo "Deleting NodeJS App ${APPNAME}..."
    fi

    sleep 1


    if [[ "$THIS_DATABASE" == "MYSQL" ]]; then

        echo "Deleting MYSQL Database ${APPNAME}..."

        # MySQL Deletion
        mysql_delete "${APPNAME}"

    elif [[ "$THIS_DATABASE" == "MONGODB" ]]; then

        echo "Deleting MongoDB Database ${APPNAME}..."

        # MongoDB Deletion

    elif [[ "$THIS_DATABASE" == "POSTGRES" ]]; then

        echo "Deleting Postgres Database ${APPNAME}..."

        # Postgres Deletion

    elif [[ "$THIS_DATABASE" == "SQLITE" ]]; then

        echo "Deleting SQLite Database ${APPNAME}..."

        # SQLite Deletion
    fi

    sleep 1

    echo "Deleting Nginx Config File"
    sleep 1

    # Delete Nginx Config File
    rm ${VALET_NGINX}/${APPNAME}.${VALET_DOMAIN}

    echo "Deleting SSL Certificate"
    sleep 1

    # Delete SSL Certificate
    valet unsecure ${APPNAME}

    echo "Deleting Data File"
    sleep 1

    # Delete Data file
    rm ${DATA_APPS}/${APPNAME}.zsh

    echo "Deleting App's Folder"
    sleep 1

    # Delete App's Folder
    rm -rf ${APPNAME}

    echo "Done. App Deleted Successfully!!!"

else

    clear
    echo "Aborting Deletion Process. App is safe :)"
    sleep 3
    clear

fi