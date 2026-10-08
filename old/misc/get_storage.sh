#!/bin/bash

# Initialize variables
largest_device=""
largest_size=0
used_space=""
available_space=""
total_size=0
total_used=0
total_avail=0

# Function to convert sizes to bytes (ignoring fractions)
convert_to_bytes() {
  local size=${1%[KMGTP]*}
  local unit=${1##*[0-9.]}

  # Ignore fractional part by taking the integer part only
  size=${size%%.*}

  case "$unit" in
    K) echo $((size * 1024)) ;;
    M) echo $((size * 1024 ** 2)) ;;
    G) echo $((size * 1024 ** 3)) ;;
    T) echo $((size * 1024 ** 4)) ;;
    P) echo $((size * 1024 ** 5)) ;;
    *) echo "$size" ;; # Handle sizes without units
  esac
}

# Process df output
df -h | awk 'NR > 1 {print $1, $2, $3, $4}' | while read -r device size used avail; do
  [[ $device == "tmpfs" || $device == "devtmpfs" ]] && continue # Skip tmpfs devices

  size_in_bytes=$(convert_to_bytes "$size")
  used_in_bytes=$(convert_to_bytes "$used")
  avail_in_bytes=$(convert_to_bytes "$avail")

  # Skip processing if size conversion fails
  [[ -z $size_in_bytes || -z $used_in_bytes || -z $avail_in_bytes ]] && continue

  # Update total counters
  total_size=$((total_size + size_in_bytes))
  total_used=$((total_used + used_in_bytes))
  total_avail=$((total_avail + avail_in_bytes))

  # Check for the largest device
  if ((size_in_bytes > largest_size)); then
    largest_device=$device
    largest_size=$size_in_bytes
    used_space=$used
    available_space=$avail
    
    # Output results
    echo "Largest Device: $largest_device"
    echo "Used Space: $used_space"
    echo "Available Space: $available_space"
  fi
done
