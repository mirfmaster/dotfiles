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
alias rg=ranger
alias h=history
alias xport="kill-port"
alias clear_history='cat /dev/null > ~/.bash_history && history -c'
alias lg=lazygit
# alias postman="~/Applications/Postman/Postman"
alias postman="nohup ~/Applications/Postman/Postman &>/dev/null &"

# git extension
# remove committed & clean workspace
alias grhc="git reset --hard HEAD && git clean -fd" #equivalent to git reset hardcore!
alias gres="git reset" 
alias gcml="gcm && ggl" 
alias gcD="git branch -D" 
alias gs="gst"
alias s="gst"

# warp-cli cloudflare
alias wc="warp-cli"
alias wcs="wc status"
alias wcc="wc connect"
alias wcd="wc disconnect"
alias wcr="wc disconnect && wc connect"

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

alias j="joplin"
alias jd="~/.joplin/Joplin.AppImage"
alias ssh-list='grep "^Host " ~/.ssh/config | grep -v "Host \*" | awk "{print NR \": \" \$2}"'

alias vsc="code ."
