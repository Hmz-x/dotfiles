#!/bin/bash -x

largest_device=""
largest_size=0
used_space=""
available_space=""
total_size=0
total_used=0
total_avail=0

# Function to convert size to bytes
convert_to_bytes() {
  local size="$1"
  local unit="${size: -1}" # Get the last character (K, M, G, T)
  local value="${size%"${unit}"}" # Extract numeric part of size
  case "$unit" in
    T) awk "BEGIN {printf \"%.0f\", $value * 1024 * 1024 * 1024 * 1024}" ;;
    G) awk "BEGIN {printf \"%.0f\", $value * 1024 * 1024 * 1024}" ;;
    M) awk "BEGIN {printf \"%.0f\", $value * 1024 * 1024}" ;;
    K) awk "BEGIN {printf \"%.0f\", $value * 1024}" ;;
    *) echo "$value" ;;
  esac
}

# Parse df output
while read -r device size used avail; do
  # Skip header
  if [[ "$device" == "Filesystem" ]]; then
    continue
  fi

  # Accumulate totals
  total_size=$(awk "BEGIN {print $total_size + $(convert_to_bytes "$size")}")
  total_used=$(awk "BEGIN {print $total_used + $(convert_to_bytes "$used")}")
  total_avail=$(awk "BEGIN {print $total_avail + $(convert_to_bytes "$avail")}")

  # Identify the largest device
  size_in_bytes=$(convert_to_bytes "$size")
  if (( size_in_bytes > largest_size )); then
    largest_device="$device"
    largest_size="$size_in_bytes"
    used_space="$used"
    available_space="$avail"
  fi
done < <(df -h | awk 'NR > 1 {print $1, $2, $3, $4}')

# Handle command-line arguments
case "$1" in
  --size)
    echo "Total Size: $(awk "BEGIN {printf \"%.2f GB\", $total_size / (1024 * 1024 * 1024)}")"
    ;;
  --used)
    echo "Total Used: $(awk "BEGIN {printf \"%.2f GB\", $total_used / (1024 * 1024 * 1024)}")"
    ;;
  --avail)
    echo "Total Available: $(awk "BEGIN {printf \"%.2f GB\", $total_avail / (1024 * 1024 * 1024)}")"
    ;;
  *)
    echo "Largest Device: $largest_device"
    echo "Used Space: $used_space"
    echo "Available Space: $available_space"
    ;;
esac
