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
    psql -d $DOCKER_POSTGRES_DB -P expanded=auto -P 'null=(null)'
}

resetPantau() {
  dcdn --volumes && dcupd && sleep 1 && pnpm migrate up && pnpm seed:mod
}
<<<<<<< Updated upstream
||||||| constructed merge base

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
=======

remockPantau() {
    bl_warn "Make sure you are inside apps/api"
    mockery --dir=service --output=service/mocks --all
    mockery --dir=internal/rest --output=internal/rest/mocks --all
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
>>>>>>> Stashed changes
