#!/usr/bin/env python3
"""
Validate contributor profile files.

This script checks all contributor Markdown files in the contributors/
directory for required fields, proper formatting, and common issues.

Usage:
    python validate_contributors.py

Exit codes:
    0 - All files valid
    1 - Validation errors found
    2 - Script error (missing directory, etc.)
"""

import os
import sys
import re
from pathlib import Path
from typing import List, Tuple, Dict


# Required fields that must be present in every profile
REQUIRED_FIELDS = [
    'Name:',
    'Role / Position:',
    'Primary Tech Stack:',
    'Work Style / Preferences:',
    'Learning / Growth:',
    'Recent / Notable Projects:',
    'Career Aspirations:',
    'Links:',
]

# Sensitive patterns that should not be in profiles
SENSITIVE_PATTERNS = [
    (r'\b\d{3}-\d{3}-\d{4}\b', 'phone number'),
    (r'\b\d{3}\.\d{3}\.\d{4}\b', 'phone number'),
    (r'\b[A-Za-z0-9._%+-]+@(?!github\.com|users\.noreply\.github\.com)[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b', 'email address'),
    (r'\b(?:API[_\s]?KEY|SECRET[_\s]?KEY|PASSWORD|TOKEN)\s*[:=]\s*[\'"]?[\w\-]+[\'"]?', 'API key or secret'),
]


class ValidationError:
    """Represents a validation error."""
    
    def __init__(self, filepath: Path, line_num: int, message: str, severity: str = 'ERROR'):
        self.filepath = filepath
        self.line_num = line_num
        self.message = message
        self.severity = severity
    
    def __str__(self):
        location = f"{self.filepath.name}"
        if self.line_num > 0:
            location += f":L{self.line_num}"
        return f"{self.severity}: {location} - {self.message}"


def validate_file(filepath: Path) -> List[ValidationError]:
    """Validate a single contributor file."""
    errors = []
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
            lines = content.split('\n')
    except Exception as e:
        errors.append(ValidationError(filepath, 0, f"Failed to read file: {e}"))
        return errors
    
    # Check file naming convention
    if not re.match(r'^[a-z\-]+\.md$', filepath.name):
        errors.append(ValidationError(
            filepath, 0,
            "Filename must be lowercase with hyphens (e.g., firstname-lastname.md)",
            'ERROR'
        ))
    
    # Check for required fields
    for field in REQUIRED_FIELDS:
        if field not in content:
            errors.append(ValidationError(
                filepath, 0,
                f"Missing required field: {field}",
                'ERROR'
            ))
    
    # Check for sensitive information
    for line_num, line in enumerate(lines, 1):
        for pattern, description in SENSITIVE_PATTERNS:
            if re.search(pattern, line, re.IGNORECASE):
                errors.append(ValidationError(
                    filepath, line_num,
                    f"Possible {description} detected - remove sensitive information",
                    'WARNING'
                ))
    
    # Check for placeholder text
    placeholder_patterns = [
        r'\[Your .+?\]',
        r'\[e\.g\.,',
        r'\[Brief description',
        r'\[Description',
    ]
    
    for line_num, line in enumerate(lines, 1):
        for pattern in placeholder_patterns:
            if re.search(pattern, line):
                errors.append(ValidationError(
                    filepath, line_num,
                    "Placeholder text found - please fill in actual information",
                    'WARNING'
                ))
    
    # Check for empty required sections
    if re.search(r'\*\*Recent / Notable Projects:\*\*\s*$', content, re.MULTILINE):
        errors.append(ValidationError(
            filepath, 0,
            "Projects section is empty - add at least one project",
            'ERROR'
        ))
    
    if re.search(r'\*\*Links:\*\*\s*$', content, re.MULTILINE):
        errors.append(ValidationError(
            filepath, 0,
            "Links section is empty - add at least one link",
            'ERROR'
        ))
    
    # Check for proper Markdown heading
    if not content.strip().startswith('## Name:'):
        errors.append(ValidationError(
            filepath, 1,
            "File should start with '## Name:' heading",
            'ERROR'
        ))
    
    return errors


def validate_all_contributors(contributors_dir: Path) -> Tuple[int, int, List[ValidationError]]:
    """Validate all contributor files in directory."""
    if not contributors_dir.exists():
        print(f"❌ Contributors directory not found: {contributors_dir}")
        sys.exit(2)
    
    # Get all .md files
    md_files = list(contributors_dir.glob('*.md'))
    
    if not md_files:
        print(f"⚠️  No contributor files found in {contributors_dir}")
        return 0, 0, []
    
    all_errors = []
    files_with_errors = 0
    
    for filepath in sorted(md_files):
        errors = validate_file(filepath)
        if errors:
            all_errors.extend(errors)
            files_with_errors += 1
    
    return len(md_files), files_with_errors, all_errors


def print_results(total_files: int, files_with_errors: int, errors: List[ValidationError]):
    """Print validation results."""
    print()
    print("=" * 70)
    print("Validation Results")
    print("=" * 70)
    print()
    
    if not errors:
        print(f"✅ All {total_files} contributor file(s) are valid!")
        print()
        return
    
    # Group errors by severity
    error_count = sum(1 for e in errors if e.severity == 'ERROR')
    warning_count = sum(1 for e in errors if e.severity == 'WARNING')
    
    # Print errors
    if error_count > 0:
        print(f"❌ Found {error_count} error(s):")
        print()
        for error in errors:
            if error.severity == 'ERROR':
                print(f"  {error}")
        print()
    
    # Print warnings
    if warning_count > 0:
        print(f"⚠️  Found {warning_count} warning(s):")
        print()
        for error in errors:
            if error.severity == 'WARNING':
                print(f"  {error}")
        print()
    
    # Summary
    print("-" * 70)
    print(f"Files checked: {total_files}")
    print(f"Files with issues: {files_with_errors}")
    print(f"Total errors: {error_count}")
    print(f"Total warnings: {warning_count}")
    print()
    
    if error_count > 0:
        print("❌ Validation failed. Please fix the errors above.")
    else:
        print("⚠️  Validation passed with warnings. Consider addressing them.")
    print()


def main():
    """Main function."""
    print("=" * 70)
    print("Dev Work Insights - Contributor Profile Validator")
    print("=" * 70)
    
    # Get script directory
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    contributors_dir = project_root / 'contributors'
    
    # Validate all files
    total_files, files_with_errors, errors = validate_all_contributors(contributors_dir)
    
    # Print results
    print_results(total_files, files_with_errors, errors)
    
    # Exit with appropriate code
    error_count = sum(1 for e in errors if e.severity == 'ERROR')
    sys.exit(1 if error_count > 0 else 0)


if __name__ == '__main__':
    main()
