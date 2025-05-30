#!/bin/bash

# Ansible/AWX Project Structure Initialization Script
# Creates a complete project structure following Ansible best practices
# Author: Ansible Expert
# Version: 2.0

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Set project root to parent directory of scripts/
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Function to print colored output
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to create directory and add .donotdelete file
create_dir_with_placeholder() {
    local dir_path=$1
    mkdir -p "$PROJECT_ROOT/$dir_path"
    touch "$PROJECT_ROOT/$dir_path/.donotdelete"
    print_message "$GREEN" "✓ Created: $dir_path"
}

# Function to create file with content
create_file() {
    local file_path=$1
    local content=$2
    echo "$content" > "$PROJECT_ROOT/$file_path"
    print_message "$BLUE" "✓ Created file: $file_path"
}

# Main execution
print_message "$YELLOW" "=== Ansible/AWX Project Structure Generator ==="
print_message "$YELLOW" "Creating structure in: $PROJECT_ROOT"
echo ""

# Create main directories
print_message "$YELLOW" "Creating directory structure..."

# Collections directory (for custom collections)
create_dir_with_placeholder "collections/ansible_collections"

# Group variables
create_dir_with_placeholder "group_vars/all"
create_dir_with_placeholder "group_vars/production"
create_dir_with_placeholder "group_vars/staging"
create_dir_with_placeholder "group_vars/development"

# Host variables
create_dir_with_placeholder "host_vars"

# Inventory directories
create_dir_with_placeholder "inventory/production"
create_dir_with_placeholder "inventory/staging"
create_dir_with_placeholder "inventory/development"

# Playbooks directory
create_dir_with_placeholder "playbooks"

# Roles directory
create_dir_with_placeholder "roles"

# Custom modules
create_dir_with_placeholder "library"

# Custom plugins
create_dir_with_placeholder "plugins/action"
create_dir_with_placeholder "plugins/callback"
create_dir_with_placeholder "plugins/connection"
create_dir_with_placeholder "plugins/filter"
create_dir_with_placeholder "plugins/lookup"
create_dir_with_placeholder "plugins/vars"

# Templates directory (global)
create_dir_with_placeholder "templates"

# Files directory (global)
create_dir_with_placeholder "files"

# Documentation
create_dir_with_placeholder "docs"

# Tests directory
create_dir_with_placeholder "tests/integration"
create_dir_with_placeholder "tests/unit"

# AWX specific directories
create_dir_with_placeholder "awx/job_templates"
create_dir_with_placeholder "awx/workflows"
create_dir_with_placeholder "awx/credentials"
create_dir_with_placeholder "awx/projects"
create_dir_with_placeholder "awx/inventories"

# Molecule testing
create_dir_with_placeholder "molecule/default"

# Vault directory for encrypted files
create_dir_with_placeholder "vault"

# Creating essential files
print_message "$YELLOW" "Creating configuration files..."

# ansible.cfg
create_file "ansible.cfg" "[defaults]
# Basic configuration
inventory = inventory/development/hosts.yml
roles_path = roles:galaxy_roles
collections_path = ./collections
host_key_checking = False
retry_files_enabled = False
stdout_callback = yaml
callback_whitelist = timer, profile_tasks, profile_roles
gathering = smart
fact_caching = jsonfile
fact_caching_connection = .ansible_cache
fact_caching_timeout = 86400

# Performance tuning
forks = 50
pipelining = True

# SSH connection
[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no
control_path = /tmp/ansible-ssh-%%h-%%p-%%r

# Persistent connection
[persistent_connection]
connect_timeout = 30
command_timeout = 30

# AWX/Tower specific
[galaxy]
server_list = galaxy

[galaxy_server.galaxy]
url = https://galaxy.ansible.com/"

# requirements.yml for roles
create_file "requirements.yml" "---
# Ansible Galaxy requirements
# Install with: ansible-galaxy install -r requirements.yml

roles: []
  # - name: geerlingguy.docker
  #   version: 4.1.0
  # - name: geerlingguy.postgresql
  #   version: 3.4.0

collections: []
  # - name: community.general
  #   version: '>=5.0.0'
  # - name: ansible.posix
  #   version: '>=1.4.0'
  # - name: community.docker
  #   version: '>=3.0.0'"

# .gitignore
create_file ".gitignore" "# Ansible files
*.retry
.ansible_cache/
.ansible_facts/

# Vault passwords
.vault_pass
.vault_pass.txt
vault_pass*
*.vault

# Python
__pycache__/
*.py[cod]
*\$py.class
*.pyc
venv/
.env

# IDE
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# Logs and temp files
*.log
*.tmp
*.bak
*.orig

# SSH keys
*.pem
*.key
id_rsa*
id_dsa*

# Test files
.molecule/
.pytest_cache/
.coverage

# AWX/Tower
tower-cli.cfg
.tower_cli.cfg

# Downloaded roles
galaxy_roles/
roles/*
!roles/.gitkeep
!roles/requirements.yml
!roles/ansible-updates/

# Terraform
*.tfstate
*.tfstate.*
.terraform/

# Custom
local/
private/
secrets/"

# Get project name from directory
PROJECT_NAME=$(basename "$PROJECT_ROOT")

# README.md
create_file "README.md" "# $PROJECT_NAME

An Ansible project following best practices for configuration management and automation.

## Project Structure

\`\`\`
$PROJECT_NAME/
├── ansible.cfg              # Ansible configuration
├── requirements.yml         # Galaxy roles and collections
├── site.yml                # Main playbook
├── awx/                    # AWX/Tower specific configurations
├── collections/            # Custom Ansible collections
├── docs/                   # Documentation
├── files/                  # Static files
├── group_vars/             # Group variables
│   ├── all/               # Variables for all hosts
│   ├── production/        # Production environment
│   ├── staging/           # Staging environment
│   └── development/       # Development environment
├── host_vars/              # Host-specific variables
├── inventory/              # Inventory files
│   ├── production/        # Production inventory
│   ├── staging/           # Staging inventory
│   └── development/       # Development inventory
├── library/                # Custom modules
├── molecule/               # Molecule tests
├── playbooks/              # Additional playbooks
├── plugins/                # Custom plugins
├── roles/                  # Project roles
├── scripts/                # Utility scripts
├── templates/              # Jinja2 templates
├── tests/                  # Test files
└── vault/                  # Encrypted sensitive data
\`\`\`

## Getting Started

### Prerequisites

- Ansible >= 2.9
- Python >= 3.6
- ansible-lint (optional)
- molecule (for testing)

### Installation

1. Clone this repository:
   \`\`\`bash
   git clone <repository-url>
   cd $PROJECT_NAME
   \`\`\`

2. Install required roles and collections:
   \`\`\`bash
   ansible-galaxy install -r requirements.yml
   \`\`\`

3. Set up vault password (optional):
   \`\`\`bash
   echo 'your-vault-password' > .vault_pass
   chmod 600 .vault_pass
   \`\`\`

### Usage

Run the main playbook:
\`\`\`bash
ansible-playbook site.yml -i inventory/development/hosts.yml
\`\`\`

### Testing

Run Molecule tests:
\`\`\`bash
molecule test
\`\`\`

### AWX/Tower Integration

This project is designed to work seamlessly with AWX/Tower. 
Configuration files for job templates, workflows, and credentials 
are located in the \`awx/\` directory.

## Contributing

Please read CONTRIBUTING.md for details on our code of conduct 
and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details."

# CONTRIBUTING.md
create_file "CONTRIBUTING.md" "# Contributing to $PROJECT_NAME

## Code Standards

### Ansible Best Practices

1. **Idempotency**: All playbooks and roles must be idempotent
2. **Variables**: Use descriptive variable names with proper scoping
3. **Tags**: Implement meaningful tags for all tasks
4. **Documentation**: Document all roles and playbooks

### Git Workflow

1. Create a feature branch from \`main\`
2. Make your changes
3. Test your changes with Molecule
4. Submit a pull request

### Testing Requirements

- All roles must have Molecule tests
- Playbooks should be tested in a development environment
- Use ansible-lint for code quality

### Commit Messages

Follow conventional commits:
- \`feat:\` for new features
- \`fix:\` for bug fixes
- \`docs:\` for documentation
- \`refactor:\` for code refactoring
- \`test:\` for tests
- \`chore:\` for maintenance"

# Main site.yml playbook
create_file "site.yml" "---
# Main Ansible Playbook
# This is the entry point for your infrastructure automation

- name: Common configuration for all hosts
  hosts: all
  gather_facts: yes
  become: yes
  tags:
    - common
  roles: []
    # - common
    # - security

- name: Configure web servers
  hosts: webservers
  gather_facts: yes
  become: yes
  tags:
    - web
  roles: []
    # - nginx
    # - php

- name: Configure database servers
  hosts: databases
  gather_facts: yes
  become: yes
  tags:
    - db
  roles: []
    # - postgresql
    # - mysql

- name: Configure application servers
  hosts: appservers
  gather_facts: yes
  become: yes
  tags:
    - app
  roles: []
    # - docker
    # - kubernetes"

# Example inventory file
create_file "inventory/development/hosts.yml" "---
# Development inventory
all:
  children:
    webservers:
      hosts:
        web01:
          ansible_host: 192.168.1.10
        web02:
          ansible_host: 192.168.1.11
    databases:
      hosts:
        db01:
          ansible_host: 192.168.1.20
          postgresql_version: 14
    appservers:
      hosts:
        app01:
          ansible_host: 192.168.1.30
        app02:
          ansible_host: 192.168.1.31
  vars:
    ansible_user: ansible
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
    environment: development"

# Group vars example
create_file "group_vars/all/main.yml" "---
# Global variables for all hosts

# Common packages to install
common_packages:
  - vim
  - htop
  - curl
  - wget
  - git

# Timezone configuration
timezone: UTC

# SSH configuration
ssh_port: 22
ssh_permit_root_login: 'no'

# Update configuration
automatic_updates_enabled: true"

# AWX job template example
create_file "awx/job_templates/deploy-application.yml" "---
# AWX Job Template Configuration
name: Deploy Application
description: Deploy application to target environment
job_type: run
inventory: Production Inventory
project: Infrastructure Automation
playbook: playbooks/deploy-application.yml
credentials:
  - Production SSH Key
  - Vault Password
extra_vars:
  deployment_version: '{{ deployment_version }}'
  environment: '{{ target_environment }}'
ask_variables_on_launch: true
survey_enabled: true
survey_spec:
  name: Deployment Survey
  description: Deployment configuration options
  spec:
    - variable: deployment_version
      question_name: Application Version
      type: text
      required: true
      default: latest
    - variable: target_environment
      question_name: Target Environment
      type: multiplechoice
      required: true
      choices:
        - production
        - staging
      default: staging"

# Molecule default scenario
create_file "molecule/default/molecule.yml" "---
dependency:
  name: galaxy
driver:
  name: docker
platforms:
  - name: instance
    image: quay.io/ansible/ubuntu:latest
    pre_build_image: true
    privileged: true
    command: /lib/systemd/systemd
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
provisioner:
  name: ansible
  inventory:
    host_vars:
      instance:
        ansible_python_interpreter: /usr/bin/python3
verifier:
  name: ansible"

# Create a sample role structure
print_message "$YELLOW" "Creating sample role structure..."
mkdir -p "$PROJECT_ROOT/roles/sample-role"/{tasks,handlers,templates,files,vars,defaults,meta,tests}

create_file "roles/sample-role/tasks/main.yml" "---
# Tasks file for sample-role

- name: Include OS-specific variables
  include_vars: '{{ ansible_os_family }}.yml'
  tags:
    - sample-role
    - configuration

- name: Ensure required packages are installed
  package:
    name: '{{ item }}'
    state: present
  loop: '{{ required_packages | default([]) }}'
  tags:
    - sample-role
    - packages

- name: Configure service
  template:
    src: config.j2
    dest: /etc/sample/config.conf
    owner: root
    group: root
    mode: '0644'
  notify: restart sample service
  tags:
    - sample-role
    - configuration"

create_file "roles/sample-role/meta/main.yml" "---
galaxy_info:
  author: Your Name
  description: Sample role description
  company: Your Company
  license: MIT
  min_ansible_version: '2.9'
  platforms:
    - name: Ubuntu
      versions:
        - focal
        - jammy
    - name: EL
      versions:
        - '8'
        - '9'
  galaxy_tags:
    - sample
    - example

dependencies: []"

# Final messages
echo ""
print_message "$GREEN" "=== Project structure created successfully! ==="
print_message "$YELLOW" "Project location: $PROJECT_ROOT"
echo ""
print_message "$BLUE" "Next steps:"
echo "  1. cd $PROJECT_ROOT"
echo "  2. Initialize git (if not already done): git init"
echo "  3. Install requirements: ansible-galaxy install -r requirements.yml"
echo "  4. Configure inventory files for your environments"
echo "  5. Start creating your playbooks and roles"
echo ""
print_message "$GREEN" "Happy automating with Ansible! 🚀"