#!/bin/bash

#Add Aditional Repositories
sudo add-apt-repository ppa:thierry-f/fork-michael-gruz #Repository for driver for MX310 scanner driver

#Get Updates
sudo apt-get update  # To get the latest package lists
sudo apt-get upgrade -y

#Enable Flatpak apps to be installed
sudo apt-get install flatpak -y
sudo apt-get install gnome-software-plugin-flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#Install SNAP Packages
sudo snap install code --classic
sudo snap install skype
sudo snap install brave

#Install Flatpak Packages
sudo flatpak install flathub org.gpodder.gpodder -y
sudo flatpak install flathub com.github.geigi.cozy -y
sudo flatpak install flathub org.keepassxc.KeePassXC -y
sudo flatpak install flathub org.videolan.VLC -y
sudo flatpak install flathub org.audacityteam.Audacity -y
sudo flatpak install flathub org.gnome.Extensions -y #Enable and manage Gnome shell extensions
sudo flatpak install flathub fr.handbrake.ghb -y
sudo flatpak install flathub com.github.iwalton3.jellyfin-media-player -y
sudo flatpak install flathub org.gnome.EasyTAG -y

#Install From Repo
sudo apt-get install synaptic -y #GUI package manager and app installer
sudo apt-get install gufw -y #Fireweall GUI
sudo apt-get install libdvd-pkg -y #Then run sudo dpkg-reconfigure libdvd-pkg to build the package
sudo apt-get install ubuntu-restricted-extras -y #Includes Lame encoder
sudo apt-get install nautilus-admin -y #Admin permissions extension for file manager
sudo apt-get install git -y
sudo apt-get install tlp -y #Laptop power saving tools, check using sudo tlp-stat -s
sudo apt-get install tlp-rdw -y #Used by TLP to control Bluetooth and Wifi radios
sudo apt-get install thinkfan -y #Helps control the fan and enables disengaged full speed
sudo apt-get install lm-sensors -y #Module to read the CPU core temperatures, used by Thinkfan
sudo apt-get install printer-driver-gutenprint -y #MX310 printer driver
sudo apt-get install libsane-common -y #Common Scanner library, should already be installed
sudo apt-get install scangearmp2 -y #MX310 Scanner driver
sudo apt-get install intel-gpu-tools -y #Run intel_gpu_top to check vaapi use
sudo apt-get install intel-media-driver -y #Vaapi driver for intel UHD620 graphic card
sudo apt-get install vainfo -y #Run vainfo to check that vaapi driver is installed
sudo apt-get install gnome-tweaks -y
sudo apt-get install ffmpeg -y #Needed to convert Audible files to .m4a
sudo apt-get install gnome-clocks -y #World clocks for Gnome Desktop
sudo apt-get install pavucontrol -y #Audio routing for audacity recording from browser etc
sudo apt-get install clamav -y #Command line Virus scanning. sudo freshclam to update then scan with clamscan -r -i --exclude-dir="^/sys" --bell /

#Download and intsall deb Files, Clean then Delete
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P ~/Downloads
sudo dpkg -i ~/Downloads/google-chrome-stable_current_amd64.deb
sudo apt-get -f -y install
sudo rm -f ~/Downloads/google-chrome-stable_current_amd64.deb
sudo wget https://launchpad.net/veracrypt/trunk/1.25.4/+download/veracrypt-console-1.25.4-Ubuntu-20.04-amd64.deb -P ~/Downloads
sudo dpkg -i ~/Downloads/veracrypt-console-1.25.4-Ubuntu-20.04-amd64.deb
sudo rm -f ~/Downloads/veracrypt-console-1.25.4-Ubuntu-20.04-amd64.deb
sudo dkpg -i ~/software-install/nordvpn-release_1.0.0_all.deb #this installs the certificate and repository
sudo apt-get update -y
sudo apt-get install nordvpn -y
sudo usermod -aG nordvpn $USER #after restart run nordvpn login and copy URL to browser
nordvpn whitelist add subnet 192.168.8.0/24 #allow local connections when VPN is connected

#Copy Configuration Files
sudo cp ~/software-install/BCM20702A1-0a5c-21e6.hcd /lib/firmware/brcm #Add missing Bluetooth firmware
sudo cp ~/software-install/tlp.conf /etc #Set TLP to remember wifi and bluetooth status on reboot
sudo cp ~/software-install/i915firmware/*.bin /lib/firmware/i915 #Copy missing i915 firmwares to remove warning
sudo cp ~/software-install/sysctl.conf  /etc #Set swappiness of SSD to 10
sudo cp ~/software-install/thinkfan.yaml /etc #Thinkfan configuration for version 1.x onwards
sudo cp ~/software-install/thinkpad_acpi.conf /etc/modprobe.d #Set Thinkfan to load at boot
sudo cp ~/software-install/thinkfan /etc/default #Start Thinkfan
sudo cp ~/software-install/dll.conf /etc/sane.d #Enable Cannon Scanner
sudo cp ~/software-install/freshclam.conf /etc/clamav/freshclam.conf #Disable automatic updates of clamav change checks=24 to checks=0
sudo cp ~/software-install/OpenVPNConfigs/*.nmconnection /etc/NetworkManager/system-connections #Copy OpenVPN configurations
sudo cp ~/software-install/ian /var/lib/AccountsService/icons #Copy user profile picture
sudo update-initramfs -u -k all #Update firmware modules copied above

#Configure application packages
sudo dpkg-reconfigure libdvd-pkg #Build DVD package
sudo flatpak override org.gpodder.gpodder --filesystem /media/ #For gPodder Set the device synchronisation folder to /media/ian/CLIP JAM/Podcasts

#Setup Services to start on Boot
sudo sensors-detect --auto #Thinkfan detect sensors automatic mode using coretemp and acptiz modules
sudo systemctl enable thinkfan.service #Start ThinkFan service
sudo systemctl enable tlp.service #Start TLP Laptop Powersaving service
sudo ufw enable #Enable Firewall

#Remove problematic or conflicting packages
sudo apt-get remove gstreamer1.0-vaapi -y #Should be installed with Ubuntu-Restricted_Extras, conflicts with video playback as uses 10 bit
sudo apt-get remove power-profiles-daemon -y #Conflicts with TLP and should be removed on install of TLP, but not always

#Turn Ubuntu Livepatch on
sudo ua attach C1GJ3qERoroJZK8grUPweqPhwhzn1
sudo ua enable livepatch

#Cleanup
sudo apt-get update
sudo apt-get autoremove -y
sudo apt-get clean

#Set up Gnome Extensions need to be run as user not root
gnome-extensions enable BingWallpaper@ineffable-gmail.com #Enable Bing Wallpaper
gnome-extensions disable ubuntu-dock@ubuntu.com #Disable Ubuntu dock on LHS of screen
gsettings set org.gnome.desktop.interface show-battery-percentage true #show battery percentage in top bar

echo 'Reboot now and check Thinkfan operation - After reboot, may need to run systemctl enable thinkfan.service'

#Restart the computer:)
sudo reboot

exit 0 #Exit the script, shouldn't get here
