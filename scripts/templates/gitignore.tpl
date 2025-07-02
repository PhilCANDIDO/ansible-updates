# =============================================================================
# .gitignore for PROJECT_NAME - Ansible Project
# This file excludes sensitive, temporary, and environment-specific files
# =============================================================================

# =============================================================================
# ANSIBLE SPECIFIC FILES
# =============================================================================

# Ansible runtime files
*.retry
.ansible/
.ansible_cache/
.ansible_facts/
ansible_collections/

# Ansible Galaxy downloaded roles (keep project roles)
galaxy_roles/
roles/*/
!roles/
!roles/.donotdelete
!roles/*/

# Ansible vault files and passwords
.vault_pass
.vault_pass.txt
.vault_password
vault_pass*
*.vault
vault_*.yml

# Ansible logs
ansible.log
ansible-*.log
logs/ansible*.log

# Ansible temporary files
*.tmp
*.bak
*.orig
*~

# =============================================================================
# INVENTORY AND CONFIGURATION FILES
# =============================================================================

# Environment-specific inventory files (contain sensitive host information)
inventory/*.yml
inventory/*.yaml
inventory/*.ini
inventory/*.json
inventory/*/*.yml
inventory/*/*.yaml
inventory/*/*.ini
inventory/*/*.json

# Keep sample/template inventory files
!inventory/**/*sample*
!inventory/**/*template*
!inventory/**/*example*
!inventory/**/hosts_sample.yml
!inventory/**/.donotdelete

# Environment-specific configuration
ansible.cfg.local
ansible.cfg.*.local
config/local/
config/*/local/

# Host and group variables with sensitive data
group_vars/*/vault.yml
group_vars/*/secrets.yml
host_vars/*/vault.yml
host_vars/*/secrets.yml

# AWX/Tower specific files
tower-cli.cfg
.tower_cli.cfg
.tower_cli_*
awx-cli.cfg
.awx_cli_*

# =============================================================================
# SSH AND SECURITY FILES
# =============================================================================

# SSH keys and certificates
*.pem
*.key
*.crt
*.csr
*.p12
*.pfx
id_rsa*
id_dsa*
id_ecdsa*
id_ed25519*
*.pub
authorized_keys*

# SSL/TLS certificates and keys
ssl/
certs/
certificates/
tls/
ca/

# Security scan results
security-scan-*.json
vulnerability-*.json
compliance-*.json

# =============================================================================
# PYTHON ENVIRONMENT
# =============================================================================

# Python bytecode
__pycache__/
*.py[cod]
*$py.class
*.so

# Virtual environments
venv/
env/
ENV/
.venv/
.env/
.python-version
.pyenv-version

# Python packaging
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Python testing
.tox/
.coverage
.coverage.*
.cache
.pytest_cache/
nosetests.xml
coverage.xml
*.cover
.hypothesis/

# Jupyter Notebook
.ipynb_checkpoints

# =============================================================================
# TESTING AND MOLECULE
# =============================================================================

# Molecule test results
.molecule/
molecule/*/molecule.yml.backup
molecule/*/.molecule/

# Test reports and artifacts
test-results/
test-reports/
junit.xml
.kitchen/
.kitchen.local.yml

# Performance testing
.locust/

# =============================================================================
# IDE AND EDITOR FILES
# =============================================================================

# Visual Studio Code
.vscode/
*.code-workspace

# JetBrains IDEs
.idea/
*.iml
*.ipr
*.iws

# Sublime Text
*.sublime-project
*.sublime-workspace

# Vim
*.swp
*.swo
*~
.vim/
.netrwhist

# Emacs
*~
\#*\#
/.emacs.desktop
/.emacs.desktop.lock
*.elc
auto-save-list
tramp
.\#*

# =============================================================================
# OPERATING SYSTEM FILES
# =============================================================================

# macOS
.DS_Store
.AppleDouble
.LSOverride
Icon
._*
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

# Windows
Thumbs.db
Thumbs.db:encryptable
ehthumbs.db
ehthumbs_vista.db
*.stackdump
[Dd]esktop.ini
$RECYCLE.BIN/
*.cab
*.msi
*.msix
*.msm
*.msp
*.lnk

# Linux
*~
.fuse_hidden*
.directory
.Trash-*
.nfs*

# =============================================================================
# CLOUD AND INFRASTRUCTURE
# =============================================================================

# Terraform
*.tfstate
*.tfstate.*
*.tfvars
.terraform/
.terraform.lock.hcl
override.tf
override.tf.json
*_override.tf
*_override.tf.json
.terraformrc
terraform.rc
crash.log

# Kubernetes
.kube/config
kubeconfig*
*.kubeconfig

# Docker
.docker/
docker-compose.override.yml
.dockerignore

# Vagrant
.vagrant/
*.box

# AWS
.aws/credentials
.aws/config

# GCP
.gcp/
service-account*.json
*-service-account.json

# Azure
.azure/

# =============================================================================
# MONITORING AND LOGGING
# =============================================================================

# Log files
*.log
logs/
log/
*.out
*.err

# Monitoring data
prometheus/data/
grafana/data/
elasticsearch/data/

# Application logs
app.log
application.log
debug.log
error.log
access.log

# =============================================================================
# BACKUP AND TEMPORARY FILES
# =============================================================================

# Backup files
*.backup
*.bak
*.old
*~
.backup/
backup/
backups/

# Temporary directories
tmp/
temp/
.tmp/
.temp/

# Archive files (when not needed)
*.tar
*.tar.gz
*.tgz
*.zip
*.rar
*.7z

# =============================================================================
# PROJECT SPECIFIC
# =============================================================================

# Development environment files
.env
.env.local
.env.development
.env.staging
.env.production
.environment

# Local development overrides
local/
.local/
private/
.private/
secrets/
.secrets/

# Custom scripts and tools
scripts/local/
tools/local/
bin/local/

# Documentation builds
docs/_build/
docs/build/
site/

# Package managers
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# =============================================================================
# VERSION CONTROL AND CI/CD
# =============================================================================

# Git
.git/
.gitconfig.local

# GitHub Actions artifacts
.github/workflows/artifacts/

# GitLab CI
.gitlab-ci-local/

# Jenkins
.jenkins/

# CircleCI
.circleci/local/

# Travis CI
.travis.yml.local

# =============================================================================
# CUSTOM PROJECT DIRECTORIES
# Keep these sections for project-specific exclusions
# =============================================================================

# Custom exclusions for PROJECT_NAME
# Add your project-specific patterns here

# Example: Custom build directories
# build/PROJECT_NAME/
# dist/PROJECT_NAME/

# Example: Generated configuration files
# config/generated/
# templates/compiled/

# Example: Runtime data
# data/runtime/
# cache/PROJECT_NAME/

# =============================================================================
# EXCEPTIONS - Files to always include
# =============================================================================

# Force include important template and example files
!.gitkeep
!.donotdelete
!**/README.md
!**/CHANGELOG.md
!**/LICENSE
!**/*.example
!**/*.sample
!**/*.template
!roles/**/meta/main.yml
!inventory/**/*.example
!group_vars/**/*.example
!host_vars/**/*.example

# Force include CI/CD configuration
!.github/workflows/*.yml
!.gitlab-ci.yml
!.travis.yml
!.circleci/config.yml
!Jenkinsfile

# Force include documentation
!docs/**/*.md
!docs/**/*.rst
!docs/requirements.txt