#!/usr/bin/env zsh

# ============================================================
# BLANK NODE APPLICATION
# ============================================================

# ------------------------------------------------------------
# Configuration
# ------------------------------------------------------------

APP_TYPE="NODE"
NODE_VERSION="24"
BUILD_TOOL="VITE"
DATABASE="SQLITE"

# ------------------------------------------------------------
# Functions
# ------------------------------------------------------------

function check_node() {

    if ! command -v node >/dev/null 2>&1; then
        echo ""
        echo "Node.js is not installed."
        echo "Please install Node.js ${NODE_VERSION} LTS first."
        echo ""
        exit 1
    fi

    local NODE_MAJOR=$(node -v | sed 's/^v//' | cut -d. -f1)

    if (( NODE_MAJOR < 24 )); then
        echo ""
        echo "Node.js 24+ is required."
        echo "Current version: $(node -v)"
        echo ""
        exit 1
    fi
}

function create_directories() {

    mkdir -p \
        src/js \
        src/scss \
        public \
        storage/database \
        resources \
        tests
}

function create_files() {

    touch \
        src/js/app.js \
        src/scss/app.scss \
        .env \
        .env.example \
        .gitignore \
        README.md \
        vite.config.js
}

function configure_package() {

    npm pkg set type="module"
    npm pkg set private=true

    npm pkg set scripts.dev="vite"
    npm pkg set scripts.build="vite build"
    npm pkg set scripts.preview="vite preview"
    npm pkg set scripts.lint="eslint ."
    npm pkg set scripts.format="prettier --write ."
}

function install_dependencies() {

    echo ""
    echo "Installing application dependencies..."

    npm install \
        better-sqlite3 \
        dotenv
}

function install_dev_dependencies() {

    echo ""
    echo "Installing development dependencies..."

    npm install --save-dev \
        vite \
        sass \
        eslint \
        prettier
}

function create_gitignore() {

    cat > .gitignore <<'EOF'
node_modules/
dist/

.env
.env.*

!.env.example

storage/database/*.sqlite
storage/database/*.sqlite3

.DS_Store
*.log
EOF
}

function create_env_example() {

    cat > .env.example <<'EOF'
APP_NAME=
APP_ENV=development

DATABASE_PATH=storage/database/database.sqlite
EOF
}

function create_index() {

    cat > index.html <<'EOF'
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Application</title>
</head>

<body>

    <main id="app">
        <h1>Application</h1>
    </main>

    <script type="module" src="/src/js/app.js"></script>

</body>

</html>
EOF
}

function create_js() {

    cat > src/js/app.js <<'EOF'
import '../scss/app.scss';

console.log('Application started.');
EOF
}

function create_scss() {

    cat > src/scss/app.scss <<'EOF'
* {
    box-sizing: border-box;
}

html,
body {
    margin: 0;
    padding: 0;
}

body {
    font-family: sans-serif;
}
EOF
}

function create_vite_config() {

    cat > vite.config.js <<'EOF'
import { defineConfig } from 'vite';

export default defineConfig({
    server: {
        host: 'localhost',
        port: 5173
    }
});
EOF
}

function create_readme() {

    cat > README.md <<EOF
# ${APPNAME}

Node.js ${NODE_VERSION} application.

## Stack

- Node.js ${NODE_VERSION}
- Vite
- Sass
- better-sqlite3
- dotenv
- ESLint
- Prettier

## Development

\`\`\`bash
npm run dev
\`\`\`

## Build

\`\`\`bash
npm run build
\`\`\`

## Lint

\`\`\`bash
npm run lint
\`\`\`

## Format

\`\`\`bash
npm run format
\`\`\`
EOF
}

# ------------------------------------------------------------
# Start
# ------------------------------------------------------------

clear

echo "========================================"
echo "        BLANK NODE APPLICATION"
echo "========================================"
echo ""

check_node

# ------------------------------------------------------------
# Application Name
# ------------------------------------------------------------

read "APPNAME?Application name: "

if [[ -z "$APPNAME" ]]; then
    echo ""
    echo "Application name cannot be empty."
    exit 1
fi

# Convert application name to npm-safe name
NPMNAME=$(echo "$APPNAME" \
    | tr '[:upper:]' '[:lower:]' \
    | sed 's/[^a-z0-9_-]/-/g' \
    | sed 's/--*/-/g' \
    | sed 's/^-//' \
    | sed 's/-$//')

echo ""
echo "Application:"
echo "  Name: $APPNAME"
echo "  Package: $NPMNAME"
echo ""

# ------------------------------------------------------------
# Create Application
# ------------------------------------------------------------

if [[ -d "$APPNAME" ]]; then

    echo "Directory already exists:"
    echo "$APPNAME"
    echo ""

    exit 1
fi

mkdir "$APPNAME"

cd "$APPNAME" || exit 1

# ------------------------------------------------------------
# Initialize Node
# ------------------------------------------------------------

echo ""
echo "Initializing Node.js project..."

npm init -y

npm pkg set name="$NPMNAME"
npm pkg set version="0.1.0"
npm pkg set description="$APPNAME"

# ------------------------------------------------------------
# Configure
# ------------------------------------------------------------

echo ""
echo "Configuring project..."

configure_package

# ------------------------------------------------------------
# Directories
# ------------------------------------------------------------

echo ""
echo "Creating project structure..."

create_directories
create_files

# ------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------

install_dependencies
install_dev_dependencies

# ------------------------------------------------------------
# Starter Files
# ------------------------------------------------------------

echo ""
echo "Creating starter files..."

create_gitignore
create_env_example
create_index
create_js
create_scss
create_vite_config
create_readme

# ------------------------------------------------------------
# Git
# ------------------------------------------------------------

if command -v git >/dev/null 2>&1; then

    echo ""
    echo "Initializing Git..."

    git init
    git add .
    git commit -m "Initial project setup" >/dev/null 2>&1

fi

# ------------------------------------------------------------
# Complete
# ------------------------------------------------------------

echo ""
echo "========================================"
echo "        PROJECT CREATED"
echo "========================================"
echo ""

echo "Location:"
pwd

echo ""
echo "Node:"
node -v

echo "NPM:"
npm -v

echo ""
echo "Installed stack:"
echo "  ✓ Node.js"
echo "  ✓ Vite"
echo "  ✓ Sass"
echo "  ✓ better-sqlite3"
echo "  ✓ dotenv"
echo "  ✓ ESLint"
echo "  ✓ Prettier"

echo ""
echo "Next:"
echo ""
echo "  cd \"$APPNAME\""
echo "  npm run dev"
echo ""