#!/usr/bin/env bash
#
# update-superproductivity.sh
# Download a specific or the latest x86_64 AppImage for
# Super-Productivity into ~/.local/bin, with optional force
# refresh, and integrate via AppImageLauncher if available.
#
# Usage:
#   update-superproductivity.sh [options]
#
# Options:
#   -f, --force         Always download & install even if tag matches
#   -V, --version TAG   Download & install the given TAG (e.g. v13.0.0)
#   -h, --help          Show this help message
#

set -euo pipefail

# Defaults
FORCE=0
VERSION=""
BIN_DIR="${HOME}/.local/bin"
APPIMAGE_NAME="superProductivity-x86_64.AppImage"
TARGET="${BIN_DIR}/${APPIMAGE_NAME}"
STATE_FILE="${HOME}/.cache/update-superproductivity.state"

# Parse CLI args
while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--force)
      FORCE=1
      shift
      ;;
    -V|--version)
      if [[ $# -lt 2 ]]; then
        echo "Error: --version requires an argument" >&2
        exit 1
      fi
      VERSION="$2"
      shift 2
      ;;
    -h|--help)
      cat <<EOF
Usage: $(basename "$0") [options]

Options:
  -f, --force         Always download & install even if tag matches
  -V, --version TAG   Download & install the given TAG (e.g. v13.0.0)
  -h, --help          Show this help message
EOF
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

# Ensure dirs exist
mkdir -p "${BIN_DIR}" "$(dirname "${STATE_FILE}")"

# Choose API endpoint
if [[ -n "${VERSION}" ]]; then
  API_URL="https://api.github.com/repos/johannesjo/super-productivity/releases/tags/${VERSION}"
else
  API_URL="https://api.github.com/repos/johannesjo/super-productivity/releases/latest"
fi

# 1) Fetch release JSON
RELEASE_JSON=$(curl -s "${API_URL}")

# 2) Extract tag_name and validate
LATEST_TAG=$(printf '%s' "${RELEASE_JSON}" | jq -r '.tag_name // empty')
if [[ -z "${LATEST_TAG}" ]]; then
  echo "❌ Could not fetch release info from ${API_URL}" >&2
  exit 1
fi

# 3) If not forced, compare to last-installed
if [[ $FORCE -eq 0 && -f "${STATE_FILE}" ]]; then
  LAST_TAG=$(<"${STATE_FILE}")
  if [[ "${LATEST_TAG}" == "${LAST_TAG}" ]]; then
    echo "👍 Already up-to-date (${LATEST_TAG})"
    exit 0
  fi
fi
(( FORCE )) && echo "⚡ Forcing download of ${LATEST_TAG}"

# 4) Find AppImage download URL
DOWNLOAD_URL=$(printf '%s' "${RELEASE_JSON}" \
  | jq -r --arg name "${APPIMAGE_NAME}" \
      '.assets[] | select(.name == $name).browser_download_url')

if [[ -z "${DOWNLOAD_URL}" ]]; then
  echo "❌ Could not find asset ${APPIMAGE_NAME} in ${LATEST_TAG}" >&2
  exit 1
fi

# 5) Download & install
echo "⬇️  Downloading Super-Productivity ${LATEST_TAG}…"
TMPFILE=$(mktemp)
curl -L --progress-bar "${DOWNLOAD_URL}" -o "${TMPFILE}"
mv "${TMPFILE}" "${TARGET}"
chmod +x "${TARGET}"

# 6) Record state
echo "${LATEST_TAG}" > "${STATE_FILE}"
echo "✅ Installed Super-Productivity ${LATEST_TAG} at ${TARGET}"

# 7) Integrate via AppImageLauncher if present
if cmd=$(command -v AppImageLauncher 2>/dev/null); then
  echo "🔗 Integrating with AppImageLauncher…"
  if ! "$cmd" "${TARGET}"; then
    echo "⚠️  AppImageLauncher integration failed" >&2
  fi
else
  echo "ℹ️  AppImageLauncher not detected; skipping integration"
fi

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
