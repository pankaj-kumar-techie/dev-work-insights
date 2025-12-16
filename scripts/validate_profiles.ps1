<#
.SYNOPSIS
    Validate contributor profile files

.DESCRIPTION
    This script checks all contributor Markdown files in the contributors/
    directory for required fields, proper formatting, and common issues.
    No external dependencies required.

.EXAMPLE
    .\validate_profiles.ps1
    
.NOTES
    Author: Dev Work Insights
    Version: 1.0
    Requires: PowerShell 5.1 or higher
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Required fields that must be present
$RequiredFields = @(
    'Name:',
    'Role / Position:',
    'Primary Tech Stack:',
    'Work Style / Preferences:',
    'Learning / Growth:',
    'Recent / Notable Projects:',
    'Career Aspirations:',
    'Links:'
)

# Sensitive patterns to detect
$SensitivePatterns = @(
    @{ Pattern = '\b\d{3}-\d{3}-\d{4}\b'; Description = 'phone number' },
    @{ Pattern = '\b\d{3}\.\d{3}\.\d{4}\b'; Description = 'phone number' },
    @{ Pattern = '\b[A-Za-z0-9._%+-]+@(?!github\.com|users\.noreply\.github\.com)[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'; Description = 'email address' },
    @{ Pattern = '\b(?:API[_\s]?KEY|SECRET[_\s]?KEY|PASSWORD|TOKEN)\s*[:=]\s*[''"]?[\w\-]+[''"]?'; Description = 'API key or secret' }
)

# Color functions
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Write-Success { param([string]$Message) Write-ColorOutput $Message "Green" }
function Write-Error { param([string]$Message) Write-ColorOutput $Message "Red" }
function Write-Warning { param([string]$Message) Write-ColorOutput $Message "Yellow" }
function Write-Info { param([string]$Message) Write-ColorOutput $Message "Cyan" }

# Validation error class
class ValidationError {
    [string]$Filepath
    [int]$LineNum
    [string]$Message
    [string]$Severity
    
    ValidationError([string]$filepath, [int]$lineNum, [string]$message, [string]$severity) {
        $this.Filepath = $filepath
        $this.LineNum = $lineNum
        $this.Message = $message
        $this.Severity = $severity
    }
    
    [string] ToString() {
        $filename = Split-Path -Leaf $this.Filepath
        $location = $filename
        if ($this.LineNum -gt 0) {
            $location += ":L$($this.LineNum)"
        }
        return "$($this.Severity): $location - $($this.Message)"
    }
}

# Validate a single file
function Test-ContributorFile {
    param([string]$FilePath)
    
    [System.Collections.ArrayList]$errors = @()
    
    # Read file
    try {
        $content = Get-Content -Path $FilePath -Raw -Encoding UTF8
        $lines = Get-Content -Path $FilePath -Encoding UTF8
    } catch {
        [void]$errors.Add([ValidationError]::new($FilePath, 0, "Failed to read file: $_", "ERROR"))
        return ,$errors
    }
    
    $filename = Split-Path -Leaf $FilePath
    
    # Check file naming convention
    if ($filename -notmatch '^[a-z\-]+\.md$') {
        $errors += [ValidationError]::new($FilePath, 0, "Filename must be lowercase with hyphens (e.g., firstname-lastname.md)", "ERROR")
    }
    
    # Check for required fields
    foreach ($field in $RequiredFields) {
        if ($content -notlike "*$field*") {
            $errors += [ValidationError]::new($FilePath, 0, "Missing required field: $field", "ERROR")
        }
    }
    
    # Check for sensitive information
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $lineNum = $i + 1
        $line = $lines[$i]
        
        foreach ($pattern in $SensitivePatterns) {
            if ($line -match $pattern.Pattern) {
                $errors += [ValidationError]::new($FilePath, $lineNum, "Possible $($pattern.Description) detected - remove sensitive information", "WARNING")
            }
        }
    }
    
    # Check for placeholder text
    $placeholderPatterns = @('\[Your .+?\]', '\[e\.g\.,', '\[Brief description', '\[Description')
    
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $lineNum = $i + 1
        $line = $lines[$i]
        
        foreach ($pattern in $placeholderPatterns) {
            if ($line -match $pattern) {
                $errors += [ValidationError]::new($FilePath, $lineNum, "Placeholder text found - please fill in actual information", "WARNING")
                break
            }
        }
    }
    
    # Check for empty required sections
    if ($content -match '\*\*Recent / Notable Projects:\*\*\s*$') {
        $errors += [ValidationError]::new($FilePath, 0, "Projects section is empty - add at least one project", "ERROR")
    }
    
    if ($content -match '\*\*Links:\*\*\s*$') {
        $errors += [ValidationError]::new($FilePath, 0, "Links section is empty - add at least one link", "ERROR")
    }
    
    # Check for proper Markdown heading
    if ($content -notmatch '^## Name:') {
        $errors += [ValidationError]::new($FilePath, 1, "File should start with '## Name:' heading", "ERROR")
    }
    
    return $errors
}

# Main validation
Write-Host ""
Write-ColorOutput "======================================================================" "Cyan"
Write-ColorOutput "Dev Work Insights - Contributor Profile Validator" "Cyan"
Write-ColorOutput "======================================================================" "Cyan"

# Get script directory and project paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$ContributorsDir = Join-Path $ProjectRoot "contributors"

# Check if contributors directory exists
if (-not (Test-Path $ContributorsDir)) {
    Write-Error "❌ Contributors directory not found: $ContributorsDir"
    exit 2
}

# Get all .md files
$mdFiles = Get-ChildItem -Path $ContributorsDir -Filter "*.md" -File

if ($mdFiles.Count -eq 0) {
    Write-Warning "⚠️  No contributor files found in $ContributorsDir"
    exit 0
}

# Validate all files
$allErrors = @()
$filesWithErrors = 0

foreach ($file in $mdFiles) {
    $errors = Test-ContributorFile -FilePath $file.FullName
    if ($null -ne $errors -and $errors.Count -gt 0) {
        $allErrors += $errors
        $filesWithErrors++
    }
}

# Print results
Write-Host ""
Write-ColorOutput "======================================================================" "Cyan"
Write-ColorOutput "Validation Results" "Cyan"
Write-ColorOutput "======================================================================" "Cyan"
Write-Host ""

if ($allErrors.Count -eq 0) {
    Write-Success "✅ All $($mdFiles.Count) contributor file(s) are valid!"
    Write-Host ""
    exit 0
}

# Group errors by severity
$errorCount = ($allErrors | Where-Object { $_.Severity -eq 'ERROR' }).Count
$warningCount = ($allErrors | Where-Object { $_.Severity -eq 'WARNING' }).Count

# Print errors
if ($errorCount -gt 0) {
    Write-Error "❌ Found $errorCount error(s):"
    Write-Host ""
    foreach ($error in $allErrors | Where-Object { $_.Severity -eq 'ERROR' }) {
        Write-Host "  $($error.ToString())"
    }
    Write-Host ""
}

# Print warnings
if ($warningCount -gt 0) {
    Write-Warning "⚠️  Found $warningCount warning(s):"
    Write-Host ""
    foreach ($error in $allErrors | Where-Object { $_.Severity -eq 'WARNING' }) {
        Write-Host "  $($error.ToString())"
    }
    Write-Host ""
}

# Summary
Write-Host "----------------------------------------------------------------------"
Write-Host "Files checked: $($mdFiles.Count)"
Write-Host "Files with issues: $filesWithErrors"
Write-Host "Total errors: $errorCount"
Write-Host "Total warnings: $warningCount"
Write-Host ""

if ($errorCount -gt 0) {
    Write-Error "❌ Validation failed. Please fix the errors above."
} else {
    Write-Warning "⚠️  Validation passed with warnings. Consider addressing them."
}
Write-Host ""

exit $(if ($errorCount -gt 0) { 1 } else { 0 })
