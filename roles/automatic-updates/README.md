# Automatic Updates Role

This Ansible role configures automatic updates for multiple Linux distributions including RedHat family (RHEL, AlmaLinux, OracleLinux), Debian family (Debian, Ubuntu), and SUSE family (openSUSE).

## Features

- **Multi-distribution support**: Automatically detects and configures the appropriate update mechanism
- **Package exclusions**: Exclude critical packages from automatic updates
- **Customizable scheduling**: Configure when updates should run
- **Email notifications**: Optional email alerts for update status
- **Idempotent**: Safe to run multiple times

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `update_schedule` | `"03:00"` | Time when updates should run (24h format) |
| `update_exclude_packages` | `[]` | List of package patterns to exclude |
| `auto_updates_enabled` | `true` | Enable/disable automatic updates |
| `auto_updates_apply_updates` | `true` | Apply updates automatically or download only |
| `auto_updates_reboot` | `false` | Automatically reboot if required |
| `auto_updates_email_to` | `""` | Email address for notifications |

## Usage

```yaml
- hosts: all
  become: true
  vars:
    update_schedule: "02:30"
    update_exclude_packages:
      - "kernel*"
      - "mysql*"
      - "nginx"
  roles:
    - automatic-updates
```

## Tags

- `auto-updates`: All tasks
- `install`: Package installation tasks
- `config`: Configuration tasks
- `schedule`: Scheduling tasks
- `service`: Service management tasks

## Requirements

- Ansible 2.9+
- Root/sudo access on target hosts
- Internet connectivity for package downloads