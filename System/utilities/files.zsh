# files

# file error check
function file_check() {

    local file="${1}"

    if [[ ! -f "${file}" ]]; then
        echo "Error: File '${file}' not found." >&2
        return 1
    fi

}

# file copy
function file_copy() {

    local source="${1}"
    local destination="${2}"

    if [[ -z "${source}" || -z "${destination}" ]]; then
        echo "Error: Missing arguments for file_copy." >&2
        return 1
    fi

    file_check "${source}"

    # copy file
    cp -f "${source}" "${destination}"

}

# file create
function file_create() {

    local file="${1}"

    if [[ -z "${file}" ]]; then
        echo "Error: Missing argument for file_create." >&2
        return 1
    fi

    # create file
    touch "${file}"
    
}

# file edit
function file_edit() {

    local file="${1}"

    if [[ -z "${file}" ]]; then
        echo "Error: Missing argument for file_edit." >&2
        return 1
    fi

    file_check "${file}"

    # edit file
    gedit "${file}"
}

# file delete
function file_delete() {

    local file="${1}"

    if [[ -z "${file}" ]]; then
        echo "Error: Missing argument for file_delete." >&2
        return 1
    fi

    file_check "${file}"

    # delete file
    rm -f "${file}"
}

# file rename
function file_rename() {

    local old="${1}"
    local new="${2}"

    if [[ -z "${old}" || -z "${new}" ]]; then
        echo "Error: Missing arguments for file_rename." >&2
        return 1
    fi

    file_check "${old}"

    # rename file
    mv "${old}" "${new}"
}

# file read
function file_read() {

    local file="${1}"

    if [[ -z "${file}" ]]; then
        echo "Error: Missing argument for file_read." >&2
        return 1
    fi

    file_check "${file}"

    # define an empty array
    local lines=()

    # read file

    # read lines from the file using a while loop
    while ifs= read -r line; do

        # add each line to the array
        lines+=("$line")

    # file & extension
    done < "${file}"

    # print the contents of the array
    printf '%s\n' "${lines[@]}"

}

# file read by line
function file_read_line() {

    local file="${1}"
    local line_number="${2}"

    if [[ -z "${file}" || -z "${line_number}" ]]; then
        echo "Error: Missing arguments for file_read_line." >&2
        return 1
    fi

    file_check "${file}"

    # define an empty array
    local lines=()

    # read file

    # read lines from the file using a while loop
    while ifs= read -r line; do

        # add each line to the array
        lines+=("$line")

    # file & extension
    done < "${file}"

    # print the contents of the array
    printf '%s\n' "${lines[${line_number}]}"

    # ------------------------------------------
    # usage: 
    # file-read-line "nameoffile" ".txt" 3

}

# file write
function file_write() {

    local file="${1}"
    local message="${2}"

    if [[ -z "${file}" || -z "${message}" ]]; then
        echo "Error: Missing arguments for file_write." >&2
        return 1
    fi

    # variables
    echo "${message}" >> ${file}
}

# file empty contents
function file_wipe() {

    local file="${1}"

    if [[ -z "${file}" ]]; then
        echo "Error: Missing argument for file_wipe." >&2
        return 1
    fi

    file_check "${file}"

    # empty file
    echo -n > ${file}

}

function file_find_replace() {

    local file="${1}"
    local find="${2}"
    local replace="${3}"

    if [[ -z "${file}" || -z "${find}" || -z "${replace}" ]]; then
        echo "Error: Missing arguments for file_find_replace." >&2
        return 1
    fi

    file_check "${file}"

    sed -i "s/${find}/${replace}/g" ${file}

}   