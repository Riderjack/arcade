#!/bin/bash
# Pulls the latest menu/scripts from GitHub, then refreshes every game
# listed in games.txt from its published website.
# Safe to run any time:  ~/arcade/update.sh
cd "$HOME/arcade" || exit 1

echo "== $(date) =="
echo "-- GitHub --"
timeout 30 git pull --ff-only || echo "git pull skipped (no internet?)"

echo "-- Games --"
while read -r folder url; do
  [ -z "$folder" ] && continue
  case "$folder" in \#*) continue ;; esac
  echo "$folder <- $url"
  mkdir -p "$folder"
  ( cd "$folder" && timeout 60 wget -q -r -np -nH -k -E -N "$url" ) || echo "  skipped"
done < games.txt
echo "done"
