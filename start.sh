#!/bin/bash
# Runs at login (from ~/.config/labwc/autostart).
# Opens the arcade menu right away; game updates download in the
# background and show up on the NEXT boot.
sleep 2
bash "$HOME/arcade/update.sh" > "$HOME/arcade/update.log" 2>&1 &
B=$(command -v chromium || command -v chromium-browser)
exec $B --kiosk --noerrdialogs --disable-infobars --no-first-run \
  --password-store=basic --autoplay-policy=no-user-gesture-required \
  "file://$HOME/arcade/menu.html"
