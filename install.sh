#!/data/data/com.termux/files/usr/bin/bash

# ─────────────────────────────────────────
#   Cognify Termux Desktop Setup
#   github.com/Naruto859/Cognify-Termux-Desktop-Setup
# ─────────────────────────────────────────

export PATH="/data/data/com.termux/files/usr/bin:$PATH"

echo ">>> [1/6] Packages update ho rahe hain..."
pkg update -y
apt-get upgrade -y -o Dpkg::Options::="--force-confold"
pkg install x11-repo -y

echo ">>> [2/6] XFCE4, Chromium, Termux-X11, PulseAudio install ho raha hai..."
pkg install xfce4 xfce4-goodies chromium termux-x11-nightly papirus-icon-theme pulseaudio -y

echo ">>> [3/6] Configs download ho rahe hain..."
curl -L https://github.com/Naruto859/Cognify-Termux-Desktop-Setup/raw/main/configs.tar.gz \
  -o ~/configs.tar.gz || { echo "ERROR: Config download failed!"; exit 1; }

echo ">>> [4/6] Wallpapers download ho rahe hain..."
mkdir -p ~/Wallpapers
for i in {1..9}; do
  curl -L --fail \
    "https://github.com/Naruto859/Cognify-Termux-Desktop-Setup/raw/main/wallpapers/$i.png" \
    -o ~/Wallpapers/$i.png || echo "  Wallpaper $i nahi mila, skip."
done

echo ">>> [5/6] Configs extract ho rahe hain..."
tar -xzf ~/configs.tar.gz --strip-components=5 -C ~
rm ~/configs.tar.gz

# ── Wallpaper XML fix ──
DESKTOP_XML="$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
if [ -f "$DESKTOP_XML" ]; then
  sed -i "s|value=\"[^\"]*Downloads[^\"]*\"|value=\"$HOME/Wallpapers/1.png\"|g" "$DESKTOP_XML"
  sed -i "s|Downloads|Wallpapers|g" "$DESKTOP_XML"
else
  mkdir -p "$(dirname "$DESKTOP_XML")"
  cat > "$DESKTOP_XML" << XMLEOF
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="workspace0" type="empty">
          <property name="image-path" type="string" value="$HOME/Wallpapers"/>
          <property name="image-show" type="bool" value="true"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="$HOME/Wallpapers/1.png"/>
        </property>
      </property>
    </property>
  </property>
</channel>
XMLEOF
fi

# ── PULSE_SERVER ko completely hatao (yahi problem thi) ──
sed -i '/PULSE_SERVER/d' ~/.bashrc ~/.profile 2>/dev/null
rm -f ~/.config/environment.d/pulse.conf 2>/dev/null

# ── PulseAudio config — AAudio sink auto load ──
mkdir -p ~/.config/pulse
cat > ~/.config/pulse/default.pa << 'PAEOF'
.include /data/data/com.termux/files/usr/etc/pulse/default.pa
load-module module-aaudio-sink
set-default-sink AAudio_sink
PAEOF

echo ">>> [6/6] start-desktop script ban raha hai..."
cat > ~/start-desktop << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

export PATH="/data/data/com.termux/files/usr/bin:$PATH"
export DISPLAY=:1

# ── PulseAudio start karo ──
pulseaudio --kill 2>/dev/null
sleep 1
pulseaudio --start --exit-idle-time=-1
sleep 2

# ── X11 start karo ──
termux-x11 :1 &
sleep 4

# ── Wallpaper set karo ──
xfconf-query -c xfce4-desktop \
  -p /backdrop/screen0/monitor0/workspace0/image-path \
  -s "$HOME/Wallpapers" --create -t string 2>/dev/null
xfconf-query -c xfce4-desktop \
  -p /backdrop/screen0/monitor0/workspace0/last-image \
  -s "$HOME/Wallpapers/1.png" --create -t string 2>/dev/null
xfconf-query -c xfce4-desktop \
  -p /backdrop/screen0/monitor0/workspace0/image-show \
  -s true --create -t bool 2>/dev/null
xfconf-query -c xfce4-desktop \
  -p /backdrop/screen0/monitor0/workspace0/image-style \
  -s 5 --create -t int 2>/dev/null

# ── Theme apply karo ──
xfconf-query -c xsettings -p /Net/ThemeName \
  -s "Catppuccin-Mocha-Standard-Blue-Dark" 2>/dev/null
xfconf-query -c xsettings -p /Net/IconThemeName \
  -s "Papirus-Dark" 2>/dev/null

# ── XFCE4 launch karo ──
xfce4-session
EOF
chmod +x ~/start-desktop

echo ""
echo "✅ Setup complete!"
echo "▶  Termux-X11 app kholo, phir Termux mein likho:  ./start-desktop"
echo ""
