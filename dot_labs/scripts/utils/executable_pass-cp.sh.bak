#!/bin/bash

# Script: password-selector.sh
# Description: Simplified password/TOTP selector for password store

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to get clean display name from full path
get_clean_name() {
    local full_path="$1"
    local clean=$(echo "$full_path" | sed 's|.*\.password-store/||; s|\.gpg$||')
    echo "$clean"
}

# Function to determine if entry is TOTP
is_totp_entry() {
    local entry="$1"
    [[ "$entry" == totp/* ]]
}

# Function to test if pass otp works
test_pass_otp() {
    pass otp -h >/dev/null 2>&1
}

# Function to get secret (password or TOTP)
get_secret() {
    local entry="$1"

    if is_totp_entry "$entry" && test_pass_otp; then
        # TOTP entry - get the OTP code
        pass otp "$entry" 2>/dev/null | head -n 1 | tr -d '\n\r'
    else
        # Regular password or fallback
        pass show "$entry" 2>/dev/null | head -n 1 | tr -d '\n\r'
    fi
}

# Function to copy to clipboard
copy_to_clipboard() {
    local secret="$1"
    local service="$2"
    local is_totp="$3"

    local type="Password"
    [[ "$is_totp" == "true" ]] && type="TOTP"

    secret=$(echo "$secret" | tr -d '\n\r' | head -c 100)

    if [ -z "$secret" ]; then
        echo -e "${RED}✗ Empty secret${NC}"
        return 1
    fi

    # Try clipboard methods in order
    if command -v wl-copy >/dev/null 2>&1; then
        echo -n "$secret" | wl-copy >/dev/null 2>&1
        [ $? -eq 0 ] && echo -e "${GREEN}✓ $type for $service copied (wl-copy)${NC}"
    elif command -v xclip >/dev/null 2>&1 && [ -n "$DISPLAY" ]; then
        echo -n "$secret" | xclip -selection clipboard >/dev/null 2>&1
        [ $? -eq 0 ] && echo -e "${GREEN}✓ $type for $service copied (xclip)${NC}"
    elif command -v xsel >/dev/null 2>&1 && [ -n "$DISPLAY" ]; then
        echo -n "$secret" | xsel --clipboard --input >/dev/null 2>&1
        [ $? -eq 0 ] && echo -e "${GREEN}✓ $type for $service copied (xsel)${NC}"
    else
        echo -e "${RED}✗ No clipboard tools available${NC}"
        echo -e "${YELLOW}$secret${NC}"
        return 1
    fi
}

# Function to clear clipboard
clear_clipboard() {
    command -v wl-copy >/dev/null 2>&1 && echo "" | wl-copy >/dev/null 2>&1
    command -v xclip >/dev/null 2>&1 && echo "" | xclip -selection clipboard >/dev/null 2>&1
    command -v xsel >/dev/null 2>&1 && echo "" | xsel --clipboard --input >/dev/null 2>&1
}

# Function to list valid entries
list_entries() {
    local entries=()
    local totp_count=0

    while IFS= read -r -d '' file; do
        local clean_name=$(get_clean_name "$file")

        # Skip unwanted folders
        [[ "$clean_name" == docker-credential-helpers/* || "$clean_name" == */.git* ]] && continue

        if pass show "$clean_name" >/dev/null 2>&1; then
            entries+=("$clean_name")
            [[ "$clean_name" == totp/* ]] && ((totp_count++))
        fi
    done < <(find ~/.password-store -name "*.gpg" -print0 2>/dev/null)

    printf '%s\n' "${entries[@]}" | sort
    echo -e "${GREEN}Total: ${#entries[@]} entries ($totp_count TOTP)${NC}"
}

# Function to show menu
show_menu() {
    local entries=()
    local totp_count=0

    while IFS= read -r -d '' file; do
        local clean_name=$(get_clean_name "$file")

        # Skip unwanted folders
        [[ "$clean_name" == docker-credential-helpers/* || "$clean_name" == */.git* ]] && continue

        if pass show "$clean_name" >/dev/null 2>&1; then
            entries+=("$clean_name")
            [[ "$clean_name" == totp/* ]] && ((totp_count++))
        fi
    done < <(find ~/.password-store -name "*.gpg" -print0 2>/dev/null)

    IFS=$'\n' sorted_entries=($(printf '%s\n' "${entries[@]}" | sort))
    unset IFS
    entries=("${sorted_entries[@]}")

    local count=${#entries[@]}
    [[ $count -eq 0 ]] && { echo -e "${RED}No entries found${NC}"; exit 1; }

    echo -e "${YELLOW}Password/TOTP Manager${NC}"
    echo "Total: $count entries ($totp_count TOTP)"
    echo ""
    echo "Entries:"

    for i in "${!entries[@]}"; do
        local entry="${entries[$i]}"
        local type=""
        [[ "$entry" == totp/* ]] && type=" [TOTP]"
        printf " %2d: %s%s\n" $((i+1)) "$entry" "$type"
    done

    echo ""
    [[ $totp_count -gt 0 && $(test_pass_otp) ]] && echo -e "${GREEN}✓ TOTP support enabled${NC}"

    while true; do
        read -p "Select (1-$count) or 'q': " choice

        [[ "$choice" =~ ^[qQ]$ ]] && exit 0

        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$count" ]; then
            local selected="${entries[$((choice-1))]}"
            local is_totp=false
            [[ "$selected" == totp/* ]] && is_totp=true

            echo ""
            echo -e "${YELLOW}Getting $selected...${NC}"

            local secret=$(get_secret "$selected")

            if [ -n "$secret" ]; then
                copy_to_clipboard "$secret" "$selected" "$is_totp"

                # Auto-clear in background
                local clear_time=45
                [[ "$is_totp" == "true" ]] && clear_time=30
                (sleep "$clear_time"; clear_clipboard) &

                echo -e "${GREEN}✓ Done! Clipboard will clear in ${clear_time}s${NC}"
                sleep 1
                exit 0
            else
                echo -e "${RED}✗ Failed to get secret${NC}"
            fi
        else
            echo -e "${RED}Invalid choice${NC}"
        fi
    done
}

# Function for specific service
copy_specific() {
    local service="$1"

    [[ -z "$service" ]] && { echo -e "${RED}Service name required${NC}"; exit 1; }

    if ! pass show "$service" >/dev/null 2>&1; then
        echo -e "${RED}Entry '$service' not found${NC}"
        list_entries
        exit 1
    fi

    local is_totp=false
    [[ "$service" == totp/* ]] && is_totp=true

    echo -e "${YELLOW}Getting $service...${NC}"
    local secret=$(get_secret "$service")

    [[ -n "$secret" ]] && copy_to_clipboard "$secret" "$service" "$is_totp"

    local clear_time=45
    [[ "$is_totp" == "true" ]] && clear_time=30
    (sleep "$clear_time"; clear_clipboard) &
    echo -e "${GREEN}✓ Copied! Clears in ${clear_time}s${NC}"
    sleep 2
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            echo "Usage: $0 [-s SERVICE] [-l] [-t]"
            echo "  -s SERVICE  Copy specific service"
            echo "  -l          List entries"
            echo "  -t          Test clipboard"
            echo "  (no args)   Interactive menu"
            exit 0
            ;;
        -l)
            list_entries
            exit 0
            ;;
        -t)
            echo -e "${YELLOW}Testing clipboard...${NC}"
            local test_text="TEST-$(date +%s)"
            echo -n "$test_text" | wl-copy 2>/dev/null || echo -n "$test_text" | xclip -selection clipboard 2>/dev/null || echo -n "$test_text" | xsel --clipboard --input 2>/dev/null
            echo -e "${GREEN}✓ Copied '$test_text' - try pasting${NC}"
            sleep 2
            exit 0
            ;;
        -s)
            shift
            copy_specific "$1"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use -h for help"
            exit 1
            ;;
    esac
    shift
done

# Main execution
command -v pass >/dev/null 2>&1 || { echo -e "${RED}pass command not found${NC}"; echo "Install: sudo apt install pass"; exit 1; }

show_menu
