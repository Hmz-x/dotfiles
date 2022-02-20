#!/bin/sh

# Convert given ms file to pdf. Written by Hamza Kerem Mumcu

# Program data
pdf_prg="zathura" # Program to read pdf files with
out_ext="pdf"
filename="$1"
apply_eqn_bool="false"

apply_eqn(){
	# If strings .EQ and .EN exist in file, set apply_eqn_bool to true
	grep -wq "\.EQ" "$filename" && grep -wq "\.EN" "$filename" &&
	apply_eqn_bool="true"
}

compile(){
	new_file="$(chext.sh "$filename" "$out_ext")"

	# Compile with eqn flags and return
	[ "X${apply_eqn_bool}" = "Xtrue" ] &&
	groff -ms -e "$filename" -T "$out_ext" > "$new_file" && return

	groff -ms "$filename" -T "$out_ext" > "$new_file"
}

apply_eqn

compile

# Read PDF
exec "$pdf_prg" "$new_file"
