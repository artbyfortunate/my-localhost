# Wordpress CLI
function wordpress_cli() {

    # Reviews current WP-CLI info, checks for updates, or views defined aliases.
    wp cli
}

# Wordpress Config
function wordpress_config() {

    # Generates and reads the wp-config.php file.
    wp config
}

# Wordpress Core
function wordpress_core() {

    # Downloads, installs, updates, and manages a WordPress installation.
    wp core ${1}
}

# Wordpress Database
function wordpress_database() {

    # Performs basic database operations using credentials stored in wp-config.php.
    wp db
}