---
# Molecule configuration for PROJECT_NAME
# Basic setup for testing Ansible roles and playbooks

dependency:
  name: galaxy
  options:
    requirements-file: requirements.yml

driver:
  name: docker

platforms:
  - name: ubuntu22
    image: quay.io/ansible/ubuntu2204:latest
    pre_build_image: true
    privileged: true
    command: /lib/systemd/systemd
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    tmpfs:
      - /run
      - /tmp
    capabilities:
      - SYS_ADMIN

  - name: ubuntu20
    image: quay.io/ansible/ubuntu2004:latest
    pre_build_image: true
    privileged: true
    command: /lib/systemd/systemd
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    tmpfs:
      - /run
      - /tmp
    capabilities:
      - SYS_ADMIN

provisioner:
  name: ansible
  config_options:
    defaults:
      callbacks_enabled: profile_tasks
      stdout_callback: yaml
      verbosity: 1
  inventory:
    host_vars:
      ubuntu22:
        ansible_python_interpreter: /usr/bin/python3
      ubuntu20:
        ansible_python_interpreter: /usr/bin/python3

verifier:
  name: ansible

scenario:
  test_sequence:
    - dependency
    - cleanup
    - destroy
    - syntax
    - create
    - prepare
    - converge
    - idempotence
    - verify
    - cleanup
    - destroy