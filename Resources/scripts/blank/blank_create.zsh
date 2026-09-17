#!/usr/bin/env zsh

echo "\n"
echo "Enter your App/Website's name : "
echo "=============================== "
read APPNAME_INPUT

local APPNAME="${(L)APPNAME_INPUT}"

if [[ -d "${APPNAME}" ]]; then

    clear

    echo "App/Website \"${APPNAME}\" already exists. Please choose a different name."

else

    echo "You typed : ${APPNAME}"

    # Create App Folder
    echo "Create & Enter App's Folder"
    mkdir ${APPNAME} && cd ${APPNAME}

    # Create Directories
    echo "\n"
    echo "Create folders: css, js, images"
    mkdir css js images

    sleep 1
    echo "\n"

    # Create CSS
    echo "Create app.css"
    touch css/app.css

    cat > css/app.css <<'EOF'
/* Reset */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: sans-serif;
    line-height: 1.6;
    color: #333;
}

.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
}
EOF

    sleep 1
    echo "\n"

    # Create JS
    echo "Create app.js"
    touch js/app.js

    cat > js/app.js <<'EOF'
document.addEventListener('DOMContentLoaded', function () {
    console.log('Application started.');
});
EOF

    sleep 1
    echo "\n"

    # Create index.html
    echo "Create index.html"
    touch index.html

    cat > index.html <<'EOF'
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Application</title>
    <link rel="stylesheet" href="css/app.css">
</head>

<body>

    <div class="container">
        <h1>Welcome to My Website</h1>
        <p>This is a blank website.</p>
    </div>

    <script src="js/app.js"></script>

</body>

</html>
EOF

    sleep 1
    echo "\n"

    # Create Database
    echo "Create Database ${MYSQL_USERNAME}, ${MYSQL_PASSWORD}, ${APPNAME}"
    mysql -u "${MYSQL_USERNAME}" --password="${MYSQL_PASSWORD}" -e 'CREATE DATABASE '${APPNAME}';'

    sleep 1
    echo "\n"

    # Valet Secure
    echo "Valet Secure"
    valet secure

    sleep 1
    echo "\n"

    # Create Data File
    echo "Create & Update Data file"
    cp ${RESOURCES_TEMPLATES_BLANK}/blank.zsh ${DATA_APPS}/${APPNAME}.zsh

    sleep 1

    sed_find_replace 'function blank() {' "function ${APPNAME}() {" "${DATA_APPS}/${APPNAME}.zsh"
    sed_find_replace 'APPNAME="APPNAME"' "APPNAME='"${APPNAME}"'" "${DATA_APPS}/${APPNAME}.zsh"

    sed_find_replace 'FRAMEWORK="FRAMEWORK"' 'FRAMEWORK="BLANK"' "${DATA_APPS}/${APPNAME}.zsh"

    sed_find_replace 'DBNAME="DBNAME"' "DBNAME='${APPNAME}'" "${DATA_APPS}/${APPNAME}.zsh"

    sed_find_replace 'DBUSER="DBUSER"' 'DBUSER="root"' "${DATA_APPS}/${APPNAME}.zsh"

    sed_find_replace 'DBPASS="DBPASS"' 'DBPASS="root"' "${DATA_APPS}/${APPNAME}.zsh"

    sed_find_replace 'DBTYPE="DBTYPE"' 'DBTYPE="MYSQL"' "${DATA_APPS}/${APPNAME}.zsh"

    sed_find_replace 'local DIR="${HOST_APPS}/blank"' "local DIR='"${HOST_APPS}/${APPNAME}"'" "${DATA_APPS}/${APPNAME}.zsh"

    source ~/.zshrc

fi
