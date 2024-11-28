# User configuration
bindkey -v
bindkey '^I'   complete-word       # tab          | complete
bindkey '^[[Z' autosuggest-execute  # shift + tab  | autosuggest
bindkey '`' autosuggest-accept  # `  | autosuggest-accept
# bindkey '^M' autosuggest-accept # Ctrl + Enter

# bindkey '^[[13;2u' autosuggest-accept # Shift + Enter
bindkey '^ ' autosuggest-accept # Ctrl + Space

bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey -M viins 'jj' vi-cmd-mode
