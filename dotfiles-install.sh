#!/bin/sh

if [ -z "$1" ]; then
	echo "No username given. Exitting."
	exit 1
fi

user="$1"

# Program constant
chmod_val=755
dotfiles_dir="/home/${user}/.local/dotfiles"

# Create directories
while read -r line; do
	dir="/home/${user}/${line}"
	[ ! -d "$dir" ] && install -d --owner="$user" --group="$user" --mode=$chmod_val "$dir"
done < "$dotfiles_dir/directories.txt"

# Bash stuff 
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/bash/.bashrc" "/home/${user}/"
install --compare -D --owner=root --group=root --mode=700 \
	"$dotfiles_dir/bash/.bashrc" /root/
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/bash/.bash_profile" "/home/${user}/"

# Vim stuff
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/vim/.vimrc" "/home/${user}/"

# X stuff
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/X/.xinitrc" "/home/${user}/"
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/X/.Xresources" "/home/${user}/"

# WM, System, & Misc stuff
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/WM/"* "/home/${user}/.local/bin/WM/"
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/misc/"* "/home/${user}/.local/bin/misc/"
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/system/"* "/home/${user}/.local/bin/system/"

# Etc stuff
install --compare -D --owner=root --group=root --mode=644 \
	"$dotfiles_dir/etc/"* /etc/

# Herbstluftwm stuff
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/herbstluftwm/autostart" "/home/${user}/.config/herbstluftwm/"

# mpd stuff
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/mpd/mpd.conf" "/home/${user}/.config/mpd/"
