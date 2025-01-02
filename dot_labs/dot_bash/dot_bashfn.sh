alias clear_history='cat /dev/null > ~/.bash_history && history -c'

################# FUNCTIONS ########################
setRepoConfigProfile() {
  bl_info "Setting up repo config using personal email"
  git config user.email "mirfmaster@gmail.com"
  git config user.name "Muhamad Iqbal"
}

setRepoConfigProfileZOT() {
  bl_info "Setting up repo config using ZOT email"
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

  /usr/sbin/terraform-docs --sort-by "required" -c "$template" "$path" > "$path/readme.md"
}

cmall() {
    cm add ~/.labs/
}

cmpush() {
  bl_info "Syncing working directory with remote repository"
  sleep 1
  ga .
  gcmsg "."
  ggp
}

cmsync() {
  bl_info "Syncing local changes with working directory"
  cm add ~/.labs/
  cm re-add

  cd ~/.local/share/chezmoi
  cmpush
  bl_info "Sync success, redirecting to previous pwd~"
  cd -
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

resetPantau() {
  dcdn --volumes && dcupd && sleep 1.5 && pnpm migrate up && pnpm seed:mod
}

up() {
    # Default number of levels to go up
    local levels=${1:-1}
    
    # Validate input is a positive integer
    if ! [[ "$levels" =~ ^[0-9]+$ ]] ; then
        echo "Error: Please provide a positive integer" >&2
        return 1
    fi
    
    # Build the path string
    local path=""
    for ((i=1; i<=levels; i++)); do
        path="../$path"
    done
    
    # Remove trailing slash
    path=${path%/}
    
    # Check if the target directory exists and is accessible
    if [ ! -d "$path" ]; then
        echo "Error: Cannot go up $levels levels - directory does not exist" >&2
        return 1
    fi
    
    # Change to the target directory
    cd "$path"
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

remockPantau() {
    cd apps/api
    # bl_warn "Make sure you are inside apps/api"
    mockery --dir=service --output=service/mocks --all
    mockery --dir=internal/rest --output=internal/rest/mocks --all
    cd -
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

function recopy() {
    local src config_file preserve_path=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --preserve-path)
                preserve_path=true
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
        echo "Usage: recopy [--preserve-path] <config_file>"
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
    cd - > /dev/null

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

            # Create target directory if it doesn't exist
            if [ "$preserve_path" = true ]; then
                mkdir -p "$dir_path"
                target_dir="$dir_path"
            else
                target_dir="."
            fi

            # Copy all contents of the directory
            if cp -rf "$src/$dir_path/"* "$target_dir/" 2>/dev/null; then
                echo "✅ Copied contents of: $dir_path/* -> $target_dir/"
            else
                echo "❌ Failed to copy contents of: $dir_path"
            fi
        else
            # Handle regular file copying
            local filename
            if [ "$preserve_path" = true ]; then
                filename="$line"
                # Create directory structure if it doesn't exist
                local dirname=$(dirname "$filename")
                [ "$dirname" != "." ] && mkdir -p "$dirname"
            else
                filename=$(basename "$line")
            fi

            if cp -f "$src/$line" "$filename" 2>/dev/null; then
                echo "✅ Copied: $line -> $filename"
            else
                echo "❌ Failed: $line"
            fi
        fi
    done < "$config_file"
}

# Add completion for the recopy function
compdef '_files' recopy

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
            -b|--build)
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
