alias batmode="redshift -t 6500:2300 -b 0.85 -l 6.16:106.83"
alias redshiftx="redshift -x"
alias batmodex="redshiftx"
alias bye="shutdown -n now"
alias hibernate="systemctl hibernate"

alias kf="kitty --start-as=fullscreen && exit"
alias lv="lvim"
alias v="nvim"
alias xx="exit"
alias x="exit"
alias c="cd"
# alias rg=ranger
alias h=history
alias xport="kill-port"
alias clear_history='cat /dev/null > ~/.bash_history && history -c'
alias lg=lazygit
alias ld='DOCKER_HOST="unix:///var/run/docker.sock" lazydocker'
# alias postman="~/Applications/Postman/Postman"
alias postman="nohup ~/Applications/Postman/Postman &>/dev/null &"
alias py="python"
alias pym="python manage.py"

# git extension
# remove committed & clean workspace
alias grhc="git reset --hard HEAD && git clean -fd" #equivalent to git reset hardcore!
alias gres="git reset" 
alias gcml="gcm && ggl" 
alias gcD="git branch -D" 
alias gs="gst"
alias s="gst"
# alias gchanges='git log --since="1 week ago" --name-only --pretty=format:"" --diff-filter=ACMRT | sort -u' # To see what files changed in the last 1 week
# alias gchanges='git log --since="1 week ago" --name-only --pretty=format:"" --diff-filter=ACMRT | grep -v "^node_modules/\|^vendor/" | sort -u'
alias gchanges='f() { git log --since="1 week ago" --name-only --pretty=format:"" --diff-filter=ACMRT | grep -v "${1:-node_modules}/\|${2:-vendor}/" | sort -u; }; f'

# warp-cli cloudflare
alias wpc="warp-cli"
alias wpcs="wpc status"
alias wpcc="wpc connect"
alias wpcd="wpc disconnect"
alias wpcr="wpc disconnect && wc connect"

# Chezmoi
alias cm="chezmoi"
alias cme="cm edit --apply"
alias cma="cm add"
alias cms="cm status"
# alias cmsync="cm re-add" #cm sync
alias cmd="cm diff"
alias cmcd="cm cd"
alias cmdryrun="cm git pull -- --rebase && cm diff"
alias cmu="cm update"

# PHP
alias cphp="sudo update-alternatives --config php"

# SHORTDIRS
alias labs="cd ~/.labs"

alias mirf="cd ~/spaces/mirf"
alias igapi="cd ~/spaces/mirf/igapi"
alias workerphp="cd ~/spaces/mirf/BJS/worker-php"

alias zot="cd ~/spaces/zot"


## ETC
# Terraform
alias tf="terraform"
alias tfd="terraform-docs"

## GOLANG
alias air='$(go env GOPATH)/bin/air'

alias ssh-list='grep "^Host " ~/.ssh/config | grep -v "Host \*" | awk "{print NR \": \" \$2}"'

alias vsc="code ."
alias nscan="nmap -sP"
alias nscanhome="nscan 192.168.100.0/24"

alias tm="tmux_smart_open"
# alias tm="tmux"
# alias tmo="tmux_open_session"
alias tml="tmux ls"
alias tma="tmux a"
alias tmn="tmux new -s"
alias tmat="tmux a -t"

alias mr="mise run"
alias fm="spf"


# Docker compose aliases
alias dcc="docker compose"                          # Base docker compose command
alias dcupd=docker_compose_up
alias dcdn=docker_compose_down
alias dcls="docker compose ls"                   # List Docker Compose projects
alias dcps="docker compose ps"                   # List containers alias dcr="docker compose restart"               # Restart services
alias dcrm="docker compose rm"                   # Remove stopped containers
alias dcl="docker compose logs"                  # View output from containers
alias dclf="docker compose logs -f"              # Follow log output
alias dcpull="docker compose pull"               # Pull service images
alias dcstart="docker compose start"             # Start services
alias dcstop="docker compose stop"               # Stop services
alias dcrun="docker compose run --rm"            # Run one-off command
alias dcrb="docker compose up -d --force-recreate --build"  # Rebuild and recreate containers

# Docker command aliases
alias d="docker"                          # Base docker command
alias dp="docker ps"                      # List running containers
alias dpa="docker ps -a"                  # List all containers
alias di="docker images"                  # List images
alias dip="docker image prune"            # Remove unused images
alias dcp="docker container prune"        # Remove stopped containers
alias dvp="docker volume prune"           # Remove unused volumes
alias dsp="docker system prune"           # Remove unused data
alias dspa="docker system prune -a"       # Remove all unused data
alias dl="docker logs"                    # View container logs
alias dlf="docker logs -f"                # Follow container logs
alias dstat="docker stats"                # Show container resource usage
alias dtop="docker top"                   # Show container processes
alias dex="docker exec -it"               # Execute command in running container
alias dst="docker stop"                   # Docker stop
# alias dstall='docker stop $(docker ps -q 2>/dev/null) 2>/dev/null || true'
alias dstall='docker stop $(docker ps --format "{{.Names}}" | grep -v buildkit)'
alias dr="docker run --rm"                # Run container and remove it after exit
alias drm="docker rm"                     # Remove containers
alias drmi="docker rmi"                   # Remove images
alias db="docker build"                   # Build an image
alias dt="docker tag"                     # Tag an image
alias dh="docker history"                 # Show image history
alias dn="docker network"                 # Network management
alias dv="docker volume"                  # Volume management
alias dvl="docker volume ls"              # List volumes
alias dnl="docker network ls"             # List networks


# Laravel compose aliases
alias art="php artisan"
alias pas="php artisan serve"
alias pats="php artisan serve"
alias paoc='php artisan optimize:clear'
alias pao='php artisan optimize'

alias pamf='php artisan migrate:fresh'
alias pamfs='php artisan migrate:fresh --seed'
alias pamr='php artisan migrate:rollback'

alias pamc='php artisan make:controller'
alias pamcl='php artisan make:class'
alias pame='php artisan make:event'
alias pamen='php artisan make:enum'
alias pamfa='php artisan make:factory'
alias pami='php artisan make:interface'
alias pamj='php artisan make:job'
alias paml='php artisan make:listener'
alias pamm='php artisan make:model'
alias pamn='php artisan make:notification'
alias pamp='php artisan make:policy'
alias pampp='php artisan make:provider'
alias pams='php artisan make:seeder'
alias pamt='php artisan make:test'
alias pamtr='php artisan make:trait'
alias paql='php artisan queue:listen'
alias paqr='php artisan queue:retry'
alias paqt='php artisan queue:table'
alias paqw='php artisan queue:work'


# CURRY
# sudo apt-get install libnotify-bin
alias shortbreak='sleep 10m && notify-send -u critical "break end"'
alias myip='curl ifconfig.co'
alias reload='exec zsh'
alias ccc='ccr code'

# Verbosity
alias \
	cp='cp -iv' \
    md='mkdir -pv' \
	mv='mv -iv' \
	rm='rm -vI'

alias ls='ls -lhX --color=auto --group-directories-first'

alias \
    1='cd ~1' \
    2='cd ~2' \
    3='cd ~3' \
    4='cd ~4' \
    5='cd ~5' \
    6='cd ~6' \
    7='cd ~7' \
    8='cd ~8' \
    9='cd ~9'


# ref: https://www.linuxquestions.org/questions/linux-newbie-8/xargs-cd-is-not-working-796219/#post3906430 (why cd does not work with xargs).
# ref: https://www.linuxquestions.org/questions/linux-newbie-8/xargs-cd-is-not-working-796219/#post3907371 (about pipeline).
#cd to any directories in home directory from any directories
#(up to 2 directory from home directory)
#it's kind of overwhelm to search the entire home directory
# alias sd='cd "$(fd -aHI -d 2 -E .git -E node_modules -E .cache/npm/_cacache -t d . ~ | fzf --height 20%)"'
# sudo apt install fd-find
alias sd='cd "$(find ~ -mindepth 1 -maxdepth 4 -name .eclipse -prune -o -type d | fzf --height 20% --bind change:first)"'

# Search directory within ~/spaces and open it using nvim
alias sv='dir="$(find ~/spaces -mindepth 1 -maxdepth 3 -type d | fzf --height 20% --bind change:first)" && [ -n "$dir" ] && cd "$dir" && nvim || true'

# NOTE: deprecated cos rare usage and replaced by zoxide
# cd to any directories in git root directory/current working directory
# alias ds='cd "$(find $(git rev-parse --show-toplevel) -mindepth 1 \( -name node_modules -name vendor -o -name .git \) -prune -o -type d | sort -g | fzf --height 20% --bind change:first)"'

#search and open file on current working directory in $EDITOR directly
# alias sf='rg --hidden --files | fzf --multi --height 20% --preview="head -$LINES {}" --preview-window=wrap,hidden --bind "ctrl-/:toggle-preview,ctrl-n:preview-down,ctrl-p:preview-up" | xargs -or -I {} $EDITOR "{}"'

#search and open file on git root directory/current working directory in $EDITOR directly
alias cs='rg --hidden --files $(git rev-parse --show-toplevel 2>/dev/null) | fzf --multi --height 20% --preview="head -$LINES {}" --preview-window=wrap,hidden --bind "ctrl-/:toggle-preview,ctrl-n:preview-down,ctrl-p:preview-up" | xargs -or -I {} $EDITOR "{}"'

# ref: https://askubuntu.com/a/999218
alias list_app_lru="find /usr/bin -size +1000k -atime +100 -exec ls -ltuh --time-style=long-iso {} \;"

alias myalias='grep "^alias" ~/.labs/.bash/.shortbash.sh'
