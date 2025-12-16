@echo off
echo ========================================
echo Testing Dev Work Insights Repository
echo ========================================
echo.

echo [1/4] Checking directory structure...
dir /B
echo.

echo [2/4] Checking contributors directory...
dir /B contributors
echo.

echo [3/4] Checking scripts directory...
dir /B scripts
echo.

echo [4/4] Running validation script...
python scripts\validate_contributors.py
echo.

echo ========================================
echo Test Complete
echo ========================================
