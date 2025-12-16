#!/usr/bin/env python3
"""
Generate a new contributor profile from template.

This script creates a new contributor Markdown file with proper naming
and structure based on the TEMPLATE.md file.

Usage:
    python generate_template.py

The script will prompt for the contributor's name and create a file
in the contributors/ directory with the format: firstname-lastname.md
"""

import os
import sys
import re
from pathlib import Path


def get_contributor_name():
    """Prompt for and validate contributor name."""
    while True:
        name = input("Enter contributor's full name (e.g., Jane Doe): ").strip()
        
        if not name:
            print("❌ Name cannot be empty. Please try again.")
            continue
        
        if len(name.split()) < 2:
            print("❌ Please enter both first and last name.")
            continue
        
        # Check for invalid characters
        if not re.match(r'^[a-zA-Z\s\-\.]+$', name):
            print("❌ Name contains invalid characters. Use only letters, spaces, hyphens, and periods.")
            continue
        
        return name


def name_to_filename(name):
    """Convert full name to filename format (firstname-lastname.md)."""
    # Remove extra spaces and convert to lowercase
    name = ' '.join(name.split()).lower()
    
    # Replace spaces with hyphens
    filename = name.replace(' ', '-')
    
    # Remove any characters that aren't letters or hyphens
    filename = re.sub(r'[^a-z\-]', '', filename)
    
    # Remove multiple consecutive hyphens
    filename = re.sub(r'-+', '-', filename)
    
    # Remove leading/trailing hyphens
    filename = filename.strip('-')
    
    return f"{filename}.md"


def create_contributor_file(name, template_path, output_dir):
    """Create a new contributor file from template."""
    # Read template
    try:
        with open(template_path, 'r', encoding='utf-8') as f:
            template_content = f.read()
    except FileNotFoundError:
        print(f"❌ Template file not found: {template_path}")
        print("Make sure TEMPLATE.md exists in the scripts/ directory.")
        sys.exit(1)
    
    # Replace placeholder with actual name
    content = template_content.replace('[Your Full Name]', name)
    
    # Generate filename
    filename = name_to_filename(name)
    filepath = output_dir / filename
    
    # Check if file already exists
    if filepath.exists():
        overwrite = input(f"⚠️  File {filename} already exists. Overwrite? (y/N): ").strip().lower()
        if overwrite != 'y':
            print("❌ Cancelled. File not created.")
            sys.exit(0)
    
    # Create contributors directory if it doesn't exist
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Write file
    try:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"✅ Successfully created: {filepath}")
        print(f"\n📝 Next steps:")
        print(f"   1. Edit {filepath}")
        print(f"   2. Fill in all required fields")
        print(f"   3. Add your projects and details")
        print(f"   4. Run validation: python scripts/validate_contributors.py")
        print(f"   5. Submit a pull request")
        return filepath
    except Exception as e:
        print(f"❌ Error creating file: {e}")
        sys.exit(1)


def main():
    """Main function."""
    print("=" * 60)
    print("Dev Work Insights - Contributor Profile Generator")
    print("=" * 60)
    print()
    
    # Get script directory
    script_dir = Path(__file__).parent
    template_path = script_dir / 'TEMPLATE.md'
    
    # Get project root (parent of scripts directory)
    project_root = script_dir.parent
    output_dir = project_root / 'contributors'
    
    # Get contributor name
    name = get_contributor_name()
    
    # Create file
    filepath = create_contributor_file(name, template_path, output_dir)
    
    print()
    print("=" * 60)
    print("✨ Profile template created successfully!")
    print("=" * 60)


if __name__ == '__main__':
    main()
