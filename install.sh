#!/bin/bash

#================================================
# Installer for Aljailane Tool Suite
# Created by aljailane
#================================================

# --- Configuration ---
INSTALL_DIR="/opt/aljailane"
BIN_DIR="/usr/local/bin"
COMMAND_NAME="aljailane"
SOURCE_FILES=("launcher.sh" "sec.sh" "an.sh")

# --- Main Logic ---
echo "Starting installation of Aljailane Tool Suite..."

# 1. Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run with root privileges. Use 'sudo ./install.sh'"
  exit 1
fi

# 2. Create installation directory
echo "Creating installation directory at $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"

# 3. Copy script files
echo "Copying tool files..."
for file in "${SOURCE_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Error: Source file '$file' not found. Make sure it's in the same directory as the installer."
        exit 1
    fi
    cp "$file" "$INSTALL_DIR/"
done

# 4. Set execution permissions
echo "Setting execution permissions..."
chmod +x "$INSTALL_DIR"/*.sh

# 5. Create the symbolic link for the command
echo "Creating command '$COMMAND_NAME'..."
ln -sf "$INSTALL_DIR/launcher.sh" "$BIN_DIR/$COMMAND_NAME"

# 6. Final success message
echo "--------------------------------------------------"
echo "✅ Installation complete!"
echo "You can now run the tool from anywhere by simply typing:"
echo ""
echo "  $COMMAND_NAME"
echo ""
echo "--------------------------------------------------"

exit 0
