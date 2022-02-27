#!/bin/sh

[ ! -x "$(command -v dmenu)" ] && 
{ printf "%s\n" "dmenu is not in PATH. Exitting" 2>&1; exit 1; }

MUSIC_DIR="$MUSIC_DIR_ENVVAR"
[ -z "$MUSIC_DIR" ] && MUSIC_DIR="${HOME}/Music"
mpc update &> /dev/null

selected_dir="$(ls "$MUSIC_DIR" | dmenu -i -l 10 -p "Directory: ")"

# Do nothing if input is empty
[ -z "$selected_dir" ] && exit 0

# Execute mpc commands and play songs from selected_dir
mpc clear && mpc add "$selected_dir" && mpc play
