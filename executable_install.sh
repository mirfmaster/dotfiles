set -e


if [ ! "$(command -v chezmoi)" ]; then
  bin_dir="$HOME/.local/bin"
  if [ "$(command -v curl)" ]; then
    sh -c "$(curl -fsLS https://chezmoi.io/get)" -- init --apply mirfmaster
  elif [ "$(command -v wget)" ]; then
    sh -c "$(wget -fsLS https://chezmoi.io/get)" -- init --apply mirfmaster
  else
    echo "To install chezmoi, you must have curl or wget installed." >&2
    exit 1
  fi
fi

. ~/.labs/.sh/install.sh
