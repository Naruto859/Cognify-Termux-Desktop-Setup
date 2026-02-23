#!/data/data/com.termux/files/usr/bin/bash

# 1. Update Repos
pkg update -y && pkg upgrade -y
pkg install x11-repo -y

# 2. Install Packages
pkg install xfce4 xfce4-goodies chromium termux-x11-nightly papirus-icon-theme -y

# 3. Download Assets (Replace YourUsername with Naruto859)
curl -L https://github.com/Naruto859/Cognify-Termux-Desktop-Setup/raw/main/configs.tar.gz -o ~/configs.tar.gz
curl -L https://github.com/Naruto859/Cognify-Termux-Desktop-Setup/raw/main/wallpaper.jpg -o ~/wallpaper.jpg

# 4. Extract Configs
tar -xvzf ~/configs.tar.gz -C ~

# 5. Create Start Script
echo "termux-x11 :1 & xfce4-session" > ~/start-desktop
chmod +x ~/start-desktop
