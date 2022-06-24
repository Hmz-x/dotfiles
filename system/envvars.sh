#!/bin/sh

###### MY ENVVARS #######
# Graphical Ennvars
export COMPUTER_TYPE_ENVVAR="LAPTOP"
export DEF_WALLPAPER_ENVVAR="${HOME}/Documents/pics/propr.jpg"
export HLWM_TAG_NUM_ENVVAR=4
export YT_CLIENT_ENVVAR="freetube" 
export BROWSER_ENVVAR="brave" 
export WM_ENVVAR="herbstluftwm" 
export IN_STEADY_STR_ENVVAR="INPUT STEADY"
export IN_SLIDING_STR_ENVVAR="INPUT SLIDING"
export ICON_STR_ENVVAR="\\\uf644"

# export envvars depending on device
if [ "$COMPUTER_TYPE_ENVVAR" = "LAPTOP" ]; then
	export TERMINAL_ENVVAR="urxvt"
elif [ "$COMPUTER_TYPE_ENVVAR" = "DESKTOP" ]; then
	export TERMINAL_ENVVAR="${HOME}/.local/kitty.app/bin/kitty"
fi
##########################

###### SYS ENVVARS #######
export EDITOR="vim"
export VISUAL="vim"
export PS1='\[\033[0;0m\][\u:\w]\$ '
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="${PATH}:${HOME}/.local/bin/WM"
export PATH="${PATH}:${HOME}/.local/bin/misc"
export PATH="${PATH}:${HOME}/.local/bin/lf"
export PATH="${PATH}:${HOME}/.local/bin/system"
export OPENER="${HOME}/.local/bin/lf/opener.sh"
export MUSIC_DIR_ENVVAR="${HOME}/Music"
export GITHUB_UNAME_ENVVAR="Hmz-x"
export USB_ENVVAR='/mnt/usb'
export SSH_SERVER_ENVVAR='welcometoelectric.world'
export SSH_USER_ENVVAR='root'
export SSH_DIR_ENVVAR='/var/www/welcometoelectric/'
export WEBDEV_PROJ_ENVVAR='welcometoelectric'
##########################
