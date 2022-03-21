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

isempty()
{
	if [ "$(file "$1" | cut -d ' ' -f 2)" = "empty" ]; then
		echo "true"
	else
		echo "false" 
	fi
}

display_image()
{
	feh "$FEH_OPTION" --no-fehbg "$1"
}

display_art(){
	albumart_temp_file="$(mktemp)"
	mpc albumart "$selected_dir/" > "$albumart_temp_file" 2> /dev/null

	# If no image data is written to temp albumart file, search for 
	# images embedded in the files or a jpg, png, etc. file in the directory instead
	if [ "$(isempty "$albumart_temp_file")" = "true" ]; then
		readpicture_temp_file="$(mktemp)"
		
		for file in "${MUSIC_DIR}/${selected_dir}/"*; do
			# Write embedded image to temp readpicture file
			mpc readpicture "${selected_dir}/$(basename "$file")" > \
				"$readpicture_temp_file" 2> /dev/null
			
			# If embedded image exists, display
			if [ "$(isempty "$readpicture_temp_file")" = "false" ]; then
				display_image "$readpicture_temp_file"
				break
			# If not, check if file is an image (jpg, png, etc.) file
			elif file "$file" | grep -iq "image"; then
				display_image "$file"
				break
			fi
		done
	# if albumart_temp_file is not empty display image file in the background
	else
		feh --bg-tile --no-fehbg "$albumart_temp_file"
	fi
	
	# Cleanup
	rm "$albumart_temp_file"
	[ -f "$readpicture_temp_file" ] && rm "$readpicture_temp_file"
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
