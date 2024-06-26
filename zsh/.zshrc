#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Default setup
set -o vi
export PS1='\[\033[0;0m\][\u:\w]\$ '

# General Aliases
alias sd='spotdl'
alias v='vim'
alias p='pacman'
alias c='clear'
alias e='exit'
alias l='less'
alias z='zathura'
alias tb='nc termbin.com 9999'
alias vhc='vim "${HOME}/.config/herbstluftwm/autostart"' # vim Hl config
alias vet='vim /etc/hosts'
alias cdb='builtin cd "${HOME}/.local/bin"'
alias cdd='builtin cd "${HOME}/.local/dotfiles"'
alias pl='pkill set_lemonbar.sh; pkill lemonbar'
alias ag='aspell -n -c' # aspell groff doc
alias yd='yay --removemake --nocleanmenu --nodiffmenu -S' # yay default install
alias c2s='ssh "${SSH_USER_ENVVAR}@${SSH_SERVER_ENVVAR}"' # connect to server
alias doc2pdf='soffice --headless --convert-to pdf'
alias vqc='vim "${HOME}/.config/qtile/config.py"' # vim qtile config
alias cql='cat "${HOME}/.local/share/qtile/qtile.log"' # cat qtile log
alias rqc='qtile cmd-obj -o cmd -f reload_config' # reload qtile config
alias ls="ls --color=auto"

# scp to server
s2s()
{
	scp "$@" "${SSH_USER_ENVVAR}@${SSH_SERVER_ENVVAR}:${SSH_DIR_ENVVAR}"
}

# copy contents of file to clip
xc()
{
	cat "$1" | xclip
}

# cd into dirname of given file
cd()
{
	{ [ -z "$1" ] && builtin cd ~; } ||
	{ [ -f "$1" ] && builtin cd "$(dirname "$1")"; } || 
	builtin cd "$1"
}

# Nmcli connection stuff
wcon()
{
	ssid="$1"

	if nmcli con show | grep -q "$ssid"; then
		nmcli dev wifi connect "$ssid"
	else
		nmcli dev wifi connect "$ssid" --ask
	fi
}

alias wscan='nmcli dev wifi'
alias wdel='nmcli con del'
alias wshow='nmcli connection show'

# Git stuff
gcr()
{
	# Git clone repo
	[ -n "$2" ] && GITHUB_UNAME_ENVVAR="$2"
	git clone "http://github.com/${GITHUB_UNAME_ENVVAR}/${1}"
}

alias ga='git add'
alias gc='git commit -m'
alias gp='git push -u origin master'
alias gs='git status'
alias gl='git log'
alias gr='git rm'

# Mount stuff
mnt()
{
	sudo mount /dev/"$1" "$USB_ENVVAR"
}

umnt()
{
	sudo umount "$USB_ENVVAR"
}

mnt-mv()
{
	df -h "$USB_ENVVAR"

	mkdir "$1" && 
	sudo mv -v "$USB_ENVVAR"/* "$1" &&

	du -h "$1" && 
	df -h "$USB_ENVVAR" && 

	umnt
}

mnt-cp()
{
	df -h "$USB_ENVVAR"

	mkdir "$1" && 
	sudo cp -vr "$USB_ENVVAR"/* "$1" &&

	du -h "$1" && 
	df -h "$USB_ENVVAR" &&
	
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

	[ -n "$1" ] && in="$1"
	[ -n "$2" ] && out="$2"

	for file in *."$in"; do
		new_file="$(chext.sh "$file" "$out")"
		ffmpeg -i "$file" "$new_file" && rm "$file"
	done
}

# Unzip stuff
uzip()
{
	for file in *.zip; do
		unzip "$file" && rm -r "$file"
	done
}

# Convert stuff
con2pdf()
{
	for file in *.jpg *.png; do
		echo "$file"
		convert -scale 1920x1080 -auto-orient "$file" "${file}.pdf"
	done

	pdfunite *.pdf "${1}FINAL.pdf"
	rm -v *.jpg.pdf
}

ocon()
{
	sudo openconnect --protocol=anyconnect --user=hmumcu --server=webvpn2.purdue.edu
}

# Push ~/Music to mobile music dir via adb
sync_mus()
{
	adbsync_exec="$HOME/.local/bin/better-adb-sync/src/adbsync.py"
	mob_music_dir="storage/self/primary/Music"
	$adbsync_exec push "$HOME/Music/." "$mob_music_dir"
}

# using timeshift backup root partition and save to home partition
tshift()
{
	comments="Clean"
	[ -n "$1" ] && comments="$1"
	home_part="$(mount | grep /home | sed 's/ .*//')"
	root_part="$(mount | grep '/ ' | sed 's/ .*//')"
	
	if [ -b "$root_part" ] && [ -b "$home_part" ]; then 
		sudo timeshift --create --comments "$comments" --target $root_part --backup-device $home_part	
	else
		echo "Error: the correct root or home partitions are not configured."
	fi			
}

# connect to openvpn using the given config file
ovpn()
{
	config_file="/${HOME}/.config/openvpn/CIT-Knoy-TCP4-443-config.ovpn"
	sudo /sbin/openvpn "$config_file"
}

sendsrv()
{
	# Send to server
	user="hamza"
	srv="128.210.6.108"
	dir="/var/www/html/cutemafia.org/public_html/img"
	
	scp "$1" "$user@$srv:$dir"
}

showimg()
{
	input="$1"
	img="$(./convert-img.sh -i "$input" -r)" && echo "$img"
	sxiv "$img"

	[ -n "$2" ] && mv "$img" "$2"
}

[ -n "$(command -v starship)" ] && eval "$(starship init zsh)"
