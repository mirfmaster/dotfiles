#!/usr/bin/env bash

# Personal Wallpaper Sync Script
# Syncs wallpapers from ~/Pictures/Wallpapers/Personal/ to theme backgrounds using symlinks

set -o pipefail
set -e

COLOR_GREEN='\033[0;32m'
COLOR_RED='\033[0;31m'
COLOR_YELLOW='\033[1;33m'
COLOR_BLUE='\033[0;34m'
COLOR_RESET='\033[0m'

PERSONAL_WALLPAPERS="$HOME/Pictures/Wallpapers/Personal/"
THEME_BACKGROUNDS="$HOME/.config/omarchy/current/theme/backgrounds/"
CURRENT_BG_LINK="$HOME/.config/omarchy/current/background"

SUPPORTED_FORMATS=("jpg" "jpeg" "png" "webp" "gif")

log_info() {
    echo -e "${COLOR_BLUE}[INFO]${COLOR_RESET} $1"
}

log_success() {
    echo -e "${COLOR_GREEN}[SUCCESS]${COLOR_RESET} $1"
}

log_warning() {
    echo -e "${COLOR_YELLOW}[WARNING]${COLOR_RESET} $1"
}

log_error() {
    echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} $1"
}

check_directories() {
    if [[ ! -d "$PERSONAL_WALLPAPERS" ]]; then
        log_error "Personal wallpapers directory not found: $PERSONAL_WALLPAPERS"
        exit 1
    fi

    if [[ ! -d "$THEME_BACKGROUNDS" ]]; then
        log_error "Theme backgrounds directory not found: $THEME_BACKGROUNDS"
        exit 1
    fi
}

find_personal_wallpapers() {
    local wallpapers=()
    
    for ext in "${SUPPORTED_FORMATS[@]}"; do
        while IFS= read -r -d '' file; do
            wallpapers+=("$file")
        done < <(find "$PERSONAL_WALLPAPERS" -maxdepth 1 -type f -iname "*.$ext" -print0 | sort -z)
    done
    
    printf '%s\n' "${wallpapers[@]}"
}

remove_broken_symlinks() {
    local removed=0

    while IFS= read -r -d '' symlink; do
        if [[ ! -e "$symlink" ]]; then
            rm -f "$symlink"
            : $((removed++))
            log_warning "Removed broken symlink: $(basename "$symlink")"
        fi
    done < <(find "$THEME_BACKGROUNDS" -maxdepth 1 -type l -print0)
}

sync_wallpapers() {
    local personal_wallpapers=("$@")
    local synced=0
    local skipped=0
    local updated=0

    log_info "Found ${#personal_wallpapers[@]} personal wallpaper(s)"
    echo ""

    for wallpaper in "${personal_wallpapers[@]}"; do
        local filename=$(basename "$wallpaper")
        local target="$THEME_BACKGROUNDS/$filename"

        if [[ -L "$target" ]]; then
            if [[ "$wallpaper" -ef "$target" ]]; then
                : $((skipped++))
                log_info "Skipped (already synced): $filename"
                continue
            else
                rm -f "$target"
                ln -s "$wallpaper" "$target"
                : $((updated++))
                log_success "Updated symlink: $filename"
            fi
        elif [[ -e "$target" ]]; then
            : $((skipped++))
            log_warning "Skipped (file exists, not a symlink): $filename"
            continue
        else
            ln -s "$wallpaper" "$target"
            : $((synced++))
            log_success "Created symlink: $filename"
        fi
    done

    echo ""
    log_success "Sync complete:"
    echo "  - New symlinks created: $synced"
    echo "  - Symlinks updated: $updated"
    echo "  - Skipped (already synced): $skipped"
}

show_theme_backgrounds() {
    log_info "Theme backgrounds directory contents:"
    echo ""

    local total=0
    local personal=0
    local theme=0

    while IFS= read -r -d '' file; do
        : $((total++))
        local filename=$(basename "$file")

        if [[ -L "$file" ]]; then
            local target=$(readlink "$file")
            if [[ "$target" == "$PERSONAL_WALLPAPERS"* ]]; then
                echo -e "  ${COLOR_GREEN}→${COLOR_RESET} $filename (personal)"
                : $((personal++))
            else
                echo -e "  ${COLOR_YELLOW}→${COLOR_RESET} $filename (symlink)"
            fi
        elif [[ -f "$file" ]]; then
            echo -e "  ${COLOR_BLUE}•${COLOR_RESET} $filename (theme)"
            : $((theme++))
        fi
    done < <(find "$THEME_BACKGROUNDS" -maxdepth 1 -type f,l -print0 | sort -z)

    echo ""
    log_info "Total backgrounds: $total (personal: $personal, theme: $theme)"
}

main() {
    echo -e "${COLOR_BLUE}========================================${COLOR_RESET}"
    echo -e "${COLOR_BLUE}  Personal Wallpaper Sync${COLOR_RESET}"
    echo -e "${COLOR_BLUE}========================================${COLOR_RESET}"
    echo ""

    check_directories

    log_info "Checking for broken symlinks..."
    remove_broken_symlinks

    local personal_wallpapers
    mapfile -t personal_wallpapers < <(find_personal_wallpapers)

    if [[ ${#personal_wallpapers[@]} -eq 0 ]]; then
        log_warning "No wallpapers found in $PERSONAL_WALLPAPERS"
        echo ""
        show_theme_backgrounds
        exit 0
    fi

    echo ""
    sync_wallpapers "${personal_wallpapers[@]}"

    echo ""
    show_theme_backgrounds

    echo ""
    log_success "Wallpaper sync completed successfully!"
    echo ""
    log_info "Tip: Use 'omarchy-theme-bg-next' to cycle through wallpapers"
}

main "$@"
