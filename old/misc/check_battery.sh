#!/bin/sh

MED_LOW_BATTERY_PER=20
LOW_BATTERY_PER=11
VERY_LOW_BATTERY_PER=8

NOTI_CLIENT="notify-send"
ICON="/home/${USER}/Documents/pics/Metro Zu Art/lofty_gooned_out.png"


sound_beep()
{
	mpc pause
	pamixer --unmute
	sleep 0.5
	abeep -f 460 -l 300 -r 3 -d $1
}

check_battery()
{
	"$NOTI_CLIENT" -i "$ICON" -u low -t 4500 "Battery: ${battery_per}%"
	sleep_secs=30

	if ((battery_per<MED_LOW_BATTERY_PER)); then
		"$NOTI_CLIENT" -i "$ICON" -u low -t 4500 "Battery At Low Level"
		sound_beep 800
		sleep_secs=120
	fi

	if ((battery_per<LOW_BATTERY_PER)); then
		"$NOTI_CLIENT" -i "$ICON" -u low -t "Battery At Critical Level"
		sound_beep 400
	fi

	if ((battery_per<VERY_LOW_BATTERY_PER)); then 
		"$NOTI_CLIENT" -i "$ICON" -u low -t "Battery At Extremely Critical Level" 
		sound_beep 200
	fi

	((battery_per>MED_LOW_BATTERY_PER)) && exit

	sleep $sleep_secs
	battery_per=$(acpi -b | grep -Ewo '([[:digit:]]){1,3}%' | grep -Ewo '([[:digit:]]){1,3}')
	((battery_per<MED_LOW_BATTERY_PER)) && check_battery
}

battery_per=$(acpi -b | grep -Ewo '([[:digit:]]){1,3}%' | grep -Ewo '([[:digit:]]){1,3}')
check_battery
