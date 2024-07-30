#!/bin/sh

# This script is for picking a password from .password-store and
# then copying it to clipboard

TERMINAL="alacritty"
pass="$(ls ~/.password-store | sort | sed 's/\.gpg//g' | rofi -dmenu)"
[ -n "$pass" ] && "$TERMINAL" -e bash -c "pass show -c $pass; sleep 3"
