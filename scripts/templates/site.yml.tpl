---
# Main playbook for PROJECT_NAME
# This is the entry point for infrastructure automation

- name: Common configuration for all hosts
  hosts: all
  become: true
  gather_facts: true
  tags:
    - common
  
  tasks:
    - name: Update package cache
      package:
        update_cache: true
      tags:
        - packages

    - name: Install essential packages
      package:
        name: "{{ essential_packages }}"
        state: present
      tags:
        - packages

- name: Configure web servers
  hosts: webservers
  become: true
  tags:
    - web
  
  roles: []
    # Add your web server roles here:
    # - nginx
    # - ssl

- name: Configure database servers
  hosts: databases
  become: true
  tags:
    - database
  
  roles: []
    # Add your database roles here:
    # - mysql
    # - postgresql

- name: Configure application servers
  hosts: appservers
  become: true
  tags:
    - app
  
  roles: []
    # Add your application roles here:
    # - docker
    # - app-deploy