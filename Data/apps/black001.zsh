function black001() {

	# Selector
    local OPTION=${1}
	
	# Config
	local APPNAME='black001'
	local FRAMEWORK="BLANK"
	# local DBNAME="DBNAME"
	# local DBUSER="DBUSER"
	# local DBPASS="DBPASS"
	# local DBTYPE="DBTYPE"

	# Directories
	local DIR='/home/fortunate/Host/Apps/black001'

	if [ ! ${1} ]; then
	
		# No parameter specified
		cd $DIR

	else
		cd $DIR

		. "${RESOURCES_SCRIPTS_BLANK}/blank_actions.zsh"
		
	fi

}