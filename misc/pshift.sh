#!/bin/bash

if [ "$2" = "stdout" ]; then
	soundstretch "$1" "$2" -r=$(($3*5))% | mpv -
else
	soundstretch "$1" "$2" -r=$(($3*5))%
fi
