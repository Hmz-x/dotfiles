#!/bin/bash

# Start notification daemon fnott
pgrep fnott || fnott &

# Reduce blue light
wlsunset -l 40.4 -L -86.9 &
