function s
    set -l host (awk '/^Host / {print $2}' ~/.ssh/config | fzf)
    and ssh $host
end

function pkgpurge --description 'Purge all installed packages matching <substring>'
    set -l pattern $argv[1]
    if test -z "$pattern"
        echo "Usage: pkgpurge <substring>"
        echo "Example: pkgpurge php83"
        return 1
    end

    set -l hits (pacman -Qq | grep $pattern)
    if test -z "$hits"
        echo "No packages match '$pattern' – nothing to remove."
        return 0
    end

    echo "Removing: $hits"
    yay -Rns $hits
end

function tmux_smart_open
    # 1. tmux installed?
    if not command -q tmux
        echo "tmux is not installed"
        return 1
    end

    # 2. Any existing sessions?
    set -l existing_sessions $(tmux list-sessions -F "#S" 2>/dev/null)
    if test -z "$existing_sessions"
        echo "No existing sessions; creating a new one."
        tmux new-session
        return 0
    end

    # 3. Pick a session (or cancel)
    set -l header "Select tmux session to attach to (ESC to cancel)"
    if test -n "$TMUX"    # already inside tmux
        set header "Select tmux session to switch to (ESC to cancel)"
    end

    set -l choice (echo "$existing_sessions" | \
                   fzf --height 20% --bind change:first --header="$header")
    test -z "$choice"; and return 0   # user cancelled

    # 4. Attach / switch
    set -l chosen (string trim "$choice")
    if test -n "$TMUX"
        tmux switch-client -t "$chosen"
    else
        tmux attach-session -t "$chosen"
    end
end

function t --description "fuzzy tmux attach / switch / create"

    # 0. helper to create a new session
    function __t_new
        set -l name (string replace ' ' '-' (basename $PWD))  # default name
        read -p 'New session name> ' -l name
        test -z "$name"; and set name (basename $PWD)
        tmux new-session -ds (string trim "$name")
        tmux switch-client -t "$name"
    end

    # 1. tmux installed?
    command -q tmux; or begin
        echo "tmux not installed"
        return 1
    end

    # 2. build colour-free list
    set -l raw (tmux list-sessions -F "#S" 2>/dev/null | string trim)

    # 3. no sessions → just run plain tmux (let tmux-resurrection do its thing)
    if test -z "$raw"
        tmux
        return
    end

    # 4. interactive picker
    set -l choice $(
        printf '%s\n' $raw |
        fzf --bind 'ctrl-n:reload(echo Create-new)+accept' \
            --header '↑↓ choose session  |  Ctrl-N = create new  |  ESC = cancel' \
            --height 40% --reverse
    )
    test -z "$choice"; and return     # cancelled

    if test "$choice" = "Create-new"
        __t_new
    else
        set -l chosen (string trim "$choice")
        if test -n "$TMUX"
            tmux switch-client -t "$chosen"
        else
            tmux attach-session -t "$chosen"
        end
    end
end

# bl_info: a friendly coloured message
function bl_info --description 'Pretty print an info line'
    set_color --bold cyan
    echo $argv
    set_color normal
end

# push chezmoi state to upstream
function cmpush --description 'Commit & push chezmoc repo'
    bl_info "Syncing working directory with remote repository"
    sleep 1

    git add .                 # ga .  (alias)
    git commit --message "."  # gcmsg
    git push                  # ggp
end

# bring local & chezmoi state together, then push out
function cmsync --description 'Sync local changes and push them'
    bl_info "Syncing local changes with working directory"

    # chezmoi add verbose (-v) wherever it is supported
    chezmoi add ~/.labs
    chezmoi add ~/.config/fish
    chezmoi add ~/.config/hypr
    chezmoi re-add
    cd ~/.local/share/chezmoi

    # push changes up
    cmpush
    bl_info "Sync success, returning to previous pwd"
    cd -
end

