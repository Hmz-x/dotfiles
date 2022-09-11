#!/bin/sh

if [ -z "$1" ]; then
	echo "No username given. Exitting."
	exit 1
fi

user="$1"

# Program constant
chmod_val=755

# Create directories
while read -r line; do
	dir="/home/${user}/${line}"
	[ ! -d "$dir" ] && install -d --owner="$user" --group="$user" --mode=$chmod_val "$dir"
done < ./directories.txt

# Bash stuff 
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	./bash/.bashrc "/home/${user}/"
install --compare -D --owner=root --group=root --mode=700 \
	./bash/.bashrc /root
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	./bash/.bash_profile "/home/${user}/"

# X stuff
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	./X/.xinitrc "/home/${user}/"
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	./X/.Xresources "/home/${user}/"

# WM, System, & Misc stuff
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	./WM/* "/home/${user}/.local/bin/WM"
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	./misc/* "/home/${user}/.local/bin/misc"
install --compare -D --owner="$user" --group="$user" --mode=$chmod_val \
	./system/* "/home/${user}/.local/bin/system"
