#!/bin/sh

source_readable()
{
	file="$1"
	[ -r "$file" ] && . "$file"
}


# source envvars rc
envvars_rc="${HOME}/.local/bin/envvars.sh"
source_readable "$envvars_rc"

# source shell rc
shell_rc="${HOME}/.bashrc"
source_readable "$shell_rc"

# start graphical server
[ -z "$DISPLAY" ] && startx
