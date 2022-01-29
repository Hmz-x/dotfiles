#!/bin/sh

# Program data
cli_sleep_time=".3"
gui_sleep_time="3"

hc(){
	herbstclient "$@"
}

hc use_index 2
# Spawn empty terminal 
"$TERMINAL" &
sleep "$cli_sleep_time"

hc use_index 1
# Spawn terminal with cmus
"$TERMINAL" -e cmus &
sleep "$cli_sleep_time"

hc use_index 0
"$BROWSER" &> /dev/null &
sleep "$gui_sleep_time"
hc use_index 1
