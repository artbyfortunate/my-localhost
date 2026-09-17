# create database
function postgres_create() {
    psql -U "${POSTGRES_USERNAME}" -c "create database \"${1}\";"
}

# delete database
function postgres_delete() {
    psql -U "${POSTGRES_USERNAME}" -c "drop database \"${1}\";"
}

# find replace in database
function postgres_find_replace() {
    local db="$1"
    local find="$2"
    local replace="$3"
    psql -U "${POSTGRES_USERNAME}" "${db}" <<eof
DO \$\$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT table_name, column_name FROM information_schema.columns WHERE table_schema = 'public' AND data_type IN ('character varying', 'text', 'char')) LOOP
        EXECUTE 'update \"' || r.table_name || '\" set \"' || r.column_name || '\" = replace(\"' || r.column_name || '\", ''' || '${find}' || ''', ''' || '${replace}' || ''')';
    END LOOP;
END \$\$;
eof
}

function postgres_check_connection() {
    if ! pg_isready -U "${POSTGRES_USERNAME}" > /dev/null 2>&1; then
        echo "Error: Unable to connect to PostgreSQL server with provided credentials." >&2
        return 1
    fi
}

function postgres_check_database_exists() {
    local db="$1"
    if ! psql -U "${POSTGRES_USERNAME}" -tc "select 1 from pg_database where datname = '${db}';" | grep -q 1; then
        echo "Error: Database '${db}' does not exist." >&2
        return 1
    fi
}

function postgres_export_database() {
    local db="$1"
    local output_file="$2"
    if [[ -z "${db}" || -z "${output_file}" ]]; then
        echo "Error: Missing arguments for postgres_export_database." >&2
        return 1
    fi
    pg_dump -U "${POSTGRES_USERNAME}" "${db}" > "${output_file}"
}
