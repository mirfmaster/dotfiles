alias oc='opencode'
alias v='nvim'
alias x='exit'

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

# Networking
alias nscan="nmap -sP"
alias nscanhome="nscan 192.168.100.0/24"
alias myip='curl ifconfig.co'

# TMUX
alias tm="tmux_smart_open"
# alias tm="tmux"
# alias tml="tmux ls"
# alias tma="tmux a"
alias tmn="tmux new -s"
alias tmat="tmux a -t"

alias ls='ls -lhX --color=auto --group-directories-first'
