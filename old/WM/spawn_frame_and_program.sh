#!/bin/sh

# Create a new horizontal or vertical frame (based on argument), focus on frame, and then spawn
# the given program. Arg 2 = split direction, Arg 1 = executable to spawn

# If there are no frames open, no need to split frames, just exec $1.
#[ "$(herbstclient layout | grep -q '0x')" || herbstclient spawn "$1" ]

herbstclient fullscreen off

[ "$2" != "vertical" ] && herbstclient split horizontal && herbstclient focus right
[ "$2" = "vertical" ] && herbstclient split vertical && herbstclient focus down
exec "$1"
