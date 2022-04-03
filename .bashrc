#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

set -o vi

export USB='/mnt/usb'
export PS1='\[\033[0;0m\][\u:\w]\$ '
export PATH="${PATH}:${HOME}/.local/bin"

# General Aliases
alias po='loginctl poweroff'
alias rb='loginctl reboot'
alias v='vim'
alias p='pacman'
alias c='clear'
alias e='exit'
alias tb='nc termbin.com 9999'
alias vhc='vim /home/hkm/.config/herbstluftwm/autostart' # vim Hl config
alias cdb='cd "${HOME}/.local/bin"'
alias cdd='cd "${HOME}/.local/dotfiles"'
alias pl='pkill set_lemonbar.sh; pkill lemonbar'

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
	nmcli dev wifi connect "$1" --ask
}

alias wscan='nmcli dev wifi'

wdel()
{
	nmcli con del "$1"
}

alias wshow='nmcli connection show'

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
		unzip "$file" && rm -r "$file"
	done
}

# Convert stuff
con2pdf()
{
	for file in *.jpg; do
		echo "$file"
		convert -scale 1920x1080 -auto-orient "$file" "${file}.pdf"
	done

	pdfunite *.pdf "${1}FINAL.pdf"
	rm -v *.jpg.pdf
}
