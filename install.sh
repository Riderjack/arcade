#!/bin/bash
# One-time setup on the Pi. Turns ~/arcade into a copy of the GitHub repo
# (game folders are kept) and makes it start at login.
set -e
REPO="https://github.com/Riderjack/arcade.git"
mkdir -p "$HOME/arcade" && cd "$HOME/arcade"
[ -d .git ] || git init -q
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO"
git fetch -q origin
git checkout -q -B main origin/main -f
git branch -q --set-upstream-to=origin/main main
chmod +x start.sh update.sh
mkdir -p "$HOME/.config/labwc"
grep -q 'arcade/start.sh' "$HOME/.config/labwc/autostart" 2>/dev/null || \
  echo "$HOME/arcade/start.sh &" >> "$HOME/.config/labwc/autostart"
./update.sh
echo "ARCADE INSTALLED. Reboot with:  systemctl reboot"
