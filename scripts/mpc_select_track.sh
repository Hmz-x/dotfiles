#!/bin/sh

[ ! -x "$(command -v dmenu)" ] && 
{ printf "%s\n" "dmenu is not in PATH. Exitting" 2>&1; exit 1; }

# Get track name and number
selected_track="$(mpc playlist | dmenu -i -l 10 -p "Track: ")"
track_number="$(mpc playlist | grep "$selected_track" --line-number | cut -d ':' -f 1)"

mpc play "$track_number"
