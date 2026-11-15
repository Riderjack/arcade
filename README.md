# Arcade

Tabletop arcade, Raspberry Pi 5.

- `menu.html` – the game menu the Pi boots into. Add games in `CONFIG.GAMES`.
- `games.txt` – each game's folder and published web address.
- `update.sh` – gets the newest menu from here and re-downloads every game.
- `start.sh` – runs at login: update, then open the menu full screen.
- `install.sh` – one-time setup on a fresh Pi.

**Update the Pi:** reboot it, or run `bash ~/arcade/update.sh`.

**Add a game:** add a line to `games.txt`, add an entry to `CONFIG.GAMES` in `menu.html`, then reboot the Pi.

**Fresh SD card:** run
`curl -sL https://raw.githubusercontent.com/Riderjack/arcade/main/install.sh | bash`
