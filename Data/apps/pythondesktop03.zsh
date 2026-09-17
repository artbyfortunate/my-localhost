function pythondesktop03() {

	# Selector
    local OPTION=${1}

	# Config
	local APPNAME='pythondesktop03'
	local FRAMEWORK="PYTHON"
	local APPTYPE='DESKTOP'
	local PYFRAMEWORK='FLASK'
	local DBNAME='pythondesktop03'
	local DBUSER="-"
	local DBPASS="-"
	local DBTYPE="SQLITE"

	# Directories
	local DIR='/home/fortunate/Host/Apps/pythondesktop03'

	if [ ! ${1} ]; then

		# No parameter specified
		cd $DIR

	else
		cd $DIR

		. "${RESOURCES_SCRIPTS_PYTHON}/python_actions.zsh"

	fi

}
