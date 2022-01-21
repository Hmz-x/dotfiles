# Load Xresources
xrdb .Xresources

# Start Pulseadio daemon
pulseaudio -D

# export wm_envvar and exec it
export wm_envvar="herbstluftwm" && exec "$wm_envvar"
