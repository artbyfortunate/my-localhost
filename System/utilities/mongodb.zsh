# create database
function mongodb_create() {
    mongosh "${MONGODB_URI}" --eval "db.getSiblingDB('${1}').createDatabase()" > /dev/null 2>&1
}

# delete database
function mongodb_delete() {
    mongosh "${MONGODB_URI}" --eval "db.getSiblingDB('${1}').dropDatabase()"
}

# find replace in database
function mongodb_find_replace() {
    local db="$1"
    local find="$2"
    local replace="$3"
    mongosh "${MONGODB_URI}" --quiet <<eof
const dbs = db.getSiblingDB('${db}');
dbs.getCollectionNames().forEach(function(collection) {
    var cursor = dbs[collection].find();
    while (cursor.hasNext()) {
        var doc = cursor.next();
        var modified = false;
        for (var key in doc) {
            if (typeof doc[key] === 'string' && doc[key].includes('${find}')) {
                doc[key] = doc[key].replace(/\\${find}/g, '${replace}');
                modified = true;
            }
        }
        if (modified) {
            dbs[collection].save(doc);
        }
    }
});
eof
}

function mongodb_check_connection() {
    if ! mongosh "${MONGODB_URI}" --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
        echo "Error: Unable to connect to MongoDB server with provided credentials." >&2
        return 1
    fi
}

function mongodb_check_database_exists() {
    local db="$1"
    if ! mongosh "${MONGODB_URI}" --eval "db.getSiblingDB('${db}').getCollectionNames()" > /dev/null 2>&1; then
        echo "Error: Database '${db}' does not exist." >&2
        return 1
    fi
}

function mongodb_export_database() {
    local db="$1"
    local output_file="$2"
    if [[ -z "${db}" || -z "${output_file}" ]]; then
        echo "Error: Missing arguments for mongodb_export_database." >&2
        return 1
    fi
    mongodump --uri="${MONGODB_URI}" --db="${db}" --out="${output_file}"
}
