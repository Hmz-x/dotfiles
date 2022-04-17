#!/bin/sh

# source files
shellrc="$HOME/.bashrc"
[ -r "$shellrc" ] && . "$shellrc"

# start graphical server
[ -z "$DISPLAY" ] && startx
