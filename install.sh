#!/data/data/com.termux/files/usr/bin/bash

# ─────────────────────────────────────────
#   Cognify Termux Desktop Setup
#   github.com/Naruto859/Cognify-Termux-Desktop-Setup
# ─────────────────────────────────────────

set -e  # Stop on any error

echo ">>> [1/6] Updating & upgrading packages..."
pkg update -y
apt-get upgrade -y -o Dpkg::Options::="--force-confold"
pkg install x11-repo -y

echo ">>> [2/6] Installing XFCE4, Chromium, Termux-X11..."
pkg install xfce4 xfce4-goodies chromium termux-x11-nightly papirus-icon-theme -y

echo ">>> [3/6] Downloading configs..."
curl -L https://github.com/Naruto859/Cognify-Termux-Desktop-Setup/raw/main/configs.tar.gz \
  -o ~/configs.tar.gz || { echo "ERROR: Config download failed!"; exit 1; }

echo ">>> [4/6] Downloading wallpapers..."
mkdir -p ~/Wallpapers
for i in {1..12}; do
  # FIX: ~ must NOT be inside quotes
  curl -L --fail \
    "https://github.com/Naruto859/Cognify-Termux-Desktop-Setup/raw/main/wallpapers/$i.png" \
    -o ~/Wallpapers/$i.png || echo "  Wallpaper $i not found, skipping."
done

echo ">>> [5/6] Extracting configs..."
tar -xzf ~/configs.tar.gz -C ~ || { echo "ERROR: Extraction failed!"; exit 1; }
rm ~/configs.tar.gz  # Cleanup

echo ">>> [6/6] Creating start-desktop script..."
cat > ~/start-desktop << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# Start Termux-X11 display server
termux-x11 :1 &
sleep 3

# Set display and launch XFCE4
export DISPLAY=:1
xfce4-session
EOF
chmod +x ~/start-desktop

echo ""
echo "✅ Setup complete!"
echo ""
echo "▶  To start the desktop:"
echo "   1. Open Termux-X11 app"
echo "   2. Come back to Termux and run:  ./start-desktop"
echo ""
