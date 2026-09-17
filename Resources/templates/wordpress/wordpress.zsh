function wordpress() {

	# Selector
    local OPTION=${1}
	
	# Config
	local APPNAME="APPNAME"
	local FRAMEWORK="FRAMEWORK"
	local DBNAME="DBNAME"
	local DBUSER="DBUSER"
	local DBPASS="DBPASS"
	local DBTYPE="DBTYPE"

	# Directories
	local DIR="${HOST_APPS}/wordpress"

	if [ ! ${1} ]; then
	
		# No parameter specified
		cd $DIR

	else
		cd $DIR

		. "${RESOURCES_SCRIPTS_WORDPRESS}/wordpress_actions.zsh"
		
	fi

}