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

echo ">>> [2/6] XFCE4, Chromium, Termux-X11 install ho raha hai..."
pkg install xfce4 xfce4-goodies chromium termux-x11-nightly papirus-icon-theme -y

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

echo ">>> [6/6] start-desktop script ban raha hai..."
cat > ~/start-desktop << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

# PATH fix — commands milenge
export PATH="/data/data/com.termux/files/usr/bin:$PATH"
export DISPLAY=:1

# X11 start karo
termux-x11 :1 &
sleep 4

# Wallpaper set karo
xfconf-query -c xfce4-desktop \
  -p /backdrop/screen0/monitor0/workspace0/last-image \
  -s "$HOME/Wallpapers/1.png" 2>/dev/null

# Theme apply karo
xfconf-query -c xsettings \
  -p /Net/ThemeName \
  -s "Catppuccin-Mocha-Standard-Blue-Dark" 2>/dev/null

# Icon theme apply karo
xfconf-query -c xsettings \
  -p /Net/IconThemeName \
  -s "Papirus-Dark" 2>/dev/null

# XFCE4 launch karo
xfce4-session
EOF
chmod +x ~/start-desktop

echo ""
echo "✅ Setup complete!"
echo "▶  Termux-X11 app kholo, phir Termux mein likho:  ./start-desktop"
echo ""
