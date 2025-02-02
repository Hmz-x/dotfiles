[[ $- != *i* ]] && return

# Default setup
set -o vi

# Source aliases
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

if [ "$(command -v lvim)" ]; then
  alias v='lvim'
else
  alias v='vim'
fi

# X11: copy contents of file to clip
xcpy()
{
	"$@" | xclip -selection clipboard
}

# Wayland: copy contents of file to clip
wcpy()
{
	"$@" | wl-copy
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

# Git stuff
gcr()
{
	# Git clone repo
	git clone "http://github.com/${GITHUB_UNAME_ENVVAR}/${1}"
}

# Unzip stuff
uzip()
{
	for file in *.zip; do
		unzip "$file" && rm -r "$file"
	done
}

# using timeshift backup root partition and save to home partition
tshift()
{
	comments="Clean"
	[ -n "$1" ] && comments="$1"
	home_part="$(mount | grep /home | sed 's/ .*//')"
	root_part="$(mount | grep '/ ' | sed 's/ .*//')"
	
	if [ -b "$root_part" ] && [ -b "$home_part" ]; then 
		sudo timeshift --create --comments "$comments" --target "$root_part" --backup-device "$home_part"
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

# randomly edit images using convert-img.sh
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

# Create tar archive of all the directories in the passed directory
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
  # git Get Last Tag
  if [ -z "$1" ]; then
    echo "Usage: lt TAG" 2>&1
    return
  fi
  git tag | grep "$1" | tail -n 1
}

nt() {
  # git Get Next Tag & Push
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
  if [ -n "$(ls -A /mnt/usb 2>/dev/null)" ]; then
      echo "/mnt/usb is busy, exiting."
      return
  fi

  sudo mount /dev/"$1" /mnt/usb
}

# Launch tmux when in a ssh sesh if not root user
if [ "$UID" -ne 0 ] && [ -n "$SSH_CONNECTION" ] && [ -z "$TMUX" ]; then
        tmux attach || tmux
fi

export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"
[ -n "$(command -v starship)" ] && eval "$(starship init bash)"
