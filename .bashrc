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
#TMP
export M1='/home/hkm/Misc/Audio_Media/Headspace/Take Series - Start Here/Take 10'
export M2='/home/hkm/Misc/Audio_Media/downloads/Headspace - Meditation and Mindfulness Made Simple (2018)/Singles/8 - Anxious Moments/'

# Program Environment Variables
export PATH="$PATH:/$HOME/.local/bin"
export EDITOR='vim' # Text Editor
export BROWSER='brave-browser-nightly' # Web Browser
export BROWSER_GEN='brave' # Browser General Name
export YT_CLIENT='freetube' # YouTube Client
export VID_PLAYER='mpv' # Video/Media Player
export MUS_PLAYER='mpc' # Music Player
export FILE_MAN='lf' # File Manager
export TERMINAL='urxvt' # Terminal

# General Aliases
alias sb='source ~/.bashrc'
alias po='loginctl poweroff'
alias rb='loginctl reboot'
alias v='vim'
alias sp='sudo pacman'
alias c='clear'
alias e='exit'
alias z='zathura'
alias l='less'
alias pt='pkill tmux'
alias pi='ssh pi@192.168.1.131'
alias tb='nc termbin.com 9999'
alias vhc='vim /home/hkm/.config/herbstluftwm/autostart' # vim Hl config
alias cdt='cd /home/hkm/CS/tool-references' 
alias cdl='cd "$HOME"/.local/bin'
alias cdd='cd /home/hkm/CS/dotfiles/'
alias ag='aspell -n -c'
alias hc='herbstclient'
alias mp='ncmpcpp'
# TMP
alias d='date'
alias cdm1='cd "$M1"'
alias cdm2='cd "$M2"'

# Workflow
set -o vi

# General Functions
# Call redshift "$1" times
rs()
{
	count="$(echo "$1" | grep [[:digit:]])"
	[ -z "$count" ] && count=2
	for ((i=0; i<"$count"; i++)); do
		redshift -O 5555 -m vidmode
	done
}

# CD into dirname of given file
cd()
{
	{ [ -z "$1" ] && command cd ~; } ||
	{ [ -f "$1" ] && command cd "$(dirname "$1")"; } || 
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
	SSID="$1"
	if nmcli con show | grep -q "$SSID"; then
		nmcli dev wifi connect "$SSID"
	else
		nmcli dev wifi connect "$SSID" --ask
	fi
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

# Ffmpeg stuff
fcon() # ffmpeg convert
{
	in="wav"
	out="mp3"

	for file in *."$in"; do
		new_file="$(echo "$file" | cut -d '_' -f 1).${out}"
		ffmpeg -i "$file" "$new_file" && rm "$file"
	done
}

# Unzip stuff
uzip()
{
	for file in *.zip; do
		unzip "$file" 
		rm "$file"
	done
}

# Convert stuff
con2pdf()
{
	for file in *.jpg; do
		echo "$file"
		convert -auto-orient "$file" "${file}.pdf"
	done

	pdfunite *.pdf "${1}FINAL.pdf"
}
