if status is-interactive
    # Commands to run in interactive sessions can go here
end

zoxide init --cmd cd fish | source

set -gx VOLTA_HOME "$HOME/.volta"

# pnpm
set -gx PNPM_HOME "/home/mirf/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

mise activate fish | source
# starship init fish | source

# fish_vi_key_bindings
# bind -M insert \cf forward-char    # Ctrl-F also works
# bind -M insert \cr history-search-backward   # Ctrl-R in insert
