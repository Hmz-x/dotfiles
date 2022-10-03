#!/bin/sh

LOW_BATTERY_PER=11
VERY_LOW_BATTERY_PER=8

battery_per="$(acpi -b | grep -Ewo '([[:digit:]]){1,3}%' | grep -Ewo '([[:digit:]]){1,3}')"

notify-send.sh "Battery: ${battery_per}%"
((battery_per<LOW_BATTERY_PER)) && notify-send.sh "Battery At Critical Level" && 
	abeep -f 460 -l 300 -r 3 -d 500

if acpi -b | grep -q "Discharging"; then
	if ((battery_per<VERY_LOW_BATTERY_PER)); then 
		notify-send.sh "Battery At Extremely Critical Level" 
		abeep -f 460 -l 300 -r 3 -d 500
		sleep 20

		if ((battery_per<VERY_LOW_BATTERY_PER)); then 
			notify-send.sh "Shutting Down" --action="Cancel":"pkill $0" 
			abeep -f 460 -l 300 -r 3 -d 500
			sleep 10 && sudo poweroff now
		fi
	fi
fi
