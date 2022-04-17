#!/bin/sh

# source files
shellrc="$HOME/.bashrc"
[ -r "$shellrc" ] && . "$shellrc"

# start graphical server
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
	startx
fi
