#!/bin/sh

[ -z "$1" ] && exit 1

dot_count="$(echo "$1" | grep -Fo '.' | wc -l)"
without_ext="$(echo "$1" | cut -d '.' -f -$dot_count)"

if [ -n "$2" ]; then
	echo "${without_ext}.${2}"
else
	echo "$without_ext"
fi
