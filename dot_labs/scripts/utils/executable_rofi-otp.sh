#!/bin/bash

# Get clean paths using tree to list the totp directory, but include .gpg files
selected=$(tree ~/.password-store/totp -f --noreport | 
    grep '\.gpg' | 
    sed 's|.*/totp/||' | 
    sed 's|\.gpg$||' |
    rofi -dmenu -i -p "OTP")

if [ -n "$selected" ]; then
    # Remove trailing whitespace and ensure no empty selection
    clean_path=$(echo "$selected" | tr -d '[:space:]')
    if [ -n "$clean_path" ]; then
        if pass otp "totp/$clean_path" -c; then
            notify-send "OTP" "Code copied for $clean_path"
        else
            notify-send -u critical "OTP Error" "Failed to get OTP for $clean_path"
        fi
    fi
fi
