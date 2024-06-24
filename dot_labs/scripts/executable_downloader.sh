#!/bin/bash

# Array of GitHub repositories
REPOS=(
    "TheAssassin/AppImageLauncher"
    # Add more repositories as needed
)

# Download directory
DOWNLOAD_DIR="$HOME/Downloads/apps"

# Create download directory if it doesn't exist
mkdir -p "$DOWNLOAD_DIR"

# Function to download the latest release from a GitHub repository
download_latest_release() {
    local repo=$1

    echo "Processing repository: $repo"

    # Get the latest release download URL
    DOWNLOAD_URL=$(curl -s https://api.github.com/repos/$repo/releases/latest \
    | grep -Eo 'https://[^\"]+\.AppImage')

    echo $DOWNLOAD_URL
    if [[ -z "$DOWNLOAD_URL" ]]; then
        echo "Failed to get the download URL for $repo"
        return
    fi

    # Extract the filename from the URL
    FILENAME=$(basename "$DOWNLOAD_URL")

    # Download the latest release
    curl -L "$DOWNLOAD_URL" -o "$DOWNLOAD_DIR/$FILENAME"

    # Make the downloaded AppImage executable
    chmod +x "$DOWNLOAD_DIR/$FILENAME"

    echo "Downloaded $FILENAME to $DOWNLOAD_DIR"
}

# Loop through each repository and download the latest release
for REPO in "${REPOS[@]}"; do
    download_latest_release "$REPO"
done

