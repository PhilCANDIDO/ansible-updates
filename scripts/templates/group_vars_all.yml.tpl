---
# =============================================================================
# Global Variables for PROJECT_NAME
# These variables apply to all hosts in all environments
# =============================================================================

# =============================================================================
# PROJECT CONFIGURATION
# =============================================================================

# Project identification
project_name: "PROJECT_NAME"
project_version: "{{ ansible_local.PROJECT_NAME.version | default('1.0.0') }}"
project_description: "Ansible automation project for PROJECT_NAME infrastructure"

# Deployment configuration
deployment_user: "deploy"
deployment_group: "deploy"
deployment_home: "/opt/{{ project_name }}"
deployment_releases_path: "{{ deployment_home }}/releases"
deployment_shared_path: "{{ deployment_home }}/shared"
deployment_current_path: "{{ deployment_home }}/current"

# Environment detection
environment: "{{ ansible_inventory_file | regex_replace('.*inventory/([^/]+)/.*', '\\1') | default('development') }}"
environment_tier: "{{ 'prod' if environment == 'production' else 'non-prod' }}"

# =============================================================================
# SYSTEM CONFIGURATION
# =============================================================================

# Timezone and locale
#timezone: "UTC"
#locale: "en_US.UTF-8"
#language_pack: "language-pack-en"

# NTP configuration
#ntp_enabled: true
#ntp_servers:
#  - "0.pool.ntp.org"
#  - "1.pool.ntp.org"
#  - "2.pool.ntp.org"
#  - "3.pool.ntp.org"
#chrony_servers:
#  - "pool.ntp.org"

# DNS configuration
#dns_nameservers:
#  - "8.8.8.8"
#  - "8.8.4.4"
#  - "1.1.1.1"
#dns_search_domains:
#  - "{{ project_name }}.local"
#  - "internal"

# =============================================================================
# PACKAGE MANAGEMENT
# =============================================================================

# Essential packages for all systems
essential_packages:
  - curl
  - wget
  - unzip
  - tar
  - gzip
  - git
  - vim
  - nano
  - htop
  - tree
  - rsync
  - jq
  - ca-certificates
  - gnupg
  - lsb-release

# Development tools (optional)
development_packages:
  - build-essential
  - python3-pip
  - python3-dev
  - python3-venv
  - nodejs
  - npm

# Security packages
security_packages:
  - fail2ban
  - ufw
  - aide
  - rkhunter
  - chkrootkit

# Monitoring packages
monitoring_packages:
  - collectd
  - prometheus-node-exporter
  - filebeat
  - metricbeat

# Package management settings
package_cache_update: true
package_cache_valid_time: 3600
package_autoremove: true
package_autoclean: true

# =============================================================================
# USER MANAGEMENT
# =============================================================================

# System users configuration
#system_users:
#  - name: "{{ deployment_user }}"
#    group: "{{ deployment_group }}"
#    groups: []
#    shell: "/bin/bash"
#    home: "/home/{{ deployment_user }}"
#    create_home: true
#    system: false
#    state: present

# Administrative users
#admin_users:
#  - name: "ansible"
#    group: "ansible"
#    groups: ["sudo", "adm"]
#    shell: "/bin/bash"
#    home: "/home/ansible"
#    create_home: true
#    system: false
#    state: present

# Service users
service_users: []
  # Example:
  # - name: "nginx"
  #   group: "nginx"
  #   shell: "/bin/false"
  #   home: "/var/lib/nginx"
  #   create_home: false
  #   system: true
  #   state: present

# =============================================================================
# SSH CONFIGURATION
# =============================================================================

# SSH daemon configuration
#ssh_port: 22
#ssh_address_family: "any"
#ssh_listen_address: ["0.0.0.0"]

# SSH security settings
#ssh_permit_root_login: false
#ssh_password_authentication: false
#ssh_pubkey_authentication: true
#ssh_challenge_response_authentication: false
#ssh_gss_api_authentication: false
#ssh_x11_forwarding: false
#ssh_use_pam: true
#ssh_use_dns: false
#ssh_tcp_keep_alive: true
#ssh_client_alive_interval: 300
#ssh_client_alive_count_max: 2

# SSH access control
#ssh_allow_users: []
#ssh_allow_groups: ["ssh-users", "admin"]
#ssh_deny_users: []
#ssh_deny_groups: []

# SSH key management
#ssh_authorized_keys_exclusive: false
#ssh_authorized_keys_file: ".ssh/authorized_keys"

# =============================================================================
# SECURITY CONFIGURATION
# =============================================================================

# Firewall configuration
#firewall_enabled: true
#firewall_default_input_policy: "DROP"
#firewall_default_output_policy: "ACCEPT"
#firewall_default_forward_policy: "DROP"

# Common firewall rules
#firewall_rules:
#  - rule: "allow"
#    port: "{{ ssh_port }}"
#    proto: "tcp"
#    comment: "SSH access"
#  - rule: "allow"
#    port: "80"
#    proto: "tcp"
#    comment: "HTTP access"
#  - rule: "allow"
#    port: "443"
#    proto: "tcp"
#    comment: "HTTPS access"

# Fail2ban configuration
#fail2ban_enabled: true
#fail2ban_bantime: 3600
#fail2ban_findtime: 600
#fail2ban_maxretry: 5
#fail2ban_backend: "auto"
#fail2ban_destemail: "admin@{{ project_name }}.local"

# SSL/TLS configuration
#ssl_protocols: ["TLSv1.2", "TLSv1.3"]
#ssl_ciphers: "ECDHE+AESGCM:ECDHE+AES256:ECDHE+AES128:!aNULL:!MD5:!DSS"
#ssl_prefer_server_ciphers: true
#ssl_session_cache: "shared:SSL:10m"
#ssl_session_timeout: "10m"

# Certificate paths
#ssl_certificate_path: "/etc/ssl/certs"
#ssl_private_key_path: "/etc/ssl/private"
#ssl_dhparam_path: "/etc/ssl/dhparam.pem"
#ssl_dhparam_size: 2048

# =============================================================================
# LOGGING CONFIGURATION
# =============================================================================

# System logging
#rsyslog_enabled: true
#rsyslog_remote_logging: false
#rsyslog_server: "logs.{{ project_name }}.local"
#rsyslog_port: 514

# Log rotation
#logrotate_enabled: true
#logrotate_frequency: "daily"
#logrotate_retention: 30
#logrotate_compress: true
#logrotate_delaycompress: true

# Application logging
#app_log_level: "{{ 'DEBUG' if environment == 'development' else 'INFO' }}"
#app_log_path: "/var/log/{{ project_name }}"
#app_log_format: "json"
#app_log_max_size: "100M"
#app_log_max_files: 10

# =============================================================================
# MONITORING CONFIGURATION
# =============================================================================

# Monitoring settings
#monitoring_enabled: true
#metrics_enabled: true
#alerts_enabled: true

# Prometheus configuration
#prometheus_enabled: "{{ monitoring_enabled }}"
#prometheus_node_exporter_port: 9100
#prometheus_server: "prometheus.{{ project_name }}.local"

# Grafana configuration
#grafana_enabled: "{{ monitoring_enabled }}"
#grafana_server: "grafana.{{ project_name }}.local"
#grafana_port: 3000

# Log aggregation
#log_aggregation_enabled: true
#elasticsearch_enabled: "{{ log_aggregation_enabled }}"
#elasticsearch_server: "elasticsearch.{{ project_name }}.local"
#elasticsearch_port: 9200

# Alertmanager
#alertmanager_enabled: "{{ alerts_enabled }}"
#alertmanager_server: "alertmanager.{{ project_name }}.local"
#alertmanager_port: 9093

# Health checks
#health_check_enabled: true
#health_check_interval: 30
#health_check_timeout: 10
#health_check_retries: 3

# =============================================================================
# BACKUP CONFIGURATION
# =============================================================================

# Backup settings
#backup_enabled: true
#backup_schedule: "0 2 * * *"  # 2 AM daily
#backup_retention_days: 30
#backup_retention_weeks: 12
#backup_retention_months: 12

# Backup destinations
#backup_local_path: "/var/backups/{{ project_name }}"
#backup_remote_enabled: false
#backup_remote_server: "backup.{{ project_name }}.local"
#backup_remote_path: "/backups/{{ project_name }}"

# Backup types
#backup_system_enabled: true
#backup_database_enabled: true
#backup_application_enabled: true
#backup_logs_enabled: false

# Backup compression
#backup_compression_enabled: true
#backup_compression_level: 6
#backup_encryption_enabled: false

# =============================================================================
# UPDATE MANAGEMENT
# =============================================================================

# Automatic updates
#automatic_updates_enabled: true
#automatic_updates_schedule: "0 3 * * *"  # 3 AM daily
#automatic_updates_reboot: false
#automatic_updates_reboot_time: "04:00"

# Update exclusions
update_exclude_packages: []
  # Example exclusions:
  # - "kernel*"
  # - "mysql*"
  # - "nginx"
  # - "docker*"

# Security updates
#security_updates_enabled: true
#security_updates_priority: true
#security_updates_reboot: "{{ automatic_updates_reboot }}"

# =============================================================================
# PERFORMANCE TUNING
# =============================================================================

# System limits
#system_limits:
#  - domain: "*"
#    type: "soft"
#    item: "nofile"
#    value: 65536
#  - domain: "*"
#    type: "hard"
#    item: "nofile"
#    value: 65536
#  - domain: "root"
#    type: "soft"
#    item: "nofile"
#    value: 65536
#  - domain: "root"
#    type: "hard"
#    item: "nofile"
#    value: 65536

# Kernel parameters
#kernel_parameters:
#  vm.swappiness: 10
#  vm.dirty_ratio: 15
#  vm.dirty_background_ratio: 5
#  net.core.somaxconn: 1024
#  net.core.netdev_max_backlog: 5000
#  net.ipv4.tcp_max_syn_backlog: 1024

# Memory management
#swap_enabled: true
#swap_file_path: "/swapfile"
#swap_file_size: "2G"

# =============================================================================
# NOTIFICATION CONFIGURATION
# =============================================================================

# Email notifications
#email_notifications_enabled: false
#email_smtp_server: "smtp.{{ project_name }}.local"
#email_smtp_port: 587
#email_smtp_user: "notifications@{{ project_name }}.local"
#email_from_address: "{{ email_smtp_user }}"
#email_admin_addresses:
#  - "admin@{{ project_name }}.local"

# Slack notifications
#slack_notifications_enabled: false
#slack_webhook_url: "{{ vault_slack_webhook_url | default('') }}"
#slack_channel: "#alerts"
#slack_username: "Ansible"

# Teams notifications
#teams_notifications_enabled: false
#teams_webhook_url: "{{ vault_teams_webhook_url | default('') }}"

# =============================================================================
# DEVELOPMENT AND DEBUGGING
# =============================================================================

# Debug settings (development only)
#debug_mode: "{{ environment == 'development' }}"
#verbose_logging: "{{ debug_mode }}"
#debug_tasks: "{{ debug_mode }}"

# Development tools
#development_mode: "{{ environment == 'development' }}"
#install_dev_tools: "{{ development_mode }}"
#install_debug_tools: "{{ development_mode }}"

# Testing configuration
#testing_enabled: "{{ environment in ['development', 'staging'] }}"
#integration_tests_enabled: "{{ testing_enabled }}"
#performance_tests_enabled: "{{ environment == 'staging' }}"

# =============================================================================
# EXTERNAL SERVICES
# =============================================================================

# Database configuration (connection details in vault)
#database_enabled: false
#database_type: "postgresql"  # postgresql, mysql, mariadb
#database_host: "{{ vault_database_host | default('localhost') }}"
#database_port: "{{ vault_database_port | default('5432') }}"
#database_name: "{{ project_name }}"
#database_user: "{{ vault_database_user | default(project_name) }}"
#database_password: "{{ vault_database_password }}"

# Redis configuration
#redis_enabled: false
#redis_host: "{{ vault_redis_host | default('localhost') }}"
#redis_port: 6379
#redis_password: "{{ vault_redis_password | default('') }}"

# Message queue configuration
#message_queue_enabled: false
#message_queue_type: "rabbitmq"  # rabbitmq, redis
#message_queue_host: "{{ vault_mq_host | default('localhost') }}"
#message_queue_port: 5672
#message_queue_user: "{{ vault_mq_user | default('guest') }}"
#message_queue_password: "{{ vault_mq_password | default('guest') }}"

# =============================================================================
# CONDITIONAL VARIABLES
# =============================================================================

# Environment-specific overrides
#production_settings:
#  debug_mode: false
#  verbose_logging: false
#  automatic_updates_reboot: false
#  backup_retention_days: 90
#  monitoring_enabled: true

#staging_settings:
#  debug_mode: false
#  verbose_logging: true
#  automatic_updates_reboot: true
#  backup_retention_days: 7
#  monitoring_enabled: true

#development_settings:
#  debug_mode: true
#  verbose_logging: true
#  automatic_updates_reboot: true
#  backup_retention_days: 3
#  monitoring_enabled: false

# Apply environment-specific settings
#environment_config: "{{ vars[environment + '_settings'] | default({}) }}"

# =============================================================================
# COMPUTED VARIABLES
# =============================================================================

# Dynamic variables based on facts and configuration
#effective_debug_mode: "{{ environment_config.debug_mode | default(debug_mode) }}"
#effective_monitoring: "{{ environment_config.monitoring_enabled | default(monitoring_enabled) }}"
#effective_backup_retention: "{{ environment_config.backup_retention_days | default(backup_retention_days) }}"

# Service URLs
#service_urls:
#  prometheus: "http://{{ prometheus_server }}:9090"
#  grafana: "http://{{ grafana_server }}:{{ grafana_port }}"
#  elasticsearch: "http://{{ elasticsearch_server }}:{{ elasticsearch_port }}"
#  alertmanager: "http://{{ alertmanager_server }}:{{ alertmanager_port }}"

# =============================================================================
# FEATURE FLAGS
# =============================================================================

# Feature toggles for gradual rollouts
#feature_flags:
#  new_monitoring_stack: "{{ environment != 'production' }}"
#  enhanced_security: true
#  performance_optimization: "{{ environment == 'production' }}"
#  experimental_features: "{{ environment == 'development' }}"
#  beta_features: "{{ environment in ['development', 'staging'] }}"

# =============================================================================
# VALIDATION RULES
# =============================================================================

# Variable validation (used in tasks)
#required_variables:
#  - project_name
#  - environment
#  - deployment_user

#valid_environments:
#  - development
#  - staging
#  - production

#valid_database_types:
#  - postgresql
#  - mysql
#  - mariadb