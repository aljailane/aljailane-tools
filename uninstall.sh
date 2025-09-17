#!/bin/bash

#================================================
# Uninstaller for Aljailane Tool Suite
# Created by aljailane
# Description: Safely and completely removes the
#              Aljailane Tool Suite from the system.
#================================================

# --- Configuration (must match install.sh) ---
INSTALL_DIR="/opt/aljailane"
BIN_DIR="/usr/local/bin"
COMMAND_NAME="aljailane"
COMMAND_PATH="$BIN_DIR/$COMMAND_NAME"

# --- Data directories created by the tools ---
DATA_DIRS=(
    "/home/clamav_logs"
    "/home/clamav_quarantine"
    "/home/reports"
    "/home/trash_bin_*" # Using a wildcard for trash bins
)

# --- Main Logic ---
echo "Starting uninstallation of Aljailane Tool Suite..."
echo "--------------------------------------------------"

# 1. Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run with root privileges. Use 'sudo ./uninstall.sh'"
  exit 1
fi

# 2. Remove the symbolic link (the command)
if [ -L "$COMMAND_PATH" ]; then
    echo "Removing command '$COMMAND_NAME' from $BIN_DIR..."
    rm -f "$COMMAND_PATH"
    echo "Command removed."
else
    echo "Command '$COMMAND_NAME' not found. Skipping."
fi

# 3. Remove the installation directory
if [ -d "$INSTALL_DIR" ]; then
    echo "Removing installation directory at $INSTALL_DIR..."
    rm -rf "$INSTALL_DIR"
    echo "Installation directory removed."
else
    echo "Installation directory '$INSTALL_DIR' not found. Skipping."
fi

# 4. Ask to remove data directories
echo "--------------------------------------------------"
read -p "Do you want to remove data directories (logs, reports, quarantine)? [y/N]: " remove_data

if [[ "$remove_data" =~ ^[Yy]$ ]]; then
    echo "Removing data directories..."
    for dir in "${DATA_DIRS[@]}"; do
        # Check if the directory/pattern exists before trying to remove
        if [ -d "$dir" ] || ls -d $dir > /dev/null 2>&1; then
            echo "Removing $dir..."
            rm -rf "$dir"
        fi
    done
    echo "Data directories removed."
else
    echo "Skipping removal of data directories."
fi

# 5. Final success message
echo "--------------------------------------------------"
echo "✅ Uninstallation complete!"
echo "The Aljailane Tool Suite has been successfully removed from your system."
echo "--------------------------------------------------"

exit 0
