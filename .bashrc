#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# General Environment Variables
export PS1='\[\033[0;0m\][\u:\w]\$ '
export VISUAL='vim'
export USB='/mnt/usb'
export BOOK='/home/hkm/Documents/pdf/UNIX_Admin_Handbook.pdf'

# Program Environment Variables
export EDITOR='vim' # Text Editor
export BROWSER='brave-browser-nightly' # Web Browser
export BROWSER_GEN='brave' # Browser General Name
export YT_CLIENT='freetube' # YouTube Client
export VID_PLAYER='mpv' # Video/Media Player
export MUS_PLAYER='cmus' # Music Player
export FILE_MAN='lf' # File Manager
export TERMINAL='urxvt' # Terminal

# General Aliases
alias po='loginctl poweroff'
alias rb='loginctl reboot'
alias v='vim'
alias p='pacman'
alias c='clear'
alias e='exit'
alias pt='pkill tmux'
alias pi='ssh pi@192.168.1.119'
alias br='xrandr --output LVDS-1 --brightness 0.7'
alias z='zathura "$BOOK" &'
alias tb='nc termbin.com 9999'
alias vhc='vim .config/herbstluftwm/autostart' # vim Hl config
alias cdt='cd ~/CS/tool-references' 
alias d='date'

# Workflow
set -o vi
if res="$(pgrep -x "$WM")" && [ -n "$res" ]; then
	xrdb .Xresources
	#[ -z "$TMUX" ] && tmux.sh && exit 
fi

# General Functions
# Call redshift "$1" times
rs()
{
	count="$(echo "$1" | grep [[:digit:]])"
	[ -z "$count" ] && count=2
	for ((i=0; i<"$count"; i++)); do
		redshift -O 5000
	done
}

# CD into dirname of given file
cd()
{
	{ [ -z "$1" ] && command cd ~; } ||
	{ [ -f "$1" ] && command cd "$(dirname $1)"; } || 
	command cd "$1"
}

# Transmissions torrent stuff
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

t-stop()
{
	transmission-remote -t "$1" --stop
}

t-start()
{
	transmission-remote -t "$1" --start
}

t-mv()
{
	dir="$1"
	[ ! -d "$dir" ] && dir="$PWD"
	
	sudo mv -v /var/lib/transmission/downloads/ "$dir"
}

# Nmcli connection stuff
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

# Git stuff
ga()
{
	git add "$@"
}

gc()
{
	git commit -m "$@"
}

gp()
{
	git push -u origin master
}

gs()
{
	git status
}

gl()
{
	git log
}

gr()
{
	git rm "$@"
}

# Mount stuff
mnt()
{
	sudo mount /dev/"$1" "$USB"
}

umnt()
{
	sudo umount "$USB"
}

mnt-mv()
{
	df -h "$USB"

	mkdir "$1" && 
	sudo mv -v "$USB"/* "$1" &&

	du -h "$1" && 
	df -h "$USB" && 

	umnt
}

mnt-cp()
{
	df -h "$USB"

	mkdir "$1" && 
	sudo cp -vr "$USB"/* "$1" &&

	du -h "$1" && 
	df -h "$USB" &&
	
	umnt
}

# Diff stuff
t-diff()
{
	diff <(tree "$1") <(tree "$2") | less
}
