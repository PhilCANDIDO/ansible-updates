---
# Minimal inventory for PROJECT_NAME
# This is a template - customize with your actual hosts and IPs

#all:
#  children:
#    # Web servers group
#    webservers:
#      hosts:
#        web01:
#          ansible_host: 192.168.1.10
#        web02:
#          ansible_host: 192.168.1.11
#      vars:
#        server_role: webserver
#
#    # Database servers group  
#    databases:
#      hosts:
#        db01:
#          ansible_host: 192.168.1.20
#      vars:
#        server_role: database
#
#    # Application servers group
#    appservers:
#      hosts:
#        app01:
#          ansible_host: 192.168.1.30
#      vars:
#        server_role: application
#
#  vars:
#    # Global connection settings
#    ansible_user: ansible
#    ansible_ssh_private_key_file: ~/.ssh/id_rsa
#    
#    # Environment identifier
#    environment: development
#    project_name: PROJECT_NAME