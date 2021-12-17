#!/bin/sh

{ [ -n "$1" ] && dir="$1"; } || dir="$HOME"
{ [ -n "$EDITOR" ] && editor="$EDITOR"; } || editor="vim"

wbi=0 # window base index
pbi=0 # pane base index
sesh="default" # default session
music_player="cmus"

# If session exists, attach to it and finally quit.
tmux has-session -t "$sesh" && tmux attach -t "$sesh" && exit 0

# If not, create new session in the background.
# Name the first window "editor", name the second window "music"
# Create a new horizontal pane.
tmux new-session -s "$sesh" -n editor -d
tmux new-window -t "$sesh" -n music 
tmux split-window -v -p 10 -t "$sesh":$wbi

# To all panes, cd into $dir and then clear.
# In "music" window, launch music player
tmux send-keys -t "$sesh":$wbi.$pbi "cd $dir; clear" C-m
tmux send-keys -t "$sesh":$wbi.$((pbi+1)) "cd $dir; clear" C-m
tmux send-keys -t "$sesh":$((wbi+1)) "cd $dir; clear; $music_player" C-m

# Select the starting window and attach session
tmux select-window -t "$sesh":$((wbi+1))
tmux attach -t "$sesh"
