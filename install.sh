#!/data/data/com.termux/files/usr/bin/bash

# 1. Update Repos
pkg update -y && pkg upgrade -y
pkg install x11-repo -y

# 2. Install Packages
pkg install xfce4 xfce4-goodies chromium termux-x11-nightly papirus-icon-theme -y

# 3. Download Main Configs
curl -L https://github.com/Naruto859/Cognify-Termux-Desktop-Setup/raw/main/configs.tar.gz -o ~/configs.tar.gz

# 4. Download Wallpapers (Loop for 1.png to 12.png)
mkdir -p ~/Wallpapers
for i in {1..9}
do
  curl -L "https://github.com/Naruto859/Cognify-Termux-Desktop-Setup/raw/main/wallpapers/$i.png" -o "~/Wallpapers/$i.png"
done

# 5. Extract Configs
tar -xvzf ~/configs.tar.gz -C ~

# 6. Create Start Script
echo "termux-x11 :1 & xfce4-session" > ~/start-desktop
chmod +x ~/start-desktop
