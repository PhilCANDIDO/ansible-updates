# ansible-updates

An Ansible project following best practices for configuration management and automation.

## Project Structure

```
ansible-updates/
├── ansible.cfg              # Ansible configuration
├── requirements.yml         # Galaxy roles and collections
├── site.yml                # Main playbook
├── awx/                    # AWX/Tower specific configurations
├── collections/            # Custom Ansible collections
├── docs/                   # Documentation
├── files/                  # Static files
├── group_vars/             # Group variables
│   ├── all/               # Variables for all hosts
│   ├── production/        # Production environment
│   ├── staging/           # Staging environment
│   └── development/       # Development environment
├── host_vars/              # Host-specific variables
├── inventory/              # Inventory files
│   ├── production/        # Production inventory
│   ├── staging/           # Staging inventory
│   └── development/       # Development inventory
├── library/                # Custom modules
├── molecule/               # Molecule tests
├── playbooks/              # Additional playbooks
├── plugins/                # Custom plugins
├── roles/                  # Project roles
├── scripts/                # Utility scripts
├── templates/              # Jinja2 templates
├── tests/                  # Test files
└── vault/                  # Encrypted sensitive data
```

## Getting Started

### Prerequisites

- Ansible >= 2.9
- Python >= 3.6
- ansible-lint (optional)
- molecule (for testing)

### Installation

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd ansible-updates
   ```

2. Install required roles and collections:
   ```bash
   ansible-galaxy install -r requirements.yml
   ```

3. Set up vault password (optional):
   ```bash
   echo 'your-vault-password' > .vault_pass
   chmod 600 .vault_pass
   ```

### Usage

Run the main playbook:
```bash
ansible-playbook site.yml -i inventory/development/hosts.yml
```

### Testing

Run Molecule tests:
```bash
molecule test
```

### AWX/Tower Integration

This project is designed to work seamlessly with AWX/Tower. 
Configuration files for job templates, workflows, and credentials 
are located in the `awx/` directory.

## Contributing

Please read CONTRIBUTING.md for details on our code of conduct 
and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
