#!/bin/bash
source install.env

#Add Aditional Repositories

#Get Updates
sudo apt-get update  # To get the latest package lists
sudo apt-get upgrade -y

#Enable Flatpak apps to be installed
sudo apt-get install flatpak -y
sudo apt-get install gnome-software-plugin-flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#Enable Python PIP packages to be installed 
sudo apt-get install python3-pip -y
sudo apt-get install pipx -y #new way to install isolated from system

#Install SNAP Packages
sudo snap install skype
sudo snap install code --classic
sudo snap install bottom #htop type monitoring dashboard
sudo snap install get-iplayer
sudo snap install nordvpn

#Install Flatpak Packages
sudo flatpak install flathub org.keepassxc.KeePassXC -y
sudo flatpak install flathub com.mattjakeman.ExtensionManager -y #Enable and manage Gnome shell extensions
sudo flatpak install flathub com.github.iwalton3.jellyfin-media-player -y
sudo flatpak install flathub org.videolan.VLC -y
sudo flatpak install flathub com.github.johnfactotum.Foliate -y #ePub book reader
sudo flatpak install flathub io.github.dweymouth.supersonic -y #jelyfin and subsonic client
sudo flatpak install flathub org.audacityteam.Audacity -y #need to start audacity without pavucontroller running
sudo flatpak install flathub com.borgbase.Vorta -y #backup application using borg as backend

#Install From Repo
sudo apt-get install synaptic -y #GUI package manager and app installer
sudo apt-get install gufw -y #Fireweall GUI
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install ubuntu-restricted-extras #install non-interactive for MS Fonts and includes Lame encoder
sudo apt-get install nautilus-admin -y #Admin permissions extension for file manager
sudo apt-get install git -y
sudo apt-get install tlp -y #Laptop power saving tools, check using sudo tlp-stat -s
sudo apt-get install tlp-rdw -y #Used by TLP to control Bluetooth and Wifi radios
sudo apt-get install thinkfan -y #Helps control the fan and enables disengaged full speed
sudo apt-get install lm-sensors -y #Module to read the CPU core temperatures, used by Thinkfan
sudo apt-get install printer-driver-gutenprint -y #MXG3650s printer driver
sudo apt-get install libsane-common -y #Common Scanner library, should already be installed
sudo apt-get install intel-gpu-tools -y #Run intel_gpu_top to check vaapi use
sudo apt-get install intel-media-va-driver-non-free -y #faster intel quicksync version of the Vaapi driver for intel UHD620 graphic card
sudo apt-get install vainfo -y #Run vainfo to check that vaapi driver is installed
sudo apt-get install gnome-tweaks -y
sudo apt-get install ffmpeg -y #Needed to convert Audible files to .m4a
sudo apt-get install pavucontrol -y #Audio routing for audacity recording from browser etc
sudo apt-get install clamav -y #Command line Virus scanning. sudo freshclam then clamscan -r -i --exclude-dir="^/sys" --exclude-dir="^/var/lib/flatpak" --bell /
sudo apt-get install libfuse2t64 -y #needed for appimage software to run
sudo apt-get install fzf -y #fuzzy search and history for BASH Terminal
sudo apt-get install tmux -y #terminal session window panes
sudo apt-get install pcscd -y #needed for yubikey desktop integration
sudo apt-get install gnome-screenshot -y #needed for yubikey QR code scan screenshot
sudo apt-get install sudo apt install libpam-u2f -y #Yubico authentication library
sudo apt-get install python3-dnspython python3-psutil -y #dependencies for PyRadio
sudo apt-get install libpam-u2f -y #needed for yubikey sudo authentication

#Download and intsall deb Files, Clean then Delete
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P ~/Downloads
sudo dpkg -i ~/Downloads/google-chrome-stable_current_amd64.deb
sudo apt-get -f -y install #fix any errors
sudo rm -f ~/Downloads/google-chrome-stable_current_amd64.deb

#NordVPN Snap Setup
sudo groupadd nordvpn
sudo usermod -aG nordvpn $USER
sudo snap connect nordvpn:network-control
sudo snap connect nordvpn:network-observe
sudo snap connect nordvpn:firewall-control
sudo snap connect nordvpn:login-session-observe
sudo snap connect nordvpn:system-observe
sudo snap connect nordvpn:hardware-observe
sudo nordvpn login --token $T470NORD
sudo nordvpn set lan-discovery enable #alternative to whitelisting the IP range 192.168.8.0/24
sudo nordvpn set autoconnect on london #autoconnect to London UK on startup
sudo nordvpn set tpl on #set threat protection lite to on
sudo nordvpn set meshnet on #turn meshnet on to connect to server when not on LAN

#Install Python packages
pipx install "yt-dlp[default]" #YouTube downloader
wget https://raw.githubusercontent.com/coderholic/pyradio/master/pyradio/install.py -P ~/software-install
python3 ~/software-install/install.py #update using cd ~/software-install then python3 install.py --update

#Copy Configuration Files
sudo cp ~/software-install/tlp.conf /etc #Set TLP to remember wifi and bluetooth status on reboot
sudo cp ~/software-install/sysctl.conf /etc #Set swappiness of SSD to 10
sudo cp ~/software-install/thinkfan.yaml /etc #Thinkfan configuration for version 1.x onwards
sudo cp ~/software-install/thinkpad_acpi.conf /etc/modprobe.d #Set Thinkfan to load at boot
sudo cp ~/software-install/thinkfan /etc/default #Start Thinkfan
sudo cp ~/software-install/freshclam.conf /etc/clamav/freshclam.conf #Disable automatic updates of clamav change checks=24 to checks=0
sudo cp ~/software-install/ian /var/lib/AccountsService/icons #Copy user profile picture
sudo cp ~/software-install/grub /etc/default #disable probe for other OS e.g. Windows and don't display menu. Use F12 and select boot disk.
sudo cp ~/software-install/.profile ~ #copy amended profile to set firefox to use wayland session
sudo cp ~/software-install/main.conf /etc/bluetooth #enable experimental features which enables low energy profiles and removes errors
sudo cp ~/software-install/google-chrome.desktop ~/.local/share/applications #chrome desktop shortcut including hardare video decode settings
sudo cp ~/software-install/sudo /etc/pam.d #add ability to use Yubikey as a sudo authentication. Run pamu2fcfg > ~/.config/Yubico/u2f_keys after reboot
sudo cp ~/software-install/cvlc ~/.local/bin #shortcut to allow cvlc flatpak to run using just cvlc command not flathub run so pyradio works
sudo cp ~/software-install/ian /var/lib/AccountsService/icons #restore user profile picture

#Configure application packages
sudo sensors-detect --auto #Thinkfan detect sensors automatic mode using coretemp and acptiz modules
sudo cp ~/software-install/modules /etc #copy modules to load which is coretemp for thinkfan
~/software-install/desktop_integration.sh --install #install desktop integration which creates a start shortcut and icon
sudo update-grub #update grub after changing the grub configuration

#Setup Services to start on Boot
sudo systemctl enable thinkfan.service #Start ThinkFan service
sudo systemctl enable tlp.service #Start TLP Laptop Powersaving service
sudo ufw enable #Enable Firewall

#Remove problematic or conflicting packages
sudo apt-get remove power-profiles-daemon -y #Conflicts with TLP and should be removed on install of TLP, but not always
sudo snap remove canonical-livepatch #not used for non-LTS versions and causes error in log. Reneable for 26.04

#Turn Ubuntu Livepatch on - If on an LTS release
# sudo ua attach C1GJ3qERoroJZK8grUPweqPhwhzn1
# sudo ua enable livepatch

#Cleanup
sudo apt-get update
sudo apt-get autoremove -y
sudo apt-get clean

#Set up Gnome Extensions need to be run as user not root
gnome-extensions disable ubuntu-dock@ubuntu.com #Disable Ubuntu dock on LHS of screen
gnome-extensions disable ding@rastersoft.com #disable the Home folder on desktop which causes occasional crashes of gjs
gsettings set org.gnome.desktop.interface show-battery-percentage true #show battery percentage in top bar
wget -O ~/Downloads/bing.zip https://extensions.gnome.org/download-extension/BingWallpaper@ineffable-gmail.com.shell-extension.zip?shell_version=99.99.9
gnome-extensions install ~/Downloads/bing.zip #install bing wallpaper changer extension, version 99.99.9 should download latest version
rm -f ~/Downloads/bing.zip #-f option removes without asking confirmation
gnome-extensions enable BingWallpaper@ineffable-gmail.com #finally enable bing wallpaper

echo 'Reboot now and check Thinkfan operation - After reboot, may need to run systemctl enable thinkfan.service'

#Restart the computer:)
sudo reboot

exit 0 #Exit the script, shouldn't get here
