#!/bin/bash

# Array of URLs to download
URLS=(
    "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    "https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb"
)

# Download directory
DOWNLOAD_DIR="$HOME/Downloads/apps"

# Create download directory if it doesn't exist
mkdir -p "$DOWNLOAD_DIR"

# Function to download a file from a URL
download_file() {
    local url=$1

    echo "Processing URL: $url"

    # Extract the filename from the URL
    FILENAME=$(basename "$url")

    # Download the file
    curl -L "$url" -o "$DOWNLOAD_DIR/$FILENAME"

    echo "Downloaded file from $url"
    echo ""
    echo ""
}

# Loop through each URL and download the file
for URL in "${URLS[@]}"; do
    download_file "$URL"
done

