<#
.SYNOPSIS
    Generate a new contributor profile for Dev Work Insights

.DESCRIPTION
    This script creates a new contributor Markdown file with proper naming
    and structure based on the TEMPLATE.md file. No external dependencies required.

.EXAMPLE
    .\generate_profile.ps1
    
.NOTES
    Author: Dev Work Insights
    Version: 1.0
    Requires: PowerShell 5.1 or higher
#>

# Set strict mode for better error handling
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Color functions for better UX
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Write-Success { param([string]$Message) Write-ColorOutput $Message "Green" }
function Write-Error { param([string]$Message) Write-ColorOutput $Message "Red" }
function Write-Warning { param([string]$Message) Write-ColorOutput $Message "Yellow" }
function Write-Info { param([string]$Message) Write-ColorOutput $Message "Cyan" }

# Banner
Write-Host ""
Write-ColorOutput "============================================================" "Cyan"
Write-ColorOutput "  Dev Work Insights - Contributor Profile Generator" "Cyan"
Write-ColorOutput "============================================================" "Cyan"
Write-Host ""

# Get script directory and project paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$TemplatePath = Join-Path $ScriptDir "TEMPLATE.md"
$ContributorsDir = Join-Path $ProjectRoot "contributors"

# Validate template exists
if (-not (Test-Path $TemplatePath)) {
    Write-Error "[ERROR] Template file not found: $TemplatePath"
    Write-Host "   Make sure TEMPLATE.md exists in the scripts/ directory."
    exit 1
}

# Function to get and validate contributor name
function Get-ContributorName {
    while ($true) {
        Write-Host ""
        $name = Read-Host "Enter contributor's full name (e.g., Pankaj Kumar)"
        
        # Trim whitespace
        $name = $name.Trim()
        
        # Validate not empty
        if ([string]::IsNullOrWhiteSpace($name)) {
            Write-Error "[ERROR] Name cannot be empty. Please try again."
            continue
        }
        
        # Validate has at least first and last name
        $nameParts = $name -split '\s+'
        if ($nameParts.Count -lt 2) {
            Write-Error "[ERROR] Please enter both first and last name."
            continue
        }
        
        # Validate only contains letters, spaces, hyphens, and periods
        if ($name -notmatch '^[a-zA-Z\s\-\.]+$') {
            Write-Error "[ERROR] Name contains invalid characters. Use only letters, spaces, hyphens, and periods."
            continue
        }
        
        return $name
    }
}

# Function to convert name to filename
function ConvertTo-Filename {
    param([string]$Name)
    
    # Convert to lowercase and replace spaces with hyphens
    $filename = $Name.ToLower() -replace '\s+', '-'
    
    # Remove any characters that aren't letters or hyphens
    $filename = $filename -replace '[^a-z\-]', ''
    
    # Remove multiple consecutive hyphens
    $filename = $filename -replace '-+', '-'
    
    # Remove leading/trailing hyphens
    $filename = $filename.Trim('-')
    
    return "$filename.md"
}

# Get contributor name
$contributorName = Get-ContributorName

# Read template
try {
    $templateContent = Get-Content -Path $TemplatePath -Raw -Encoding UTF8
} catch {
    Write-Error "❌ Failed to read template file: $_"
    exit 1
}

# Replace placeholder with actual name
$content = $templateContent -replace '\[Your Full Name\]', $contributorName

# Generate filename
$filename = ConvertTo-Filename -Name $contributorName
$filepath = Join-Path $ContributorsDir $filename

# Check if file already exists
if (Test-Path $filepath) {
    Write-Host ""
    Write-Warning "[WARNING] File '$filename' already exists."
    $overwrite = Read-Host "Overwrite? (y/N)"
    
    if ($overwrite -ne 'y' -and $overwrite -ne 'Y') {
        Write-Error "[CANCELLED] File not created."
        exit 0
    }
}

# Create contributors directory if it doesn't exist
if (-not (Test-Path $ContributorsDir)) {
    New-Item -ItemType Directory -Path $ContributorsDir -Force | Out-Null
}

# Write file with UTF-8 encoding (no BOM)
try {
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($filepath, $content, $utf8NoBom)
    
    Write-Host ""
    Write-Success "[OK] Successfully created: $filepath"
    
    # Display next steps
    Write-Host ""
    Write-ColorOutput "Next steps:" "Yellow"
    Write-Host "   1. Edit $filepath"
    Write-Host "   2. Fill in all required fields"
    Write-Host "   3. Add your projects and details"
    Write-Host "   4. Run validation:"
    Write-Host "      Windows:    .\scripts\validate_profiles.ps1"
    Write-Host "      Linux/Mac:  ./scripts/validate_profiles.sh"
    Write-Host "   5. Submit a pull request to the repository"
    Write-Host ""
    Write-ColorOutput "============================================================" "Cyan"
    Write-Success "[SUCCESS] Profile template created successfully!"
    Write-ColorOutput "============================================================" "Cyan"
    Write-Host ""
    
} catch {
    Write-Error "[ERROR] Error creating file: $_"
    exit 1
}
