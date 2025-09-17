#!/bin/bash

#================================================================================
# المثبت الاحترافي لأدوات Aljailane (عبر Git)
# الإصدار: 2.2 (تحديث قسري ومقاوم للأخطاء)
# المؤلف: تم إنشاؤه وتطويره بواسطة Manus لـ aljailane
# الوصف: يقوم بجلب وتثبيت أحدث إصدار من أدوات Aljailane مباشرة من GitHub.
#================================================================================

set -e # Exit immediately if a command exits with a non-zero status.

# --- Configuration ---
GITHUB_REPO="aljailane/aljailane-tools"
INSTALL_DIR="/opt/aljailane"
BIN_DIR="/usr/local/bin"
COMMAND_NAME="aljailane"

# --- Functions ---
check_command() {
    command -v "$1" >/dev/null 2>&1
}

install_dependencies() {
    echo "Checking for dependencies..."
    local pkg_manager=""
    local packages_to_install=()

    if check_command apt; then pkg_manager="apt-get"; elif check_command dnf; then pkg_manager="dnf"; elif check_command yum; then pkg_manager="yum"; else
        echo "Warning: Unsupported package manager. Please install git, curl, clamav, pv manually."
        return
    fi

    declare -A req_pkgs=( ["git"]="git" ["curl"]="curl" ["clamav"]="clamscan" ["pv"]="pv" )
    for pkg_name in "${!req_pkgs[@]}"; do
        if ! check_command "${req_pkgs[$pkg_name]}"; then packages_to_install+=("$pkg_name"); fi
    done

    if [ ${#packages_to_install[@]} -gt 0 ]; then
        echo "Installing missing dependencies: ${packages_to_install[*]}..."
        sudo "$pkg_manager" update -y
        sudo "$pkg_manager" install -y "${packages_to_install[@]}"
    else
        echo "✅ All dependencies are already satisfied."
    fi
}

# --- Main Logic ---
echo "Starting installation of Aljailane Tool Suite..."
echo "--------------------------------------------------"

# 1. Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run with root privileges. Use 'sudo' with the curl command."
  exit 1
fi

# 2. Install dependencies
install_dependencies

# 3. [FINAL] Clone or perform a forced update
if [ -d "$INSTALL_DIR/.git" ]; then
    echo "Updating existing installation in $INSTALL_DIR..."
    cd "$INSTALL_DIR"
    # Fetch the latest changes from the remote repository
    git fetch origin main
    # Reset the local branch to match the remote branch, discarding any local changes
    echo "Forcing update to the latest version..."
    git reset --hard origin/main
    cd - > /dev/null
else
    if [ -d "$INSTALL_DIR" ]; then
        echo "Found a non-git directory at $INSTALL_DIR. Removing for a clean installation."
        rm -rf "$INSTALL_DIR"
    fi
    echo "Cloning repository into $INSTALL_DIR..."
    git clone "https://github.com/${GITHUB_REPO}.git" "$INSTALL_DIR"
fi

# 4. Set execution permissions
echo "Setting execution permissions..."
chmod +x "$INSTALL_DIR"/*.sh

# 5. Create the symbolic link for the command
echo "Creating command '$COMMAND_NAME' in $BIN_DIR..."
ln -sf "$INSTALL_DIR/launcher.sh" "$BIN_DIR/$COMMAND_NAME"

# 6. Final success message
echo "--------------------------------------------------"
echo "✅ Installation/Update complete!"
echo "You can now run the tool from anywhere by simply typing:"
echo ""
echo "  $COMMAND_NAME"
echo ""
echo "--------------------------------------------------"

exit 0
