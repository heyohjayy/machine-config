# DevOps Workstation Configuration Script

Production-grade Ubuntu workstation and server configuration script built with Bash.

This project automates the setup and configuration of a Linux machine for DevOps engineering workflows and LAMP stack deployments.

The script installs and configures essential development tools, containerisation platforms, web servers, database services, PHP runtime components, firewall security, and monitoring utilities.

---

## Features

- System update and upgrade
- Docker installation and configuration
- Nginx installation and configuration
- Apache installation and configuration
- MySQL installation and configuration
- PHP installation with Apache integration
- Core DevOps utilities installation
- Firewall configuration using UFW
- Fail2ban installation
- Unattended security upgrades
- Automatic service management
- Logging system
- Idempotent package installation
- Test web page deployment
- Final infrastructure status reporting

---

## Technologies Used

- Bash
- Ubuntu 22.04 / 24.04
- Docker
- Apache
- Nginx
- MySQL
- PHP
- UFW
- Fail2ban
- Git

---

## Installed Components

### Core Utilities

- curl
- wget
- git
- vim
- nano
- tree
- unzip
- htop
- jq

### Infrastructure Services

- Docker
- Nginx
- Apache2
- MySQL

### PHP Components

- php
- php-cli
- php-common
- php-mysql
- libapache2-mod-php

### Security Components

- UFW
- Fail2ban
- unattended-upgrades

---

## Usage

```bash
sudo ./workstation-bootstrap.sh
