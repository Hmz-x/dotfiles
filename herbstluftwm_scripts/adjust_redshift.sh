#!/bin/sh

# Raise or lower redshift value based on given argument. Written by Hamza Kerem Mumcu.

rc_file="${HOME}/.config/.adjust_redshiftrc"
min_redshift_val=0 # default value
max_redshift_val=10
redshift_temp=5555

check_rc_corruption(){
	# Dont allow lowering of redshift if redshift_envvar is already at min
	[ "X${redshift_envvar}" = "X${min_redshift_val}" ] &&
	[ "$1" = "1" ] && exit 0

	# Dont allow raising of redshift if redshift_envvar is already at max
	[ "X${redshift_envvar}" = "X${max_redshift_val}" ] && 
	{ [ "$1" = "0" ] || [ -z "$1" ]; } && exit 0

	# Check if redshift_envvar is between min_redshift_val and max_redshift_val
	num_matched_bool="false"
	for i in $(seq $min_redshift_val $max_redshift_val); do
		[ "X${redshift_envvar}" = "X${i}" ] && num_matched_bool="true" && break
	done	

	# If not, write min_redshift_val to rc_file
	[ ! "X${num_matched_bool}" = "Xtrue" ] &&
	printf 'export redshift_envvar=%s\n' "$min_redshift_val" > "$rc_file"
}

write_to_rc()
{
	# if passed the argument 0 or no argument passed, increase redshift_envvar by 1
	{ [ "$1" = "0" ] || [ -z "$1" ]; } && 
	printf 'export redshift_envvar=%s\n' $((redshift_envvar+1)) > "$rc_file"

	# if passed the argument 1 decrease redshift_envvar by 1
	[ "$1" = "1" ] && 
	printf 'export redshift_envvar=%s\n' $((redshift_envvar-1)) > "$rc_file"
}

change_redshift_val()
{
	echo "in change_redshift_val"
	redshift -x -m vidmode # reset and remove adjustments
	for i in $(seq 1 $redshift_envvar); do
	echo "in loop"
		redshift -O $redshift_temp -m vidmode
	done
}

# Check if redshift is executable, if not exit
[ -x "$(command -v redshift)" ] || 
{ printf 'Unable to execute redshift. Exitting\n' 2>&1 && exit 1; }

# Check if rc_file exists and then read data from it
[ -r "$rc_file" ] || { printf 'Unable to read %s. Exitting.\n' "$rc_file" 2>&1 && exit 1; }
source "$rc_file"

# Check the data, redshift_envvar, and write the new value to rc_file, if neccessary
check_rc_corruption "$1"
write_to_rc "$1"

# Re-read data 
source "$rc_file" 

# Change redshift value
change_redshift_val
