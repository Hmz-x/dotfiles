#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Default setup
set -o vi
export PS1='\[\033[0;0m\][\u:\w]\$ '
export EDITOR='lvim'
export VISUAL='lvim'
export BROWSER='firefox'

# General Aliases
alias md='xrandr --output HDMI-1 --same-as eDP-1' # mirror display on X
alias sd='spotdl'
alias c='clear'
alias e='exit'
alias l='less'
alias z='zathura'
alias tb='nc termbin.com 9999'
alias vet='sudo vim /etc/hosts'
alias cdb='builtin cd "${HOME}/.local/bin"'
alias cdd='builtin cd "${HOME}/.local/dotfiles"'
alias ag='aspell -n -c' # aspell groff doc
alias yni='yay --removemake --cleanmenu=false --noconfirm -S' # yay non-interactive install
alias doc2pdf='soffice --headless --convert-to pdf'
alias vqc='lvim "${HOME}/.config/qtile/config.py"' # vim qtile config
alias cql='cat "${HOME}/.local/share/qtile/qtile.log"' # cat qtile log
alias rqc='qtile cmd-obj -o cmd -f reload_config' # reload qtile config
alias c2s='ssh "${SSH_USER_ENVVAR}@${SSH_SERVER_ENVVAR}"' # connect to server
alias ls="ls --color=auto"
alias rnm='sudo systemctl restart NetworkManager'

if [ "$(command -v lvim)" ]; then
  alias v='lvim'
else
  alias v='vim'
fi

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
	GITHUB_UNAME_ENVVAR="Hmz-x"
	git clone "http://github.com/${GITHUB_UNAME_ENVVAR}/${1}"
}

alias ga='git add'
alias gc='git commit -m'
alias gp='git push -u origin master'
alias gs='git status'
alias gl='git log'
alias gr='git rm'

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
	input="$1" # input file	
	member="$2"
	
	[ $# -lt 2 ] && echo "usage: sendsrv \$input \$member" && return 1

	user="hkm"
	srv="128.210.6.108"
	img_dir="/var/www/cutemafia/public_html/img/$member"
	html_file="/var/www/cutemafia/public_html/${member}.html"
	
	# Get file perms, if not 644, chmod to 644
	file_perms="$(stat -c "%a %n" "$input" | cut -d ' ' -f 1)"	
	[ $file_perms -eq 644 ] || chmod 644 "$input"
	scp "$input" "$user@$srv:$img_dir"
	ssh "$user@$srv" "sed -i -e '/<\/h1>/a \        <img src=\"img/$member/$input\">' $html_file"
}

random-edit()
{
	for file in "$@"; do
		input="$file"
		ext="$(echo "$input" | rev | cut -d '.' -f 1 | rev)"
		without_ext="$(chext.sh "$input")"
		for i in $(seq 1 25); do 
			#echo "in $input out ${without_ext}-${i}"
			~/.local/bin/convert-img/convert-img.sh -i "$input" \
				-r -o "${without_ext}-${i}.${ext}"
		done
	done
}

showimg()
{
	input="$1"
	img="$(convert-img.sh -i "$input" -r)" && echo "$img"
	sxiv "$img"

	[ -n "$2" ] && mv "$img" "$2"
}

gettar()
{
  [ ! -d "$1" ] && echo "usage: gettar DIR" && return 1

  dir="${1%/}"
  echo "$dir"

	for file in "${dir}/"*; do 
    # Only get tar of directories
    [ ! -d "$file" ] && continue

    file="$(basename "$file")"
    tar -czvf "${dir}/${file}.tar.gz" -C "$dir" "${dir}/${file}"
	done
}

f3d()
{
  figlet -f /usr/share/figlet/fonts/larry3d.flf "$@" | \
    lolcat -a -d 10 -s 100
}

fgoth()
{
  figlet -f /usr/share/figlet/fonts/gothic__.flf "$@" | \
    lolcat -a -d 10 -s 100
}

lt()
{
  if [ -z "$1" ]; then
    echo "Usage: lt TAG" 2>&1
    return
  fi
  git tag | grep "$1" | tail -n 1
}

nt() {
  if [ -z "$1" ]; then
    echo "Usage: nt <tag-name>"
    return 1
  fi

  tag_name="$1"
  
  # Find the latest tag related to the given tag name
  last_tag=$(git tag | grep -E "^v[0-9]+\.[0-9]+\.[0-9]+(-${tag_name})?$" | grep "${tag_name}" | sort -V | tail -n 1)
  
  if [ -z "$last_tag" ]; then
    # If no related tag exists, start with v0.0.1
    new_tag="v0.0.1-${tag_name}"
  else
    # Extract the version number (vn.n.n)
    version=$(echo "$last_tag" | grep -oE "v[0-9]+\.[0-9]+\.[0-9]+")
    
    # Increment the patch version
    major=$(echo "$version" | cut -d '.' -f 1 | cut -c 2-)
    minor=$(echo "$version" | cut -d '.' -f 2)
    patch=$(echo "$version" | cut -d '.' -f 3)
    new_patch=$((patch + 1))
    
    # Construct the new tag
    new_tag="v${major}.${minor}.${new_patch}-${tag_name}"
  fi

  git tag "$new_tag"
  echo "New tag: $new_tag"

  git push origin "$new_tag"
}

mnt()
{
  if [ -f /mnt/usb/* ]; then
    echo /mnt/usb is busy exiting.
    return
  fi
  sudo mount /dev/"$1" /mnt/usb
}

umnt()
{
  sudo umount /mnt/usb
}

# Launch tmux when in a ssh sesh if not root user
if [ "$UID" -ne 0 ] && [ -n "$SSH_CONNECTION" ] && [ -z "$TMUX" ]; then
        tmux attach || tmux
fi

# Move tar extracted jdk package to /usr/lib/jvm and add to PATH
#export JAVA_HOME="/usr/lib/jvm/jdk-21.0.2"
#export PATH="$JAVA_HOME/bin:$PATH"
# Append to history after each command and reload
export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

[ -n "$(command -v starship)" ] && eval "$(starship init bash)"
