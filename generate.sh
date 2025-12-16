#!/bin/bash
#
# Auto-detection launcher for Linux/macOS
# Runs the Bash profile generator script

echo ""
echo "============================================================"
echo "  Dev Work Insights - Profile Generator (Linux/macOS)"
echo "============================================================"
echo ""

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if bash is available
if ! command -v bash &> /dev/null; then
    echo "ERROR: Bash not found!"
    echo "Please install Bash 4.0 or higher."
    exit 1
fi

# Make the script executable if it isn't already
chmod +x "$SCRIPT_DIR/scripts/generate_profile.sh" 2>/dev/null || true

# Run the Bash script
bash "$SCRIPT_DIR/scripts/generate_profile.sh"

exit $?
