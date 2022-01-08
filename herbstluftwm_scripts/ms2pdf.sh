#!/bin/sh

# Convert given ms file to pdf

out_ext="pdf"

new_file="$(chext.sh "$1" "$out_ext")"
groff -ms "$1" -T "$out_ext" > "$new_file"

exec zathura "$new_file"
