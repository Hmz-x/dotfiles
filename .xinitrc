# Load Xresources
xrdb .Xresources

# Start Pulseadio daemon
pulseaudio -D

# Start mpd
#sudo rc-service mpd start
mpd --verbose &> /dev/null

# Set default brightness 
adj_brightnessrc_file="${HOME}/.config/.adjust_brightnessrc"
def_brightness_val=10 # Aka max_brightness_val
printf 'export brightness_envvar=%s' $def_brightness_val > "$adj_brightnessrc_file"

# Set default redshift
adj_redshiftrc_file="${HOME}/.config/.adjust_redshiftrc"
def_redshift_val=0 # Aka min_redshift_val
printf 'export redshift_envvar=%s' $def_redshift_val > "$adj_redshiftrc_file"

# export misc. env vars
export MUSIC_DIR_ENVVAR="${HOME}/Music"
monitor_out_str="$(xrandr --listactivemonitors | awk 'NR==2')"
monitor_out_str_space_count="$(echo "$monitor_out_str" | grep -o '[[:space:]]' | wc -l)"
export X_MONITOR_OUTPUT_ENVVAR="$(echo "$monitor_out_str" | \
	cut -d ' ' -f $((monitor_out_str_space_count+1)))"

# export WM env var and exec it
export WM_ENVVAR="herbstluftwm" && exec "$WM_ENVVAR"
