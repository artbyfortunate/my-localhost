# Valet Start
function valet_start() {

    # Start the Valet services
    valet start
}

# Valet Stop
function valet_stop() {

    # Stop the Valet services
    valet stop
}

# Valet Domain
function valet_domain() {

    # Get or set the domain used for Valet sites
    valet domain ${1}
}

# Valet Forget
function valet_forget() {

    # Remove the current working (or specified) directory from Valet's list of paths
    valet forget

}

# Valet Install
function valet_install() {

    # Install the Valet services
    valet install
}

# Valet Link
function valet_link() {

    # Link the current working directory to Valet
    valet link
}

# Valet Links
function valet_links() {

    # Display all of the registered Valet links
    valet links
}

# Valet Open
function valet_open() {

    # Open the site for the current (or specified) directory in your browser
    valet open
}

# Valet Park
function valet_park() {
    # Register the current working (or specified) directory with Valet
    valet park
}

# Valet Paths
function valet_paths() {

    # Get all of the paths registered with Valet
    valet paths
}

# Valet Port
function valet_port() {

    # Get or set the port number used for Valet sites
    valet port
}

# Valet Restart
function valet_restart() {

    # Restart the Valet services
    valet restart
}

# Valet Secure
function valet_secure() {

    # Secure the given domain with a trusted TLS certificate
    valet secure
}

# Valet Unsecure
function valet_unsecure() {

    # Stop serving the given domain over HTTPS and remove the trusted TLS certificate
    valet unsecure
}

# Valet Update
function valet_update() {

    # Update Valet Linux and clean up cruft
    valet update
}

# Valet Which
function valet_which() {

    # Determine which Valet driver serves the current working directory
    valet which
}