#!/bin/sh

# Switch to last monitor, launch terminal and execute calcurse

# If a calcurse instance is already running, just exit
[ -n "$(pgrep -x calcurse)" ] && exit 0

herbstclient use $HLWM_TAG_NUM_ENVVAR
herbstclient spawn "$TERMINAL_ENVVAR" -e calcurse
