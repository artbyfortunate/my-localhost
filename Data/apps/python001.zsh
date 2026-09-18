function python001() {

	# Selector
    local OPTION=${1}

	# Config
	local APPNAME='python001'
	local FRAMEWORK="PYTHON"
	local APPTYPE='DESKTOP'
	local PYFRAMEWORK='FLASK'
	local DBNAME='python001'
	local DBUSER="-"
	local DBPASS="-"
	local DBTYPE="SQLITE"

	# Directories
	local DIR='/home/fortunate/Host/Apps/python001'

	if [ ! ${1} ]; then

		# No parameter specified
		cd $DIR

	else
		cd $DIR

		. "${RESOURCES_SCRIPTS_PYTHON}/python_actions.zsh"

	fi

}
