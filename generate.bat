@echo off
REM Auto-detection launcher for Windows
REM Runs the PowerShell profile generator script

echo.
echo ============================================================
echo   Dev Work Insights - Profile Generator (Windows)
echo ============================================================
echo.

REM Check if PowerShell is available
where powershell >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: PowerShell not found!
    echo Please install PowerShell 5.1 or higher.
    exit /b 1
)

REM Run the PowerShell script
powershell -ExecutionPolicy Bypass -File "%~dp0scripts\generate_profile.ps1"

exit /b %ERRORLEVEL%
