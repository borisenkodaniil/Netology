#!/bin/bash

data="$HOME/data.txt"
log="$HOME/log.txt"
tmp="$HOME/tmp.txt"

pids=$(ls /proc | grep '^[0-9]\+$' | sort -n)

echo "$pids" > "$tmp"

if [ ! -f "$data" ]; then
  mv "$tmp" "$data"
else

  comm -13 "$data" "$tmp" | while read -r pid; do
    [ -n "$pid" ] && echo "Время: $(date '+%Y-%m-%d %H:%M:%S') | Процесс: $pid" >> "$log"
  done

  mv "$tmp" "$data"
fi

PS3="Выберите PID: "
select pid in $pids; do
  [ -n "$pid" ] || { echo "Неверный выбор"; continue; }

  exe=$(readlink "/proc/$pid/exe" 2>/dev/null)
  name="${exe##*/}"
  [ -n "$name" ] || name="?"

  cmdline=""
  fd=""
  root=""
  cwd=""

  PS3="Выберите параметр: "
  select param in cmdline fd root cwd menu; do
    case "$param" in
      cmdline)
        cmdline=$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null)
        cmdline=${cmdline:0:60}
        echo "$cmdline"
        ;;
      fd)
        fd=$(ls "/proc/$pid/fd" 2>/dev/null | tr '\n' ' ')
        fd=${fd:0:40}
        echo "$fd"
        ;;
      root)
        root=$(readlink "/proc/$pid/root" 2>/dev/null)
        root=${root:0:20}
        echo "$root"
        ;;
      cwd)
        cwd=$(readlink "/proc/$pid/cwd" 2>/dev/null)
        cwd=${cwd:0:20}
        echo "$cwd"
        ;;
      menu)
        break
        ;;
      *)
        echo "Неверный ввод"
        ;;
    esac
  done

  printf "%-10s %-20s %-60s %-40s %-20s %-20s\n" "PID" "Name" "Cmdline" "FD" "Root" "CWD"
  printf "%-10s %-20s %-60s %-40s %-20s %-20s\n" \
    "$pid" "${name:0:20}" "$cmdline" "$fd" "$root" "$cwd"
  echo
done
