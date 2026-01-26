alias clear_history='cat /dev/null > ~/.bash_history && history -c'

################# FUNCTIONS ########################
setRepoConfigProfile() {
  echo -e "\033[1;34m[INFO]\033[0m Setting up repo config using personal email"
  git config user.email "mirfmaster@gmail.com"
  git config user.name "Muhamad Iqbal"
}

setRepoConfigProfileZOT() {
  echo -e "\033[1;34m[INFO]\033[0m Setting up repo config using ZOT email"
  git config user.email "iqbal@zero-one-group.com"
  git config user.name "Muhamad Iqbal"
}

dockerStopRestart() {
  bl_info "Update all docker to no auto restart"
  docker update --restart=no $(docker ps -a -q)
}

gtfd() {
  local template="$1"
  local path="$2"

  /usr/sbin/terraform-docs --sort-by "required" -c "$template" "$path" >"$path/readme.md"
}

cmpush() {
  echo -e "\033[1;34m[INFO]\033[0m Syncing working directory with remote repository"
  sleep 1
  git add .
  git commit -m "."
  git push
}

cmsync() {
  echo -e "\033[1;34m[INFO]\033[0m Syncing local changes to repo"

  chezmoi add ~/.labs/

  cd ~/.local/share/chezmoi

  # Find and remove deleted files, with logging
  deleted=$(chezmoi status | grep "^D " | awk '{print $2}')

  if [ -n "$deleted" ]; then
    echo -e "\033[1;33m[WARN]\033[0m Removing deleted files:"
    echo "$deleted" | while read file; do
      echo "  - $file"
      rm -f "$file"
    done
  else
    echo -e "\033[1;32m[OK]\033[0m No deleted files"
  fi

  cmpush

  cd -
  echo -e "\033[1;34m[INFO]\033[0m Sync success"
}
# NOTE: USAGE
# psqld -e                  # uses all values from .env
# psqld -e other_database   # uses .env but overrides database name
# # or
# psqld --env              # uses all values from .env
# psqld --env other_database # uses .env but overrides database name
# psqld database_name                                    # uses defaults
# psqld database_name 5433                              # custom port
# user=myuser password=mypass psqld database_name       # custom credentials
psqld() {
  if [ "$1" = "-e" ] || [ "$1" = "--env" ]; then
    # Use .env file
    if [ -f .env ]; then
      # Only load database-related variables
      DATABASE_USER=$(grep '^DATABASE_USER=' .env | cut -d '=' -f2)
      DATABASE_PASSWORD=$(grep '^DATABASE_PASSWORD=' .env | cut -d '=' -f2)
      DATABASE_HOST=$(grep '^DATABASE_HOST=' .env | cut -d '=' -f2)
      DATABASE_PORT=$(grep '^DATABASE_PORT=' .env | cut -d '=' -f2)
      DATABASE_NAME=$(grep '^DATABASE_NAME=' .env | cut -d '=' -f2)

      export DOCKER_POSTGRES_DB="postgresql://${DATABASE_USER:-postgres}:${DATABASE_PASSWORD:-postgres}@${DATABASE_HOST:-localhost}:${DATABASE_PORT:-5432}/${2:-$DATABASE_NAME}"
    else
      echo "Error: .env file not found"
      return 1
    fi
  else
    # Use command line parameters
    export DOCKER_POSTGRES_DB="postgresql://${user:-postgres}:${password:-postgres}@localhost:${2:-5432}/$1"
  fi

  export PAGER=less
  psql -d $DOCKER_POSTGRES_DB -P expanded=auto -P 'null=(null)' -P border=2
}

add_prefix() {
  # Check if prefix is provided
  if [ -z "$1" ]; then
    echo "Usage: add_prefix <prefix>"
    echo "Example: add_prefix NEW_"
    return 1
  fi

  prefix="$1"

  # Loop through all files in current directory
  for file in *; do
    # Skip if it's a directory
    if [ -d "$file" ]; then
      continue
    fi

    # Skip if the file already starts with the prefix
    case "$file" in
    "$prefix"*)
      echo "Skipping $file - already has prefix"
      continue
      ;;
    esac

    # Rename the file
    new_name="$prefix$file"
    mv "$file" "$new_name"
    echo "Renamed: $file -> $new_name"
  done
}

rm_contain() {
  if [ -z "$1" ]; then
    echo "Usage: delete_files_containing <text_pattern>"
    echo "Example: delete_files_containing '_test.go'"
    return 1
  fi

  # First list the files that will be deleted
  echo "The following files will be deleted:"
  find . -type f -name "*${1}*" -print

  # Ask for confirmation (zsh compatible)
  echo -n "Are you sure you want to delete these files? (y/N) "
  read confirm

  if [[ "$confirm" == [yY] || "$confirm" == [yY][eE][sS] ]]; then
    find . -type f -name "*${1}*" -delete
    echo "Files deleted successfully."
  else
    echo "Operation cancelled."
  fi
}

# Function to search and open tmux sessions using fzf
# Usage: tmo
function tmux_open_session() {
  local session

  # Check if tmux is running
  if ! command -v tmux >/dev/null 2>&1; then
    echo "tmux is not installed"
    return 1
  fi

  # Get existing sessions
  session=$(tmux list-sessions -F "#S" 2>/dev/null | fzf --height 20% \
    --bind change:first \
    --header "Select tmux session")

  # If no session selected, exit
  if [ -z "$session" ]; then
    return 0
  fi

  # If not in tmux, attach to session
  if [ -z "$TMUX" ]; then
    tmux attach-session -t "$session"
  else
    # If already in tmux, switch to session
    tmux switch-client -t "$session"
  fi
}

function tmux_smart_open() {
  local session

  # Check if tmux is running
  if ! command -v tmux >/dev/null 2>&1; then
    echo "tmux is not installed"
    return 1
  fi

  # Get existing sessions
  local existing_sessions
  existing_sessions=$(tmux list-sessions -F "#S" 2>/dev/null)

  if [ -z "$existing_sessions" ]; then
    # No existing sessions, just open tmux
    echo "No existing tmux sessions. Opening a new tmux session."
    tmux
  else
    # If already inside a tmux session, offer to switch, otherwise attach
    if [ -n "$TMUX" ]; then
      # We are inside tmux, so list sessions for switching
      session=$(echo "$existing_sessions" | fzf --height 20% \
        --bind change:first \
        --header "Select tmux session to switch to or press ESC to create new")

      # If no session selected (ESC pressed), create a new tmux session
      if [ -z "$session" ]; then
        echo "No session selected. Opening a new tmux session."
        tmux new-session
      else
        # Switch to the selected session
        tmux switch-client -t "$session"
      fi
    else
      # We are not inside tmux, so list sessions for attaching
      session=$(echo "$existing_sessions" | fzf --height 20% \
        --bind change:first \
        --header "Select tmux session to attach to or press ESC to create new")

      # If no session selected (ESC pressed), create a new tmux session
      if [ -z "$session" ]; then
        echo "No session selected. Opening a new tmux session."
        tmux
      else
        # Attach to the selected session
        tmux attach-session -t "$session"
      fi
    fi
  fi
}

function recopy() {
  local src config_file flatten_names=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
    --flatten-names)
      flatten_names=true
      shift
      ;;
    *)
      config_file="$1"
      shift
      ;;
    esac
  done

  # Check if config file is provided
  if [ -z "$config_file" ]; then
    echo "Usage: recopy [--flatten-names] <config_file>"
    return 1
  fi

  # Check if config file exists
  if [ ! -f "$config_file" ]; then
    echo "Config file not found: $config_file"
    return 1
  fi

  # Store current dir and get source dir
  cd ..
  src="$(pwd)"
  cd - >/dev/null

  echo "Source: $src"
  echo "Destination: $(pwd)"

  # Read and process config file
  while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [ -z "$line" ] && continue
    [[ "$line" =~ ^#.*$ ]] && continue

    # Check if the line ends with /*
    if [[ "$line" == *"/*" ]]; then
      # Remove the /* from the end to get the directory path
      dir_path="${line%/*}"

      # Check if the source directory exists
      if [ ! -d "$src/$dir_path" ]; then
        echo "❌ Failed: Directory not found - $dir_path"
        continue
      fi

      # Copy all contents of the directory
      if [ "$flatten_names" = true ]; then
        # Copy and rename each file individually
        for file in "$src/$dir_path/"*; do
          if [ -f "$file" ]; then
            local rel_path="${file#$src/}"
            local flat_name=$(echo "${rel_path%/*}/${rel_path##*/}" | tr '/' '_')
            if cp -f "$file" "$flat_name" 2>/dev/null; then
              echo "✅ Copied: $rel_path -> $flat_name"
            else
              echo "❌ Failed to copy: $rel_path"
            fi
          fi
        done
      else
        if cp -rf "$src/$dir_path/"* "./" 2>/dev/null; then
          echo "✅ Copied contents of: $dir_path/* -> ./"
        else
          echo "❌ Failed to copy contents of: $dir_path"
        fi
      fi
    else
      # Handle regular file copying
      local filename
      if [ "$flatten_names" = true ]; then
        # Convert path to flattened name
        filename=$(echo "$line" | tr '/' '_')
      else
        filename=$(basename "$line")
      fi

      # Remove existing file if it exists
      [ -e "$filename" ] && rm -f "$filename"

      # Copy with force flag
      if cp -f "$src/$line" "$filename" 2>/dev/null; then
        echo "✅ Copied: $line -> $filename"
      else
        echo "❌ Failed: $line"
      fi
    fi
  done <"$config_file"
}

# Docker compose up with detach mode and optional build
docker_compose_up() {
  local compose_file=""
  local build_flag=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -f)
      if [ -n "$2" ]; then
        compose_file=(-f "$2")
        shift 2
      else
        echo "Error: -f requires a file argument"
        return 1
      fi
      ;;
    -b | --build)
      build_flag="--build"
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: dcupd [-f compose-file] [-b|--build]"
      return 1
      ;;
    esac
  done

  if [ -n "$compose_file" ]; then
    docker compose $compose_file up -d $build_flag
  else
    docker compose up -d $build_flag
  fi
}

docker_compose_down() {
  local compose_file=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -f)
      if [ -n "$2" ]; then
        compose_file=(-f "$2")
        shift 2
      else
        echo "Error: -f requires a file argument"
        return 1
      fi
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: dcdown [-f compose-file]"
      return 1
      ;;
    esac
  done

  if [ -n "${compose_file[*]}" ]; then
    docker compose "${compose_file[@]}" down
  else
    docker compose down
  fi
}

# Personal Wallpaper Sync Function
# Syncs wallpapers from ~/Pictures/Wallpapers/Personal/ to theme backgrounds
wp-sync() {
  ~/.labs/scripts/wp-sync.sh "$@"
}
