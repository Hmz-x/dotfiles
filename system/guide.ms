.TL
Quick Guide to Hmz's Artix + Openrc System
.AU
Hmz

.IP
.B "init" ":" 
starts the boot process and calls 
.B "openrc"
.IP
.B "openrc" ":" 
runs the services in the default and boot service list and calls
.B "agetty"
.IP
.B "agetty" ":" 
calls 
.B "login"
to log the user into the system
.IP
.B "~/.bash_profile" :
is read on login and according to my configuration, first sources 
.B "~/.local/bin/system/envvars.sh"
which exports a number of user written environment variables as well as
.B "~/.bashrc"
which contains several important aliases and functions, and finally 
.B "startx"
is called if not already in a graphical environment
.IP
.B "startx" :
starts the 
.B "X" 
environment calls 
.B "xinit"
and the client file
.B "~/.xinitrc"
is passed that starts notable daemons such as
.B "pulseaudio"
and 
.B "mpd" ","
then does some customized 
.B X 
configurations and exports user defined environment variables that directly 
relate to 
.B X ","
and finally executes the window manager 
.B "herbstluftwm"
.IP
.B "herbstluftwm" :
calls its configuration file 
.B "~/.config/herbstluftwm/autostart" ","
which is a 
.B "POSIX shell"
script, containg commands that start GUI programs such as
.B "picom"
and 
.B "feh" ","
and then specifically configures the window manager using its client program
.B "herbstclient" 
that sets a whole bunch of keybindings and display attributes, and finally
.B "set_lemonbar.sh" ","
my personal script that allows for the quick configuration of 
.B "lemonbar" ","
is called and the output is piped into the status bar 
.B "lemonbar"
