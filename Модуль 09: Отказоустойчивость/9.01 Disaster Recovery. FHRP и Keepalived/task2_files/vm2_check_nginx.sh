#!/bin/bash

SERVER_IP="192.168.122.241"
INDEX_FILE="/var/www/html/index.html"

curl -s "http://$SERVER_IP" > /dev/null
if [ $? -ne 0 ]; then
    exit 1
fi

if [ ! -f "$INDEX_FILE" ]; then
    exit 1
fi

exit 0