#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

set -o vi

# General Aliases
alias po='sudo shutdown -h now'
alias rb='sudo reboot'
alias v='vim'
alias p='pacman'
alias c='clear'
alias e='exit'
alias l='less'
alias z='zathura'
alias tb='nc termbin.com 9999'
alias vhc='vim /home/hkm/.config/herbstluftwm/autostart' # vim Hl config
alias cdb='cd "${HOME}/.local/bin"'
alias cdd='cd "${HOME}/.local/dotfiles"'
alias pl='pkill set_lemonbar.sh; pkill lemonbar'
alias ag='aspell -n -c' # aspell groff doc
alias yd='yay --removemake --nocleanmenu --nodiffmenu -S' # yay default install
alias c2s='ssh "${SSH_USER_ENVVAR}@${SSH_SERVER_ENVVAR}"' # connect to server

# copy contents of file to clip
xc()
{
	cat "$1" | xclip
}

# CD into dirname of given file
cd()
{
	{ [ -z "$1" ] && command cd ~; } ||
	{ [ -f "$1" ] && command cd "$(dirname "$1")"; } || 
	command cd "$1"
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
