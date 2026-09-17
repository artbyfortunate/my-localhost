# Directories
########################################################

# MY
MY="${HOME}/my-localhost"

# Base
BASE="${MY}/Base"
BASE_CORE="${BASE}/Core"
BASE_COMMANDS="${BASE}/Commands"
BASE_HELPERS="${BASE}/Helpers"

# Configs
CONFIGS="${MY}/Configs"

# System
SYSTEM="${MY}/System"
SYSTEM_UTILITIES="${SYSTEM}/utilities"
SYSTEM_FUNCTIONS="${SYSTEM}/functions"

# Program
PROGRAM="${MY}/Program"
PROGRAM_APP="${PROGRAM}/app"
PROGRAM_HOST="${PROGRAM}/host"

# Data
DATA="${MY}/Data"
DATA_APPS="${DATA}/apps"
DATA_HOST="${DATA}/host"

# Resources
RESOURCES="${MY}/Resources"
RESOURCES_SCRIPTS="${RESOURCES}/scripts"
RESOURCES_SCRIPTS_WORDPRESS="${RESOURCES_SCRIPTS}/wordpress"
RESOURCES_SCRIPTS_BLANK="${RESOURCES_SCRIPTS}/blank"
RESOURCES_SCRIPTS_LARAVEL="${RESOURCES_SCRIPTS}/laravel"
RESOURCES_SCRIPTS_NODEJS="${RESOURCES_SCRIPTS}/nodejs"
RESOURCES_SCRIPTS_PYTHON="${RESOURCES_SCRIPTS}/python"
RESOURCES_TEMPLATES="${RESOURCES}/templates"
RESOURCES_TEMPLATES_WORDPRESS="${RESOURCES_TEMPLATES}/wordpress"
RESOURCES_TEMPLATES_BLANK="${RESOURCES_TEMPLATES}/blank"
RESOURCES_TEMPLATES_NODEJS="${RESOURCES_TEMPLATES}/nodejs"
RESOURCES_TEMPLATES_PYTHON="${RESOURCES_TEMPLATES}/python"
RESOURCES_GLOBAL="${RESOURCES}/global"

# Host
HOST="${HOME}/Host"
HOST_APPS="${HOST}/Apps"
HOST_DATA="${HOST}/__Data"
HOST_FRAMEWORKS="${HOST_DATA}/Frameworks"
HOST_TOOLS="${HOST_DATA}/Tools"

function SOURCEFILE() {

    source "${1}/${2}.zsh"

}

# Get User & Server Configs
########################################################

SOURCEFILE "${CONFIGS}" "user"
SOURCEFILE "${CONFIGS}" "server"

# Compile Scripts
########################################################

SOURCEFILE "${BASE_HELPERS}" "compile_scripts"

COMPILESCRIPTS "${SYSTEM_UTILITIES}" "system_utilities"
COMPILESCRIPTS "${SYSTEM_FUNCTIONS}" "system_functions"
COMPILESCRIPTS "${DATA_APPS}" "data_apps"

# Compile Scripts
########################################################

SOURCEFILE "${BASE_COMMANDS}" "system_utilities"
SOURCEFILE "${BASE_COMMANDS}" "system_functions"
SOURCEFILE "${BASE_COMMANDS}" "data_apps"