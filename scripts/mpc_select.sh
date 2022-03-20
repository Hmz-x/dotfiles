#!/bin/sh

# Program constants
DMENU_LINE_COUNT=10
FEH_OPTION="--bg-tile"

select_dir(){
	MUSIC_DIR="$MUSIC_DIR_ENVVAR"
	[ -z "$MUSIC_DIR" ] && MUSIC_DIR="${HOME}/Music"
	mpc update &> /dev/null

	selected_dir="$(ls "$MUSIC_DIR" | dmenu -i -l "$DMENU_LINE_COUNT" -p "Directory: ")"

	# Do nothing if input is empty
	[ -z "$selected_dir" ] && exit 0

	# Execute mpc commands and play songs from selected_dir
	mpc clear && mpc add "$selected_dir" && mpc play
}

select_track(){
	# Get track name and number
	selected_track="$(mpc playlist | dmenu -i -l 10 -p "Track: ")"
	#echo "Selected track: $selected_track"
	# select the first instance only
	track_number="$(mpc playlist | grep -F "$selected_track" --line-number | \
		awk 'NR==1' | cut -d ':' -f 1)"
	#echo "Track number: $track_number"

	mpc play "$track_number"
}

display_art(){
	# If the selected_dir contains an 

	temp_file="$(mktemp)"
	mpc albumart "$selected_dir/" > "$temp_file" 2> /dev/null

	# If no image data is written to temp file, just remove it and 
	# search for jpg, png, etc. files instead
	if [ "$(file "$temp_file" | cut -d ' ' -f 2)" = "empty" ]; then
		rm "$temp_file"
		for file in "${MUSIC_DIR}/${selected_dir}/"*; do
			file "$file" | grep -iq "image" &&
			feh "$FEH_OPTION" --no-fehbg "$file" &&
			break
		done
	# Else display image file, temp_file, in the background
	else
		feh --bg-tile --no-fehbg "$temp_file"
	fi
}

# Check that dmenu is in path
[ ! -x "$(command -v dmenu)" ] && 
{ printf "%s\n" "dmenu is not in PATH. Exitting" 2>&1; exit 1; }

if [ -z "$1" ] || [ "X$1" = "X--select-dir" ]; then
	# Select directory using dmenu and start playing its songs
	select_dir 
	# Display albumart of the selected directory
	display_art
elif [ "X$1" = "X--select-track" ]; then
	# Select a track in the selected directory
	select_track
else
	printf "%s\n" "Unknown option was passed. Exitting." 2>&1; exit 1; 
fi
