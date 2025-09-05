#!/bin/bash

# --- Configuration ---
TERRAGRUNT_VERSION="0.83.2" # <<< LATEST STABLE VERSION - CHECK RELEASES!
INSTALL_PATH="/usr/local/bin"
DOWNLOAD_URL_BASE="https://github.com/gruntwork-io/terragrunt/releases/download"

# Determine architecture
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        TERRAGRUNT_ARCH="amd64"
        ;;
    aarch64)
        TERRAGRAGRUNT_ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH. Please download manually."
        exit 1
        ;;
esac

TERRAGRUNT_FILENAME="terragrunt_linux_${TERRAGRUNT_ARCH}"
TEMP_DIR=$(mktemp -d)

# --- Main Script Execution ---

echo "Starting Terragrunt direct installation script..."

# Check for curl (and other dependencies if needed, added for robustness)
if ! command -v curl &> /dev/null; then
    echo "curl is not installed. Installing curl..."
    sudo apt update
    sudo apt install -y curl
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install curl. Exiting."
        exit 1
    fi
fi

# Download Terragrunt
echo "Downloading Terragrunt v${TERRAGRUNT_VERSION} for ${ARCH}..."
# FIX: The 'v' was missing before the version number in the URL path
DOWNLOAD_URL="${DOWNLOAD_URL_BASE}/v${TERRAGRUNT_VERSION}/${TERRAGRUNT_FILENAME}"
echo "From: ${DOWNLOAD_URL}"

curl -L -o "${TEMP_DIR}/terragrunt" "${DOWNLOAD_URL}"
if [ $? -ne 0 ]; then
    echo "Error: Failed to download Terragrunt. Check the version or URL. Exiting."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Make executable and move to install path
echo "Making terragrunt executable and moving to ${INSTALL_PATH}..."
chmod +x "${TEMP_DIR}/terragrunt"
sudo mv "${TEMP_DIR}/terragrunt" "${INSTALL_PATH}/terragrunt"

if [ $? -ne 0 ]; then
    echo "Error: Failed to move terragrunt to ${INSTALL_PATH}. Check permissions."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Clean up
rm -rf "$TEMP_DIR"

echo "--- Verification ---"
echo "Terragrunt version:"
terragrunt --version

echo ""
echo "Installation complete!"
echo "Terragrunt is installed at ${INSTALL_PATH}/terragrunt."
echo "Remember to install Terraform separately if you haven't already."
