#!/bin/bash

DL_DIR="/home/hkm/Music/Leanmobb_Fukkst4r"
USERNAME="lonestarfractal"

# Check if Tor service is running
tor_status=$(systemctl is-active --quiet tor && echo "running" || echo "not running")
# Check if proxychains4 executable is available
proxychains_status=$(command -v proxychains4 >/dev/null && echo "installed" || echo "not installed")

# If both conditions are met, execute the desired action
if [[ "$tor_status" == "running" && "$proxychains_status" == "installed" ]]; then
    echo "Both Tor is running and proxychains4 is installed."
    echo "Downloading content..."
else
    echo "Either Tor is not running or proxychains4 is not installed. Exitting."
    exit 1
fi

[ ! -d "$DL_DIR" ] && mkdir -p "$DL_DIR"
cd "$DL_DIR" || { echo "Failed to cd into $DL_DIR. Exitting."; exit 1; }

if [[ "$1" == "-q" || "$1" == "--quiet" ]]; then
  proxychains4 -q yt-dlp -f bestaudio "https://soundcloud.com/${USERNAME}/likes" &> /dev/null
else
  proxychains4 -q yt-dlp -f bestaudio "https://soundcloud.com/${USERNAME}/likes"
fi
