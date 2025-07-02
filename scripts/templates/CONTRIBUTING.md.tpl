# Contributing to PROJECT_NAME

Welcome! We're excited that you're interested in contributing to PROJECT_NAME. This document provides guidelines and instructions for contributing to our Ansible automation project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Environment](#development-environment)
- [Ansible Best Practices](#ansible-best-practices)
- [Project Structure](#project-structure)
- [Git Workflow](#git-workflow)
- [Testing Requirements](#testing-requirements)
- [Code Style Guidelines](#code-style-guidelines)
- [Documentation Standards](#documentation-standards)
- [Security Guidelines](#security-guidelines)
- [Submitting Changes](#submitting-changes)
- [Review Process](#review-process)
- [Release Process](#release-process)

## Code of Conduct

This project follows the [Ansible Community Code of Conduct](https://docs.ansible.com/ansible/devel/community/code_of_conduct.html). By participating, you are expected to uphold this code.

## Getting Started

### Prerequisites

Before contributing, ensure you have the following installed:

- **Ansible** >= 2.12
- **Python** >= 3.8
- **Git** >= 2.20
- **Docker** (for testing)
- **ansible-lint** >= 6.0
- **molecule** >= 4.0
- **yamllint** >= 1.26

### Development Tools Installation

```bash
# Install Python development tools
pip install --upgrade pip
pip install ansible ansible-lint molecule[docker] yamllint pytest-ansible

# Install pre-commit hooks (recommended)
pip install pre-commit
pre-commit install

# Install additional testing tools
pip install ansible-navigator ansible-builder
```

## Development Environment

### Initial Setup

1. **Fork and clone the repository**:
   ```bash
   git clone https://github.com/your-username/PROJECT_NAME.git
   cd PROJECT_NAME
   ```

2. **Set up your development environment**:
   ```bash
   # Create virtual environment
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate

   # Install dependencies
   pip install -r requirements-dev.txt
   ansible-galaxy install -r requirements.yml
   ```

3. **Configure Ansible**:
   ```bash
   # Copy and customize configuration
   cp ansible.cfg.example ansible.cfg
   
   # Set up vault password (if needed)
   echo 'your-vault-password' > .vault_pass
   chmod 600 .vault_pass
   ```

### Environment Verification

```bash
# Test your setup
ansible --version
ansible-lint --version
molecule --version

# Run initial tests
make test-syntax
make test-lint
```

## Ansible Best Practices

### Idempotency

All playbooks and roles **must** be idempotent:

```yaml
# ✅ Good - Idempotent
- name: Ensure nginx is installed
  package:
    name: nginx
    state: present

# ❌ Bad - Not idempotent
- name: Install nginx
  shell: apt-get install nginx
```

### Variable Naming

Use descriptive, consistent variable names:

```yaml
# ✅ Good
nginx_server_name: "{{ inventory_hostname }}"
mysql_root_password: "{{ vault_mysql_root_password }}"
app_deployment_version: "1.2.3"

# ❌ Bad
server: "{{ inventory_hostname }}"
pwd: "{{ vault_pwd }}"
ver: "1.2.3"
```

### Task Documentation

Every task must have a clear, descriptive name:

```yaml
# ✅ Good
- name: Install required system packages for web server
  package:
    name: "{{ web_server_packages }}"
    state: present
  tags:
    - packages
    - web-server

# ❌ Bad
- name: Install packages
  package:
    name: "{{ packages }}"
    state: present
```

### Error Handling

Implement proper error handling and validation:

```yaml
- name: Validate required variables are defined
  assert:
    that:
      - app_name is defined
      - app_version is defined
      - deployment_environment in ['development', 'staging', 'production']
    fail_msg: "Required variables are missing or invalid"

- name: Create application directory
  file:
    path: "/opt/{{ app_name }}"
    state: directory
    owner: "{{ app_user }}"
    group: "{{ app_group }}"
    mode: '0755'
  register: app_dir_result
  failed_when: false

- name: Handle directory creation failure
  fail:
    msg: "Failed to create application directory: {{ app_dir_result.msg }}"
  when: app_dir_result.failed
```

## Project Structure

### Directory Organization

```
PROJECT_NAME/
├── roles/                  # Ansible roles
│   └── role-name/
│       ├── tasks/          # Role tasks
│       ├── handlers/       # Event handlers
│       ├── templates/      # Jinja2 templates
│       ├── files/          # Static files
│       ├── vars/           # Role variables
│       ├── defaults/       # Default variables
│       ├── meta/           # Role metadata
│       └── tests/          # Role tests
├── playbooks/              # Additional playbooks
├── inventory/              # Environment inventories
├── group_vars/             # Group variables
├── host_vars/              # Host-specific variables
├── library/                # Custom modules
├── plugins/                # Custom plugins
└── tests/                  # Integration tests
```

### Role Structure Requirements

Each role must follow the standard Ansible role structure:

```yaml
# roles/example-role/meta/main.yml
---
galaxy_info:
  author: Your Name
  description: Brief description of the role
  license: MIT
  min_ansible_version: 2.12
  platforms:
    - name: Ubuntu
      versions: [20.04, 22.04]
  galaxy_tags: [web, nginx, ssl]
dependencies: []
```

## Git Workflow

### Branching Strategy

We use **Git Flow** with the following branch types:

- **`main`**: Production-ready code
- **`develop`**: Integration branch for features
- **`feature/feature-name`**: New features
- **`bugfix/bug-description`**: Bug fixes
- **`hotfix/critical-fix`**: Critical production fixes
- **`release/version-number`**: Release preparation

### Commit Message Format

Follow **Conventional Commits** specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes

**Examples:**
```
feat(nginx): add SSL certificate management
fix(mysql): resolve connection timeout issue
docs(readme): update installation instructions
test(web-server): add molecule scenarios for Ubuntu 22.04
```

### Branch Workflow

1. **Create feature branch**:
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/your-feature-name
   ```

2. **Make changes and commit**:
   ```bash
   git add .
   git commit -m "feat(component): add new functionality"
   ```

3. **Push and create PR**:
   ```bash
   git push origin feature/your-feature-name
   # Create Pull Request via GitHub/GitLab interface
   ```

## Testing Requirements

### Mandatory Tests

All contributions must include:

1. **Syntax validation**
2. **Linting checks**
3. **Molecule tests**
4. **Integration tests** (for complex changes)

### Running Tests Locally

```bash
# Syntax check
ansible-playbook --syntax-check site.yml

# Lint all files
ansible-lint .
yamllint .

# Test specific role
cd roles/your-role
molecule test

# Run all tests
make test-all
```

### Molecule Test Structure

Each role should include molecule scenarios:

```yaml
# roles/example-role/molecule/default/molecule.yml
---
dependency:
  name: galaxy
driver:
  name: docker
platforms:
  - name: instance-ubuntu-20
    image: quay.io/ansible/ubuntu2004:latest
    pre_build_image: true
  - name: instance-ubuntu-22
    image: quay.io/ansible/ubuntu2204:latest
    pre_build_image: true
provisioner:
  name: ansible
  config_options:
    defaults:
      callbacks_enabled: profile_tasks
verifier:
  name: ansible
```

### Test Coverage Requirements

- **Unit tests**: All custom modules and plugins
- **Integration tests**: End-to-end playbook execution
- **Platform tests**: Multiple OS versions where applicable
- **Idempotency tests**: Verify tasks are idempotent

## Code Style Guidelines

### YAML Formatting

```yaml
---
# Use consistent indentation (2 spaces)
- name: Install and configure web server
  block:
    - name: Install nginx package
      package:
        name: nginx
        state: present
      
    - name: Configure nginx
      template:
        src: nginx.conf.j2
        dest: /etc/nginx/nginx.conf
        backup: true
      notify: restart nginx
  
  when: ansible_os_family == "Debian"
  tags:
    - nginx
    - web-server
```

### Variable Files

```yaml
---
# Group related variables logically
# Web Server Configuration
nginx_version: "1.20"
nginx_worker_processes: "{{ ansible_processor_vcpus }}"
nginx_worker_connections: 1024

# SSL Configuration
ssl_certificate_path: "/etc/ssl/certs"
ssl_private_key_path: "/etc/ssl/private"
ssl_protocols: ["TLSv1.2", "TLSv1.3"]

# Application Configuration
app_name: "PROJECT_NAME"
app_port: 8080
app_environment: "production"
```

### Jinja2 Templates

```jinja2
{# templates/nginx.conf.j2 #}
# Nginx configuration for {{ app_name }}
# Generated by Ansible - DO NOT EDIT MANUALLY

user {{ nginx_user }};
worker_processes {{ nginx_worker_processes }};

events {
    worker_connections {{ nginx_worker_connections }};
    use epoll;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    
    {% for server in nginx_servers %}
    server {
        listen {{ server.port }}{% if server.ssl | default(false) %} ssl{% endif %};
        server_name {{ server.name }};
        
        {% if server.ssl | default(false) %}
        ssl_certificate {{ ssl_certificate_path }}/{{ server.name }}.crt;
        ssl_certificate_key {{ ssl_private_key_path }}/{{ server.name }}.key;
        {% endif %}
        
        location / {
            proxy_pass http://{{ server.backend }};
        }
    }
    {% endfor %}
}
```

## Documentation Standards

### Role Documentation

Each role must include comprehensive README.md:

```markdown
# Role Name

Brief description of what the role does.

## Requirements

- Ansible >= 2.12
- Target OS: Ubuntu 20.04+, CentOS 8+

## Role Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `app_name` | `myapp` | Application name |
| `app_port` | `8080` | Application port |

## Dependencies

- community.general
- ansible.posix

## Example Playbook

\`\`\`yaml
- hosts: servers
  roles:
    - role: role-name
      vars:
        app_name: myapp
        app_port: 8080
\`\`\`
```

### Inline Documentation

```yaml
---
# This playbook deploys the PROJECT_NAME application
# It handles database setup, application deployment, and service configuration
- name: Deploy PROJECT_NAME application
  hosts: app_servers
  become: true
  vars:
    # Database configuration - these should be in vault
    db_host: "{{ vault_db_host }}"
    db_password: "{{ vault_db_password }}"
    
    # Application configuration
    app_version: "{{ deployment_version | default('latest') }}"
    app_environment: "{{ target_environment | default('production') }}"
```

## Security Guidelines

### Sensitive Data Handling

1. **Always use Ansible Vault for secrets**:
   ```bash
   # Encrypt sensitive variables
   ansible-vault encrypt_string 'secret_password' --name 'vault_db_password'
   ```

2. **Never commit plain text secrets**:
   ```yaml
   # ✅ Good
   mysql_root_password: "{{ vault_mysql_root_password }}"
   
   # ❌ Bad
   mysql_root_password: "plain_text_password"
   ```

3. **Use secure file permissions**:
   ```yaml
   - name: Create SSL private key
     copy:
       content: "{{ vault_ssl_private_key }}"
       dest: "/etc/ssl/private/{{ domain_name }}.key"
       owner: root
       group: root
       mode: '0600'  # Restrictive permissions
   ```

### Security Best Practices

- Always validate user inputs
- Use parameterized queries for database operations
- Implement least privilege principle
- Regular security updates in CI/CD
- Scan for vulnerabilities using ansible-lint security rules

## Submitting Changes

### Pull Request Process

1. **Ensure all tests pass**:
   ```bash
   make test-all
   ```

2. **Update documentation** if needed

3. **Create descriptive PR**:
   - Clear title following conventional commits
   - Detailed description of changes
   - Link to related issues
   - Include testing evidence

4. **PR Template**:
   ```markdown
   ## Description
   Brief description of changes
   
   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Documentation update
   - [ ] Refactoring
   
   ## Testing
   - [ ] Syntax check passed
   - [ ] Lint checks passed
   - [ ] Molecule tests passed
   - [ ] Manual testing completed
   
   ## Checklist
   - [ ] Code follows style guidelines
   - [ ] Documentation updated
   - [ ] Tests added/updated
   - [ ] No breaking changes
   ```

### Pre-submit Checklist

- [ ] Code is properly formatted
- [ ] All tests pass locally
- [ ] Documentation is updated
- [ ] Commit messages follow convention
- [ ] No sensitive data exposed
- [ ] Changes are backward compatible

## Review Process

### Review Criteria

Code reviews will check for:

1. **Functionality**: Does it work as expected?
2. **Security**: Are there security implications?
3. **Performance**: Is it efficient?
4. **Maintainability**: Is the code clean and readable?
5. **Testing**: Adequate test coverage?
6. **Documentation**: Properly documented?

### Reviewer Guidelines

- Be constructive and respectful
- Focus on the code, not the person
- Explain the "why" behind suggestions
- Approve when requirements are met
- Request changes for issues that must be fixed

## Release Process

### Versioning

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR**: Incompatible API changes
- **MINOR**: Backward-compatible functionality
- **PATCH**: Backward-compatible bug fixes

### Release Workflow

1. **Create release branch**:
   ```bash
   git checkout -b release/1.2.0
   ```

2. **Update version files**:
   - Update CHANGELOG.md
   - Update version in meta files
   - Update documentation

3. **Test release candidate**:
   ```bash
   make test-release
   ```

4. **Merge and tag**:
   ```bash
   git checkout main
   git merge release/1.2.0
   git tag v1.2.0
   git push origin main --tags
   ```

## Getting Help

### Community Resources

- **Documentation**: [Ansible Documentation](https://docs.ansible.com/)
- **Community**: [Ansible Community Forum](https://forum.ansible.com/)
- **Chat**: [Ansible Matrix/IRC channels](https://docs.ansible.com/ansible/devel/community/communication.html)

### Project Support

- **Issues**: Report bugs via GitHub Issues
- **Discussions**: Use GitHub Discussions for questions
- **Security**: Email security@project-domain.com for security issues

### Maintainers

- **Primary Maintainer**: [Your Name](mailto:your.email@domain.com)
- **Infrastructure Team**: [Team Email](mailto:infrastructure@domain.com)

---

Thank you for contributing to PROJECT_NAME! Your efforts help make this project better for everyone.

## License

By contributing to PROJECT_NAME, you agree that your contributions will be licensed under the project's [MIT License](LICENSE).