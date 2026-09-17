# sed find replace
function sed_find_replace() {


    local old=${1}
    local new=${2}
    local filename=${3}

    # sed find replace
    sudo sed -i 's|'${old}'|'${new}'|g' ${filename}
}

# sed add to path
function sed_add_to_path() {

    # sed find replace
    sed -i 's|:$path|:'${1}':$path|g' ${HOME}/.zshrc
}