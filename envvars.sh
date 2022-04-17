#!/bin/sh

###### MY ENVVARS #######
# Graphical Ennvars
export YT_CLIENT_ENVVAR="freetube" 
export BROWSER_ENVVAR="brave" 
export TERMINAL_ENVVAR="urxvt"
export WM_ENVVAR="herbstluftwm" 

# Place the following in .xinitrc
#monitor_out_str="$(xrandr --listactivemonitors | awk 'NR==2')"
#monitor_out_str_space_count="$(echo "$monitor_out_str" | grep -o '[[:space:]]' | wc -l)"
#export X_MONITOR_OUTPUT_ENVVAR="$(echo "$monitor_out_str" | \
	#cut -d ' ' -f $((monitor_out_str_space_count+1)))"

export MUSIC_DIR_ENVVAR="${HOME}/Music"
export COMPUTER_TYPE_ENVVAR="LAPTOP"
export GITHUB_UNAME_ENVVAR="Hmz-x"
export USB='/mnt/usb'
##########################

###### SYS ENVVARS #######
export EDITOR="vim"
export VISUAL="vim"
export PS1='\[\033[0;0m\][\u:\w]\$ '
export PATH="${PATH}:${HOME}/.local/bin"
export OPENER="${HOME}/.local/bin/opener.sh"
##########################

####### MISC ENVVARS ###### 
#export NTP_CLIENT_ENVVAR="ntpctl"
#export STATUS_BAR_ENVVAR="lemonbar"
#export STATUS_BAR_SETTER_ENVVAR="set_lemonbar.sh"
##########################
