#!/bin/sh

# Load Xresources
xrdb .Xresources

# Start Pulseadio daemon
pulseaudio -D

# Start mpd
mpd --verbose &> /dev/null

# Mute pulseaudio when entering X
pamixer --mute

# Set default brightness 
adj_brightnessrc_file="${HOME}/.config/.adjust_brightnessrc"
def_brightness_val=10 # Aka max_brightness_val
printf 'export brightness_envvar=%s' $def_brightness_val > "$adj_brightnessrc_file"

# Set default redshift
adj_redshiftrc_file="${HOME}/.config/.adjust_redshiftrc"
def_redshift_val=0 # Aka min_redshift_val
printf 'export redshift_envvar=%s' $def_redshift_val > "$adj_redshiftrc_file"

###### Xrandr Envvars ###### 
# Set X output monitor envvar
monitor_out_str="$(xrandr --listactivemonitors | awk 'NR==2')"
monitor_out_str_space_count="$(echo "$monitor_out_str" | grep -o '[[:space:]]' | wc -l)"
export X_MONITOR_OUTPUT_ENVVAR="$(echo "$monitor_out_str" | \
	cut -d ' ' -f $((monitor_out_str_space_count+1)))"

# Set monitor resolution envvars
monitor_res_str="$(xrandr | grep "$X_MONITOR_OUTPUT_ENVVAR" | cut -d ' ' -f 4 | \
	cut -d '+' -f 1)"
export X_MONITOR_X_RES_ENVVAR="$(echo "$monitor_res_str" | cut -d 'x' -f 1)"
export X_MONITOR_Y_RES_ENVVAR="$(echo "$monitor_res_str" | cut -d 'x' -f 2)"
###########################

exec "$WM_ENVVAR"
