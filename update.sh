#!/bin/bash
# Pulls the latest menu/scripts from GitHub, then downloads a fresh copy
# of every game listed in games.txt from its published website.
# Safe to run any time:  bash ~/arcade/update.sh
cd "$HOME/arcade" || exit 1

echo "== $(date) =="
echo "-- GitHub --"
timeout 30 git pull --ff-only || echo "git pull skipped (no internet?)"

echo "-- Games --"
while read -r folder url; do
[ -z "$folder" ] && continue
case "$folder" in \#*) continue ;; esac
echo "$folder <- $url"
rm -rf "$folder.new"
mkdir -p "$folder.new"
( cd "$folder.new" && timeout 90 wget -q -r -np -nH -k -E "$url" )
if [ -s "$folder.new/index.html" ]; then
# download worked: swap the new copy in
rm -rf "$folder.old"
[ -d "$folder" ] && mv "$folder" "$folder.old"
mv "$folder.new" "$folder" && rm -rf "$folder.old"
echo "  updated"
else
rm -rf "$folder.new"
echo "  skipped (kept the old copy)"
fi
done < games.txt
echo "done"
