#!/usr/bin/env zsh

# ============================================================
# PYTHON APPLICATION
# ============================================================

# ------------------------------------------------------------
# Configuration
# ------------------------------------------------------------

FRAMEWORK="PYTHON"
DATABASE="SQLITE"
PYTHON_MIN_VERSION="10"

# ------------------------------------------------------------
# Functions
# ------------------------------------------------------------

function check_python() {

    if ! command -v python3 >/dev/null 2>&1; then
        echo ""
        echo "Python 3 is not installed."
        echo "Please install Python 3.${PYTHON_MIN_VERSION}+ first."
        echo ""
        exit 1
    fi

    local PY_MINOR=$(python3 -c 'import sys; print(sys.version_info[1])')

    if (( PY_MINOR < PYTHON_MIN_VERSION )); then
        echo ""
        echo "Python 3.${PYTHON_MIN_VERSION}+ is required."
        echo "Current version: $(python3 --version)"
        echo ""
        exit 1
    fi
}

function clean_input() {

    # Strip carriage returns and surrounding whitespace so stray
    # terminal characters (e.g. \r) don't fall through a case match.
    local raw="${1}"
    raw="${raw//$'\r'/}"
    raw="${raw## }"
    raw="${raw%% }"
    echo "${raw}"
}

function select_app_type() {

    APPTYPE=""

    while [[ -z "${APPTYPE}" ]]; do

        echo ""
        echo "App Type : "
        echo "=========== "
        echo "1 = Python Desktop (Flask + HTMX + Tailwind + pywebview)"
        echo "2 = Desktop App (FastAPI + pywebview)"
        echo "3 = Web App"
        echo ""
        echo "Select App Type by Typing Number : "
        read APPTYPE_INPUT

        local CLEAN=$(clean_input "${APPTYPE_INPUT}")

        case "${CLEAN}" in
            "1" )
                APPTYPE="DESKTOP"
                PYFRAMEWORK="FLASK"
            ;;
            "2" )
                APPTYPE="DESKTOP"
                PYFRAMEWORK="FASTAPI"
            ;;
            "3" )
                APPTYPE="WEB"
            ;;
            * )
                echo ""
                echo "\"${APPTYPE_INPUT}\" is not a valid option. Type 1, 2 or 3."
            ;;
        esac

    done
}

function select_web_framework() {

    PYFRAMEWORK=""

    while [[ -z "${PYFRAMEWORK}" ]]; do

        echo ""
        echo "Web Framework : "
        echo "================ "
        echo "1 = Django"
        echo "2 = FastAPI"
        echo ""
        echo "Select Framework by Typing Number : "
        read PYFRAMEWORK_INPUT

        local CLEAN=$(clean_input "${PYFRAMEWORK_INPUT}")

        case "${CLEAN}" in
            "1" )
                PYFRAMEWORK="DJANGO"
            ;;
            "2" )
                PYFRAMEWORK="FASTAPI"
            ;;
            * )
                echo ""
                echo "\"${PYFRAMEWORK_INPUT}\" is not a valid option. Type 1 or 2."
            ;;
        esac

    done
}

function create_venv() {

    echo ""
    echo "Creating virtual environment..."
    python3 -m venv venv

    source venv/bin/activate

    pip install --upgrade pip >/dev/null
}

function create_gitignore() {

    cat > .gitignore <<'EOF'
venv/
__pycache__/
*.pyc

.env
.env.*

!.env.example

db/*.sqlite
db/*.sqlite3
*.sqlite3

.DS_Store
*.log
EOF
}

function create_env_example() {

    cat > .env.example <<EOF
APP_NAME=${APPNAME}
APP_ENV=development

DATABASE_PATH=db/${APPNAME}.sqlite
EOF

    cp .env.example .env
}

function create_readme() {

    cat > README.md <<EOF
# ${APPNAME}

Python application (${APPTYPE}${PYFRAMEWORK:+ / $PYFRAMEWORK}).

## Stack

- Python 3.${PYTHON_MIN_VERSION}+
- ${PYFRAMEWORK}
- SQLite
EOF

    if [[ "${APPTYPE}" == "DESKTOP" && "${PYFRAMEWORK}" == "FLASK" ]]; then
        cat >> README.md <<'EOF'

- HTMX
- Tailwind CSS (standalone CLI)
- pywebview
- PySide6 / Qt
EOF
    fi

    cat >> README.md <<EOF

## Setup

\`\`\`bash
source venv/bin/activate
pip install -r requirements.txt
\`\`\`

\`\`\`bash
source venv/bin/activate
pip install -r requirements.txt
\`\`\`

## Run

$(create_readme_run_instructions)
EOF
}

function create_readme_run_instructions() {

    case "${APPTYPE}" in
        "DESKTOP" )
            if [[ "${PYFRAMEWORK}" == "FLASK" ]]; then
                echo '```bash'
                echo './tailwind_watch.zsh'
                echo '```'
                echo ''
                echo 'Then, in another terminal:'
                echo '```bash'
                echo './run_desktop.zsh'
                echo '```'
            else
                echo '```bash'
                echo 'python run_desktop.py'
                echo '```'
            fi
        ;;
        "WEB" )
            case "${PYFRAMEWORK}" in
                "DJANGO" )
                    echo '```bash'
                    echo 'python manage.py runserver'
                    echo '```'
                ;;
                "FASTAPI" )
                    echo '```bash'
                    echo 'uvicorn app.main:app --reload'
                    echo '```'
                ;;
            esac
        ;;
    esac
}

function create_git() {

    if command -v git >/dev/null 2>&1; then

        echo ""
        echo "Initializing Git..."

        git init >/dev/null
        git add .
        git commit -m "Initial project setup" >/dev/null 2>&1

    fi
}

# --- Desktop: Flask + HTMX + Tailwind + pywebview ----------------

function scaffold_python_desktop() {

    echo ""
    echo "Creating Python Desktop project structure..."

    mkdir -p \
        app/static/css \
        app/static/js \
        app/templates \
        db \
        tests

    touch app/__init__.py

    # ------------------------------------------------------------
    # Flask application
    # ------------------------------------------------------------

    cat > app.py <<'EOF'
import sqlite3
import threading

import webview
from flask import Flask, render_template, request

app = Flask(__name__)

DATABASE = "db/APPDB.sqlite"


def get_db():
    connection = sqlite3.connect(DATABASE)
    connection.row_factory = sqlite3.Row
    return connection


def init_db():
    connection = get_db()

    connection.execute("""
        CREATE TABLE IF NOT EXISTS projects (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            client TEXT NOT NULL,
            status TEXT NOT NULL DEFAULT 'Planning'
        )
    """)

    connection.commit()
    connection.close()


@app.route("/")
def index():
    connection = get_db()

    projects = connection.execute("""
        SELECT *
        FROM projects
        ORDER BY id DESC
    """).fetchall()

    connection.close()

    return render_template("index.html", projects=projects)


@app.route("/projects/add", methods=["POST"])
def add_project():

    name = request.form["name"]
    client = request.form["client"]

    connection = get_db()

    connection.execute("""
        INSERT INTO projects (name, client)
        VALUES (?, ?)
    """, (name, client))

    connection.commit()

    projects = connection.execute("""
        SELECT *
        FROM projects
        ORDER BY id DESC
    """).fetchall()

    connection.close()

    return render_template("projects.html", projects=projects)


@app.route("/projects/delete/<int:project_id>", methods=["DELETE"])
def delete_project(project_id):

    connection = get_db()

    connection.execute("""
        DELETE FROM projects
        WHERE id = ?
    """, (project_id,))

    connection.commit()
    connection.close()

    return "", 200


def start_server():

    app.run(
        host="127.0.0.1",
        port=5000,
        debug=False,
        use_reloader=False
    )


if __name__ == "__main__":

    init_db()

    server = threading.Thread(
        target=start_server,
        daemon=True
    )

    server.start()

    webview.create_window(
        "APPNAME",
        "http://127.0.0.1:5000",
        width=1200,
        height=800,
        min_size=(900, 600)
    )

    webview.start(gui="qt")
EOF

    sed_find_replace "APPNAME" "${APPNAME}" "app.py"
    sed_find_replace "APPDB" "${APPNAME}" "app.py"

    # ------------------------------------------------------------
    # HTML / Jinja / HTMX
    # ------------------------------------------------------------

    cat > app/templates/index.html <<'EOF'
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>APPNAME</title>

    <link
        rel="stylesheet"
        href="{{ url_for('static', filename='css/app.css') }}"
    >

    <script
        src="{{ url_for('static', filename='js/htmx.min.js') }}"
    ></script>
</head>

<body class="min-h-screen bg-slate-100 text-slate-900">

    <header class="border-b bg-white">

        <div class="mx-auto flex max-w-6xl items-center justify-between px-6 py-4">

            <div>
                <h1 class="text-xl font-bold">
                    APPNAME
                </h1>

                <p class="text-sm text-slate-500">
                    Python Desktop Application
                </p>
            </div>

            <div class="rounded-lg bg-slate-100 px-3 py-2 text-sm">
                Flask + HTMX + Tailwind
            </div>

        </div>

    </header>

    <main class="mx-auto max-w-6xl px-6 py-10">

        <div class="mb-8">

            <h2 class="text-3xl font-bold">
                Projects
            </h2>

            <p class="mt-2 text-slate-500">
                A local desktop application powered by Python.
            </p>

        </div>

        <div class="mb-8 rounded-xl border bg-white p-6 shadow-sm">

            <h3 class="mb-4 text-lg font-semibold">
                Add Project
            </h3>

            <form
                hx-post="/projects/add"
                hx-target="#project-list"
                hx-swap="innerHTML"
                class="grid gap-4 md:grid-cols-3"
            >

                <input
                    type="text"
                    name="name"
                    placeholder="Project name"
                    required
                    class="rounded-lg border px-4 py-3 outline-none focus:border-slate-500"
                >

                <input
                    type="text"
                    name="client"
                    placeholder="Client name"
                    required
                    class="rounded-lg border px-4 py-3 outline-none focus:border-slate-500"
                >

                <button
                    type="submit"
                    class="rounded-lg bg-slate-900 px-4 py-3 font-medium text-white hover:bg-slate-700"
                >
                    Add Project
                </button>

            </form>

        </div>

        <div id="project-list" class="grid gap-4">

            {% include "projects.html" %}

        </div>

    </main>

</body>

</html>
EOF

    sed_find_replace "APPNAME" "${APPNAME}" "app/templates/index.html"

    cat > app/templates/projects.html <<'EOF'
{% if projects %}

    {% for project in projects %}

        <div
            id="project-{{ project.id }}"
            class="flex items-center justify-between rounded-xl border bg-white p-5 shadow-sm"
        >

            <div>

                <h3 class="font-semibold">
                    {{ project.name }}
                </h3>

                <p class="mt-1 text-sm text-slate-500">
                    {{ project.client }}
                </p>

            </div>

            <div class="flex items-center gap-4">

                <span class="rounded-full bg-blue-100 px-3 py-1 text-xs font-medium text-blue-700">
                    {{ project.status }}
                </span>

                <button
                    hx-delete="/projects/delete/{{ project.id }}"
                    hx-target="#project-{{ project.id }}"
                    hx-swap="outerHTML"
                    class="rounded-lg border px-3 py-2 text-sm text-red-600 hover:bg-red-50"
                >
                    Delete
                </button>

            </div>

        </div>

    {% endfor %}

{% else %}

    <div class="rounded-xl border border-dashed bg-white p-12 text-center">

        <h3 class="font-semibold">
            No projects yet
        </h3>

        <p class="mt-2 text-sm text-slate-500">
            Add your first project above.
        </p>

    </div>

{% endif %}
EOF

    # ------------------------------------------------------------
    # Tailwind source and generated CSS
    # ------------------------------------------------------------

    cat > app/static/css/input.css <<'EOF'
@import "tailwindcss";

@source "../../templates";
EOF

    # ------------------------------------------------------------
    # Download Tailwind standalone CLI
    # ------------------------------------------------------------

    echo ""
    echo "Downloading Tailwind CSS standalone CLI..."

    local TAILWIND_ARCH=""

    case "$(uname -m)" in
        "x86_64" )
            TAILWIND_ARCH="x64"
        ;;
        "aarch64" | "arm64" )
            TAILWIND_ARCH="arm64"
        ;;
        * )
            echo ""
            echo "Unsupported CPU architecture: $(uname -m)"
            echo "Tailwind standalone CLI download cannot continue."
            exit 1
        ;;
    esac

    curl -fL \
        "https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-${TAILWIND_ARCH}" \
        -o tailwindcss

    chmod +x tailwindcss

    echo ""
    echo "Tailwind:"
    ./tailwindcss --help >/dev/null

    # ------------------------------------------------------------
    # Download HTMX locally
    # ------------------------------------------------------------

    echo ""
    echo "Downloading HTMX..."

    curl -fL \
        "https://unpkg.com/htmx.org@2.0.4/dist/htmx.min.js" \
        -o app/static/js/htmx.min.js

    # ------------------------------------------------------------
    # Tailwind build/watch helper
    # ------------------------------------------------------------

    cat > tailwind_watch.zsh <<'EOF'
#!/usr/bin/env zsh

./tailwindcss \
    -i ./app/static/css/input.css \
    -o ./app/static/css/app.css \
    --watch
EOF

    chmod +x tailwind_watch.zsh

    echo ""
    echo "Building Tailwind CSS..."

    ./tailwindcss \
        -i ./app/static/css/input.css \
        -o ./app/static/css/app.css \
        --minify

    # ------------------------------------------------------------
    # Desktop run helper
    # ------------------------------------------------------------

    cat > run_desktop.zsh <<'EOF'
#!/usr/bin/env zsh

source venv/bin/activate

python app.py
EOF

    chmod +x run_desktop.zsh

    # ------------------------------------------------------------
    # Dependencies
    # ------------------------------------------------------------

    cat > requirements.txt <<'EOF'
Flask
pywebview
PySide6
qtpy
python-dotenv
EOF

    echo ""
    echo "Installing Python dependencies..."
    pip install -r requirements.txt

    echo ""
    echo "Creating SQLite database..."

    sqlite_create "db/${APPNAME}.sqlite"

    echo ""
    echo "Python Desktop stack created:"
    echo "  - Flask"
    echo "  - Jinja"
    echo "  - HTMX (local)"
    echo "  - Tailwind CSS (local standalone CLI)"
    echo "  - SQLite"
    echo "  - pywebview"
    echo "  - PySide6 / Qt"
}


function scaffold_desktop() {

    echo ""
    echo "Creating project structure..."

    mkdir -p \
        app/static/css \
        app/static/js \
        app/templates \
        db \
        tests

    touch app/__init__.py

    cat > app/main.py <<'EOF'
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.requests import Request

from app.database import get_connection

app = FastAPI()

app.mount("/static", StaticFiles(directory="app/static"), name="static")
templates = Jinja2Templates(directory="app/templates")


@app.get("/")
def index(request: Request):
    return templates.TemplateResponse(request, "index.html", {})
EOF

    cat > app/database.py <<'EOF'
import sqlite3
from pathlib import Path

DB_PATH = Path(__file__).resolve().parent.parent / "db" / "DBFILENAME"


def get_connection():
    connection = sqlite3.connect(DB_PATH)
    connection.row_factory = sqlite3.Row
    return connection
EOF

    sed_find_replace "DBFILENAME" "${APPNAME}.sqlite" "app/database.py"

    cat > app/templates/index.html <<'EOF'
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Application</title>
    <link rel="stylesheet" href="/static/css/app.css">
</head>

<body>

    <main id="app">
        <h1>Application</h1>
    </main>

    <script src="/static/js/app.js"></script>

</body>

</html>
EOF

    cat > app/static/css/app.css <<'EOF'
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

    cat > app/static/js/app.js <<'EOF'
console.log('Application started.');
EOF

    cat > run_desktop.py <<'EOF'
import threading

import uvicorn
import webview

from app.main import app


def start_server():
    uvicorn.run(app, host="127.0.0.1", port=8000, log_level="warning")


if __name__ == "__main__":
    server_thread = threading.Thread(target=start_server, daemon=True)
    server_thread.start()

    webview.create_window("Application", "http://127.0.0.1:8000")
    # Force the Qt backend explicitly (via PySide6) so pywebview doesn't
    # spend time probing for GTK first and printing scary-looking errors.
    webview.start(gui="qt")
EOF

    cat > requirements.txt <<'EOF'
fastapi
uvicorn
pywebview
pyside6
qtpy
jinja2
python-multipart
python-dotenv
EOF

    echo ""
    echo "Installing dependencies (this includes PySide6, which is a large"
    echo "download - it gives pywebview a Qt backend that works out of the"
    echo "box on Linux/Mac/Windows without needing system GTK packages)..."
    pip install -r requirements.txt

    echo ""
    echo "Creating SQLite database..."
    sqlite_create "db/${APPNAME}.sqlite"
}

# --- Web: FastAPI ------------------------------------------------

function scaffold_fastapi() {

    echo ""
    echo "Creating project structure..."

    mkdir -p \
        app/static/css \
        app/static/js \
        app/templates \
        db \
        tests

    touch app/__init__.py

    cat > app/main.py <<'EOF'
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.requests import Request

from app.database import get_connection

app = FastAPI()

app.mount("/static", StaticFiles(directory="app/static"), name="static")
templates = Jinja2Templates(directory="app/templates")


@app.get("/")
def index(request: Request):
    return templates.TemplateResponse(request, "index.html", {})
EOF

    cat > app/database.py <<'EOF'
import sqlite3
from pathlib import Path

DB_PATH = Path(__file__).resolve().parent.parent / "db" / "DBFILENAME"


def get_connection():
    connection = sqlite3.connect(DB_PATH)
    connection.row_factory = sqlite3.Row
    return connection
EOF

    sed_find_replace "DBFILENAME" "${APPNAME}.sqlite" "app/database.py"

    cat > app/templates/index.html <<'EOF'
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Application</title>
    <link rel="stylesheet" href="/static/css/app.css">
</head>

<body>

    <main id="app">
        <h1>Application</h1>
    </main>

    <script src="/static/js/app.js"></script>

</body>

</html>
EOF

    cat > app/static/css/app.css <<'EOF'
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

    cat > app/static/js/app.js <<'EOF'
console.log('Application started.');
EOF

    cat > requirements.txt <<'EOF'
fastapi
uvicorn
jinja2
python-multipart
python-dotenv
EOF

    echo ""
    echo "Installing dependencies..."
    pip install -r requirements.txt >/dev/null

    echo ""
    echo "Creating SQLite database..."
    sqlite_create "db/${APPNAME}.sqlite"
}

# --- Web: Django ---------------------------------------------------

function scaffold_django() {

    echo ""
    echo "Installing Django..."

    cat > requirements.txt <<'EOF'
django
python-dotenv
EOF

    pip install -r requirements.txt >/dev/null

    echo ""
    echo "Creating project structure..."

    django-admin startproject config .

    mkdir -p db

    # Point Django's SQLite database at db/<appname>.sqlite
    sed_find_replace "'NAME': BASE_DIR / 'db.sqlite3'," "'NAME': BASE_DIR / 'db' / '${APPNAME}.sqlite'," "config/settings.py"

    echo ""
    echo "Creating SQLite database..."
    python manage.py migrate
}

# ------------------------------------------------------------
# Start
# ------------------------------------------------------------

clear

echo "========================================"
echo "        PYTHON APPLICATION"
echo "========================================"

check_python

# ------------------------------------------------------------
# Application Name
# ------------------------------------------------------------

echo ""
echo "Enter your App's name : "
echo "======================= "
read APPNAME_INPUT

local APPNAME="${(L)APPNAME_INPUT}"

if [[ -z "${APPNAME}" ]]; then
    echo ""
    echo "Application name cannot be empty."
    exit 1
fi

if [[ -d "${APPNAME}" ]]; then

    clear

    echo "App \"${APPNAME}\" already exists. Please choose a different name."

else

    echo ""
    echo "App: ${APPNAME}"

    # ------------------------------------------------------------
    # App Type / Framework
    # ------------------------------------------------------------

    local APPTYPE=""
    local PYFRAMEWORK=""

    select_app_type

    if [[ "${APPTYPE}" == "WEB" ]]; then
        select_web_framework
    fi

    echo ""
    echo "App Type: ${APPTYPE}"
    echo "Framework: ${PYFRAMEWORK}"

    # ------------------------------------------------------------
    # Create App
    # ------------------------------------------------------------

    mkdir "${APPNAME}" && cd "${APPNAME}"

    create_venv

    case "${APPTYPE}" in
        "DESKTOP" )
            if [[ "${PYFRAMEWORK}" == "FLASK" ]]; then
                scaffold_python_desktop
            else
                scaffold_desktop
            fi
        ;;
        "WEB" )
            case "${PYFRAMEWORK}" in
                "DJANGO" )
                    scaffold_django
                ;;
                "FASTAPI" )
                    scaffold_fastapi
                ;;
            esac
        ;;
    esac

    # ------------------------------------------------------------
    # Starter Files
    # ------------------------------------------------------------

    echo ""
    echo "Creating starter files..."

    create_gitignore
    create_env_example
    create_readme
    create_git

    # ------------------------------------------------------------
    # Create & Update Data file
    # ------------------------------------------------------------

    echo ""
    echo "Create & Update Data file"
    cp ${RESOURCES_TEMPLATES_PYTHON}/python.zsh ${DATA_APPS}/${APPNAME}.zsh

    sed_find_replace 'function python() {' "function ${APPNAME}() {" "${DATA_APPS}/${APPNAME}.zsh"
    sed_find_replace 'APPNAME="APPNAME"' "APPNAME='"${APPNAME}"'" "${DATA_APPS}/${APPNAME}.zsh"
    sed_find_replace 'FRAMEWORK="FRAMEWORK"' 'FRAMEWORK="PYTHON"' "${DATA_APPS}/${APPNAME}.zsh"
    sed_find_replace 'APPTYPE="APPTYPE"' "APPTYPE='${APPTYPE}'" "${DATA_APPS}/${APPNAME}.zsh"
    sed_find_replace 'PYFRAMEWORK="PYFRAMEWORK"' "PYFRAMEWORK='${PYFRAMEWORK}'" "${DATA_APPS}/${APPNAME}.zsh"
    sed_find_replace 'DBNAME="DBNAME"' "DBNAME='${APPNAME}'" "${DATA_APPS}/${APPNAME}.zsh"
    sed_find_replace 'DBUSER="DBUSER"' 'DBUSER="-"' "${DATA_APPS}/${APPNAME}.zsh"
    sed_find_replace 'DBPASS="DBPASS"' 'DBPASS="-"' "${DATA_APPS}/${APPNAME}.zsh"
    sed_find_replace 'DBTYPE="DBTYPE"' 'DBTYPE="SQLITE"' "${DATA_APPS}/${APPNAME}.zsh"
    sed_find_replace 'local DIR="${HOST_APPS}/python"' "local DIR='"${HOST_APPS}/${APPNAME}"'" "${DATA_APPS}/${APPNAME}.zsh"

    source ~/.zshrc

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
    echo "Python:"
    python3 --version

    echo ""
    echo "Installed stack:"
    echo "  - Python 3"
    echo "  - ${PYFRAMEWORK}"
    echo "  - SQLite (db/${APPNAME}.sqlite)"

    if [[ "${APPTYPE}" == "DESKTOP" && "${PYFRAMEWORK}" == "FLASK" ]]; then
        echo "  - HTMX (local)"
        echo "  - Tailwind CSS (local standalone CLI)"
        echo "  - pywebview"
        echo "  - PySide6 / Qt"
    fi

    echo ""
    echo "Next:"
    echo ""
    echo "  ${APPNAME}"
    echo "  ${APPNAME} venv"
    echo "  ${APPNAME} run"
    echo ""

fi
