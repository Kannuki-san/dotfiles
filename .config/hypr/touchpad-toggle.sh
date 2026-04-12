#!/usr/bin/env bash

DEVICE="ftcs1000:01-2808:0101-touchpad"
STATEFILE="${XDG_RUNTIME_DIR:-/tmp}/hypr-touchpad-disabled"

if [ -e "$STATEFILE" ]; then
    # いま無効扱い → 有効に戻す
    hyprctl keyword "device[$DEVICE]:enabled" true
    rm -f "$STATEFILE"
    notify-send "Touchpad" "ON"
else
    # いま有効扱い → 無効にする
    hyprctl keyword "device[$DEVICE]:enabled" false
    touch "$STATEFILE"
    notify-send "Touchpad" "OFF"
fi
