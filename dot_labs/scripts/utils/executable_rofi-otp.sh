#!/usr/bin/env bash
# passmenu — unified launcher: OTP (from totp/) + normal passwords

# ------------------------------------------------------------------
# CONFIGURATION
# ------------------------------------------------------------------
declare -a IGNORE_FOLDERS=(
    "docker-credential-helpers"
)

# Order applies only to OTP entries
declare -a ORDERED_OTP_FOLDERS=(
    "zog"
    "bjs"
    "mirf"
)

ignore_pattern=$(IFS='|'; echo "${IGNORE_FOLDERS[*]}")

# ------------------------------------------------------------------
# 1. OTP entries (from totp/)
# ------------------------------------------------------------------
otp_raw=$(
    tree ~/.password-store/totp -f --noreport -I "$ignore_pattern" |
    grep '\.gpg$' |
    sed -E 's|.*/totp/||; s|\.gpg$||'
)

# Apply custom order to OTP
otp_ordered=""
otp_rest=""
while IFS= read -r path; do
    dir="${path%/*}"
    matched=0
    for wanted in "${ORDERED_OTP_FOLDERS[@]}"; do
        [[ "$dir" == "$wanted" ]] && { matched=1; break; }
    done
    if (( matched )); then
        otp_ordered+="$path"$'\n'
    else
        otp_rest+="$path"$'\n'
    fi
done <<< "$otp_raw"
otp_list=$(printf '%s%s' "$otp_ordered" "$(printf '%s' "$otp_rest" | sort)")

# ------------------------------------------------------------------
# 2. Normal passwords (everything except totp/)
# ------------------------------------------------------------------
pass_list=$(
    tree ~/.password-store -f --noreport -I "$ignore_pattern|totp" |
    grep '\.gpg$' |
    sed -E 's|.*/\.password-store/||; s|\.gpg$||' |
    sort
)

# ------------------------------------------------------------------
# 3. Build menu: OTP first, then passwords
# ------------------------------------------------------------------
menu=$(
    printf '%s\n' "$otp_list" | sed 's/$/\tOTP/'   # mark OTP
    printf '%s\n' "$pass_list" | sed 's/$/\tpwd/' # mark password
)

# ------------------------------------------------------------------
# 4. ROFI SELECTION
# ------------------------------------------------------------------
choice=$(printf '%s' "$menu" | column -t -s $'\t' | rofi -dmenu -i -p "pass")

[[ -z $choice ]] && exit

path=$(echo "$choice" | awk '{print $1}')
type=$(echo "$choice" | awk '{print $2}')

case "$type" in
    OTP)
        pass otp "totp/$path" -c &&
            notify-send "OTP" "Code copied for $path"
        ;;
    pwd)
        pass show -c "$path" &&
            notify-send "pass" "Password copied for $path"
        ;;
esac || notify-send -u critical "error" "Could not copy $type for $path"
