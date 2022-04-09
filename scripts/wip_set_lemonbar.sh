#!/bin/sh
 
# Script constants
DEFAULT_SLEEP_TIME="1"
SEPERATOR_STRING="|"
FUNC_DELIM="-" # Function delimeter

return_char_count()
{
	passed_input="$1"
	passed_delim="$2"

	local_space_count=$(echo "$1" | grep -o "$passed_delim" | wc -l)
	echo $local_space_count
}

return_strlen()
{
	local_strlen=$(printf "%s" "$1" | wc -m)
	echo $local_strlen
}

get_text()
{
	input="$1"

	# Print spaces
	#for i in $(seq 0 $((init_ch_count-var_ch_count))); do
		#printf " "
	#done
	
	# Print characters
	#for i in $(seq $var_ch_count $init_ch_count); do
		#printf "$input" | cut -c $i
	#done
	echo "XXX $input XXX" # | cut -b -$var_ch_count
}

get_cpu_info()
{
	cpu_data="$(mpstat | awk 'NR==4')"
	usr_data="$(echo $cpu_data | cut -d ' ' -f 4)"
	sys_data="$(echo $cpu_data | cut -d ' ' -f 6)"

	echo "usr: ${usr_data} sys: ${sys_data}"
}

return_window_titles()
{
	recieved_window_titles=""
	temp_window_titles_file="$(mktemp)"
	
	# Output list_clients_output properly formatted to temp_window_titles_file
	echo "$list_clients_output" | cut -d ' ' -f 2- > "$temp_window_titles_file"
	
	while read -r line; do
		# Get only last string in the entire line
		space_count="$(return_char_count "$line" " ")"
		if ((space_count==0)); then
			single_window_title="$line"
		else
			single_window_title="$(echo "$line" | cut -d ' ' -f $((space_count+1)))"
		fi
		recieved_window_titles="${recieved_window_titles}${single_window_title} "
	done < "$temp_window_titles_file"

	rm "$temp_window_titles_file"
	echo "$recieved_window_titles"
}

get_hlwm_info()
{
	# Local constants
	SPACE_COUNT=20
	TOTAL_TAG_COUNT=4
	REGULAR_TAG_COLOR="#000000"
	CURRENT_TAG_COLOR="#FFFFFF"
	REGULAR_TAG_BG_COLOR="#EEFF7C"
	CURRENT_TAG_BG_COLOR="#DE6FFF"

	current_tag="$(herbstclient list_monitors | cut -d '"' -f 2)"
	
	# Print all tag boxes each containing tag number and window titles
	for tag in $(seq 1 $TOTAL_TAG_COUNT); do

		# Print color formatting
		if [ "$current_tag" = "$tag" ]; then
			printf -- "%s" "%{B${CURRENT_TAG_BG_COLOR}} %{F${CURRENT_TAG_COLOR}} "
		else
			printf -- "%s" "%{B${REGULAR_TAG_BG_COLOR}} %{F${REGULAR_TAG_COLOR}} "
		fi

		# Print regular tag number 
		printf "%s" "$tag"

		# Get window titles for each tag, print if applicable
		list_clients_output="$(herbstclient list_clients --tag="$tag" --title)"
		if [ -n "$list_clients_output" ]; then
			# Parse through the entire data and only get the program name
			window_titles="$(return_window_titles)"

			# Calculate number of spaces needed for the rest of the "tag box"
			window_titles_strlen=$(return_strlen "$window_titles")
			spaces_left=$((SPACE_COUNT-window_titles_strlen-1))

			# Print window titles of the programs only
			printf " %s" "$window_titles"
		else
			spaces_left=$SPACE_COUNT
		fi

		# Print space
		for j in $(seq 1 $spaces_left); do
			printf "%s" " "
		done
	done
	printf -- "%s\n" "%{B${REGULAR_TAG_BG_COLOR}}"
}

get_acpi_info()
{
	charging_percentage="$(acpi | cut -d ' ' -f 4 | cut -b -3)"
	charging_status="$(acpi | cut -d ' ' -f 3 | cut -d ',' -f 1)"
	echo "${charging_status} ${charging_percentage}"
}

get_nmcli_info()
{
	con_line="$(nmcli device | awk 'NR==2')"
	echo $con_line
}

get_mpc_info()
{
	# Basic stuff
	vol="$(mpc status '%volume%')"
	song="$(mpc current)"
	songpos="$(mpc status '%songpos%')"
	pl_length="$(mpc status '%length%')"

	# Status stuff
	random_status="$(mpc status '%random%')"
	random_status_letter="."
	[ "$random_status" = "on" ] && random_status_letter="R"

	single_status="$(mpc status '%single%')"
	single_status_letter="."
	[ "$single_status" = "on" ] && single_status_letter="S"

	repeat_status="$(mpc status '%repeat%')"
	repeat_status_letter="."
	[ "$repeat_status" = "on" ] && repeat_status_letter="R"

	# If --ttf-font-awesome is passed, echo icon strings too
	if  [ "$ttf_fa_bool" = "true" ]; then
		state_status="$(mpc status '%state%')"
		[ "$state_status" = "playing" ] && state_icon="\\uf001"
		[ "$state_status" = "paused" ] && state_icon="\\uf05e"
	fi	

	echo "mpc volume:${vol} | ${song} (${songpos}/${pl_length}) " \
		"(${random_status_letter}${single_status_letter}${repeat_status_letter}) " \
		"${state_icon}"
}

get_date_info()
{
	date '+%T   %d/%B/%Y   %:z'
}

get_pulseaudio_info()
{
	echo "PA volume: $(pamixer --get-volume)"
}

call_later()
{
	# Write passed_dir and passed_func to temp_loop_file, and passed_arg if exists

	# Passed aligment direction
	passed_dir="%{$1}"
	# Passed executable function
	passed_func="$2"
	# Passed argument for function
	{ [ -n "$3" ] && passed_arg="${FUNC_DELIM}${3}"; } || passed_arg=""


	echo "In call_later(). passed_dir: $passed_dir, passed_func: $passed_func passed_arg: $passed_arg"

	# Create temp file if non-existent
	if [ ! -f "$temp_loop_file" ]; then
		temp_loop_file="$(mktemp)" || 
		{ printf -- "%s\n" "Fatal: Couldn't create temporary file. Exitting" 2>&1; exit 1; }
	fi
	
	line_count=$(wc -l "$temp_loop_file" | cut -d ' ' -f 1)

	# If alignment_direction is same as the previous passed_func's direction, 
	# don't write passed_dir.
	if ((line_count>0)) &&
	awk "NR==$line_count" "$temp_loop_file" | grep "$passed_dir" -q; then
		printf -- "%s%s\n" "$passed_func" "$passed_arg" >> "$temp_loop_file"
		sed -i "${line_count}N;s/\n/${FUNC_DELIM}/" "$temp_loop_file" 
	# If not, just write the new passed_dir and passed_func to file
	else
		#printf -- "In func: %s${FUNC_DELIM}%s\n" "$passed_dir" "$passed_func"
		printf -- "%s${FUNC_DELIM}%s%s\n" "$passed_dir" "$passed_func" "$passed_arg" >> \
			"$temp_loop_file"
	fi
}

parse_options()
{
	# true if --ttf-font-awesome pos-param is passed
	ttf_fa_bool="false"
	# true if get_text is called
	active_get_text_count="false"
	# Result to default sleep_time if --sleep-time SLEEP_TIME isn't passed
	sleep_time="$DEFAULT_SLEEP_TIME"
	# default alignment direction is c (center)
	alignment_direction="c"

	while [ "$#" -gt 0 ]; do
		case "$1" in
			'--ttf-font-awesome') ttf_fa_bool="true";;	
			'--sleep-time') [ -n "$2" ] && sleep_time="$2" && shift;;

			'-l') alignment_direction="l";;
			'-r') alignment_direction="r";;
			'-c') alignment_direction="c";;

			# Special function
			'get_text') [ -n "$2" ] && init_ch_count=$(return_strlen "$2") &&
				var_ch_count=1 && call_later "$alignment_direction" "get_text" "$2" &&
				shift;;

			# If given function executes without any errors, call it later 
			*) "$1" &> /dev/null && call_later "$alignment_direction" "$1";;
		esac
	shift	
	done
}

lemonbar_loop()
{
	echo "temp file: $temp_loop_file"
	# Read lines to output to lemonbar from temp_loop_file
	while true; do
		lemonbar_str=""

		while read line; do
			# Get direction first
			lemonbar_str="$lemonbar_str $(echo "$line" | cut -d "$FUNC_DELIM" -f 1)"
			echo "Direction:$lemonbar_str"
			
			# Then, get the rest of the input functions given and add the input
			# to lemonbar_str
			dash_count=$(return_char_count "$line" "-")
			for i in $(seq 2 $((dash_count+1))); do
				[ "$skip_func_in_bool" = "true" ] && continue

				skip_func_in_bool="false"
				func_to_exec="$(echo "$line" | cut -d "$FUNC_DELIM" -f $i)"

				#func_to_exec="$(echo "$line" | cut -d ' ' -f $i)"
				echo "func: $func_to_exec"
				#((i!=2)) && prev_func="$(echo "$line" | cut -d ' ' -f $((i-1)))" &&
				#	echo "prev func: $func_to_exec"

				if [ "$func_to_exec" = "get_text" ]; then
					skip_func_in_bool="true"
					get_text_arg="$(echo "$line" | cut -d "$FUNC_DELIM" -f $((i+1)))"
					echo "arg: $get_text_arg"
					func_output="$("$func_to_exec" "$get_text_arg")"

					((++var_ch_count))
					((var_ch_count>init_ch_count)) &&
						var_ch_count=1
				else
					func_output="$("$func_to_exec")"
				fi

				lemonbar_str="$lemonbar_str $func_output"

				# If not the last input function, add a seperator string to lemonbar_str
				((i<dash_count+1)) && lemonbar_str="$lemonbar_str $SEPERATOR_STRING"
			done	
		done < "$temp_loop_file"
		
		#while read dir_in func_in; do
			#lemonbar_str="${lemonbar_str} ${dir_in} $("$func_in")"	
			#if [ "$func_in" = "get_text" ]; then
				#((--ch_count))
				#((ch_count<1)) && ch_count=7
			#fi
		#done < "$temp_loop_file"
		
		# Output to lemonbar
		echo -e "$lemonbar_str"

		sleep "$sleep_time"
	done
}

# Parse pos-param options
parse_options "$@"

# If temp_loop_file is non-existent after pos-params are parsed, none were passed
[ ! -f "$temp_loop_file" ] && exit 0

# Loop over passed pos-param executable functions
lemonbar_loop 
