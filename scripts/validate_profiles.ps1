<#
.SYNOPSIS
    Validate contributor profile files

.DESCRIPTION
    This script checks all contributor Markdown files for required fields
    and proper formatting. No external dependencies required.

.EXAMPLE
    .\validate_profiles.ps1
    
.NOTES
    Author: Dev Work Insights
    Version: 1.0
    Requires: PowerShell 5.1 or higher
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Required fields
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

# Color functions
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Write-Success { param([string]$Message) Write-ColorOutput $Message "Green" }
function Write-Fail { param([string]$Message) Write-ColorOutput $Message "Red" }
function Write-Warn { param([string]$Message) Write-ColorOutput $Message "Yellow" }
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
    
    $errors = New-Object System.Collections.ArrayList
    
    # Read file
    try {
        $content = Get-Content -Path $FilePath -Raw -Encoding UTF8
        $lines = Get-Content -Path $FilePath -Encoding UTF8
    } catch {
        [void]$errors.Add([ValidationError]::new($FilePath, 0, "Failed to read file: $_", "ERROR"))
        return $errors
    }
    
    $filename = Split-Path -Leaf $FilePath
    
    # Check file naming
    if ($filename -notmatch '^[a-z\-]+\.md$') {
        [void]$errors.Add([ValidationError]::new($FilePath, 0, "Filename must be lowercase with hyphens", "ERROR"))
    }
    
    # Check required fields
    foreach ($field in $RequiredFields) {
        if ($content -notlike "*$field*") {
            [void]$errors.Add([ValidationError]::new($FilePath, 0, "Missing required field: $field", "ERROR"))
        }
    }
    
    # Check for sensitive info
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $lineNum = $i + 1
        $line = $lines[$i]
        
        if ($line -match '\b\d{3}-\d{3}-\d{4}\b') {
            [void]$errors.Add([ValidationError]::new($FilePath, $lineNum, "Possible phone number detected", "WARNING"))
        }
        
        if ($line -match '\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b' -and $line -notmatch '@github\.com') {
            [void]$errors.Add([ValidationError]::new($FilePath, $lineNum, "Possible email detected", "WARNING"))
        }
    }
    
    # Check for placeholders
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $lineNum = $i + 1
        $line = $lines[$i]
        
        if ($line -match '\[Your .+?\]') {
            [void]$errors.Add([ValidationError]::new($FilePath, $lineNum, "Placeholder text found", "WARNING"))
            break
        }
    }
    
    # Check empty sections
    if ($content -match '\*\*Recent / Notable Projects:\*\*\s*$') {
        [void]$errors.Add([ValidationError]::new($FilePath, 0, "Projects section is empty", "ERROR"))
    }
    
    if ($content -match '\*\*Links:\*\*\s*$') {
        [void]$errors.Add([ValidationError]::new($FilePath, 0, "Links section is empty", "ERROR"))
    }
    
    # Check heading
    if ($content -notmatch '^## Name:') {
        [void]$errors.Add([ValidationError]::new($FilePath, 1, "File should start with '## Name:' heading", "ERROR"))
    }
    
    return $errors
}

# Main
Write-Host ""
Write-ColorOutput "======================================================================" "Cyan"
Write-ColorOutput "Dev Work Insights - Contributor Profile Validator" "Cyan"
Write-ColorOutput "======================================================================" "Cyan"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$ContributorsDir = Join-Path $ProjectRoot "contributors"

if (-not (Test-Path $ContributorsDir)) {
    Write-Fail "[ERROR] Contributors directory not found: $ContributorsDir"
    exit 2
}

$mdFiles = @(Get-ChildItem -Path $ContributorsDir -Filter "*.md" -File)

if ($mdFiles.Count -eq 0) {
    Write-Warn "[WARNING] No contributor files found"
    exit 0
}

# Validate all files
$allErrors = New-Object System.Collections.ArrayList
$filesWithErrors = 0

foreach ($file in $mdFiles) {
    $errors = Test-ContributorFile -FilePath $file.FullName
    if ($null -ne $errors -and @($errors).Count -gt 0) {
        foreach ($err in $errors) {
            [void]$allErrors.Add($err)
        }
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
    Write-Success "[OK] All $($mdFiles.Count) contributor file(s) are valid!"
    Write-Host ""
    exit 0
}

# Group errors
$errorCount = 0
$warningCount = 0
foreach ($err in $allErrors) {
    if ($err.Severity -eq 'ERROR') { $errorCount++ }
    else { $warningCount++ }
}

# Print errors
if ($errorCount -gt 0) {
    Write-Fail "[ERROR] Found $errorCount error(s):"
    Write-Host ""
    foreach ($error in $allErrors) {
        if ($error.Severity -eq 'ERROR') {
            Write-Host "  $($error.ToString())"
        }
    }
    Write-Host ""
}

# Print warnings
if ($warningCount -gt 0) {
    Write-Warn "[WARNING] Found $warningCount warning(s):"
    Write-Host ""
    foreach ($error in $allErrors) {
        if ($error.Severity -eq 'WARNING') {
            Write-Host "  $($error.ToString())"
        }
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
    Write-Fail "[ERROR] Validation failed. Please fix the errors above."
} else {
    Write-Warn "[WARNING] Validation passed with warnings."
}
Write-Host ""

exit $(if ($errorCount -gt 0) { 1 } else { 0 })
