#!/bin/sh

###### MY ENVVARS #######
# Graphical Ennvars
export COMPUTER_TYPE_ENVVAR="LAPTOP"
export DEF_WALLPAPER_ENVVAR="${HOME}/Documents/pics/wallpaper"
export HLWM_TAG_NUM_ENVVAR=5
export FILE_MANAGER_ENVVAR="dolphin"
export BROWSER_ENVVAR="librewolf" 
export WM_ENVVAR="herbstluftwm" 
export IN_STEADY_STR_ENVVAR="POSITIVEONLY!!!"
export IN_SLIDING_STR_ENVVAR="PSYCHEDELIC LEANING"
export ICON_STR_ENVVAR="\\\uf217 \\\uf1de \\\u2b"
export QT_QPA_PLATFORMTHEME="qt5ct"
export TERMINAL_ENVVAR="alacritty"

# export envvars depending on device
if [ "$COMPUTER_TYPE_ENVVAR" = "LAPTOP" ]; then
	:
elif [ "$COMPUTER_TYPE_ENVVAR" = "DESKTOP" ]; then
	:
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
export MPD_HOST="127.0.0.1"
export MPD_PORT="6600"
export OPENER="${HOME}/.local/bin/lf/opener.sh"
export MUSIC_DIR_ENVVAR="${HOME}/Music"
export GITHUB_UNAME_ENVVAR="Hmz-x"
export USB_ENVVAR='/mnt/usb'
export SSH_SERVER_ENVVAR='welcometoelectric.world'
export SSH_USER_ENVVAR='root'
export SSH_DIR_ENVVAR='/var/www/welcometoelectric/'
export WEBDEV_PROJ_ENVVAR='welcometoelectric'
##########################
