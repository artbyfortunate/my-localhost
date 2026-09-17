# Folder Create
function folder_create() {

        mkdir ${1}

}

# Folder Read
function folder_read() {
    # must get folder name
    # list items in the folder
    # get folder size
}

# Folder Copy
function folder_copy() {

    # Edit Folder
    cp -r "${1}" "${2}"
}

# Folder Move
function folder_move() {

    # Edit Folder
    mv -r "${1}" "${2}"

}

# Folder Edit
function folder_edit() {

    # Edit Folder
    mv "${1}" "${2}"
}

# File Open
function folder_open() {

    if [[ -d "${1}" ]]; then
        xdg-open "${1}"
    else
        xdg-open .
    fi
    # Edit File
}

# Folder Delete
function folder_delete() {

    # Delete folder
    rm -r ${1}
}

# Folder Enter
function folder_enter() {

    # Enter Folder
    cd ${1}
}

# Folder Exit
function folder_exit() {

    # Exit Folder
    cd ..
}
