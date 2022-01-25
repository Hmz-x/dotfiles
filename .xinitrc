# Load Xresources
xrdb .Xresources

# Start Pulseadio daemon
pulseaudio -D

# Set default brightness 
rc_file="${HOME}/.config/.adjust_brightnessrc"
def_brightness_val=10 # Aka max_brightness_val
printf 'export brightness_envvar=%s' $def_brightness_val > "$rc_file"

# export wm_envvar and exec it
export wm_envvar="herbstluftwm" && exec "$wm_envvar"
