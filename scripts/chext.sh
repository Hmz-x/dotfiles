#!/bin/sh

# Print passed filename, "$1", with its extension removed.
# Display the filename with its new extension, "$2", instead.

file="$1"
[ -z "$file" ] && printf "No filename given. Returning.\n" && return 1

strlen="${#file}"
dot_index=-1
i=$((strlen-1))

# Get dot index
while [ "$i" -gt -1 ]; do
char="$(printf "%s" "$file" | cut -b $((i+1)))"
[ "$char" = '.' ] && dot_index="$i" && break
i=$((i-1))
done

[ "$dot_index" -eq -1 ] && printf "No extension was detected. Returning.\n" && return 1

i=0
# Display filename without extension
while [ "$i" -lt "$dot_index" ]; do
char="$(printf "%s" "$file" | cut -b $((i+1)))"
printf "%s" "$char"
i=$((i+1))
done

# Add on new extension	
[ -n "$2" ] && printf ".%s" "$2"
