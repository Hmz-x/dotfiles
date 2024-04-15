#!/bin/bash

# Start notification daemon fnott
pgrep fnott || fnott &

# location to determine blue / red light
LOCATION="west-lafayette"

if [ "$LOCATION" = "west-lafayette" ]; then
	lat=40.4
	long=-86.9
elif [ "$LOCATION" = "istanbul" ]; then
	lat=41
	long=28.6
else
	# Set NYC as fallback 
	lat=40.7
	long=-73.9
fi

# wayland stuff here
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
	pgrep wlsunset || wlsunset -l $lat -L $long &
fi

# Run polkit agent in background
pgrep -f wlsunset || /usr/lib/polkit-kde-authentication-agent-1 &
