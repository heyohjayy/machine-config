```bash
#!/usr/bin/env bash

# =========================================================
# DEVOPS WORKSTATION CONFIGURATION SCRIPT
# Ubuntu 22.04 / 24.04
# =========================================================

# Exit immediately if a command fails
# Treat unset variables as errors
# Catch failures inside pipelines
set -euo pipefail

# =========================================================
# VARIABLES
# =========================================================

LOG_FILE="/var/log/workstation-bootstrap.log"

# =========================================================
# LOGGING FUNCTION
# =========================================================

log() {
    echo "$(date '+%d-%m-%Y %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# =========================================================
# ENSURE SCRIPT RUNS AS ROOT
# =========================================================

if [[ $EUID -ne 0 ]]; then
    echo "Please run this script with sudo."
    exit 1
fi

# =========================================================
# COMMAND EXECUTION FUNCTION
# =========================================================

run_command() {
    log "Running: $1"
    eval "$1"
}

# =========================================================
# UPDATE SYSTEM
# =========================================================

update_system() {
    log "Updating package lists..."
    run_command "apt-get update -y"

    log "Upgrading installed packages..."
    run_command "apt-get upgrade -y"
}

# =========================================================
# INSTALL PACKAGE IF NOT INSTALLED
# =========================================================

install_package() {
    local package="$1"

    if dpkg -s "$package" >/dev/null 2>&1; then
        log "$package is already installed. Skipping."
    else
        log "Installing $package..."
        run_command "apt-get install $package -y"
    fi
}

# =========================================================
# ENABLE AND START SERVICES
# =========================================================

enable_service() {
    local service="$1"

    if systemctl is-active --quiet "$service"; then
        log "$service service is already running."
    else
        log "Starting $service service..."
        run_command "systemctl start $service"
    fi

    if systemctl is-enabled --quiet "$service"; then
        log "$service service is already enabled."
    else
        log "Enabling $service service..."
        run_command "systemctl enable $service"
    fi
}

# =========================================================
# INSTALL CORE UTILITIES
# =========================================================

install_core_tools() {
    TOOLS=(
        curl
        wget
        git
        vim
        nano
        tree
        unzip
        htop
        jq
        net-tools
        software-properties-common
        apt-transport-https
        ca-certificates
        gnupg
        lsb-release
    )

    for tool in "${TOOLS[@]}"; do
        install_package "$tool"
    done
}

# =========================================================
# INSTALL DOCKER
# =========================================================

install_docker() {
    if command -v docker >/dev/null 2>&1; then
        log "Docker already installed. Skipping."
    else
        log "Installing Docker..."
        run_command "apt-get install docker.io -y"
    fi

    enable_service docker

    log "Adding current user to docker group..."
    usermod -aG docker "${SUDO_USER:-ubuntu}"
}

# =========================================================
# INSTALL NGINX
# =========================================================

install_nginx() {
    install_package nginx
    enable_service nginx
}

# =========================================================
# INSTALL APACHE
# =========================================================

install_apache() {
    install_package apache2
    enable_service apache2
}

# =========================================================
# INSTALL MYSQL
# =========================================================

install_mysql() {
    install_package mysql-server
    enable_service mysql
}

# =========================================================
# INSTALL PHP
# =========================================================

install_php() {
    PHP_PACKAGES=(
        php
        php-cli
        php-common
        php-mysql
        libapache2-mod-php
    )

    for package in "${PHP_PACKAGES[@]}"; do
        install_package "$package"
    done
}

# =========================================================
# INSTALL SECURITY TOOLS
# =========================================================

install_security_tools() {
    SECURITY_TOOLS=(
        ufw
        fail2ban
        unattended-upgrades
    )

    for tool in "${SECURITY_TOOLS[@]}"; do
        install_package "$tool"
    done
}

# =========================================================
# CONFIGURE FIREWALL
# =========================================================

configure_firewall() {
    log "Allowing SSH..."
    run_command "ufw allow 22/tcp"

    log "Allowing HTTP..."
    run_command "ufw allow 80/tcp"

    log "Allowing HTTPS..."
    run_command "ufw allow 443/tcp"

    log "Allowing MySQL..."
    run_command "ufw allow 3306/tcp"

    log "Enabling firewall..."
    run_command "ufw --force enable"
}

# =========================================================
# CREATE TEST WEB PAGE
# =========================================================

create_test_page() {
    log "Creating test web page..."

    cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>DevOps Workstation</title>
</head>
<body>
    <h1>DevOps Machine Configuration Successful</h1>
    <p>Apache and PHP are operational.</p>
</body>
</html>
EOF
}

# =========================================================
# DISPLAY FINAL STATUS
# =========================================================

final_report() {
    log "Generating final system report..."

    echo
    echo "========== SERVICE STATUS =========="

    systemctl is-active docker
    systemctl is-active nginx
    systemctl is-active apache2
    systemctl is-active mysql

    echo
    echo "========== OPEN PORTS =========="

    ss -tuln

    echo
    echo "========== FIREWALL STATUS =========="

    ufw status
}

# =========================================================
# MAIN EXECUTION FLOW
# =========================================================

main() {
    log "Starting DevOps workstation configuration..."

    update_system

    install_core_tools

    install_docker

    install_nginx

    install_apache

    install_mysql

    install_php

    install_security_tools

    configure_firewall

    create_test_page

    final_report

    log "DevOps workstation configuration completed successfully."
}

# =========================================================
# RUN MAIN FUNCTION
# =========================================================

main
```

