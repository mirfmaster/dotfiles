alias batmode="redshift -t 6500:2300 -b 0.85 -l 6.16:106.83"
alias redshiftx="redshift -x"

alias mydata="cd /media/mirf/My\ Data"
alias usage="gnome-system-monitor"

alias kf="kitty --start-as=fullscreen && exit"
alias lv="lvim"
alias v="lvim"
alias xx="exit"

# git extension
# remove committed & clean workspace
alias grhc="git reset --hard HEAD && git clean -fd" #means git reset hardcore!

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

################# FUNCTIONS ########################
setRepoConfigProfile() {
  git config user.email "mirfmaster@gmail.com"
  git config user.name "Muhamad Iqbal"
}
