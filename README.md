# Arcade

Tabletop arcade, Raspberry Pi 5.

- `menu.html` – the game menu the Pi boots into. Add games in `CONFIG.GAMES`.
- `games.txt` – each game's folder and published web address.
- `update.sh` – gets the newest menu from here and re-downloads every game.
- `start.sh` – runs at login: update, then open the menu full screen.
- `install.sh` – one-time setup on a fresh Pi.
- `tidy-boot.sh` – one-time boot cleanup (splash screen, no boot text, black desktop, no screen blanking). Run: `sudo bash ~/arcade/tidy-boot.sh`
- `arcade-splash.png` – the ARCADE boot splash.

**Update the Pi:** reboot it. Updates download in the background and show up on the next boot. Or run `bash ~/arcade/update.sh` and then reboot.

**Add a game:** add a line to `games.txt`, add an entry to `CONFIG.GAMES` in `menu.html`, then reboot the Pi.

**Fresh SD card:** run
`curl -sL https://raw.githubusercontent.com/Riderjack/arcade/main/install.sh | bash`
