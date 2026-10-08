#!/bin/sh

# Raise or lower brightness based on given argument. Written by Hamza Kerem Mumcu.

rc_file="${HOME}/.config/.adjust_brightnessrc"
max_brightness_val=10
min_brightness_val=0

check_rc_corruption(){
	# Dont allow lowering of brightness if brightness_envvar is already at min
	[ "X${brightness_envvar}" = "X${min_brightness_val}" ] &&
	{ [ "$1" = "0" ] || [ -z "$1" ]; } && exit 0

	# Dont allow raising of brightness if brightness_envvar is already at max
	[ "X${brightness_envvar}" = "X${max_brightness_val}" ] && 
	[ "$1" = "1" ] && exit 0

	# Check if brightness_envvar is between min_brightness_val and max_brightness_val
	num_matched_bool="false"
	for i in $(seq $min_brightness_val $max_brightness_val); do
		[ "X${brightness_envvar}" = "X${i}" ] && num_matched_bool="true" && break
	done	

	# If not, write max_brightness_val to rc_file
	[ ! "X${num_matched_bool}" = "Xtrue" ] &&
	printf 'export brightness_envvar=%s\n' "$max_brightness_val" > "$rc_file"
}

write_to_rc(){
	# if passed the argument 0 or no argument passed, decrease brightness_envvar by 1
	{ [ "$1" = "0" ] || [ -z "$1" ]; } && 
	printf 'export brightness_envvar=%s\n' $((brightness_envvar-1)) > "$rc_file"

	# if passed the argument 1 increase brightness_envvar by 1
	[ "$1" = "1" ] && 
	printf 'export brightness_envvar=%s\n' $((brightness_envvar+1)) > "$rc_file"
}

xrandr_brightness(){
	# Get output from envvar or set it to given output
	output="$X_MONITOR_OUTPUT_ENVVAR"
	[ -z "$output" ] && output="LVDS-1"

	((brightness_envvar==max_brightness_val)) && 
	xrandr --output "$output" --brightness 1

	((brightness_envvar<max_brightness_val)) && 
	xrandr --output "$output" --brightness 0.$brightness_envvar
}

# Check if xrandr is executable, if not exit
[ -x "$(command -v xrandr)" ] || 
{ printf 'Unable to execute xrandr. Exitting\n' 2>&1 && exit 1; }

# Check if rc_file exists and then read data from it
[ -r "$rc_file" ] || { printf 'Unable to read %s. Exitting.\n' "$rc_file" 2>&1 && exit 1; }
source "$rc_file"

# Check the data, brightness_envvar, and write the new value to rc_file, if neccessary
check_rc_corruption "$1"
write_to_rc "$1"

# Re-read data 
source "$rc_file" 

# Change brightness
xrandr_brightness
