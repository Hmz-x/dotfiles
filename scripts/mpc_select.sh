#!/bin/sh

# Program constants
DMENU_LINE_COUNT=10
FEH_OPTION="--bg-tile"
MUSIC_DIR="${MUSIC_DIR_ENVVAR-"${HOME}/Music"}"

return_strlen()
{
	local_strlen=$(printf "%s" "$1" | wc -m)
	echo $local_strlen
}

select_dir(){
	selected_dir="$(ls "$var_music_dir" | dmenu -i -l "$DMENU_LINE_COUNT" -p "Directory: ")"
	contains_dir_bool="false"

	# Do nothing if input is empty
	[ -z "$selected_dir" ] && exit 0

	for file in "${var_music_dir}/${selected_dir}"/*; do
		[ -d "$file" ] && contains_dir_bool="true" && break
	done	
	
	# Add the selected directory on top of the current music directory
	var_music_dir="${var_music_dir}/${selected_dir}"
	[ "$contains_dir_bool" = "true" ] && select_dir
	
	# Remove the MUSIC_DIR from the mpc input directory
	music_dir_strlen=$(return_strlen "$MUSIC_DIR")	
	mpc_readable_dir="$(echo "$var_music_dir" | cut -b $((music_dir_strlen+2))-)"

	printf "%s\n\n" "Adding directory: $mpc_readable_dir"
	
	# Add and play directory
	mpc clear &> /dev/null && mpc add "$mpc_readable_dir" && mpc play

	# Display albumart of the selected directory
	display_art

	exit 0
}

select_dir_main(){
	# Prepare for select_dir
	mpc update &> /dev/null
	# Variable music dir, might change
	var_music_dir="$MUSIC_DIR"
	select_dir
}

select_track(){
	# Get track name and number
	selected_track="$(mpc playlist | dmenu -i -l 10 -p "Track: ")"

	# Select the first instance only
	track_number="$(mpc playlist | grep -F "$selected_track" --line-number | \
		awk 'NR==1' | cut -d ':' -f 1)"

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
	mpc albumart "$mpc_readable_dir/" > "$albumart_temp_file" 2> /dev/null

	# If no image data is written to temp albumart file, search for 
	# images embedded in the files or a jpg, png, etc. file in the directory instead
	if [ "$(isempty "$albumart_temp_file")" = "true" ]; then
		readpicture_temp_file="$(mktemp)"
		
		for file in "${MUSIC_DIR}/${mpc_readable_dir}/"*; do
			# Write embedded image to temp readpicture file
			mpc readpicture "${mpc_readable_dir}/$(basename "$file")" > \
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
	select_dir_main
elif [ "X$1" = "X--select-track" ]; then
	# Select a track in the selected directory
	select_track
else
	printf "%s\n" "Unknown option was passed. Exitting." 2>&1; exit 1; 
fi
