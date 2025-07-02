# Ansible Configuration File for PROJECT_NAME
# This file contains the main configuration options for Ansible
# Documentation: https://docs.ansible.com/ansible/latest/reference_appendices/config.html

[defaults]
# Basic Configuration
# inventory = inventory/development/hosts.yml
# roles_path = roles:galaxy_roles:~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
# collections_path = ./collections:~/.ansible/collections:/usr/share/ansible/collections
# library = ./library
# lookup_plugins = ./plugins/lookup
# filter_plugins = ./plugins/filter
# action_plugins = ./plugins/action
# callback_plugins = ./plugins/callback
# connection_plugins = ./plugins/connection
# vars_plugins = ./plugins/vars

# Security Settings
host_key_checking = False
retry_files_enabled = False
vault_password_file = .vault_pass