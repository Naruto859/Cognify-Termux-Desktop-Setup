#!/data/data/com.termux/files/usr/bin/bash

# ─────────────────────────────────────────
#   Cognify Termux Desktop Setup (v2.0)
#   Fixes: Wallpaper Path & DPKG Errors
# ─────────────────────────────────────────

echo ">>> [1/6] System Update & DPKG Fix..."
pkg update -y
apt-get upgrade -y -o Dpkg::Options::="--force-confold"
pkg install x11-repo -y

echo ">>> [2/6] Installing Desktop Environments..."
pkg install xfce4 xfce4-goodies chromium termux-x11-nightly papirus-icon-theme -y

echo ">>> [3/6] Downloading Configs..."
curl -L "https://github.com/Naruto859/Cognify-Termux-Desktop-Setup/raw/main/configs.tar.gz" -o ~/configs.tar.gz

echo ">>> [4/6] Downloading Wallpapers (1-12)..."
mkdir -p ~/Wallpapers
for i in {1..12}; do
  curl -L --fail "https://github.com/Naruto859/Cognify-Termux-Desktop-Setup/raw/main/wallpapers/$i.png" -o ~/Wallpapers/$i.png || echo "Skipping $i.png"
done

echo ">>> [5/6] Extracting Configs..."
# Note: Removed --strip-components unless your tar is very nested
tar -xvzf ~/configs.tar.gz -C ~ 
rm ~/configs.tar.gz

echo ">>> [6/6] Creating start-desktop with Auto-Wallpaper Fix..."
cat > ~/start-desktop << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
export DISPLAY=:1

# Start X11
termux-x11 :1 &
sleep 3

# --- Dynamic Wallpaper Fix (No more NULL folder error) ---
# Find the active monitor name automatically
MONITOR=$(xfconf-query -c xfce4-desktop -p /backdrop/screen0 -l | grep -m1 "monitor" | cut -d'/' -f4)

if [ ! -z "$MONITOR" ]; then
    # Set the folder path to avoid "Downloads" error
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/$MONITOR/workspace0/image-folder -n -t string -s "$HOME/Wallpapers"
    # Set the specific image
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/$MONITOR/workspace0/last-image -n -t string -s "$HOME/Wallpapers/1.png"
    # Set style to Zoomed (5)
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/$MONITOR/workspace0/image-style -n -t int -s 5
fi

# Start Session
xfce4-session
EOF

chmod +x ~/start-desktop
echo "✅ Setup Finished! Run ./start-desktop"
