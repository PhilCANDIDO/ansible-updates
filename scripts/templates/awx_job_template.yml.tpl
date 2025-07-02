---
# AWX Job Template Configuration for PROJECT_NAME
# This template defines a standard deployment job for AWX/Tower
# Documentation: https://docs.ansible.com/ansible-tower/latest/html/userguide/job_templates.html

#name: "Deploy PROJECT_NAME"
#description: "Deploy PROJECT_NAME application to target environment"
#job_type: run
#inventory: "{{ target_inventory | default('Development Inventory') }}"
#project: "PROJECT_NAME Infrastructure"
#playbook: site.yml
#scm_branch: "{{ scm_branch | default('main') }}"
#
## Credentials Configuration
#credentials:
#  - name: "SSH Key"
#    kind: ssh
#  - name: "Vault Password"
#    kind: vault
#  - name: "SCM Credential"
#    kind: scm
#    required: false
#
## Variables passed to the playbook
#extra_vars:
#  # Deployment Configuration
#  deployment_version: "{{ deployment_version | default('latest') }}"
#  environment: "{{ target_environment | default('development') }}"
#  force_update: "{{ force_update | default(false) }}"
#  
#  # Application Configuration
#  app_name: "PROJECT_NAME"
#  app_debug: "{{ app_debug | default(false) }}"
#  maintenance_mode: "{{ maintenance_mode | default(false) }}"
#  
#  # Infrastructure Configuration
#  update_packages: "{{ update_packages | default(false) }}"
#  restart_services: "{{ restart_services | default(true) }}"
#  run_migrations: "{{ run_migrations | default(true) }}"
#  
#  # Notification Configuration
#  notify_deployment: "{{ notify_deployment | default(true) }}"
#  notification_channels: "{{ notification_channels | default(['email', 'slack']) }}"
#
## Job Configuration
#concurrent_jobs_enabled: false
#ask_scm_branch_on_launch: true
#ask_variables_on_launch: true
#ask_tags_on_launch: true
#ask_skip_tags_on_launch: true
#ask_job_type_on_launch: false
#ask_verbosity_on_launch: true
#ask_inventory_on_launch: true
#ask_credential_on_launch: false
#ask_diff_mode_on_launch: true
#ask_limit_on_launch: true
#
## Execution Configuration
#become_enabled: true
#allow_simultaneous: false
#use_fact_cache: true
#verbosity: 1
#job_slice_count: 1
#
## Timeout and Retry
#timeout: 3600  # 1 hour timeout
#instance_groups: []
#execution_environment: "Default execution environment"
#
## Labels for organization
#labels:
#  - "deployment"
#  - "PROJECT_NAME"
#  - "infrastructure"
#
## Survey Configuration for User Input
#survey_enabled: true
#survey_spec:
#  name: "PROJECT_NAME Deployment Survey"
#  description: "Configuration options for PROJECT_NAME deployment"
#  spec:
#    - variable: deployment_version
#      question_name: "Application Version"
#      question_description: "Version/tag of the application to deploy"
#      type: text
#      required: true
#      default: "latest"
#      min_length: 1
#      max_length: 50
#
#    - variable: target_environment
#      question_name: "Target Environment"
#      question_description: "Environment where the application will be deployed"
#      type: multiplechoice
#      required: true
#      choices:
#        - development
#        - staging
#        - production
#      default: staging
#
#    - variable: target_inventory
#      question_name: "Target Inventory"
#      question_description: "Inventory to use for deployment"
#      type: multiplechoice
#      required: true
#      choices:
#        - "Development Inventory"
#        - "Staging Inventory"
#        - "Production Inventory"
#      default: "Development Inventory"
#
#    - variable: force_update
#      question_name: "Force Update"
#      question_description: "Force update even if version is the same"
#      type: multiplechoice
#      required: true
#      choices:
#        - "true"
#        - "false"
#      default: "false"
#
#    - variable: maintenance_mode
#      question_name: "Maintenance Mode"
#      question_description: "Enable maintenance mode during deployment"
#      type: multiplechoice
#      required: true
#      choices:
#        - "true"
#        - "false"
#      default: "true"
#
#    - variable: run_migrations
#      question_name: "Run Database Migrations"
#      question_description: "Execute database migrations during deployment"
#      type: multiplechoice
#      required: true
#      choices:
#        - "true"
#        - "false"
#      default: "true"
#
#    - variable: restart_services
#      question_name: "Restart Services"
#      question_description: "Restart application services after deployment"
#      type: multiplechoice
#      required: true
#      choices:
#        - "true"
#        - "false"
#      default: "true"
#
#    - variable: update_packages
#      question_name: "Update System Packages"
#      question_description: "Update system packages before deployment"
#      type: multiplechoice
#      required: false
#      choices:
#        - "true"
#        - "false"
#      default: "false"
#
#    - variable: notification_channels
#      question_name: "Notification Channels"
#      question_description: "How to notify about deployment status"
#      type: multiselect
#      required: false
#      choices:
#        - email
#        - slack
#        - teams
#        - webhook
#      default: "email,slack"
#
#    - variable: deployment_notes
#      question_name: "Deployment Notes"
#      question_description: "Additional notes about this deployment"
#      type: textarea
#      required: false
#      default: ""
#      min_length: 0
#      max_length: 500
#
## Webhook Configuration for External Integration
#webhook_service: ""
#webhook_url: ""
#webhook_credential: ""
#
## Success/Failure Notifications
#notification_templates_started: []
#notification_templates_success:
#  - "PROJECT_NAME Deployment Success"
#notification_templates_error:
#  - "PROJECT_NAME Deployment Failed"
#
## Schedule Configuration (if needed)
#schedules: []
#  # Example schedule:
#  # - name: "Nightly Staging Deployment"
#  #   description: "Automatic deployment to staging every night"
#  #   enabled: true
#  #   rrule: "DTSTART:20240101T020000Z RRULE:FREQ=DAILY;INTERVAL=1"
#  #   extra_data:
#  #     target_environment: "staging"
#  #     deployment_version: "latest"
#
## Custom Fields for Additional Metadata
#custom_virtualenv: ""
#skip_tags: []
#job_tags: []
#diff_mode: false
#verbosity: 1