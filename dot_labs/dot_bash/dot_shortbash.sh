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
alias ld=lazydocker
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
alias nscan="nmap -sP"
alias nscanhome="nscan 192.168.100.0/24"

alias tm="tmux"
alias tmls="tmux ls"
alias tma="tmux a"
alias tmat="tmux a -t"
alias tmns="tmux new -s"

# CURRY
# sudo apt-get install libnotify-bin
alias shortbreak='sleep 10m && notify-send -u critical "break end"'
alias myip='curl ifconfig.co'
alias reload='exec zsh'

# Verbosity
alias \
	cp='cp -iv' \
	mv='mv -iv' \
	rm='rm -vI'

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

alias \
    md='mkdir -pv' \
    d='dirs -v | head'

alias ls='ls -lhX --color=auto --group-directories-first'

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

# cd to any directories in git root directory/current working directory
alias ds='cd "$(find $(git rev-parse --show-toplevel) -mindepth 1 \( -name node_modules -name vendor -o -name .git \) -prune -o -type d | sort -g | fzf --height 20% --bind change:first)"'

#search and open file on current working directory in $EDITOR directly
alias sf='rg --hidden --files | fzf --multi --height 20% --preview="head -$LINES {}" --preview-window=wrap,hidden --bind "ctrl-/:toggle-preview,ctrl-n:preview-down,ctrl-p:preview-up" | xargs -or -I {} $EDITOR "{}"'

#search and open file on git root directory/current working directory in $EDITOR directly
alias cs='rg --hidden --files $(git rev-parse --show-toplevel 2>/dev/null) | fzf --multi --height 20% --preview="head -$LINES {}" --preview-window=wrap,hidden --bind "ctrl-/:toggle-preview,ctrl-n:preview-down,ctrl-p:preview-up" | xargs -or -I {} $EDITOR "{}"'


