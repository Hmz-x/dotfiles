#!/bin/bash

[ -z "$1" ] && echo "No filename passed. Exitting." && exit 1
[ -z "$2" ] && echo "No new filename passed. Exitting." && exit 1
[ -z "$3" ] && echo "No pitch value passed. Exitting." && exit 1
[ -z "$4" ] && echo "No range value passed. Exitting." && exit 1

mv -v "$1" "$2"
pval="$3"
range=$(($4-1))

for i in $(seq 0 $range); do
	outfile="out${i}-${2}"
	echo "${2} to ${outfile}: $pval"
	sbsms "$2" "$outfile" 1 1 $pval $pval

	((pval > 0)) && pval=$((pval+1))
	((pval < 0)) && pval=$((pval-1))
done
