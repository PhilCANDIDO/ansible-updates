---
# Ansible Galaxy requirements for PROJECT_NAME
# Install with: ansible-galaxy install -r requirements.yml

# Collections - Essential Ansible collections
collections:
  - name: community.general
    version: ">=7.0.0"
  - name: ansible.posix
    version: ">=1.5.0"

# Roles - Add third-party roles here as needed
roles: []
  # Examples:
  # - name: geerlingguy.docker
  #   version: "6.1.0"
  # - name: geerlingguy.nginx
  #   version: "3.0.0"
  # - name: geerlingguy.mysql
  #   version: "4.3.0"