#!/bin/bash
# Toggle battery charge limit between 80% and 100%

THRESHOLD_FILE="/sys/class/power_supply/BAT0/charge_control_end_threshold"

current=$(cat "$THRESHOLD_FILE")

if [ "$current" -eq 80 ]; then
	new=100
else
	new=80
fi

if echo "$new" | sudo tee "$THRESHOLD_FILE" > /dev/null 2>&1; then
	actual=$(cat "$THRESHOLD_FILE")
	notify-send -e -u low -i /usr/share/icons/AdwaitaLegacy/48x48/legacy/battery-full.png \
		"Battery Charge Limit" "Set to ${actual}%"
else
	notify-send -e -u critical -i /usr/share/icons/AdwaitaLegacy/48x48/legacy/battery-missing.png \
		"Battery Charge Limit" "Failed to change (run sudoers setup)"
fi
