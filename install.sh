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
git config core.fileMode false
mkdir -p "$HOME/.config/labwc"
touch "$HOME/.config/labwc/autostart"
sed -i '/arcade\/start.sh/d' "$HOME/.config/labwc/autostart"
echo "bash $HOME/arcade/start.sh &" >> "$HOME/.config/labwc/autostart"
bash ./update.sh
echo "ARCADE INSTALLED. Reboot with:  systemctl reboot"
