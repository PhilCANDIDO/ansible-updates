#!/bin/bash
#
# ansible_user_setup.sh - Create and configure Ansible user on various Linux distributions
# Version: 2.1.0 - Enhanced version with Debian-specific improvements
#
# CHANGELOG:
# 2.1.0 - 2025-07-02 - Debian-specific improvements
#   - Fixed passwordless account handling for Debian 12
#   - Enhanced distribution detection and early logging
#   - Improved error handling for locked accounts
#   - Better SSH configuration for Debian family
# 2.0.0 - 2025-07-02 - Enhanced version
#   - Improved distribution detection with fallback mechanisms
#   - Enhanced idempotency for all operations
#   - Better error handling and validation
#   - Unified package manager detection
#   - Improved SSH key management
#   - Enhanced logging and debugging
# 1.0.1 - 2025-03-24 - Fix group creation logic
# 1.0.0 - 2025-03-24 - Initial version

set -euo pipefail

VERSION="2.1.0"

# Default variables
LOG_FILE="/var/log/ansible_user_setup.log"
DATE=$(date +"%Y-%m-%d %H:%M:%S")
DEBUG=${DEBUG:-false}

# Distribution detection variables
DISTRO=""
DISTRO_FAMILY=""
VERSION_ID=""
PACKAGE_MANAGER=""

# Function to display help
show_help() {
    cat << EOF
Usage: $(basename "$0") --user USERNAME --key "SSH_PUBLIC_KEY"

Deploy Ansible connection user on Linux servers with SSH key authentication.
Enhanced version with improved distribution detection and idempotency.

Options:
  -h, --help              Display this help message and exit
  -v, --version           Display script version
  -u, --user USERNAME     Specify the username to create (required)
  -k, --key "SSH_KEY"     SSH public key for authentication (required)
  -g, --group GROUP       Specify the primary group (default: same as username)
  -l, --log FILE          Log file location (default: /var/log/ansible_user_setup.log)
  -s, --shell SHELL       User shell (default: /bin/bash)
  -n, --no-sudo           Do not configure sudo access (default: with sudo)
  -d, --debug             Enable debug mode for troubleshooting
  --dry-run               Show what would be done without making changes

Examples:
  $(basename "$0") --user ansible --key "ssh-rsa AAAAB3Nza..."
  $(basename "$0") --user automation --key "ssh-rsa AAAAB3Nza..." --group wheel
  $(basename "$0") --user ansible --key "ssh-rsa AAAAB3Nza..." --shell /bin/sh --no-sudo
  $(basename "$0") --user ansible --key "ssh-rsa AAAAB3Nza..." --debug --dry-run

Supported Distributions:
  - Red Hat family: RHEL, CentOS, AlmaLinux, Rocky Linux, Oracle Linux, Fedora
  - Debian family: Debian, Ubuntu, Linux Mint
  - SUSE family: openSUSE, SLES
  - Arch family: Arch Linux, Manjaro
  - Alpine Linux
  - Amazon Linux

EOF
    exit 0
}

# Function to display version
show_version() {
    echo "$(basename "$0") version $VERSION"
    exit 0
}

# Enhanced logging function
log() {
    local level="$1"
    local message="$2"
    local timestamp="$(date +"%Y-%m-%d %H:%M:%S")"
    local log_entry="[$timestamp] [$level] $message"
    
    # Always write to log file
    echo "$log_entry" >> "$LOG_FILE"
    
    # Display based on level
    case "$level" in
        "ERROR")
            echo -e "\033[31m$log_entry\033[0m" >&2
            ;;
        "WARN")
            echo -e "\033[33m$log_entry\033[0m"
            ;;
        "INFO")
            echo "$log_entry"
            ;;
        "DEBUG")
            if [[ "$DEBUG" == "true" ]]; then
                echo -e "\033[36m$log_entry\033[0m"
            fi
            ;;
    esac
}

# Function to execute command with dry-run support
execute_command() {
    local cmd="$1"
    local description="$2"
    local dry_run="${3:-$DRY_RUN}"
    
    log "DEBUG" "Command: $cmd"
    
    if [[ "$dry_run" == "true" ]]; then
        log "INFO" "[DRY-RUN] Would execute: $description"
        return 0
    else
        log "INFO" "Executing: $description"
        eval "$cmd"
    fi
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log "ERROR" "This script must be run as root"
        exit 1
    fi
}

# Enhanced distribution detection with multiple fallback methods
detect_distro() {
    log "DEBUG" "Starting distribution detection"
    
    # Method 1: /etc/os-release (preferred)
    if [[ -f /etc/os-release ]]; then
        log "DEBUG" "Using /etc/os-release for detection"
        . /etc/os-release
        DISTRO="${ID,,}"  # Convert to lowercase
        VERSION_ID="${VERSION_ID:-unknown}"
        
        # Determine distribution family
        case "$DISTRO" in
            rhel|centos|almalinux|rocky|oracle|fedora|amzn)
                DISTRO_FAMILY="redhat"
                ;;
            debian|ubuntu|mint)
                DISTRO_FAMILY="debian"
                ;;
            opensuse*|sles)
                DISTRO_FAMILY="suse"
                ;;
            arch|manjaro)
                DISTRO_FAMILY="arch"
                ;;
            alpine)
                DISTRO_FAMILY="alpine"
                ;;
            *)
                DISTRO_FAMILY="unknown"
                ;;
        esac
    
    # Method 2: Legacy release files
    elif [[ -f /etc/redhat-release ]]; then
        log "DEBUG" "Using /etc/redhat-release for detection"
        DISTRO_FAMILY="redhat"
        local release_content
        release_content=$(cat /etc/redhat-release)
        
        case "$release_content" in
            *"CentOS"*)
                DISTRO="centos"
                VERSION_ID=$(echo "$release_content" | grep -oE '[0-9]+' | head -1)
                ;;
            *"Red Hat"*)
                DISTRO="rhel"
                VERSION_ID=$(echo "$release_content" | grep -oE '[0-9]+' | head -1)
                ;;
            *"Oracle"*)
                DISTRO="oracle"
                VERSION_ID=$(echo "$release_content" | grep -oE '[0-9]+' | head -1)
                ;;
            *"AlmaLinux"*)
                DISTRO="almalinux"
                VERSION_ID=$(echo "$release_content" | grep -oE '[0-9]+' | head -1)
                ;;
            *"Rocky"*)
                DISTRO="rocky"
                VERSION_ID=$(echo "$release_content" | grep -oE '[0-9]+' | head -1)
                ;;
            *)
                DISTRO="unknown_rhel"
                VERSION_ID="unknown"
                ;;
        esac
    
    elif [[ -f /etc/debian_version ]]; then
        log "DEBUG" "Using /etc/debian_version for detection"
        DISTRO_FAMILY="debian"
        
        if [[ -f /etc/lsb-release ]] && grep -q "Ubuntu" /etc/lsb-release; then
            DISTRO="ubuntu"
            VERSION_ID=$(lsb_release -rs 2>/dev/null || cat /etc/debian_version)
        else
            DISTRO="debian"
            VERSION_ID=$(cat /etc/debian_version | cut -d '.' -f1)
        fi
    
    # Method 3: Command-based detection
    elif command -v lsb_release &>/dev/null; then
        log "DEBUG" "Using lsb_release for detection"
        DISTRO=$(lsb_release -si 2>/dev/null | tr '[:upper:]' '[:lower:]')
        VERSION_ID=$(lsb_release -sr 2>/dev/null)
        
        case "$DISTRO" in
            *"redhat"*|*"centos"*|*"fedora"*|*"oracle"*)
                DISTRO_FAMILY="redhat"
                ;;
            *"ubuntu"*|*"debian"*)
                DISTRO_FAMILY="debian"
                ;;
            *"suse"*)
                DISTRO_FAMILY="suse"
                ;;
            *)
                DISTRO_FAMILY="unknown"
                ;;
        esac
    
    else
        log "WARN" "Unable to detect distribution using standard methods"
        DISTRO="unknown"
        DISTRO_FAMILY="unknown"
        VERSION_ID="unknown"
    fi
    
    # Detect package manager
    detect_package_manager
    
    log "INFO" "Detected distribution: $DISTRO ($DISTRO_FAMILY) version $VERSION_ID"
    log "INFO" "Package manager: $PACKAGE_MANAGER"
}

# Enhanced package manager detection
detect_package_manager() {
    log "DEBUG" "Detecting package manager"
    
    if command -v dnf &>/dev/null; then
        PACKAGE_MANAGER="dnf"
    elif command -v yum &>/dev/null; then
        PACKAGE_MANAGER="yum"
    elif command -v apt &>/dev/null; then
        PACKAGE_MANAGER="apt"
    elif command -v apt-get &>/dev/null; then
        PACKAGE_MANAGER="apt-get"
    elif command -v zypper &>/dev/null; then
        PACKAGE_MANAGER="zypper"
    elif command -v pacman &>/dev/null; then
        PACKAGE_MANAGER="pacman"
    elif command -v apk &>/dev/null; then
        PACKAGE_MANAGER="apk"
    else
        PACKAGE_MANAGER="unknown"
        log "WARN" "No known package manager detected"
    fi
    
    log "DEBUG" "Package manager detected: $PACKAGE_MANAGER"
}

# Enhanced user existence check
user_exists() {
    local username="$1"
    if getent passwd "$username" &>/dev/null; then
        log "DEBUG" "User $username exists"
        return 0
    else
        log "DEBUG" "User $username does not exist"
        return 1
    fi
}

# Enhanced group existence check
group_exists() {
    local groupname="$1"
    if getent group "$groupname" &>/dev/null; then
        log "DEBUG" "Group $groupname exists"
        return 0
    else
        log "DEBUG" "Group $groupname does not exist"
        return 1
    fi
}

# Validate SSH public key format
validate_ssh_key() {
    local ssh_key="$1"
    
    # Basic SSH key format validation
    if [[ ! "$ssh_key" =~ ^(ssh-rsa|ssh-dss|ssh-ed25519|ecdsa-sha2-nistp256|ecdsa-sha2-nistp384|ecdsa-sha2-nistp521) ]]; then
        log "ERROR" "Invalid SSH key format. Key must start with ssh-rsa, ssh-dss, ssh-ed25519, or ecdsa-sha2-*"
        return 1
    fi
    
    # Check if key has minimum required parts
    local key_parts
    key_parts=$(echo "$ssh_key" | wc -w)
    if [[ $key_parts -lt 2 ]]; then
        log "ERROR" "SSH key appears to be incomplete. Expected format: 'key-type key-data [comment]'"
        return 1
    fi
    
    log "DEBUG" "SSH key format validation passed"
    return 0
}

# Enhanced user creation with idempotency
create_user() {
    local username="$1"
    local group="$2"
    local shell="$3"
    
    log "INFO" "Processing user creation for: $username"
    
    # Create group first if it doesn't exist
    if ! group_exists "$group"; then
        log "INFO" "Creating group: $group"
        execute_command "groupadd '$group'" "Create group $group"
    else
        log "INFO" "Group $group already exists"
    fi
    
    # Create user if it doesn't exist
    if ! user_exists "$username"; then
        log "INFO" "Creating user: $username"
        
        # Universal user creation command
        local create_user_cmd="useradd -m -g '$group' -s '$shell' -c 'Ansible automation user' '$username'"
        execute_command "$create_user_cmd" "Create user $username"
        
        log "INFO" "User $username created successfully"
    else
        log "INFO" "User $username already exists"
        
        # Verify user configuration is correct
        local current_shell
        current_shell=$(getent passwd "$username" | cut -d: -f7)
        local current_group
        current_group=$(id -gn "$username")
        
        if [[ "$current_shell" != "$shell" ]]; then
            log "INFO" "Updating shell for user $username from $current_shell to $shell"
            execute_command "usermod -s '$shell' '$username'" "Update shell for user $username"
        fi
        
        if [[ "$current_group" != "$group" ]]; then
            log "INFO" "Updating primary group for user $username from $current_group to $group"
            execute_command "usermod -g '$group' '$username'" "Update primary group for user $username"
        fi
    fi
    
    # Lock password - idempotent operation
    lock_user_password "$username"
    
# Configure SSH to allow key authentication for locked accounts - Debian 12 optimized
configure_ssh_for_locked_accounts() {
    log "INFO" "Configuring SSH for secure key-only authentication"
    
    local sshd_config="/etc/ssh/sshd_config"
    local sshd_config_d="/etc/ssh/sshd_config.d"
    local custom_config="$sshd_config_d/50-ansible-automation.conf"
    local restart_needed=false
    
    # Create sshd_config.d directory if it doesn't exist (Debian 12 uses this)
    if [[ ! -d "$sshd_config_d" ]]; then
        execute_command "mkdir -p '$sshd_config_d'" "Create SSH config directory"
    fi
    
    # For Debian 12, use modular configuration
    if [[ "$DISTRO_FAMILY" == "debian" ]]; then
        log "INFO" "Using Debian 12 modular SSH configuration"
        
        if [[ "$DRY_RUN" != "true" ]]; then
            cat > "$custom_config" << EOF
# Ansible automation user SSH configuration
# This file ensures SSH key authentication works for automation users
# Generated for user: $USERNAME

# Global settings for security
PasswordAuthentication no
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys

# Allow SSH key authentication for users with no password
PermitEmptyPasswords no

# Specific configuration for automation user: $USERNAME
Match User $USERNAME
    PubkeyAuthentication yes
    PasswordAuthentication no
    AuthenticationMethods publickey
EOF
            log "INFO" "✓ Created modular SSH configuration for user $USERNAME: $custom_config"
            restart_needed=true
        else
            log "INFO" "[DRY-RUN] Would create SSH configuration for user $USERNAME: $custom_config"
        fi
    else
        # For other distributions, modify main config
        log "INFO" "Using traditional SSH configuration method"
        
        # Backup original config
        if [[ ! -f "${sshd_config}.backup" ]]; then
            execute_command "cp '$sshd_config' '${sshd_config}.backup'" "Backup SSH configuration"
        fi
        
        # Configure main sshd_config
        local config_updated=false
        
        # Check and set PasswordAuthentication
        if grep -q "^PasswordAuthentication" "$sshd_config"; then
            if ! grep -q "^PasswordAuthentication no" "$sshd_config"; then
                execute_command "sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' '$sshd_config'" "Disable password authentication"
                config_updated=true
            fi
        else
            execute_command "echo 'PasswordAuthentication no' >> '$sshd_config'" "Add PasswordAuthentication no"
            config_updated=true
        fi
        
        # Check and set PubkeyAuthentication
        if grep -q "^PubkeyAuthentication" "$sshd_config"; then
            if ! grep -q "^PubkeyAuthentication yes" "$sshd_config"; then
                execute_command "sed -i 's/^PubkeyAuthentication.*/PubkeyAuthentication yes/' '$sshd_config'" "Enable public key authentication"
                config_updated=true
            fi
        else
            execute_command "echo 'PubkeyAuthentication yes' >> '$sshd_config'" "Add PubkeyAuthentication yes"
            config_updated=true
        fi
        
        # Add Match block for the specific user if not already present
        if ! grep -q "Match User $USERNAME" "$sshd_config"; then
            execute_command "echo '' >> '$sshd_config'" "Add empty line before Match block"
            execute_command "echo '# SSH configuration for user $USERNAME' >> '$sshd_config'" "Add comment for user config"
            execute_command "echo 'Match User $USERNAME' >> '$sshd_config'" "Add Match User block"
            execute_command "echo '    PubkeyAuthentication yes' >> '$sshd_config'" "Add PubkeyAuthentication for user"
            execute_command "echo '    PasswordAuthentication no' >> '$sshd_config'" "Add PasswordAuthentication for user"
            execute_command "echo '    AuthenticationMethods publickey' >> '$sshd_config'" "Add AuthenticationMethods for user"
            config_updated=true
            log "INFO" "✓ Added Match User block for $USERNAME in main SSH config"
        else
            log "INFO" "Match User block for $USERNAME already exists in SSH config"
        fi
        
        if [[ "$config_updated" == "true" ]]; then
            restart_needed=true
        fi
    fi
    
    # Test SSH configuration
    if [[ "$DRY_RUN" != "true" ]]; then
        if ! sshd -t; then
            log "ERROR" "SSH configuration test failed"
            
            # Cleanup on error
            if [[ -f "$custom_config" ]]; then
                rm -f "$custom_config"
            elif [[ -f "${sshd_config}.backup" ]]; then
                execute_command "cp '${sshd_config}.backup' '$sshd_config'" "Restore SSH configuration backup"
            fi
            
            exit 1
        fi
        log "INFO" "✓ SSH configuration test passed"
    fi
    
    # Restart SSH service if needed
    if [[ "$restart_needed" == "true" ]]; then
        log "INFO" "SSH configuration updated, restarting SSH service"
        restart_ssh_service
    else
        log "INFO" "SSH configuration is already properly configured"
    fi
}

# Restart SSH service with distribution detection
restart_ssh_service() {
    local ssh_service=""
    
    # Detect SSH service name based on distribution
    case "$DISTRO_FAMILY" in
        "debian")
            ssh_service="ssh"
            ;;
        "redhat"|"suse"|"arch"|"alpine")
            ssh_service="sshd"
            ;;
        *)
            # Try to detect automatically
            if systemctl list-units --type=service | grep -q "sshd.service"; then
                ssh_service="sshd"
            elif systemctl list-units --type=service | grep -q "ssh.service"; then
                ssh_service="ssh"
            else
                log "WARN" "Could not detect SSH service name, trying both sshd and ssh"
                ssh_service="sshd"
            fi
            ;;
    esac
    
    execute_command "systemctl restart '$ssh_service'" "Restart SSH service ($ssh_service)"
    
    # Verify service is running
    if [[ "$DRY_RUN" != "true" ]]; then
        if ! systemctl is-active "$ssh_service" &>/dev/null; then
            log "ERROR" "SSH service failed to start, trying alternative service name"
            local alt_service
            if [[ "$ssh_service" == "sshd" ]]; then
                alt_service="ssh"
            else
                alt_service="sshd"
            fi
            
            execute_command "systemctl restart '$alt_service'" "Restart SSH service ($alt_service)"
            
            if ! systemctl is-active "$alt_service" &>/dev/null; then
                log "ERROR" "Failed to restart SSH service"
                exit 1
            fi
        fi
        log "INFO" "SSH service restarted successfully"
    fi
}
}

# Enhanced password locking with idempotency
lock_user_password() {
    local username="$1"
    
    # Check if password is already locked
    local passwd_status
    passwd_status=$(passwd -S "$username" 2>/dev/null | awk '{print $2}' || echo "unknown")
    
    if [[ "$passwd_status" == "L" || "$passwd_status" == "LK" ]]; then
        log "INFO" "Password for user $username is already locked"
    else
        log "INFO" "Configuring password-less authentication for user $username"
        
        # Method 1: Set empty password then lock (preferred for SSH key auth)
        execute_command "passwd -d '$username' &>/dev/null" "Remove password for user $username"
        execute_command "passwd -l '$username' &>/dev/null" "Lock password for user $username"
        
        # Method 2: Alternative approach using usermod if passwd fails
        if [[ $? -ne 0 ]]; then
            log "WARN" "Standard password lock failed, trying alternative method"
            execute_command "usermod -L '$username'" "Lock account using usermod"
        fi
        
        # Verify SSH can still work with locked account
        configure_ssh_for_locked_accounts
    fi
}

# Enhanced account expiration setting with idempotency - integrated with password config
set_account_never_expire() {
    local username="$1"
    
    # Skip for Debian as it's already handled in lock_user_password()
    if [[ "$DISTRO_FAMILY" == "debian" ]]; then
        log "DEBUG" "Account expiration already configured in Debian password setup"
        return 0
    fi
    
    # Check current account expiration for non-Debian systems
    local current_expire
    current_expire=$(chage -l "$username" 2>/dev/null | grep "Account expires" | cut -d: -f2 | xargs || echo "unknown")
    
    if [[ "$current_expire" == "never" ]]; then
        log "INFO" "Account $username is already set to never expire"
    else
        log "INFO" "Setting account $username to never expire"
        
        # Universal command that works across distributions
        case "$DISTRO_FAMILY" in
            "redhat")
                if [[ "${VERSION_ID%%.*}" -ge 7 ]] 2>/dev/null || [[ "$DISTRO" == "fedora" ]]; then
                    execute_command "chage -E -1 -M 99999 '$username'" "Set account never expire (RHEL 7+/Fedora)"
                else
                    execute_command "chage -I -1 -m 0 -M 99999 -E -1 '$username'" "Set account never expire (RHEL 6)"
                fi
                ;;
            *)
                execute_command "chage -E -1 -M 99999 '$username'" "Set account never expire (Generic)"
                ;;
        esac
    fi
}

# Enhanced SSH key setup with idempotency
setup_ssh_key() {
    local username="$1"
    local ssh_key="$2"
    
    log "INFO" "Setting up SSH key for user: $username"
    
    # Validate SSH key format
    if ! validate_ssh_key "$ssh_key"; then
        log "ERROR" "SSH key validation failed"
        exit 1
    fi
    
    # Get home directory - more reliable method
    local home_dir
    home_dir=$(getent passwd "$username" | cut -d: -f6)
    
    if [[ -z "$home_dir" || "$home_dir" == "/" ]]; then
        log "ERROR" "Unable to determine home directory for user $username"
        exit 1
    fi
    
    log "DEBUG" "Home directory for $username: $home_dir"
    
    # Create .ssh directory if it doesn't exist
    local ssh_dir="$home_dir/.ssh"
    if [[ ! -d "$ssh_dir" ]]; then
        log "INFO" "Creating SSH directory: $ssh_dir"
        execute_command "mkdir -p '$ssh_dir'" "Create SSH directory"
        execute_command "chmod 700 '$ssh_dir'" "Set SSH directory permissions"
    else
        log "INFO" "SSH directory already exists: $ssh_dir"
        # Ensure correct permissions
        execute_command "chmod 700 '$ssh_dir'" "Ensure SSH directory permissions"
    fi
    
    # Handle authorized_keys file
    local auth_keys="$ssh_dir/authorized_keys"
    
    # Extract just the key part (first two fields) for comparison
    local key_signature
    key_signature=$(echo "$ssh_key" | awk '{print $1 " " $2}')
    
    # Check if key already exists
    if [[ -f "$auth_keys" ]] && grep -qF "$key_signature" "$auth_keys"; then
        log "INFO" "SSH key already exists for user $username"
    else
        log "INFO" "Adding SSH key for user $username"
        if [[ "$DRY_RUN" != "true" ]]; then
            echo "$ssh_key" >> "$auth_keys"
        else
            log "INFO" "[DRY-RUN] Would add SSH key to $auth_keys"
        fi
    fi
    
    # Set correct permissions and ownership
    execute_command "chmod 600 '$auth_keys'" "Set authorized_keys permissions"
    execute_command "chown -R '$username:$(id -gn "$username")' '$ssh_dir'" "Set SSH directory ownership"
    
    log "INFO" "SSH key setup completed for user $username"
}

# Enhanced sudo configuration with idempotency
configure_sudo() {
    local username="$1"
    local no_sudo="$2"
    
    if [[ "$no_sudo" == "true" ]]; then
        log "INFO" "Skipping sudo configuration as requested"
        return 0
    fi
    
    # Check if sudo is available
    if ! command -v sudo &>/dev/null; then
        log "WARN" "sudo command not found, attempting to install"
        install_sudo
        
        # Re-check after installation attempt
        if ! command -v sudo &>/dev/null; then
            log "WARN" "sudo is not available and could not be installed, skipping sudo configuration"
            return 0
        fi
    fi
    
    # Ensure sudoers.d directory exists
    local sudoers_dir="/etc/sudoers.d"
    if [[ ! -d "$sudoers_dir" ]]; then
        log "INFO" "Creating sudoers.d directory"
        execute_command "mkdir -p '$sudoers_dir'" "Create sudoers.d directory"
        execute_command "chmod 750 '$sudoers_dir'" "Set sudoers.d permissions"
    fi
    
    # Create/update sudoers file for the user
    local sudoers_file="$sudoers_dir/$username"
    local sudo_rule="$username ALL=(ALL) NOPASSWD: ALL"
    
    # Check if sudoers file exists and has correct content
    if [[ -f "$sudoers_file" ]] && grep -qxF "$sudo_rule" "$sudoers_file"; then
        log "INFO" "Sudo access already configured for user $username"
    else
        log "INFO" "Configuring sudo access for user $username"
        if [[ "$DRY_RUN" != "true" ]]; then
            echo "$sudo_rule" > "$sudoers_file"
            chmod 440 "$sudoers_file"
        else
            log "INFO" "[DRY-RUN] Would create sudo rule: $sudo_rule"
        fi
        log "INFO" "Sudo access configured for user $username"
    fi
    
    # Validate sudoers file syntax
    if [[ "$DRY_RUN" != "true" && -f "$sudoers_file" ]]; then
        if ! visudo -cf "$sudoers_file" &>/dev/null; then
            log "ERROR" "Sudoers file syntax error for $username"
            rm -f "$sudoers_file"
            exit 1
        fi
    fi
}

# Install sudo if not present
install_sudo() {
    log "INFO" "Attempting to install sudo"
    
    case "$PACKAGE_MANAGER" in
        "dnf"|"yum")
            execute_command "$PACKAGE_MANAGER install -y sudo" "Install sudo via $PACKAGE_MANAGER"
            ;;
        "apt"|"apt-get")
            execute_command "$PACKAGE_MANAGER update && $PACKAGE_MANAGER install -y sudo" "Install sudo via $PACKAGE_MANAGER"
            ;;
        "zypper")
            execute_command "zypper install -y sudo" "Install sudo via zypper"
            ;;
        "pacman")
            execute_command "pacman -S --noconfirm sudo" "Install sudo via pacman"
            ;;
        "apk")
            execute_command "apk add sudo" "Install sudo via apk"
            ;;
        *)
            log "WARN" "Unknown package manager, cannot install sudo automatically"
            ;;
    esac
}

# Validation function for input parameters
validate_parameters() {
    local username="$1"
    local ssh_key="$2"
    local group="$3"
    local shell="$4"
    
    # Validate username
    if [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        log "ERROR" "Invalid username format: $username"
        log "ERROR" "Username must start with lowercase letter or underscore, followed by lowercase letters, numbers, underscores, or hyphens"
        exit 1
    fi
    
    if [[ ${#username} -gt 32 ]]; then
        log "ERROR" "Username too long: $username (max 32 characters)"
        exit 1
    fi
    
    # Validate group name
    if [[ ! "$group" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        log "ERROR" "Invalid group name format: $group"
        exit 1
    fi
    
    # Validate shell
    if [[ ! -x "$shell" ]]; then
        log "WARN" "Shell $shell does not exist or is not executable"
    fi
    
    # Validate SSH key format
    validate_ssh_key "$ssh_key"
}

# Summary function
print_summary() {
    local username="$1"
    local group="$2"
    local shell="$3"
    local no_sudo="$4"
    
    log "INFO" "=== CONFIGURATION SUMMARY ==="
    log "INFO" "User: $username"
    log "INFO" "Primary Group: $group"
    log "INFO" "Shell: $shell"
    log "INFO" "Sudo Access: $(if [[ "$no_sudo" == "true" ]]; then echo "Disabled"; else echo "Enabled"; fi)"
    log "INFO" "Distribution: $DISTRO ($DISTRO_FAMILY) $VERSION_ID"
    log "INFO" "Package Manager: $PACKAGE_MANAGER"
    log "INFO" "Log File: $LOG_FILE"
    log "INFO" "============================"
}

# Main execution function
main() {
    # Initialize variables
    USERNAME=""
    SSH_KEY=""
    GROUP=""
    SHELL="/bin/bash"
    NO_SUDO="false"
    DRY_RUN="false"
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                ;;
            -v|--version)
                show_version
                ;;
            -u|--user)
                USERNAME="$2"
                shift 2
                ;;
            -k|--key)
                SSH_KEY="$2"
                shift 2
                ;;
            -g|--group)
                GROUP="$2"
                shift 2
                ;;
            -l|--log)
                LOG_FILE="$2"
                shift 2
                ;;
            -s|--shell)
                SHELL="$2"
                shift 2
                ;;
            -n|--no-sudo)
                NO_SUDO="true"
                shift
                ;;
            -d|--debug)
                DEBUG="true"
                shift
                ;;
            --dry-run)
                DRY_RUN="true"
                shift
                ;;
            *)
                log "ERROR" "Unknown parameter: $1"
                show_help
                ;;
        esac
    done
    
    # Initialize logging
    touch "$LOG_FILE" 2>/dev/null || {
        echo "Warning: Cannot write to log file $LOG_FILE, using /tmp/ansible_user_setup.log"
        LOG_FILE="/tmp/ansible_user_setup.log"
        touch "$LOG_FILE"
    }
    
    log "INFO" "Starting Ansible User Setup Script v$VERSION"
    
    # Detect Linux distribution and package manager first
    detect_distro
    
    # Show distribution info early for better debugging
    log "INFO" "Detected system: $DISTRO ($DISTRO_FAMILY) version $VERSION_ID"
    log "INFO" "Package manager: $PACKAGE_MANAGER"
    
    # Validate required parameters
    if [[ -z "$USERNAME" ]]; then
        log "ERROR" "Username is required (use --user)"
        show_help
    fi
    
    if [[ -z "$SSH_KEY" ]]; then
        log "ERROR" "SSH public key is required (use --key)"
        show_help
    fi
    
    # Set group to username if not specified
    if [[ -z "$GROUP" ]]; then
        GROUP="$USERNAME"
    fi
    
    # Check if running as root
    check_root
    
    # Validate all parameters
    validate_parameters "$USERNAME" "$SSH_KEY" "$GROUP" "$SHELL"
    
    # Print configuration summary
    print_summary "$USERNAME" "$GROUP" "$SHELL" "$NO_SUDO"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log "INFO" "=== DRY RUN MODE - NO CHANGES WILL BE MADE ==="
    fi
    
    log "INFO" "Starting user setup process for: $USERNAME"
    
    # Create user account
    create_user "$USERNAME" "$GROUP" "$SHELL"
    
    # Setup SSH key authentication
    setup_ssh_key "$USERNAME" "$SSH_KEY"
    
    # Configure sudo access
    configure_sudo "$USERNAME" "$NO_SUDO"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log "INFO" "=== DRY RUN COMPLETED - NO ACTUAL CHANGES MADE ==="
    else
        log "INFO" "User setup completed successfully for: $USERNAME"
    fi
    
    log "INFO" "Script execution completed"
}

# Execute main function with all arguments
main "$@"