#!/usr/bin/env bash
set -euo pipefail


BIN_DIR="${HOME}/.local/bin"
APPIMAGE_NAME="superProductivity-x86_64.AppImage"
TARGET="${BIN_DIR}/${APPIMAGE_NAME}"
STATE_FILE="${HOME}/.cache/update-superproductivity.state"
API_URL="https://api.github.com/repos/johannesjo/super-productivity/releases/latest"

mkdir -p "${BIN_DIR}" "$(dirname "${STATE_FILE}")"

# 1) Fetch the latest tag name
LATEST_TAG=$(curl -s "${API_URL}" \
  | jq -r '.tag_name')

# 2) Read the last-installed tag
if [[ -f "${STATE_FILE}" ]]; then
  LAST_TAG=$(<"${STATE_FILE}")
else
  LAST_TAG=""
fi

# 3) If it’s the same, exit early
if [[ "${LATEST_TAG}" == "${LAST_TAG}" ]]; then
  echo "👍 Already up-to-date (${LATEST_TAG})"
  exit 0
fi

# 4) Otherwise find & download the new AppImage
DOWNLOAD_URL=$(curl -s "${API_URL}" \
  | jq -r --arg name "${APPIMAGE_NAME}" \
      '.assets[] | select(.name == $name).browser_download_url')

if [[ -z "${DOWNLOAD_URL}" ]]; then
  echo "❌ Couldn't find AppImage asset for ${LATEST_TAG}"
  exit 1
fi

echo "⬇️  Updating to ${LATEST_TAG}…"
TMPFILE=$(mktemp)
curl -L --progress-bar "${DOWNLOAD_URL}" -o "${TMPFILE}"

# 5) Atomically replace, make executable
mv "${TMPFILE}" "${TARGET}"
chmod +x "${TARGET}"

# 6) Record the new tag
echo "${LATEST_TAG}" > "${STATE_FILE}"

echo "✅ Installed Super-Productivity ${LATEST_TAG}"

# NOTE: Create a shortcut desktop
# cat > ~/.local/share/applications/superproductivity.desktop <<EOF
# [Desktop Entry]
# Type=Application
# Name=Super Productivity
# Comment=A self-hosted productivity tool
# Exec=/home/mirf/.local/bin/superProductivity-x86_64.AppImage
# Icon=/home/mirf/.local/bin/superproductivity.png
# Categories=Office;Productivity;
# Terminal=false
# EOF
