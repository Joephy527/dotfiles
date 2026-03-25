#!/bin/bash

set -euo pipefail

STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
STATE_FILE="$STATE_DIR/hypr-night-light-state"
SHADER_PATH="$HOME/.config/hypr/shaders/night-light.frag"

mkdir -p "$STATE_DIR"

current_shader() {
    hyprctl getoption decoration:screen_shader 2>/dev/null | sed -n 's/^str: //p'
}

is_enabled() {
    [[ "$(current_shader)" == "$SHADER_PATH" ]]
}

notify_user() {
    local message="$1"

    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u low "Night Light" "$message"
    fi
}

enable_night_light() {
    hyprctl keyword decoration:screen_shader "$SHADER_PATH" >/dev/null
    printf 'on\n' > "$STATE_FILE"
}

disable_night_light() {
    if ! hyprctl keyword decoration:screen_shader "" >/dev/null 2>&1; then
        hyprctl keyword decoration:screen_shader '[[EMPTY]]' >/dev/null
    fi

    printf 'off\n' > "$STATE_FILE"
}

case "${1:-toggle}" in
    on)
        enable_night_light
        notify_user "Enabled"
        ;;
    off)
        disable_night_light
        notify_user "Disabled"
        ;;
    toggle)
        if is_enabled; then
            disable_night_light
            notify_user "Disabled"
        else
            enable_night_light
            notify_user "Enabled"
        fi
        ;;
    reapply)
        if [[ -f "$STATE_FILE" ]] && [[ "$(cat "$STATE_FILE")" == "on" ]]; then
            enable_night_light
        else
            disable_night_light
        fi
        ;;
    status)
        if is_enabled; then
            printf 'on\n'
        else
            printf 'off\n'
        fi
        ;;
    *)
        printf 'Usage: %s [toggle|on|off|reapply|status]\n' "$0" >&2
        exit 1
        ;;
esac
