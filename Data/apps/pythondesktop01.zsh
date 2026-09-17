function pythondesktop01() {

	# Selector
    local OPTION=${1}

	# Config
	local APPNAME='pythondesktop01'
	local FRAMEWORK="PYTHON"
	local APPTYPE='DESKTOP'
	local PYFRAMEWORK='FLASK'
	local DBNAME='pythondesktop01'
	local DBUSER="-"
	local DBPASS="-"
	local DBTYPE="SQLITE"

	# Directories
	local DIR='/home/fortunate/Host/Apps/pythondesktop01'

	if [ ! ${1} ]; then

		# No parameter specified
		cd $DIR

	else
		cd $DIR

		. "${RESOURCES_SCRIPTS_PYTHON}/python_actions.zsh"

	fi

}
