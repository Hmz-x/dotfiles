#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# alias ls='ls --color=auto'

# Environment Variables
export PS1='\[\033[0;0m\][\u:\w]\$ '
export EDITOR='vim'
export VISUAL='vim'

# Aliases
alias sd='shutdown now'
alias v='vim'
alias c='clear'
alias e='exit'
alias pt='pkill tmux'
alias ds='sudo nmcli dev status'

# Workflow
set -o vi
wm="bspwm"
if res="$(pgrep -x "$wm")" && [ -n "$res" ]; then
	xrdb .Xresources
	[ -z "$TMUX" ] && tmux.sh && exit 0 
fi
