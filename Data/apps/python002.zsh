function python002() {

	# Selector
    local OPTION=${1}

	# Config
	local APPNAME='python002'
	local FRAMEWORK="PYTHON"
	local APPTYPE='DESKTOP'
	local PYFRAMEWORK='FASTAPI'
	local DBNAME='python002'
	local DBUSER="-"
	local DBPASS="-"
	local DBTYPE="SQLITE"

	# Directories
	local DIR='/home/fortunate/Host/Apps/python002'

	if [ ! ${1} ]; then

		# No parameter specified
		cd $DIR

	else
		cd $DIR

		. "${RESOURCES_SCRIPTS_PYTHON}/python_actions.zsh"

	fi

}
