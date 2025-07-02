#!/bin/bash

# Ansible/AWX Project Structure Initialization Script
# Creates a complete project structure following Ansible best practices
# Author: Ansible Expert
# Version: 3.0

set -euo pipefail

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Get the directory where the script is located
readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Set project root to parent directory of scripts/
readonly PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Templates directory
readonly TEMPLATES_DIR="$SCRIPT_DIR/templates"

# Function to print colored output
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check if templates directory exists
check_templates_directory() {
    if [[ ! -d "$TEMPLATES_DIR" ]]; then
        print_message "$RED" "ERROR: Templates directory not found at: $TEMPLATES_DIR"
        print_message "$YELLOW" "Please ensure the templates directory exists with all necessary template files."
        exit 1
    fi
}

# Function to create directory and add .donotdelete file
create_dir_with_placeholder() {
    local dir_path=$1
    mkdir -p "$PROJECT_ROOT/$dir_path"
    touch "$PROJECT_ROOT/$dir_path/.donotdelete"
    print_message "$GREEN" "✓ Created: $dir_path"
}

# Function to create file from template
create_file_from_template() {
    local template_file=$1
    local target_file=$2
    local project_name=$3
    
    if [[ -f "$TEMPLATES_DIR/$template_file" ]]; then
        # Replace PROJECT_NAME placeholder with actual project name
        sed "s/PROJECT_NAME/$project_name/g" "$TEMPLATES_DIR/$template_file" > "$PROJECT_ROOT/$target_file"
        print_message "$BLUE" "✓ Created file: $target_file (from template: $template_file)"
    else
        print_message "$RED" "WARNING: Template file not found: $TEMPLATES_DIR/$template_file"
        print_message "$YELLOW" "Skipping: $target_file"
    fi
}

# Function to create basic file with content
create_basic_file() {
    local file_path=$1
    local content=$2
    echo "$content" > "$PROJECT_ROOT/$file_path"
    print_message "$BLUE" "✓ Created file: $file_path"
}

# Function to create directory structure
create_directory_structure() {
    print_message "$YELLOW" "Creating directory structure..."
    
    # Collections directory (for custom collections)
    create_dir_with_placeholder "collections/ansible_collections"
    
    # Group variables
    create_dir_with_placeholder "group_vars/all"
    create_dir_with_placeholder "group_vars/production"
    create_dir_with_placeholder "group_vars/staging"
    create_dir_with_placeholder "group_vars/development"
    
    # Host variables
    create_dir_with_placeholder "host_vars"
    
    # Inventory directories
    create_dir_with_placeholder "inventory/production"
    create_dir_with_placeholder "inventory/staging"
    create_dir_with_placeholder "inventory/development"
    
    # Playbooks directory
    create_dir_with_placeholder "playbooks"
    
    # Roles directory
    create_dir_with_placeholder "roles"
    
    # Custom modules
    create_dir_with_placeholder "library"
    
    # Custom plugins
    create_dir_with_placeholder "plugins/action"
    create_dir_with_placeholder "plugins/callback"
    create_dir_with_placeholder "plugins/connection"
    create_dir_with_placeholder "plugins/filter"
    create_dir_with_placeholder "plugins/lookup"
    create_dir_with_placeholder "plugins/vars"
    
    # Templates directory (global)
    create_dir_with_placeholder "templates"
    
    # Files directory (global)
    create_dir_with_placeholder "files"
    
    # Documentation
    create_dir_with_placeholder "docs"
    
    # Tests directory
    create_dir_with_placeholder "tests/integration"
    create_dir_with_placeholder "tests/unit"
    
    # AWX specific directories
    create_dir_with_placeholder "awx/job_templates"
    create_dir_with_placeholder "awx/workflows"
    create_dir_with_placeholder "awx/credentials"
    create_dir_with_placeholder "awx/projects"
    create_dir_with_placeholder "awx/inventories"
    
    # Molecule testing
    create_dir_with_placeholder "molecule/default"
    
    # Vault directory for encrypted files
    create_dir_with_placeholder "vault"
}

# Function to create configuration files
create_configuration_files() {
    local project_name=$1
    print_message "$YELLOW" "Creating configuration files..."
    
    # Create files from templates
    create_file_from_template "ansible.cfg.tpl" "ansible.cfg" "$project_name"
    create_file_from_template "requirements.yml.tpl" "requirements.yml" "$project_name"
    create_file_from_template "gitignore.tpl" ".gitignore" "$project_name"
    create_file_from_template "README.md.tpl" "README.md" "$project_name"
    create_file_from_template "CONTRIBUTING.md.tpl" "CONTRIBUTING.md" "$project_name"
    create_file_from_template "site.yml.tpl" "site.yml" "$project_name"
    
    # Inventory files
    create_file_from_template "hosts.yml.tpl" "inventory/development/hosts.yml" "$project_name"
    
    # Group vars
    create_file_from_template "group_vars_all.yml.tpl" "group_vars/all/main.yml" "$project_name"
    
    # AWX job template
    create_file_from_template "awx_job_template.yml.tpl" "awx/job_templates/deploy-application.yml" "$project_name"
    
    # Molecule configuration
    create_file_from_template "molecule.yml.tpl" "molecule/default/molecule.yml" "$project_name"
}

# Function to create sample role
create_sample_role() {
    local project_name=$1
    print_message "$YELLOW" "Creating sample role structure..."
    
    # Create role directories
    mkdir -p "$PROJECT_ROOT/roles/sample-role"/{tasks,handlers,templates,files,vars,defaults,meta,tests}
    
    # Create role files from templates
    create_file_from_template "role_tasks_main.yml.tpl" "roles/sample-role/tasks/main.yml" "$project_name"
    create_file_from_template "role_meta_main.yml.tpl" "roles/sample-role/meta/main.yml" "$project_name"
    
    # Create basic role files
    create_basic_file "roles/sample-role/defaults/main.yml" "---\n# Default variables for sample-role"
    create_basic_file "roles/sample-role/vars/main.yml" "---\n# Variables for sample-role"
    create_basic_file "roles/sample-role/handlers/main.yml" "---\n# Handlers for sample-role"
    create_basic_file "roles/sample-role/tests/test.yml" "---\n- hosts: localhost\n  remote_user: root\n  roles:\n    - sample-role"
}

# Function to check prerequisites
check_prerequisites() {
    print_message "$YELLOW" "Checking prerequisites..."
    
    # Check if required commands exist
    local commands=("mkdir" "touch" "sed")
    for cmd in "${commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            print_message "$RED" "ERROR: Required command '$cmd' not found"
            exit 1
        fi
    done
    
    print_message "$GREEN" "✓ Prerequisites check passed"
}

# Function to print usage
print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -v, --verbose           Enable verbose output"
    echo "  -t, --create-templates  Create template files with basic content"
    echo ""
    echo "Description:"
    echo "  Creates a complete Ansible project structure following best practices"
    echo "  Templates directory should be located at: $TEMPLATES_DIR"
    echo ""
    echo "Examples:"
    echo "  $0                      # Create project structure using existing templates"
    echo "  $0 --create-templates   # Create template files first, then project structure"
    echo "  $0 -t -v               # Create templates with verbose output"
}

# Function to create templates directory if it doesn't exist
create_templates_directory() {
    if [[ ! -d "$TEMPLATES_DIR" ]]; then
        print_message "$YELLOW" "Creating templates directory: $TEMPLATES_DIR"
        mkdir -p "$TEMPLATES_DIR"
        
        print_message "$RED" "WARNING: Templates directory was created but is empty!"
        print_message "$YELLOW" "Please populate it with the necessary template files or use --create-templates option"
        
        exit 1
    fi
}

# Function to create empty template files
create_template_files() {
    print_message "$YELLOW" "Creating empty template files in: $TEMPLATES_DIR"
    mkdir -p "$TEMPLATES_DIR"
    
    # List of required template files
    local template_files=(
        "ansible.cfg.tpl"
        "requirements.yml.tpl"
        "gitignore.tpl"
        "README.md.tpl"
        "CONTRIBUTING.md.tpl"
        "site.yml.tpl"
        "hosts.yml.tpl"
        "group_vars_all.yml.tpl"
        "awx_job_template.yml.tpl"
        "molecule.yml.tpl"
        "role_tasks_main.yml.tpl"
        "role_meta_main.yml.tpl"
    )
    
    # Create empty template files
    for template_file in "${template_files[@]}"; do
        touch "$TEMPLATES_DIR/$template_file"
        print_message "$GREEN" "✓ Created empty template: $template_file"
    done
    
    echo ""
    print_message "$YELLOW" "Template files created successfully!"
    print_message "$RED" "IMPORTANT: All template files are empty and must be populated before running the script."
    print_message "$BLUE" "Please edit the template files in: $TEMPLATES_DIR"
    print_message "$BLUE" "Use PROJECT_NAME as placeholder for the project name in templates."
    echo ""
}

# Function to validate template files content
validate_template_files() {
    print_message "$YELLOW" "Validating template files..."
    
    local template_files=(
        "ansible.cfg.tpl"
        "requirements.yml.tpl"
        "gitignore.tpl"
        "README.md.tpl"
        "CONTRIBUTING.md.tpl"
        "site.yml.tpl"
        "hosts.yml.tpl"
        "group_vars_all.yml.tpl"
        "awx_job_template.yml.tpl"
        "molecule.yml.tpl"
        "role_tasks_main.yml.tpl"
        "role_meta_main.yml.tpl"
    )
    
    local empty_files=()
    local missing_files=()
    
    for template_file in "${template_files[@]}"; do
        local file_path="$TEMPLATES_DIR/$template_file"
        
        if [[ ! -f "$file_path" ]]; then
            missing_files+=("$template_file")
        elif [[ ! -s "$file_path" ]]; then
            empty_files+=("$template_file")
        fi
    done
    
    # Check for missing files
    if [[ ${#missing_files[@]} -gt 0 ]]; then
        print_message "$RED" "ERROR: Missing template files:"
        for file in "${missing_files[@]}"; do
            print_message "$RED" "  - $file"
        done
        echo ""
        print_message "$YELLOW" "Run with --create-templates to create missing template files"
        exit 1
    fi
    
    # Check for empty files
    if [[ ${#empty_files[@]} -gt 0 ]]; then
        print_message "$RED" "ERROR: Empty template files found:"
        for file in "${empty_files[@]}"; do
            print_message "$RED" "  - $file"
        done
        echo ""
        print_message "$YELLOW" "Please populate the empty template files before running the script"
        print_message "$BLUE" "Templates location: $TEMPLATES_DIR"
        exit 1
    fi
    
    print_message "$GREEN" "✓ All template files are present and contain content"
}

# Main execution function
main() {
    local verbose=false
    local create_templates=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                print_usage
                exit 0
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            -t|--create-templates)
                create_templates=true
                shift
                ;;
            *)
                print_message "$RED" "Unknown option: $1"
                print_usage
                exit 1
                ;;
        esac
    done
    
    print_message "$YELLOW" "=== Ansible/AWX Project Structure Generator ==="
    print_message "$YELLOW" "Project location: $PROJECT_ROOT"
    print_message "$YELLOW" "Templates location: $TEMPLATES_DIR"
    echo ""
    
    # Check prerequisites
    check_prerequisites
    
    # Handle template creation mode
    if [[ "$create_templates" == true ]]; then
        create_template_files
        exit 0
    fi
    
    # Create templates directory if needed
    create_templates_directory
    
    # Validate template files
    validate_template_files
    
    # Get project name from directory
    local project_name
    project_name=$(basename "$PROJECT_ROOT")
    
    # Create structure
    create_directory_structure
    create_configuration_files "$project_name"
    create_sample_role "$project_name"
    
    # Final messages
    echo ""
    print_message "$GREEN" "=== Project structure created successfully! ==="
    print_message "$YELLOW" "Project name: $project_name"
    print_message "$YELLOW" "Project location: $PROJECT_ROOT"
    echo ""
    print_message "$BLUE" "Next steps:"
    echo "  1. cd $PROJECT_ROOT"
    echo "  2. Initialize git (if not already done): git init"
    echo "  3. Install requirements: ansible-galaxy install -r requirements.yml"
    echo "  4. Configure inventory files for your environments"
    echo "  5. Start creating your playbooks and roles"
    echo ""
    print_message "$GREEN" "Happy automating with Ansible! 🚀"
}

# Execute main function with all arguments
main "$@"