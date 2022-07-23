alias batmode="redshift -t 6500:2300 -b 0.85 -l 6.16:106.83"
alias redshiftx="redshift -x"
alias hh=history
alias clear_history='cat /dev/null > ~/.bash_history && history -c'
alias usage="gnome-system-monitor"

alias kf="kitty --start-as=fullscreen && exit"
alias lv="lvim"
alias v="lvim"
alias xx="exit"

# git extension
# remove committed & clean workspace
alias grhc="git reset --hard HEAD && git clean -fd" #equivalent to git reset hardcore!
alias gcml="gcm && ggl" 
alias gcD="git branch -D" 

# warp-cli cloudflare
alias wc="warp-cli"
alias wcs="warp status"
alias wcc="warp connect"
alias wcd="warp disconnect"
alias wcr="warp disconnect && warp connect"

# Chezmoi
alias cm="chezmoi"
alias cme="chezmoi edit --apply"
alias cms="chezmoi re-add" #chezmoi sync
alias cmd="chezmoi diff"
alias cmdryrun="chezmoi git pull -- --rebase && chezmoi diff"
alias cmu="chezmoi update"

alias t="taskwarrior-tui"

################# FUNCTIONS ########################
setRepoConfigProfile() {
  git config user.email "mirfmaster@gmail.com"
  git config user.name "Muhamad Iqbal"
}

setRepoConfigProfileZOT() {
  git config user.email "iqbal@zero-one-group.com"
  git config user.name "Muhamad Iqbal"
}
