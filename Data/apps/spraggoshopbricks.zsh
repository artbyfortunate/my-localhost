function spraggoshopbricks() {

	# Selector
    local OPTION=${1}
	
	# Config
	local APPNAME='spraggoshopbricks'
	local FRAMEWORK="WORDPRESS"
	local DBNAME='spraggoshopbricks'
	local DBUSER="root"
	local DBPASS="root"
	local DBTYPE="MYSQL"

	# Directories
	local DIR='/home/fortunate/Host/Apps/spraggoshopbricks'

	if [ ! ${1} ]; then
	
		# No parameter specified
		cd $DIR

	else
		cd $DIR

		. "${RESOURCES_SCRIPTS_WORDPRESS}/wordpress_actions.zsh"
		
	fi

}