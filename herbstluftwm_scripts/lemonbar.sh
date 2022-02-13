#!/bin/sh

get_acpi_info()
{
	charging_percentage="$(acpi | cut -d ' ' -f 4 | cut -b -3)"
	charging_status="$(acpi | cut -d ' ' -f 3 | cut -d ',' -f 1)"
	printf -- "%s\n" "${charging_status} ${charging_percentage}"
}

get_nmcli_info()
{
	con_line="$(nmcli device | awk 'NR==2')"
	read output_string <<< "$con_line"
	echo $output_string
}

get_mpc_info()
{
	vol="$(mpc status '%volume%')"
	song="$(mpc current)"
	songpos="$(mpc status '%songpos%')"
	pl_length="$(mpc status '%length%')"

	printf -- "%s\n" "mpc volume:${vol} ${song} (${songpos}/${pl_length})"
}

while true; do
	sleep_time=1
	sleep $sleep_time

	lstring="%{l} $(get_nmcli_info)"
	cstring="%{c} PA volume: $(pamixer --get-volume) | $(get_mpc_info)"
	rstring="%{r} $(get_acpi_info) | $(date '+%c')"
	
	printf -- "%s\n" "${lstring} ${cstring} ${rstring}"
done
