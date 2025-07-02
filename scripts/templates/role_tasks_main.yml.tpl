---
# Main tasks file for PROJECT_NAME role
# Customize this template for each role

- name: Include OS-specific variables
  include_vars: "{{ ansible_os_family }}.yml"
  ignore_errors: true
  tags:
    - config

- name: Install required packages
  package:
    name: "{{ required_packages | default([]) }}"
    state: present
  when: required_packages is defined
  tags:
    - install

- name: Create service user
  user:
    name: "{{ service_user | default('app') }}"
    group: "{{ service_group | default('app') }}"
    system: true
    shell: /bin/false
    home: "{{ service_home | default('/opt/app') }}"
    create_home: true
  when: create_service_user | default(false)
  tags:
    - config

- name: Configure service
  template:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
    owner: "{{ item.owner | default('root') }}"
    group: "{{ item.group | default('root') }}"
    mode: "{{ item.mode | default('0644') }}"
    backup: true
  loop: "{{ config_files | default([]) }}"
  notify: restart service
  tags:
    - config

- name: Start and enable service
  systemd:
    name: "{{ service_name }}"
    state: started
    enabled: true
    daemon_reload: true
  when: service_name is defined
  tags:
    - service