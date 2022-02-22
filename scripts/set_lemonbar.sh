#!/bin/sh

# Script constants
DEFAULT_SLEEP_TIME="1"

get_acpi_info()
{
	charging_percentage="$(acpi | cut -d ' ' -f 4 | cut -b -3)"
	charging_status="$(acpi | cut -d ' ' -f 3 | cut -d ',' -f 1)"
	echo "${charging_status} ${charging_percentage}"
}

get_nmcli_info()
{
	con_line="$(nmcli device | awk 'NR==2')"
	read output_string <<< "$con_line"
	echo $output_string
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

	echo "mpc volume:${vol} ${song} (${songpos}/${pl_length}) " \
		"(${random_status_letter}${single_status_letter}${repeat_status_letter}) " \
		"${state_icon}"
}

get_date_info()
{
	date '+%c'
}

call_later()
{
	echo "$1"
}

parse_options()
{
	# true if --ttf-font-awesome pos-param is passed
	ttf_fa_bool="false"
	# Result to default sleep_time if --sleep-time SLEEP_TIME isn't passed
	sleep_time="$DEFAULT_SLEEP_TIME"

	while [ "$#" -gt 0 ]; do
		case "$1" in
			'--ttf-font-awesome') ttf_fa_bool="true";;	
			'--sleep-time') 
				if [ -z "$2" ]; then
					printf -- "%s\n" "Non-fatal: sleep time not given." 2>&1
				else
					sleep_time="$2";
					shift
				fi;;
			*) output="$("$1" 2> /dev/null || printf -- "%s\n" "INVALID_INPUT")"; 
				[ "X$output" != "XINVALID_INPUT" ] && call_later "$1";;
		esac
	shift	
	done
}


# Parse pos-param options
parse_options "$@"

lemonbar_loop()
{
	while true; do
		echo "sleep: $sleep_time"
		sleep $sleep_time

		lstring="%{l} $(get_nmcli_info)"
		cstring="%{c} PA volume: $(pamixer --get-volume) | $(get_mpc_info)"
		rstring="%{r} $(get_acpi_info) | $(get_date_info)"
		
		echo -e "${lstring} ${cstring} ${rstring}"
	done
}

lemonbar_loop "$@"
