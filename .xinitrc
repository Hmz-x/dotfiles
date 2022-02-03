# Load Xresources
xrdb .Xresources

# Start Pulseadio daemon
pulseaudio -D

# Set default brightness 
adj_brightnessrc_file="${HOME}/.config/.adjust_brightnessrc"
def_brightness_val=10 # Aka max_brightness_val
printf 'export brightness_envvar=%s' $def_brightness_val > "$adj_brightnessrc_file"

# Set default redshift
adj_redshiftrc_file="${HOME}/.config/.adjust_redshiftrc"
def_redshift_val=0 # Aka min_redshift_val
printf 'export redshift_envvar=%s' $def_redshift_val > "$adj_redshiftrc_file"


# export wm_envvar and exec it
export wm_envvar="herbstluftwm" && exec "$wm_envvar"
