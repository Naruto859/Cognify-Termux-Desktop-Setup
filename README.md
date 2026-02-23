Cognify-Termux-Desktop-Setup
​A one-click automation script to install a high-performance Linux Desktop environment on Android using Termux-X11.
​Installation
​Run this command in Termux to start the setup:
​curl -sL https://github.com/Naruto859/Cognify-Termux-Desktop-Setup/raw/main/install.sh | bash
​Post-Installation Steps
​1. Grant Storage Permission
​Run this command to allow the browser to access your files:
​termux-setup-storage
​2. Launch the Desktop
​Open the Termux-X11 app.
​Go back to Termux and type:
​./start-desktop
​Important Notes & Requirements
​Architecture: This setup is for ARM64 (AArch64) devices only.
​Storage: Ensure you have at least 5 GB of free internal storage.
​Battery & Heat: Device may heat up and battery may drain faster during use.
​Repo Errors: If pkg update fails, run termux-change-repo and switch to a stable mirror.
​How to Change Wallpapers
​All wallpapers are saved in the ~/Wallpapers folder.
​Right-click on the desktop.
​Go to Desktop Settings.
​Choose your preferred PNG image from the list.
​Maintained by CognifyTech
