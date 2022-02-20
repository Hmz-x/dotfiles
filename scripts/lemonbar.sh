#!/bin/sh

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
	if [ "X$1" = 'X--ttf-font-awesome' ]; then
		state_status="$(mpc status '%state%')"
		[ "$state_status" = "playing" ] && state_icon="\\uf001"
		[ "$state_status" = "paused" ] && state_icon="\\uf05e"

	fi	

	echo "mpc volume:${vol} ${song} (${songpos}/${pl_length}) " \
		"(${random_status_letter}${single_status_letter}${repeat_status_letter}) " \
		"${state_icon}"
}

get_hlwm_info()
{
	#printf -- "%s\n" "$hlwm_tag_envvar"
	:
}

while true; do
	sleep_time='0.2'
	sleep $sleep_time

	lstring="%{l} $(get_hlwm_info) | $(get_nmcli_info)"
	cstring="%{c} PA volume: $(pamixer --get-volume) | $(get_mpc_info "$1")"
	rstring="%{r} $(get_acpi_info) | $(date '+%c')"
	
	echo -e "${lstring} ${cstring} ${rstring}"
done
