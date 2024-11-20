# NOTE: OLD
# # User configuration
# # bindkey -v
# bindkey '^I'   complete-word       # tab          | complete
# bindkey '^[[Z' autosuggest-execute  # shift + tab  | autosuggest
# bindkey '`' autosuggest-accept  # `  | autosuggest-accept
# # bindkey '^M' autosuggest-accept # Ctrl + Enter
#
# # bindkey '^[[13;2u' autosuggest-accept # Shift + Enter
# bindkey '^ ' autosuggest-accept # Ctrl + Space
#
# bindkey -M viins 'jj' vi-cmd-mode

# Enable vi mode
bindkey -v

# Restore common emacs keybindings
bindkey '^P' up-history                    # Ctrl + P - Previous command in history
bindkey '^N' down-history                  # Ctrl + N - Next command in history
bindkey '^R' history-incremental-search-backward # Ctrl + R - Search history backward
bindkey '^S' history-incremental-search-forward  # Ctrl + S - Search history forward
# bindkey '^A' beginning-of-line             # Ctrl + A - Go to beginning of line
# bindkey '^E' end-of-line                   # Ctrl + E - Go to end of line
# bindkey '^B' backward-char                 # Ctrl + B - Move back one character
# bindkey '^F' forward-char                  # Ctrl + F - Move forward one character
# bindkey '^K' kill-line                     # Ctrl + K - Kill to end of line
# bindkey '^U' kill-whole-line              # Ctrl + U - Kill whole line
# bindkey '^W' backward-kill-word           # Ctrl + W - Kill word backward
# bindkey '^Y' yank                         # Ctrl + Y - Paste killed text
# bindkey '^D' delete-char                  # Ctrl + D - Delete character
# bindkey '^H' backward-delete-char         # Ctrl + H - Delete character backward

# Your existing custom bindings
bindkey '^I'   complete-word              # tab          | complete
bindkey '^[[Z' autosuggest-execute       # shift + tab  | autosuggest
bindkey '`' autosuggest-accept           # `  | autosuggest-accept
bindkey '^ ' autosuggest-accept          # Ctrl + Space
bindkey -M viins 'jj' vi-cmd-mode        # jj to enter normal mode

# Set vi-mode transitions faster (default is 0.4 seconds)
export KEYTIMEOUT=20
