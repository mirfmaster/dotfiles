alias x=exit
alias v=nvim
alias reload='exec fish -l'
alias ls='ls -lhX --color=auto --group-directories-first'

# Docker
alias d="docker"                          # Base docker command
alias dp="docker ps"                      # List running containers

alias dcupd="docker compose up -d"
alias dcup="docker compose up"
alias dcdn="docker compose down"

# Tmux
alias tm="t"
alias tml="tmux ls"
alias tma="tmux a"
alias tmn="tmux new -s"
alias tmat="tmux a -t"

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

alias art="php artisan"
alias mr="mise run"

alias ccc="ccr code"
alias ld=lazydocker
alias lg=lazygit
