case "${OPTION}" in
    "folder" )

        # Open the app folder
        folder open ${DIR}

    ;;
    "venv" )

        # Activate the virtual environment in the current shell
        echo "Activating virtual environment..."
        source "${DIR}/venv/bin/activate"

    ;;
    "install" )

        # (Re)install dependencies from requirements.txt
        source "${DIR}/venv/bin/activate"
        pip install -r "${DIR}/requirements.txt"

    ;;
    "run" )

        # Run the app's dev server
        source "${DIR}/venv/bin/activate"

        case "${APPTYPE}" in
            "DESKTOP" )

                python "${DIR}/run_desktop.py"

            ;;
            "WEB" )

                case "${PYFRAMEWORK}" in
                    "DJANGO" )

                        python "${DIR}/manage.py" runserver

                    ;;
                    "FASTAPI" )

                        uvicorn app.main:app --reload

                    ;;
                    * )

                        echo "Unknown Python web framework: ${PYFRAMEWORK}"

                    ;;
                esac

            ;;
            * )

                echo "Unknown app type: ${APPTYPE}"

            ;;
        esac

    ;;
    "browse" )

        # Open the local dev server in the browser
        xdg-open "http://127.0.0.1:8000"

    ;;
    "database" )

        case "${2}" in

            "export" )

                sqlite_export_database "${DIR}/db/${DBNAME}.sqlite" "${3}"

            ;;
            "import" )

                if [[ -z "${3}" ]]; then
                    echo "Usage: ${APPNAME} database import <file.sql>"
                else
                    sqlite3 "${DIR}/db/${DBNAME}.sqlite" < "${3}"
                fi

            ;;
            * )

                echo "your options are : [ export | import ]"

            ;;
        esac

    ;;
    * )

        echo "your options are : [ \nfolder\nvenv\ninstall\nrun\nbrowse\ndatabase ]"

    ;;
esac
