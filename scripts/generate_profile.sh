#!/bin/bash
#
# Generate a new contributor profile for Dev Work Insights
#
# This script creates a new contributor Markdown file with proper naming
# and structure based on the TEMPLATE.md file. No external dependencies required.
#
# Usage: ./generate_profile.sh
#
# Author: Dev Work Insights
# Version: 1.0
# Requires: Bash 4.0 or higher

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Output functions
print_success() { echo -e "${GREEN}$1${NC}"; }
print_error() { echo -e "${RED}$1${NC}"; }
print_warning() { echo -e "${YELLOW}$1${NC}"; }
print_info() { echo -e "${CYAN}$1${NC}"; }

# Banner
echo ""
print_info "============================================================"
print_info "  Dev Work Insights - Contributor Profile Generator"
print_info "============================================================"
echo ""

# Get script directory and project paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATE_PATH="$SCRIPT_DIR/TEMPLATE.md"
CONTRIBUTORS_DIR="$PROJECT_ROOT/contributors"

# Validate template exists
if [[ ! -f "$TEMPLATE_PATH" ]]; then
    print_error "❌ Template file not found: $TEMPLATE_PATH"
    echo "   Make sure TEMPLATE.md exists in the scripts/ directory."
    exit 1
fi

# Function to get and validate contributor name
get_contributor_name() {
    while true; do
        echo ""
        read -p "Enter contributor's full name (e.g., Pankaj Kumar): " name
        
        # Trim whitespace
        name=$(echo "$name" | xargs)
        
        # Validate not empty
        if [[ -z "$name" ]]; then
            print_error "❌ Name cannot be empty. Please try again."
            continue
        fi
        
        # Validate has at least first and last name
        word_count=$(echo "$name" | wc -w)
        if [[ $word_count -lt 2 ]]; then
            print_error "❌ Please enter both first and last name."
            continue
        fi
        
        # Validate only contains letters, spaces, hyphens, and periods
        if [[ ! "$name" =~ ^[a-zA-Z\ \-\.]+$ ]]; then
            print_error "❌ Name contains invalid characters. Use only letters, spaces, hyphens, and periods."
            continue
        fi
        
        echo "$name"
        return 0
    done
}

# Function to convert name to filename
name_to_filename() {
    local name="$1"
    
    # Convert to lowercase and replace spaces with hyphens
    local filename=$(echo "$name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    
    # Remove any characters that aren't letters or hyphens
    filename=$(echo "$filename" | sed 's/[^a-z\-]//g')
    
    # Remove multiple consecutive hyphens
    filename=$(echo "$filename" | sed 's/-\+/-/g')
    
    # Remove leading/trailing hyphens
    filename=$(echo "$filename" | sed 's/^-//;s/-$//')
    
    echo "${filename}.md"
}

# Get contributor name
contributor_name=$(get_contributor_name)

# Read template
if ! template_content=$(cat "$TEMPLATE_PATH"); then
    print_error "❌ Failed to read template file"
    exit 1
fi

# Replace placeholder with actual name
content="${template_content//\[Your Full Name\]/$contributor_name}"

# Generate filename
filename=$(name_to_filename "$contributor_name")
filepath="$CONTRIBUTORS_DIR/$filename"

# Check if file already exists
if [[ -f "$filepath" ]]; then
    echo ""
    print_warning "⚠️  File '$filename' already exists."
    read -p "Overwrite? (y/N): " overwrite
    
    if [[ "$overwrite" != "y" && "$overwrite" != "Y" ]]; then
        print_error "❌ Cancelled. File not created."
        exit 0
    fi
fi

# Create contributors directory if it doesn't exist
mkdir -p "$CONTRIBUTORS_DIR"

# Write file with UTF-8 encoding
if echo "$content" > "$filepath"; then
    echo ""
    print_success "✅ Successfully created: $filepath"
    
    # Display next steps
    echo ""
    print_warning "📝 Next steps:"
    echo "   1. Edit $filepath"
    echo "   2. Fill in all required fields"
    echo "   3. Add your projects and details"
    echo "   4. Run validation:"
    echo "      Windows:    .\scripts\validate_profiles.ps1"
    echo "      Linux/Mac:  ./scripts/validate_profiles.sh"
    echo "   5. Submit a pull request to the repository"
    echo ""
    print_info "============================================================"
    print_success "✨ Profile template created successfully!"
    print_info "============================================================"
    echo ""
else
    print_error "❌ Error creating file"
    exit 1
fi
