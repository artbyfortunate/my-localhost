# create database
function mysql_create() {
    mysql -u "${MYSQL_USERNAME}" --password="${MYSQL_PASSWORD}" -e 'create database '${1}';'
}

# delete database
function mysql_delete() {
    mysql -u "${MYSQL_USERNAME}" --password="${MYSQL_PASSWORD}" -e 'drop database '${1}';'
}

# find replace in database
function mysql_find_replace() {
    local db="$1"
    local find="$2"
    local replace="$3"
    # escape single quotes in find and replace for sql
    find_escaped=$(printf '%s\n' "$find" | sed "s/'/''/g")
    replace_escaped=$(printf '%s\n' "$replace" | sed "s/'/''/g")
    mysql -u "${MYSQL_USERNAME}" --password="${MYSQL_PASSWORD}" "${db}" <<eof
$(mysql -u "${MYSQL_USERNAME}" --password="${MYSQL_PASSWORD}" -e "
select concat('update \`', table_name, '\` set \`', column_name, '\` = replace(\`', column_name, '\`, ''${find_escaped}'', ''${replace_escaped}'');')
from information_schema.columns
where table_schema = '${db}' and data_type in ('char', 'varchar', 'tinytext', 'text', 'mediumtext', 'longtext');
" | tail -n +2)
eof
}

function mysql_check_connection() {
    if ! mysqladmin ping -u "${MYSQL_USERNAME}" --password="${MYSQL_PASSWORD}" > /dev/null 2>&1; then
        echo "Error: Unable to connect to MySQL server with provided credentials." >&2
        return 1
    fi
}

function mysql_check_database_exists() {
    local db="$1"
    if ! mysql -u "${MYSQL_USERNAME}" --password="${MYSQL_PASSWORD}" -e "use ${db};" > /dev/null 2>&1; then
        echo "Error: Database '${db}' does not exist." >&2
        return 1
    fi
}

function mysql_export_database() {
    local db="$1"
    local output_file="$2"
    if [[ -z "${db}" || -z "${output_file}" ]]; then
        echo "Error: Missing arguments for mysql_export_database." >&2
        return 1
    fi
    mysqldump -u "${MYSQL_USERNAME}" --password="${MYSQL_PASSWORD}" "${db}" > "${output_file}"
}