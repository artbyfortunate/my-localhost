function python() {

	# Selector
    local OPTION=${1}

	# Config
	local APPNAME="APPNAME"
	local FRAMEWORK="FRAMEWORK"
	local APPTYPE="APPTYPE"
	local PYFRAMEWORK="PYFRAMEWORK"
	local DBNAME="DBNAME"
	local DBUSER="DBUSER"
	local DBPASS="DBPASS"
	local DBTYPE="DBTYPE"

	# Directories
	local DIR="${HOST_APPS}/python"

	if [ ! ${1} ]; then

		# No parameter specified
		cd $DIR

	else
		cd $DIR

		. "${RESOURCES_SCRIPTS_PYTHON}/python_actions.zsh"

	fi

}
