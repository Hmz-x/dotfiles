#!/bin/bash

# Start notification daemon fnott
pgrep fnott || fnott &

# Reduce blue light
LOCATION="west-lafayette"

if [ "$LOCATION" = "west-lafayette" ]; then
	lat=40.4
	long=86.9
elif [ "$LOCATION" = "istanbul" ]; then
	lat=41
	long=28.6
else
	# Set NYC as fallback 
	lat=40.7
	long=-73.9
fi

[ "$XDG_SESSION_TYPE" = "wayland" ] && wlsunset -l $lat -L $long &
