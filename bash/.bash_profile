#!/bin/sh

src_or_err()
{
	file="$1"
	. "$file" || echo "Failed to source ${file}." 2>&1
}

# source envvars rc
envvars_rc="${HOME}/.local/bin/system/envvars.sh"
src_or_err "$envvars_rc"

# source shell rc
shell_rc="${HOME}/.bashrc"
src_or_err "$shell_rc"

# start graphical server
[ -z "$DISPLAY" ] && startx
