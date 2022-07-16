alias batmode="redshift -t 6500:2300 -b 0.85 -l 6.16:106.83"
alias redshiftx="redshift -x"

alias mydata="cd /media/mirf/My\ Data"
alias usage="gnome-system-monitor"

alias kf="kitty --start-as=fullscreen && exit"
alias lv="lvim"
alias v="lvim"
alias cm="chezmoi"
alias xx="exit"

alias checkindance="yarn && \
    docker-compose down -v && \
    docker-compose up -d db && \
    yarn build:cli && \
    sleep 2 && \
    yarn migrate latest && \
    yarn seed && \
    yarn erp-integration && \
    yarn test:all
"

# git extension
# remove committed & clean workspace
alias grhc="git reset --hard HEAD && git clean -fd"

# warp-cli cloudflare
alias wc="warp-cli"
alias wcs="warp status"
alias wcc="warp connect"
alias wcd="warp disconnect"
alias wcr="warp disconnect && warp connect"

