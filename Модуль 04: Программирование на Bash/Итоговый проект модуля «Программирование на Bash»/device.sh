#!/bin/bash

src="/proc/bus/input/devices"

data="$HOME/input_data.txt"
tmp="$HOME/input_tmp.txt"
log="$HOME/input_log.txt"

name=""
handlers=""

: > "$tmp"

echo "Время запуска: $(date '+%Y-%m-%d %H:%M:%S')" >> "$log"

while read -r line; do
  case "$line" in
    N:\ Name=*)
      name=${line#*Name=}
      echo "Name: $name"
      ;;
    H:\ Handlers=*)
      handlers=${line#H: Handlers=}
      echo "Handlers: $handlers"
      ;;
    "")
      echo "Name=$name | Handlers=$handlers" >> "$tmp"
      name=""
      handlers=""
      ;;
  esac
done < "$src"

sort -u "$tmp" -o "$tmp"

if [ ! -f "$data" ]; then
  mv "$tmp" "$data"
  exit 0
fi

sort -u "$data" -o "$data"

comm -13 "$data" "$tmp" | while IFS= read -r dev; do
  [ -n "$dev" ] && echo "Время: $(date '+%Y-%m-%d %H:%M:%S') | Новое устройство: $dev" >> "$log"
done

mv "$tmp" "$data"
