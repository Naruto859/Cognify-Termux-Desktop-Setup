#!/data/data/com.termux/files/usr/bin/bash

# 1. Update Repos & Upgrade (Fix for dpkg error)
pkg update -y
apt-get upgrade -y -o Dpkg::Options::="--force-confold"
pkg install x11-repo -y

# 2. Install Packages
pkg install xfce4 xfce4-goodies chromium termux-x11-nightly papirus-icon-theme -y

# 3. Download Main Configs
curl -L https://github.com/Naruto859/Cognify-Termux-Desktop-Setup/raw/main/configs.tar.gz -o ~/configs.tar.gz

# 4. Download Wallpapers (Loop for 1 to 12)
mkdir -p ~/Wallpapers
for i in {1..12}
do
  curl -L --fail "https://github.com/Naruto859/Cognify-Termux-Desktop-Setup/raw/main/wallpapers/$i.png" -o "~/Wallpapers/$i.png" || echo "Wallpaper $i missing, skipping."
done

# 5. Extract Configs
tar -xvzf ~/configs.tar.gz -C ~

# 6. Create Start Script
echo "termux-x11 :1 & xfce4-session" > ~/start-desktop
chmod +x ~/start-desktop

# 7. Set Default Wallpaper (Fix for name change)
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s /data/data/com.termux/files/home/Wallpapers/1.png
