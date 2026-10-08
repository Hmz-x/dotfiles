#!/bin/bash

iso="$1"
dev="$2"

if [[ ! -f "$iso" && ! -f "$dev" ]]; then 
  echo "iso or device file not found. Exiting" 2>&1
fi

echo "$iso will now be burned into $dev"
read

sudo dd if fof=/dev/sdd bs=8M status=progress

++++++++____))))((((((((Z!@#$$%^^^&&&&*((()_________________+}{QWE``}))))))))))
QWERTYYYUUIOOOP{{{{{{{{{}
ASDFGHJJKLL::::::::"|
  ZXCVBNNMM<<<>>>>>>>>>>"}}}}}}}}
