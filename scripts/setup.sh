#!/bin/bash

# Update system
sudo dnf update -y

# Install Git
sudo dnf install -y git

# Install Apache
sudo dnf install -y httpd
sudo systemctl enable --now httpd

# Install PHP and common PHP plugins
sudo dnf install -y \
    php \
    php-cli \
    php-common \
    php-fpm \
    php-mysqlnd \
    php-gd \
    php-mbstring \
    php-xml \
    php-opcache

# Enable PHP-FPM
sudo systemctl enable --now php-fpm

# Install MariaDB
sudo dnf install -y mariadb105-server
sudo systemctl enable --now mariadb

# Install NFS utilities (needed for EFS/NFS mounts)
sudo dnf install -y nfs-utils

# Install CloudWatch Agent
sudo dnf install -y amazon-cloudwatch-agent

# Install/Update SSM Agent
sudo dnf install -y amazon-ssm-agent
sudo systemctl enable --now amazon-ssm-agent

# Install DNF configuration manager
sudo dnf install -y dnf-plugins-core

# Add HashiCorp repository
sudo dnf config-manager --add-repo \
    https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

# Install Terraform and Packer
sudo dnf install -y terraform packer

# Verify installations
git --version
httpd -v
php --version
mariadb --version
terraform --version
packer --version

# Verify services
sudo systemctl is-enabled httpd
sudo systemctl is-active httpd

sudo systemctl is-enabled mariadb
sudo systemctl is-active mariadb

sudo systemctl is-enabled php-fpm
sudo systemctl is-active php-fpm

sudo systemctl is-enabled amazon-ssm-agent
sudo systemctl is-active amazon-ssm-agent