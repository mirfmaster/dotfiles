#!/usr/bin/env bash
# Script: pass-cp.sh (optimized + correct OTP handling + fzf support)
# Description: Password/TOTP selector for pass with fzf fuzzy search

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Config
STORE="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
# Max length for non-TOTP clipboard content (0 = no limit)
MAX_CLIP_LEN=100

# Clipboard detection (done once)
CLIP_NAME=""
CLIP_SET=()
CLIP_CLEAR=()

detect_clipboard() {
  if command -v wl-copy >/dev/null 2>&1; then
    CLIP_NAME="wl-copy"
    CLIP_SET=(wl-copy)
    CLIP_CLEAR=(wl-copy)
    return 0
  elif command -v xclip >/dev/null 2>&1 && [[ -n "$DISPLAY" ]]; then
    CLIP_NAME="xclip"
    CLIP_SET=(xclip -selection clipboard)
    CLIP_CLEAR=(xclip -selection clipboard)
    return 0
  elif command -v xsel >/dev/null 2>&1 && [[ -n "$DISPLAY" ]]; then
    CLIP_NAME="xsel"
    CLIP_SET=(xsel --clipboard --input)
    CLIP_CLEAR=(xsel --clipboard --input)
    return 0
  fi
  return 1
}
detect_clipboard >/dev/null 2>&1

# fzf detection (done once)
FZF_AVAILABLE=0
command -v fzf >/dev/null 2>&1 && FZF_AVAILABLE=1

# OTP plugin detection (checks actual pass subcommand)
PASS_OTP_AVAILABLE=0
if pass otp -h >/dev/null 2>&1; then
  PASS_OTP_AVAILABLE=1
fi

# Tools
has_oathtool() { command -v oathtool >/dev/null 2>&1; }

# Utils
get_clean_name() {
  local full="$1"
  local clean="${full#"$STORE"/}"
  clean="${clean%.gpg}"
  printf '%s' "$clean"
}

# Attempt to get OTP via pass-otp. Prints code to stdout if it looks valid.
try_get_otp_via_pass() {
  local entry="$1"
  [[ $PASS_OTP_AVAILABLE -eq 1 ]] || return 1

  # Some implementations print only digits; be robust and extract the first 6-10 digit run
  local out code
  out="$(pass otp "$entry" 2>/dev/null | head -n 1 | tr -d '\r')"
  code="$(printf '%s' "$out" | grep -Eo '[0-9]{6,10}' | head -n 1)"
  [[ -n "$code" ]] || return 1
  printf '%s' "$code"
  return 0
}

# URL decode minimal (for percent-encoding); base32 secret usually doesn't need this, but keep it safe
urldecode() {
  local s="${1//+/ }"
  printf '%b' "${s//%/\\x}"
}

# Attempt to compute OTP via oathtool from an otpauth:// URL inside the entry
try_get_otp_via_oathtool() {
  local entry="$1"
  has_oathtool || return 1

  # Get full entry and find first otpauth:// line
  local content uri
  content="$(pass show "$entry" 2>/dev/null)" || return 1
  uri="$(printf '%s\n' "$content" | grep -m1 -E '^otpauth://(totp|hotp)/')" || return 1

  # Only support TOTP here
  echo "$uri" | grep -q '^otpauth://totp/' || return 1

  # Extract query params
  # secret= (base32), digits= (6/8), period= (default 30), algorithm= (SHA1/SHA256/SHA512)
  local secret digits period algo opt_algo
  secret="$(printf '%s' "$uri" | sed -n 's/.*[?&]secret=\([^&]*\).*/\1/p' | head -n1)"
  [[ -n "$secret" ]] || return 1
  secret="$(urldecode "$secret")"

  digits="$(printf '%s' "$uri" | sed -n 's/.*[?&]digits=\([0-9]\+\).*/\1/p' | head -n1)"
  [[ -n "$digits" ]] || digits=6

  period="$(printf '%s' "$uri" | sed -n 's/.*[?&]period=\([0-9]\+\).*/\1/p' | head -n1)"
  [[ -n "$period" ]] || period=30

  algo="$(printf '%s' "$uri" | sed -n 's/.*[?&]algorithm=\([A-Za-z0-9]\+\).*/\1/p' | head -n1)"
  case "${algo^^}" in
    SHA256) opt_algo="--sha256" ;;
    SHA512) opt_algo="--sha512" ;;
    *) opt_algo="" ;; # default SHA1
  esac

  # Compute TOTP
  local code
  if code="$(oathtool --totp -b -d "$digits" -s "$period" $opt_algo "$secret" 2>/dev/null)"; then
    code="$(printf '%s' "$code" | tr -d '[:space:]')"
    [[ "$code" =~ ^[0-9]{6,10}$ ]] || return 1
    printf '%s' "$code"
    return 0
  fi

  return 1
}

# Get password (first line)
get_password_firstline() {
  pass show "$1" 2>/dev/null | head -n 1
}

# Try OTP first (pass-otp, then oathtool), fallback to password
# On success, echoes secret and sets global IS_TOTP=true/false
IS_TOTP=false
get_secret_best_effort() {
  local entry="$1"
  local code

  if code="$(try_get_otp_via_pass "$entry")"; then
    IS_TOTP=true
    printf '%s' "$code"
    return 0
  fi

  if code="$(try_get_otp_via_oathtool "$entry")"; then
    IS_TOTP=true
    printf '%s' "$code"
    return 0
  fi

  IS_TOTP=false
  get_password_firstline "$entry"
}

# Clipboard helpers
copy_to_clipboard() {
  local secret="$1"
  local service="$2"
  local is_totp="$3"

  local type="Password"
  [[ "$is_totp" == "true" ]] && type="TOTP"

  # Do not truncate TOTP codes; optionally limit non-TOTP
  if [[ "$is_totp" != "true" && $MAX_CLIP_LEN -gt 0 && ${#secret} -gt $MAX_CLIP_LEN ]]; then
    secret="${secret:0:$MAX_CLIP_LEN}"
  fi

  if [[ -z "$secret" ]]; then
    echo -e "${RED}✗ Empty secret${NC}"
    return 1
  fi

  if [[ -n "$CLIP_NAME" ]]; then
    if printf %s "$secret" | "${CLIP_SET[@]}" >/dev/null 2>&1; then
      echo -e "${GREEN}✓ $type for $service copied (${CLIP_NAME})${NC}"
      return 0
    fi
  fi

  echo -e "${RED}✗ No clipboard tools available or copy failed${NC}"
  echo -e "${YELLOW}$secret${NC}"
  return 1
}

clear_clipboard() {
  if [[ -n "$CLIP_NAME" ]]; then
    printf '' | "${CLIP_CLEAR[@]}" >/dev/null 2>&1
  fi
}

# Build entry list without decrypting files
# Populates: ENTRIES (array), TOTP_COUNT (heuristic: folder-based)
build_entries() {
  ENTRIES=()
  TOTP_COUNT=0

  while IFS= read -r -d '' file; do
    local clean
    clean="$(get_clean_name "$file")"
    case "$clean" in
      docker-credential-helpers/*) continue ;;
      .git/*|*/.git/*) continue ;;
    esac
    ENTRIES+=("$clean")
    [[ "$clean" == totp/* ]] && ((TOTP_COUNT++))
  done < <(
    find "$STORE" \
      -path "$STORE/.git" -prune -o \
      -path "$STORE/docker-credential-helpers" -prune -o \
      -type f -name "*.gpg" -print0 2>/dev/null
  )

  if ((${#ENTRIES[@]} > 0)); then
    IFS=$'\n' ENTRIES=($(printf '%s\n' "${ENTRIES[@]}" | LC_ALL=C sort))
    unset IFS
  fi
}

list_entries() {
  build_entries
  if ((${#ENTRIES[@]} == 0)); then
    echo -e "${RED}No entries found${NC}"
    return
  fi
  for entry in "${ENTRIES[@]}"; do
    local display="$entry"
    [[ "$entry" == totp/* ]] && display="$entry [TOTP]"
    printf '%s\n' "$display"
  done
  echo -e "${GREEN}Total: ${#ENTRIES[@]} entries ($TOTP_COUNT TOTP est.)${NC}"
}

show_menu_fzf() {
  build_entries
  local count=${#ENTRIES[@]}
  if ((count == 0)); then
    echo -e "${RED}No entries found${NC}"
    exit 1
  fi

  # Format entries for fzf: "entry-name [TOTP]"
  local formatted_entries=()
  for entry in "${ENTRIES[@]}"; do
    local display="$entry"
    [[ "$entry" == totp/* ]] && display="$entry [TOTP]"
    formatted_entries+=("$display")
  done

  # Show OTP tool status
  if ((PASS_OTP_AVAILABLE == 1)); then
    echo -e "${GREEN}✓ pass-otp detected (OTP preferred)${NC}"
  elif has_oathtool; then
    echo -e "${GREEN}✓ oathtool detected (OTP via URL)${NC}"
  else
    echo -e "${YELLOW}! No OTP tools detected; falling back to passwords${NC}"
  fi
  echo ""

  # Use fzf to select entry
  local selected_display
  selected_display="$(printf '%s\n' "${formatted_entries[@]}" | fzf --height=40% --prompt='Select entry > ' --cycle --reverse)"

  local exit_code=$?
  if ((exit_code != 0)) || [[ -z "$selected_display" ]]; then
    exit 0
  fi

  # Remove " [TOTP]" suffix to get actual entry name
  local selected="${selected_display%% \[TOTP\]}"

  echo ""
  echo -e "${YELLOW}Getting $selected...${NC}"

  local secret
  secret="$(get_secret_best_effort "$selected")"
  local is_totp="false"
  $IS_TOTP && is_totp="true"

  if [[ -n "$secret" ]]; then
    copy_to_clipboard "$secret" "$selected" "$is_totp"

    # Auto-clear in background
    local clear_time=45
    [[ "$is_totp" == "true" ]] && clear_time=30
    (sleep "$clear_time"; clear_clipboard) &

    echo -e "${GREEN}✓ Done! Clipboard will clear in ${clear_time}s${NC}"
    exit 0
  else
    echo -e "${RED}✗ Failed to get secret${NC}"
    exit 1
  fi
}

show_menu_numbered() {
  build_entries
  local count=${#ENTRIES[@]}
  if ((count == 0)); then
    echo -e "${RED}No entries found${NC}"
    exit 1
  fi

  echo -e "${YELLOW}Password/TOTP Manager${NC}"
  echo "Total: $count entries ($TOTP_COUNT TOTP est.)"
  echo ""
  echo "Entries:"
  local i
  for i in "${!ENTRIES[@]}"; do
    local entry="${ENTRIES[$i]}"
    local type=""
    [[ "$entry" == totp/* ]] && type=" [TOTP]"
    printf " %2d: %s%s\n" $((i + 1)) "$entry" "$type"
  done

  echo ""
  if ((PASS_OTP_AVAILABLE == 1)); then
    echo -e "${GREEN}✓ pass-otp detected (OTP preferred)${NC}"
  elif has_oathtool; then
    echo -e "${GREEN}✓ oathtool detected (OTP via URL)${NC}"
  else
    echo -e "${YELLOW}! No OTP tools detected; falling back to passwords${NC}"
  fi

  while true; do
    read -r -p "Select (1-$count) or 'q': " choice
    [[ "$choice" =~ ^[qQ]$ ]] && exit 0

    if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= count)); then
      local selected="${ENTRIES[$((choice - 1))]}"

      echo ""
      echo -e "${YELLOW}Getting $selected...${NC}"

      local secret
      secret="$(get_secret_best_effort "$selected")"
      local is_totp="false"
      $IS_TOTP && is_totp="true"

      if [[ -n "$secret" ]]; then
        copy_to_clipboard "$secret" "$selected" "$is_totp"

        # Auto-clear in background
        local clear_time=45
        [[ "$is_totp" == "true" ]] && clear_time=30
        (sleep "$clear_time"; clear_clipboard) &

        echo -e "${GREEN}✓ Done! Clipboard will clear in ${clear_time}s${NC}"
        exit 0
      else
        echo -e "${RED}✗ Failed to get secret${NC}"
      fi
    else
      echo -e "${RED}Invalid choice${NC}"
    fi
  done
}

show_menu() {
  if ((FZF_AVAILABLE == 1)); then
    show_menu_fzf
  else
    show_menu_numbered
  fi
}

# Copy a specific service quickly
copy_specific() {
  local service="$1"
  if [[ -z "$service" ]]; then
    echo -e "${RED}Service name required${NC}"
    exit 1
  fi

  local file="$STORE/$service.gpg"
  if [[ ! -f "$file" ]]; then
    echo -e "${RED}Entry '$service' not found${NC}"
    list_entries
    exit 1
  fi

  echo -e "${YELLOW}Getting $service...${NC}"
  local secret
  secret="$(get_secret_best_effort "$service")"
  local is_totp="false"
  $IS_TOTP && is_totp="true"

  if [[ -n "$secret" ]]; then
    copy_to_clipboard "$secret" "$service" "$is_totp"
    local clear_time=45
    [[ "$is_totp" == "true" ]] && clear_time=30
    (sleep "$clear_time"; clear_clipboard) &
    echo -e "${GREEN}✓ Copied! Clears in ${clear_time}s${NC}"
  else
    echo -e "${RED}✗ Failed to get secret${NC}"
    exit 1
  fi
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      echo "Usage: $0 [-s SERVICE] [-l] [-t]"
      echo "  -s SERVICE  Copy specific service (OTP preferred)"
      echo "  -l          List entries"
      echo "  -t          Test clipboard"
      echo "  (no args)   Interactive menu (fzf if available)"
      exit 0
      ;;
    -l)
      list_entries
      exit 0
      ;;
    -t)
      echo -e "${YELLOW}Testing clipboard...${NC}"
      test_text="TEST-$(date +%s)"
      if [[ -n "$CLIP_NAME" ]]; then
        if printf %s "$test_text" | "${CLIP_SET[@]}" >/dev/null 2>&1; then
          echo -e "${GREEN}✓ Copied '$test_text' - try pasting${NC}"
        else
          echo -e "${RED}✗ Clipboard copy failed${NC}"
        fi
      else
        echo -e "${RED}✗ No clipboard tool detected${NC}"
      fi
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
command -v pass >/dev/null 2>&1 || {
  echo -e "${RED}pass command not found${NC}"
  echo "Install: sudo apt install pass"
  exit 1
}

show_menu
