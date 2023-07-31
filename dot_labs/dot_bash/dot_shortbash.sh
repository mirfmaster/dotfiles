alias batmode="redshift -t 6500:2300 -b 0.85 -l 6.16:106.83"
alias redshiftx="redshift -x"
alias batmodex="redshiftx"
alias bye="shutdown -n now"
alias hibernate="systemctl hibernate"

alias kf="kitty --start-as=fullscreen && exit"
alias lv="lvim"
alias v="lvim"
alias xx="exit"
alias x="exit"
alias c="cd"
alias rg=ranger
alias h=history
alias xport="kill-port"
alias clear_history='cat /dev/null > ~/.bash_history && history -c'
alias lg=lazygit

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
alias cmsync="cm re-add" #cm sync
alias cmd="cm diff"
alias cmcd="cm cd"
alias cmdryrun="cm git pull -- --rebase && cm diff"
alias cmu="cm update"

alias t="taskwarrior-tui"

# PHP
alias cphp="sudo update-alternatives --config php"

# SHORTDIRS
alias labs="cd ~/.labs"

alias mirf="cd ~/workspaces/mirf"
alias igapi="cd ~/workspaces/mirf/igapi"

alias zot="cd ~/workspaces/zot"
alias arta="cd ~/workspaces/zot/arta"
alias sebamed="cd ~/workspaces/zot/sebamed-v2"
alias supreme="cd ~/workspaces/zot/supreme-solar"
alias izone="cd ~/workspaces/zot/izone-infra"


## ETC
# Terraform
alias tf="terraform"
alias tfd="terraform-docs"
