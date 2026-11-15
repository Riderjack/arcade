#!/bin/bash
# Runs at login (from ~/.config/labwc/autostart).
# 1) grab any updates  2) open the arcade menu full screen.
sleep 3
"$HOME/arcade/update.sh" > "$HOME/arcade/update.log" 2>&1
B=$(command -v chromium || command -v chromium-browser)
$B --kiosk --noerrdialogs --disable-infobars --no-first-run \
  --password-store=basic --autoplay-policy=no-user-gesture-required \
  "file://$HOME/arcade/menu.html"
