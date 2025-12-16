#!/bin/bash
#
# Validate contributor profile files
#
# This script checks all contributor Markdown files in the contributors/
# directory for required fields, proper formatting, and common issues.
# No external dependencies required.
#
# Usage: ./validate_profiles.sh
#
# Exit codes:
#   0 - All files valid
#   1 - Validation errors found
#   2 - Script error
#
# Author: Dev Work Insights
# Version: 1.0
# Requires: Bash 4.0 or higher

set -euo pipefail

# Color codes
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Output functions
print_success() { echo -e "${GREEN}$1${NC}"; }
print_error() { echo -e "${RED}$1${NC}"; }
print_warning() { echo -e "${YELLOW}$1${NC}"; }
print_info() { echo -e "${CYAN}$1${NC}"; }

# Required fields
readonly REQUIRED_FIELDS=(
    "Name:"
    "Role / Position:"
    "Primary Tech Stack:"
    "Work Style / Preferences:"
    "Learning / Growth:"
    "Recent / Notable Projects:"
    "Career Aspirations:"
    "Links:"
)

# Validation error storage
declare -a ALL_ERRORS=()
declare -a ALL_WARNINGS=()

# Add error
add_error() {
    local filepath="$1"
    local line_num="$2"
    local message="$3"
    local filename=$(basename "$filepath")
    
    if [[ $line_num -gt 0 ]]; then
        ALL_ERRORS+=("ERROR: ${filename}:L${line_num} - ${message}")
    else
        ALL_ERRORS+=("ERROR: ${filename} - ${message}")
    fi
}

# Add warning
add_warning() {
    local filepath="$1"
    local line_num="$2"
    local message="$3"
    local filename=$(basename "$filepath")
    
    if [[ $line_num -gt 0 ]]; then
        ALL_WARNINGS+=("WARNING: ${filename}:L${line_num} - ${message}")
    else
        ALL_WARNINGS+=("WARNING: ${filename} - ${message}")
    fi
}

# Validate a single file
validate_file() {
    local filepath="$1"
    local filename=$(basename "$filepath")
    local has_errors=0
    
    # Read file
    if ! content=$(cat "$filepath" 2>/dev/null); then
        add_error "$filepath" 0 "Failed to read file"
        return 1
    fi
    
    # Check file naming convention
    if [[ ! "$filename" =~ ^[a-z\-]+\.md$ ]]; then
        add_error "$filepath" 0 "Filename must be lowercase with hyphens (e.g., firstname-lastname.md)"
        has_errors=1
    fi
    
    # Check for required fields
    for field in "${REQUIRED_FIELDS[@]}"; do
        if ! echo "$content" | grep -qF "$field"; then
            add_error "$filepath" 0 "Missing required field: $field"
            has_errors=1
        fi
    done
    
    # Check for sensitive information (line by line)
    local line_num=0
    while IFS= read -r line; do
        ((line_num++))
        
        # Phone numbers
        if echo "$line" | grep -qE '\b[0-9]{3}-[0-9]{3}-[0-9]{4}\b|\b[0-9]{3}\.[0-9]{3}\.[0-9]{4}\b'; then
            add_warning "$filepath" "$line_num" "Possible phone number detected - remove sensitive information"
        fi
        
        # Email addresses (excluding GitHub)
        if echo "$line" | grep -qE '\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b' && \
           ! echo "$line" | grep -qE '@(github\.com|users\.noreply\.github\.com)'; then
            add_warning "$filepath" "$line_num" "Possible email address detected - remove sensitive information"
        fi
        
        # API keys or secrets
        if echo "$line" | grep -qiE '\b(API[_\s]?KEY|SECRET[_\s]?KEY|PASSWORD|TOKEN)\s*[:=]'; then
            add_warning "$filepath" "$line_num" "Possible API key or secret detected - remove sensitive information"
        fi
        
        # Placeholder text
        if echo "$line" | grep -qE '\[Your .+?\]|\[e\.g\.,|\[Brief description|\[Description'; then
            add_warning "$filepath" "$line_num" "Placeholder text found - please fill in actual information"
        fi
    done < "$filepath"
    
    # Check for empty required sections
    if echo "$content" | grep -qE '\*\*Recent / Notable Projects:\*\*\s*$'; then
        add_error "$filepath" 0 "Projects section is empty - add at least one project"
        has_errors=1
    fi
    
    if echo "$content" | grep -qE '\*\*Links:\*\*\s*$'; then
        add_error "$filepath" 0 "Links section is empty - add at least one link"
        has_errors=1
    fi
    
    # Check for proper Markdown heading
    if ! head -n 1 "$filepath" | grep -qF "## Name:"; then
        add_error "$filepath" 1 "File should start with '## Name:' heading"
        has_errors=1
    fi
    
    return $has_errors
}

# Main
echo ""
print_info "======================================================================"
print_info "Dev Work Insights - Contributor Profile Validator"
print_info "======================================================================"

# Get script directory and project paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONTRIBUTORS_DIR="$PROJECT_ROOT/contributors"

# Check if contributors directory exists
if [[ ! -d "$CONTRIBUTORS_DIR" ]]; then
    print_error "❌ Contributors directory not found: $CONTRIBUTORS_DIR"
    exit 2
fi

# Get all .md files
shopt -s nullglob
md_files=("$CONTRIBUTORS_DIR"/*.md)
shopt -u nullglob

if [[ ${#md_files[@]} -eq 0 ]]; then
    print_warning "⚠️  No contributor files found in $CONTRIBUTORS_DIR"
    exit 0
fi

# Validate all files
files_with_errors=0

for file in "${md_files[@]}"; do
    if ! validate_file "$file"; then
        ((files_with_errors++))
    fi
done

# Print results
echo ""
print_info "======================================================================"
print_info "Validation Results"
print_info "======================================================================"
echo ""

if [[ ${#ALL_ERRORS[@]} -eq 0 && ${#ALL_WARNINGS[@]} -eq 0 ]]; then
    print_success "✅ All ${#md_files[@]} contributor file(s) are valid!"
    echo ""
    exit 0
fi

# Print errors
if [[ ${#ALL_ERRORS[@]} -gt 0 ]]; then
    print_error "❌ Found ${#ALL_ERRORS[@]} error(s):"
    echo ""
    for error in "${ALL_ERRORS[@]}"; do
        echo "  $error"
    done
    echo ""
fi

# Print warnings
if [[ ${#ALL_WARNINGS[@]} -gt 0 ]]; then
    print_warning "⚠️  Found ${#ALL_WARNINGS[@]} warning(s):"
    echo ""
    for warning in "${ALL_WARNINGS[@]}"; do
        echo "  $warning"
    done
    echo ""
fi

# Summary
echo "----------------------------------------------------------------------"
echo "Files checked: ${#md_files[@]}"
echo "Files with issues: $files_with_errors"
echo "Total errors: ${#ALL_ERRORS[@]}"
echo "Total warnings: ${#ALL_WARNINGS[@]}"
echo ""

if [[ ${#ALL_ERRORS[@]} -gt 0 ]]; then
    print_error "❌ Validation failed. Please fix the errors above."
    echo ""
    exit 1
else
    print_warning "⚠️  Validation passed with warnings. Consider addressing them."
    echo ""
    exit 0
fi
