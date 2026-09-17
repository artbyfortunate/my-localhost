function COMPILESCRIPTS() {
    local dir="${1}"
    local output_file="${BASE_COMMANDS}/${2}.zsh"

    # Validate inputs
    if [[ -z "$dir" || -z "$2" ]]; then
        print "Error: COMPILESCRIPTS requires directory and output filename arguments" >&2
        return 1
    fi

    if [[ ! -d "$dir" ]]; then
        print "Error: Directory '$dir' does not exist" >&2
        return 1
    fi

    # Initialize output file
    print -n > "$output_file"

    # Use nullglob to handle empty directories gracefully
    setopt nullglob
    local -a files=("$dir"/*.zsh)

    if (( $#files )); then
        for source_file in "${files[@]}"; do
            if [[ -f "$source_file" && -r "$source_file" ]]; then
                print "source ${source_file}" >> "$output_file"
            fi
        done
    fi
    unsetopt nullglob
}