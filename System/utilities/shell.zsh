# Shell Clear
function shell_clear() {

    # Clear Shell
    clear
}

# Shell Refresh
function shell_refresh() {

    # Refresh Shell
    source ${HOME}/.zshrc

}

# Shell Pause
function shell_pause() {

    # Pause Shell
    sleep 1
}

# Shell Loading
function shell_loading() {

    # Load
    echo -ne "${1}    \r"
}

# Shell Message
function shell_message() {

    # Message
    echo "${1}"
}

# Shell New Line
function shell_newline() {

    # New Line
    echo "\n"
}

# Shell Read Enter
function shell_read_enter() {

    # Read
    read -s -k "?${1}. Press [ENTER] to continue."
}

# Shell Read YesNo
function shell_read_yesno() {

    # Read YesNo
    read -s -k "?${1}" yn

    # Case yn
    case "${yn}" in
        "y" )
        
            ${2}

        ;;

        "n" )
        
            ${3}

        ;;

        * ) 
            clear
            echo "Enter [y] or [n]"
        ;;
    esac
}