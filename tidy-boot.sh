#!/bin/bash
# One-time cleanup so the arcade boots straight to the menu.
# Run on the Pi with:   sudo bash ~/arcade/tidy-boot.sh
#   - turns off screen blanking
#   - hides the rainbow screen, boot text and Raspberry Pi logos
#   - shows an ARCADE splash screen while booting
#   - makes the desktop plain black and hides the taskbar
# Backups of anything changed are saved with a .arcade-bak ending.

if [ "$(id -u)" -ne 0 ]; then echo "Run it with sudo:  sudo bash ~/arcade/tidy-boot.sh"; exit 1; fi
U="${SUDO_USER:-mark}"
H=$(getent passwd "$U" | cut -d: -f6)
BOOT=/boot/firmware; [ -d "$BOOT" ] || BOOT=/boot
echo "User: $U   Home: $H   Boot: $BOOT"

echo "1) Screen blanking off"
raspi-config nonint do_blanking 1 && echo "   ok"

echo "2) Hide rainbow screen"
CFG="$BOOT/config.txt"
[ -f "$CFG.arcade-bak" ] || cp "$CFG" "$CFG.arcade-bak"
grep -q '^disable_splash=1' "$CFG" || echo 'disable_splash=1' >> "$CFG"
echo "   ok"

echo "3) Quiet boot (no text, no logos, no blinking cursor)"
CMD="$BOOT/cmdline.txt"
[ -f "$CMD.arcade-bak" ] || cp "$CMD" "$CMD.arcade-bak"
LINE=$(head -n1 "$CMD")
LINE=$(echo "$LINE" | sed 's/console=tty1/console=tty3/')
for opt in quiet splash loglevel=3 logo.nologo vt.global_cursor_default=0 plymouth.ignore-serial-consoles; do
case " $LINE " in *" $opt "*) ;; *) LINE="$LINE $opt" ;; esac
done
echo "$LINE" > "$CMD"
echo "   $LINE"

echo "4) ARCADE splash screen"
THEME=/usr/share/plymouth/themes/pix
if [ -f "$THEME/splash.png" ] && [ -f "$H/arcade/arcade-splash.png" ]; then
[ -f "$THEME/splash.png.arcade-bak" ] || cp "$THEME/splash.png" "$THEME/splash.png.arcade-bak"
cp "$H/arcade/arcade-splash.png" "$THEME/splash.png"
raspi-config nonint do_boot_splash 0
echo "   rebuilding boot image (about a minute)..."
update-initramfs -u > /dev/null 2>&1 && echo "   ok" || echo "   skipped (boot image not rebuilt)"
else
echo "   skipped (splash theme or image not found)"
fi

echo "5) Black desktop, no icons"
for f in "$H"/.config/pcmanfm/*/desktop-items-*.conf; do
[ -f "$f" ] || continue
[ -f "$f.arcade-bak" ] || cp "$f" "$f.arcade-bak"
for kv in wallpaper_mode=color desktop_bg='#000000' show_trash=0 show_mounts=0 show_documents=0; do
k=${kv%%=*}
if grep -q "^$k=" "$f"; then sed -i "s|^$k=.*|$kv|" "$f"; else sed -i "/^\[\*\]/a $kv" "$f"; fi
done
echo "   $f"
done

echo "6) Hide the taskbar"
P="$H/.config/wf-panel-pi.ini"
touch "$P"
grep -q '^\[panel\]' "$P" || printf '[panel]\n' >> "$P"
grep -q '^autohide=' "$P" && sed -i 's/^autohide=.*/autohide=true/' "$P" || sed -i '/^\[panel\]/a autohide=true' "$P"
chown -R "$U":"$U" "$H/.config"
echo "   ok"

echo
echo "TIDY BOOT DONE. Reboot with:  systemctl reboot"
