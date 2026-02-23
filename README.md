# Cognify-Termux-Desktop-Setup

A one-click automation script to install a high-performance Linux Desktop environment on Android using Termux-X11.

## 🚀 Installation

Run this command in Termux to start the setup:

curl -sL https://github.com/Naruto859/Cognify-Termux-Desktop-Setup/raw/main/install.sh | bash

## 🛠️ Post-Installation Steps

### 1. Grant Storage Permission
To allow the browser and apps to access your internal files, run:

termux-setup-storage

### 2. Launch the Desktop
1. Open the Termux-X11 app on your phone.
2. Go back to Termux and type:

./start-desktop

## ⚠️ Important Notes & Requirements
* Architecture: This setup is optimized for ARM64 (AArch64) devices only.
* Storage: Ensure at least 5 GB of free internal storage.
* Battery & Heat: Heavy usage may increase battery drain and device temperature.
* Repo Errors: If pkg update fails, run termux-change-repo and switch to a stable mirror.

## 🖼️ How to Change Wallpapers
All wallpapers are saved in the ~/Wallpapers folder.
1. Right-click on the desktop.
2. Go to Desktop Settings.
3. Select your favorite PNG image from the list.

---
Maintained by CognifyTech
