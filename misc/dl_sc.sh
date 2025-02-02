#!/bin/bash

DL_DIR="/home/hkm/Music/Leanmobb_Fukkst4r"
USERNAME="lonestarfractal"

[ ! -d "$DL_DIR" ] && mkdir -p "$DL_DIR"

cd "$DL_DIR" && \
  yt-dlp -f bestaudio "https://soundcloud.com/${USERNAME}/likes" &> /dev/null
