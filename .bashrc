#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Environment Variables
export PS1='\[\033[0;0m\][\u:\w]\$ '
export EDITOR='vim'
export VISUAL='vim'
export USB='/mnt/usb'

# Aliases
#alias pa='pactl set-sink-volume @DEFAULT_SINK@ 110%'
alias sd='loginctl poweroff'
alias v='vim'
alias c='clear'
alias e='exit'
alias pt='pkill tmux'
alias pi='ssh pi@192.168.1.119'
alias br='xrandr --output LVDS-1 --brightness 0.7'

# Workflow
set -o vi
wm="bspwm"
if res="$(pgrep -x "$wm")" && [ -n "$res" ]; then
	xrdb .Xresources
	[ -z "$TMUX" ] && tmux.sh && exit 0 
fi

# Functions
rs()
{
	count="$(echo "$1" | grep [[:digit:]])"
	[ -z "$count" ] && count=2
	for ((i=0; i<"$count"; i++)); do
		redshift -O 5000
	done
}

#transmissions torrent stuff
t-daemon()
{
	sudo rc-service transmission start
	transmission-daemon
}

t-show()
{
	transmission-remote -l
}

t-add()
{
	transmission-remote -a "$1"
}

t-remove()
{
	transmission-remote -t "$1" --remove
}

t-purge()
{
	transmission-remote -t "$1" --remove-and-delete
}

ss()
{
	import -window root "$1"
}

t-mv()
{
	dir="$1"
	[ ! -d "$dir" ] && dir="$PWD"
	
	sudo mv -v /var/lib/transmission/downloads/ "$dir"
}

#nmcli connection stuff
wcon()
{
	nmcli dev wifi connect "$1" --ask
}

wscan()
{
	nmcli dev wifi 
}

wdel()
{
	nmcli con del "$1"
}

wshow()
{
	nmcli connection show
}
