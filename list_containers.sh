#! /bin/bash
source env.sh

$CONTAINER_CMD list --format csv | grep -P '^[^,]*-misp,' | cat | while read -r MATCH; do
  NAME=$(echo "$MATCH" | cut -d, -f 1)
  IP=$(echo "$MATCH" | cut -d, -f 3 | cut -d' ' -f 1)
  echo $NAME $IP
  #  ssh-keygen -f "/home/hildenae/.ssh/known_hosts" -R "$IP" 2>/dev/null 1>/dev/null;
done