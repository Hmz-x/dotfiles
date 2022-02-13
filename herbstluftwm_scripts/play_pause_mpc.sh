#!/bin/sh -x

song_status="$(mpc status '%state%')"
[ "$song_status" = 'playing' ] && mpc pause
[ "$song_status" = 'paused' ] && mpc play
