#!/bin/sh

# Constants
SESH="default" # default session

{ [ -n "$1" ] && dir="$1"; } || dir="$HOME"
{ [ -n "$EDITOR" ] && editor="$EDITOR"; } || editor="vim"

wbi=0 # window base index
pbi=0 # pane base index

# If session exists, attach to it and finally quit.
tmux has-session -t "$SESH" && tmux attach -t "$SESH" && exit 0

# If not, create new session in the background.
tmux new-session -s "$SESH" -n editor -d # Name the first window "editor"
# Name the second "manager", the third "music"
tmux new-window -t "$SESH" -n manager 
tmux new-window -t "$SESH" -n music 
# Create a new horizontal pane for the first window.
tmux split-window -v -p 20 -t "$SESH":$wbi

# For all panes, cd into $dir and then clear.
tmux send-keys -t "$SESH":$wbi.$pbi "cd $dir; clear" C-m
tmux send-keys -t "$SESH":$wbi.$((pbi+1)) "cd $dir; clear" C-m
# In "manager" window, launch file manager
tmux send-keys -t "$SESH":$((wbi+1)) "cd $dir; clear; $FILE_MAN" C-m
# In "music" window, launch music player
tmux send-keys -t "$SESH":$((wbi+2)) "cd $dir; clear; $MUS_PLAYER" C-m

# Select the starting window and attach session
tmux select-window -t "$SESH":$((wbi+2))
tmux attach -t "$SESH"
