# create database
function sqlite_create() {
    local db="$1"
    sqlite3 "${db}" "vacuum;"
}

# delete database
function sqlite_delete() {
    local db="$1"
    rm -f "${db}"
}

# find replace in database
function sqlite_find_replace() {
    local db="$1"
    local find="$2"
    local replace="$3"

    if [[ -z "${db}" || -z "${find}" || -z "${replace}" ]]; then
        echo "Error: Missing arguments for sqlite_find_replace." >&2
        return 1
    fi

    if [[ ! -f "${db}" ]]; then
        echo "Error: Database '${db}' does not exist." >&2
        return 1
    fi

    sqlite3 "${db}" <<eof
.mode list
.headers off
SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';
eof
| while IFS= read -r table; do
        if [[ -z "${table}" ]]; then
            continue
        fi

        columns=$(sqlite3 "${db}" <<eof
PRAGMA table_info("${table}");
eof
)

        while IFS='|' read -r cid name _type _notnull _dflt_value pk; do
            if [[ -z "${name}" ]]; then
                continue
            fi

            case "${_type}" in
                TEXT|VARCHAR|CHAR|CLOB|STRING)
                    sqlite3 "${db}" <<eof
UPDATE "${table}" SET "${name}" = replace("${name}", '${find}', '${replace}') WHERE "${name}" LIKE '%${find}%';
eof
                    ;;
            esac
        done <<< "${columns}"
    done
}

function sqlite_check_connection() {
    local db="$1"
    if [[ -z "${db}" ]]; then
        echo "Error: Database path not specified for SQLite." >&2
        return 1
    fi
    if [[ ! -f "${db}" ]]; then
        echo "Error: SQLite database file '${db}' does not exist." >&2
        return 1
    fi
}

function sqlite_check_database_exists() {
    local db="$1"
    if [[ ! -f "${db}" ]]; then
        echo "Error: Database '${db}' does not exist." >&2
        return 1
    fi
}

function sqlite_export_database() {
    local db="$1"
    local output_file="$2"
    if [[ -z "${db}" || -z "${output_file}" ]]; then
        echo "Error: Missing arguments for sqlite_export_database." >&2
        return 1
    fi
    sqlite3 "${db}" ".dump" > "${output_file}"
}
