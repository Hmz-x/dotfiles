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

while true; do
	sleep_time=1
	sleep $sleep_time

	lstring="%{l} $(get_nmcli_info)"
	cstring="%{c} Volume: $(pamixer --get-volume) | $(get_acpi_info)"
	rstring="%{r} $(date '+%c')"
	
	printf -- "%s\n" "${lstring} ${cstring} ${rstring}"
done
