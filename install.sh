#!/data/data/com.termux/files/usr/bin/bash

# ─────────────────────────────────────────
#   Cognify Termux Desktop - Final Fix (v3.0)
# ─────────────────────────────────────────

echo ">>> [1/5] System Update (No more DPKG errors)..."
pkg update -y
apt-get upgrade -y -o Dpkg::Options::="--force-confold"
pkg install x11-repo -y

echo ">>> [2/5] Installing Packages..."
pkg install xfce4 xfce4-goodies chromium termux-x11-nightly papirus-icon-theme -y

echo ">>> [3/5] Downloading Assets..."
curl -L "https://github.com/Naruto859/Cognify-Termux-Desktop-Setup/raw/main/configs.tar.gz" -o ~/configs.tar.gz
mkdir -p ~/Wallpapers
for i in {1..12}; do
  curl -L --fail "https://github.com/Naruto859/Cognify-Termux-Desktop-Setup/raw/main/wallpapers/$i.png" -o ~/Wallpapers/$i.png || echo "Skipped $i"
done

echo ">>> [4/5] Extracting Configs..."
# standard extraction without strip-components for safety
tar -xvzf ~/configs.tar.gz -C ~ 
rm ~/configs.tar.gz

echo ">>> [5/5] Creating Professional start-desktop..."
cat > ~/start-desktop << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
export DISPLAY=:1

# 1. Start X11
termux-x11 :1 &
sleep 4

# 2. Advanced Wallpaper Fix (Fixes 'NULL' folder & Default Rat error)
# This loop finds every monitor name (monitor0, monitorVirtual, etc.)
for prop in $(xfconf-query -c xfce4-desktop -p /backdrop/screen0 -l | grep "workspace0/last-image"); do
    MONITOR_PATH=$(echo $prop | cut -d'/' -f1-4)
    xfconf-query -c xfce4-desktop -p ${MONITOR_PATH}/workspace0/image-folder -n -t string -s "$HOME/Wallpapers"
    xfconf-query -c xfce4-desktop -p ${MONITOR_PATH}/workspace0/last-image -n -t string -s "$HOME/Wallpapers/1.png"
    xfconf-query -c xfce4-desktop -p ${MONITOR_PATH}/workspace0/image-style -n -t int -s 5
done

# 3. Apply Themes
xfconf-query -c xsettings -p /Net/ThemeName -s "Catppuccin-Mocha-Standard-Blue-Dark" 2>/dev/null
xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark" 2>/dev/null

# 4. Start Session
xfce4-session
EOF

chmod +x ~/start-desktop
echo "✅ Everything Fixed! Run: ./start-desktop"
