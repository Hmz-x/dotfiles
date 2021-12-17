# Load Xresources
xrdb .Xresources

# Start Pulseadio daemon
pulseaudio -D

# export WM and exec it
export WM="herbstluftwm" && exec "$WM"
