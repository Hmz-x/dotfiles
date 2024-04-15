#!/bin/sh

if [ -z "$1" ]; then
	echo "No username given. Exitting."
	exit 1
fi

user="$1"
HOME="/home/${user}"

# Program constant
chmod_val=755
dotfiles_dir="${HOME}/.local/dotfiles"
cpu_arch="$(uname -m)"

# Create directories
while read -r line; do
	eval dir="$line" 
	[ ! -d "$dir" ] && install -d --owner="$user" --group="$user" --mode=$chmod_val "$dir"
done < "$dotfiles_dir/directories.txt"

# Bash stuff 
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/bash/.bashrc" "$HOME"
install --compare -D --owner=root --group=root --mode=700 \
	"$dotfiles_dir/bash/.bashrc" /root/
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/bash/.bash_profile" "$HOME"

# Vim stuff
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/vim/.vimrc" "$HOME"

# X stuff
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/X/.xinitrc" "$HOME"
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/X/.Xresources" "$HOME"

# WM, System, & Misc stuff
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/WM/"* "${HOME}/.local/bin/WM/"
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/misc/"* "${HOME}/.local/bin/misc/"
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/system/"* "${HOME}/.local/bin/system/"

# Etc stuff
install --compare -D --owner=root --group=root --mode=644 \
	"$dotfiles_dir/etc/"* /etc/

# Herbstluftwm stuff
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/herbstluftwm/autostart" "${HOME}/.config/herbstluftwm/"

# mpd stuff
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/mpd/mpd.conf" "${HOME}/.config/mpd/"

# openvpn stuff
install --compare -D --owner=root --group=root --mode=644 \
	"$dotfiles_dir/openvpn/"* "${HOME}/.config/openvpn/"

# Dbus stuff
install --compare -D --owner=root --group=root --mode=644 \
	"$dotfiles_dir/dbus/"* /usr/share/dbus-1/services/

# Polybar
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/polybar/config.ini" "${HOME}/.config/polybar"
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/polybar/launch.sh" "${HOME}/.config/polybar"

# Qtile
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/qtile/"* "${HOME}/.config/qtile/"

# Alacritty
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/alacritty/alacritty.toml" "${HOME}/.config/alacritty"

# Ly
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/ly/config.ini" /etc/ly/

# starship
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/starship/starship.toml" "$HOME/.config/"

# mpv
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	"$dotfiles_dir/mpv/mpv.conf" "$HOME/.config/mpv"

# pacman
[ "$cpu_arch" = "x86_64" ] && pacman_file="$dotfiles_dir/pacman/arch-x64_pacman.conf"
[ "$cpu_arch" = "aarch64" ] && pacman_file="$dotfiles_dir/pacman/arch-arm_pacman.conf"
install --compare -D --owner=root --group=root --mode=644 \
	"$pacman_file" "/etc/pacman.conf"
