# PROJECT_NAME

Ansible automation project for PROJECT_NAME infrastructure management.

## Quick Start

### Prerequisites

- Ansible >= 2.12
- Python >= 3.8

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd PROJECT_NAME

# Install dependencies
ansible-galaxy install -r requirements.yml

# Copy and configure inventory
cp inventory/development/hosts.yml.example inventory/development/hosts.yml
# Edit hosts.yml with your server details
```

### Usage

```bash
# Run the main playbook
ansible-playbook site.yml -i inventory/development/hosts.yml

# Run specific roles
ansible-playbook site.yml -i inventory/development/hosts.yml --tags webserver

# Check mode (dry run)
ansible-playbook site.yml -i inventory/development/hosts.yml --check
```

## Project Structure

```
PROJECT_NAME/
├── ansible.cfg              # Ansible configuration
├── site.yml                 # Main playbook
├── requirements.yml         # Dependencies
├── inventory/               # Environment inventories
│   ├── development/         # Development environment
│   ├── staging/            # Staging environment
│   └── production/         # Production environment
├── group_vars/             # Group variables
├── host_vars/              # Host-specific variables
├── roles/                  # Custom roles
└── playbooks/              # Additional playbooks
```

## Environments

- **Development**: `inventory/development/hosts.yml`
- **Staging**: `inventory/staging/hosts.yml`
- **Production**: `inventory/production/hosts.yml`

## Common Tasks

```bash
# Deploy to specific environment
ansible-playbook site.yml -i inventory/production/hosts.yml

# Run only database tasks
ansible-playbook site.yml --tags database

# Update packages only
ansible-playbook playbooks/update-packages.yml

# Test connectivity
ansible all -i inventory/development/hosts.yml -m ping
```

## Configuration

### Inventory Setup

Edit `inventory/<environment>/hosts.yml` with your servers:

```yaml
all:
  children:
    webservers:
      hosts:
        web01:
          ansible_host: YOUR_SERVER_IP
```

### Variables

Customize variables in:
- `group_vars/all/main.yml` - Global settings
- `group_vars/<group>/main.yml` - Group-specific settings
- `host_vars/<host>/main.yml` - Host-specific settings

### Vault (Optional)

```bash
# Create vault password file
echo 'your-password' > .vault_pass
chmod 600 .vault_pass

# Encrypt sensitive variables
ansible-vault encrypt_string 'secret_value' --name 'vault_variable_name'
```

## Testing

```bash
# Test syntax
ansible-playbook site.yml --syntax-check

# Test with molecule (if configured)
cd roles/your-role
molecule test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test your changes
5. Submit a pull request

## License

[MIT License](LICENSE)

## Support

For questions or issues, please contact the infrastructure team or create an issue in this repository.