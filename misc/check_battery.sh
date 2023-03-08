#!/bin/sh

MED_LOW_BATTERY_PER=20
LOW_BATTERY_PER=11
VERY_LOW_BATTERY_PER=8

sound_beep()
{
	mpc pause
	pamixer --unmute
	abeep -f 460 -l 300 -r 3 -d $1
}

check_battery()
{
	notify-send.sh "Battery: ${battery_per}%"

	if ((battery_per<MED_LOW_BATTERY_PER)); then
		notify-send.sh "Battery At Low Level"
		sound_beep 800
	fi

	if ((battery_per<LOW_BATTERY_PER)); then
		notify-send.sh "Battery At Critical Level"
		sound_beep 400
	fi

	if ((battery_per<VERY_LOW_BATTERY_PER)); then 
		notify-send.sh "Battery At Extremely Critical Level" 
		sound_beep 200
	fi

	sleep 20
	battery_per=$(acpi -b | grep -Ewo '([[:digit:]]){1,3}%' | grep -Ewo '([[:digit:]]){1,3}')
	((battery_per<MED_LOW_BATTERY_PER)) && echo check && check_battery
}

battery_per=$(acpi -b | grep -Ewo '([[:digit:]]){1,3}%' | grep -Ewo '([[:digit:]]){1,3}')
check_battery
