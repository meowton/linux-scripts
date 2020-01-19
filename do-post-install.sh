#!/bin/bash

## On which system the script will run
## Default: Ubuntu
## Compatible with: Solus, Manjaro
USER_OS="Manjaro"
FLAVOR_OS="GNOME"

## Normal: Common daily use software, such as office, image viwers, todos, image editors, etc;
## Gaming: Software related to gaming, ex: Steam, Lutris, Emulators, Wine, etc;
## Xbox controller: Adds disable_ertm=1 to modprobe.d so Xbox controllers bluetooth work
## Development: Source code editing and compiling tools, ex: clang, gcc, openjdk, qtcreator, vscode, etc;
## Extra: Post-install sugar, configurations and stuff not normaly required
## Flatpak: Disabled by default, since a reboot is needed after adding the flathub repository on Ubuntu
NORMAL_INSTALL=true
GAMING_INSTALL=true
XBOX_CONTROLLER=true
DEV_INSTALL=true
EXTRA_STUFF=true
FLATPAK_ENABLE=true

## Run the script in test mode, empty the string to apply the changes to the system (default: echo)
TEST_MODE="echo"

## Packages all distros have in common
GLOBAL_PACKAGES=(cantata cryfs filezilla flameshot flatpak gimp gtkhash inkscape krita mpd mpv neofetch qbittorrent youtube-dl)
GLOBAL_PACKAGES_GAMING=()
GLOBAL_PACKAGES_DEVELOPMENT=(clang cmake gcc gdb git lldb make)

## Solus packages
SOLUS_PACKAGES=(keepassx vscode tilix)
SOLUS_PACKAGES_GAMING=(discord)
SOLUS_PACKAGES_DEVELOPMENT=()
# Customization for Budgie flavor
SOLUS_PACKAGES_BUDGIE=(budgie-calendar-applet budgie-quicknote-applet gtkhash-nautilus-extension nautilus-folder-icons vala-panel-appmenu-budgie-desktop)

## Ubuntu packages (Check the function body for snap/flatpak/ppa installs)
UBUNTU_PACKAGES=(alacarte evince fonts-hack gnome-calculator gnome-font-viewer gnome-system-monitor gthumb keepassxc libreoffice seahorse synaptic)
UBUNTU_PACKAGES_GAMING=(steam-installer)
UBUNTU_PACKAGES_DEVELOPMENT=(clang-format cppcheck g++ openjdk-13-jdk qtcreator qt5-default)
# Customization for Budgie flavor
UBUNTU_PACKAGES_BUDGIE=(budgie-appmenu-applet gnome-software-plugin-flatpak)
UBUNTU_PACKAGES_BUDGIE_PPA=(budgie-calendar-applet budgie-pixel-saver-applet budgie-sysmonitor-applet)

## Manjaro packages (Check the function body for snap/flatpak installs)
MANJARO_PACKAGES=(alacarte evince foliate gthumb keepassxc libreoffice-still seahorse ttf-hack tilix)
MANJARO_PACKAGES_GAMING=(discord lutris steam-manjaro vulkan-icd-loader lib32-vulkan-icd-loader wine-staging winetricks zerotier-one)
MANJARO_PACKGES_DEVELOPMENT=(code cppcheck jdk-openjdk qtcreator)
# Customization for GNOME flavor
MANJARO_PACKAGES_GNOME=(gnome-calculator gnome-font-viewer gnome-system-monitor nemo nemo-bulk-rename nemo-fileroller nemo-preview gtkhash-nemo)

## echo color
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
MAGENTA=$(tput setaf 5)
RESET=$(tput sgr0)
BOLD=$(tput bold)

## Array functions
do_install_array() {
case $USER_OS in
"Solus")
  arr=("$@")
  for i in "${arr[@]}"; do
    sudo eopkg it "$i" -y
  done
  ;;

"Ubuntu")
  arr=("$@")
  for i in "${arr[@]}"; do
    sudo apt install "$i" -y
  done
  ;;

"Manjaro")
  arr=("$@")
  for i in "${arr[@]}"; do
    yes | sudo pacman -Syu "$i"
  done
  ;;

*)
  echo "${BOLD}${YELLOW}Unable to install.${RESET}"
  ;;
esac
}

do_remove_array() {
case $USER_OS in
"Solus")
  arr=("$@")
  for i in "${arr[@]}"; do
    sudo eopkg rm "$i" -y
  done
  ;;

"Ubuntu")
  arr=("$@")
  for i in "${arr[@]}"; do
    sudo apt remove "$i" -y
  done
  ;;

"Manjaro")
  arr=("$@")
  for i in "${arr[@]}"; do
    yes | sudo pacman -Rsu "$i"
  done
  ;;

*)
  echo "${BOLD}${YELLOW}Unable to remove.${RESET}"
  ;;
esac
}

## OS functions
do_update() { # Call the system updater, distro based
case $USER_OS in
"Solus")
  sudo eopkg up -y
  ;;

"Ubuntu")
  sudo apt update -y && sudo apt upgrade -y
  ;;

"Manjaro")
  yes | sudo pacman -Syu
  ;;

*)
  echo "${BOLD}${YELLOW}Unable to update.${RESET}"
  ;;
esac
}

do_install_global() {
  do_install_array ${GLOBAL_PACKAGES[@]}
}

do_install_global_gaming() {
  do_install_array ${GLOBAL_PACKAGES_GAMING[@]}

  # XBOX controller bluetooth fix
  if [ "$XBOX_CONTROLLER" == "true" ]; then
    cd /etc/
    sudo mkdir 'modprobe.d'
    echo 'options bluetooth disable_ertm=1' | sudo tee -a /etc/modprobe.d/bluetooth.conf
    cd ~
  fi
}

do_install_global_dev() {
  do_install_array ${GLOBAL_PACKAGES_DEVELOPMENT[@]}
}

## Solus functions
do_install_solus() {
  do_install_array ${SOLUS_PACKAGES[@]}
}
do_install_solus_gaming() {
  do_install_array ${SOLUS_PACKAGES_GAMING[@]}
}
do_install_solus_development() {
  do_install_array ${SOLUS_PACKAGES_DEVELOPMENT[@]}
}
do_install_solus_budgie() {
  do_install_array ${SOLUS_PACKAGES_BUDGIE[@]}
}

## Ubuntu functions
do_install_ubuntu() {
  do_install_array ${UBUNTU_PACKAGES[@]}

  ## Install snaps
  # Discord  (https://snapcraft.io/discord)
  sudo snap install discord

  ## Manual installs
  # Yacreader
  sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/selmf/xUbuntu_19.10/ /' > /etc/apt/sources.list.d/home:selmf.list"
  get -nv https://download.opensuse.org/repositories/home:selmf/xUbuntu_19.10/Release.key -O Release.key
  sudo apt-key add - < Release.key
  sudo apt-get update -y
  sudo apt-get install yacreader -y
  
  # Joplin (https://joplinapp.org/)
  wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash
  
  if [ "$FLATPAK_ENABLE" == "true" ]; then
    # Flathub (https://flatpak.org/setup/)
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    # Foliate (https://flathub.org/apps/details/com.github.johnfactotum.Foliate)
    flatpak install flathub com.github.johnfactotum.Foliate -y
    # Zotero (https://flathub.org/apps/details/org.zotero.Zotero)
    flatpak install flathub org.zotero.Zotero -y
  fi
}

do_install_ubuntu_gaming() {
  do_install_array ${UBUNTU_PACKAGES_GAMING[@]}

  # Lutris (https://lutris.net)
  sudo add-apt-repository ppa:lutris-team/lutris -y && sudo apt update -y
  sudo apt-get install lutris -y

  # Wine https://wiki.winehq.org/Ubuntu
  sudo dpkg --add-architecture i386
  wget -nc https://dl.winehq.org/wine-builds/winehq.key
  sudo apt-key add winehq.key
  sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ eoan main' && sudo apt update -y
  sudo apt install --install-recommends winehq-staging -y

  # ZeroTier
  curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg --import &&
    if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | sudo bash; fi
  sudo systemctl stop zerotier-one
  sudo systemctl disable zerotier-one
  
  ## Snaps
  # Steam Linux Integration (https://snapcraft.io/solus-runtime-gaming) (DEPRECATED!!!)
  #sudo snap install --edge solus-runtime-gaming
  #sudo snap install --devmode --edge linux-steam-integration

  if [ "$FLATPAK_ENABLE" == "true" ]; then
    ## Flathub (https://flatpak.org/setup/) (Needed to install the following flatpaks)
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    # PCSX2 (https://flathub.org/apps/details/net.pcsx2.PCSX2)
    flatpak install flathub net.pcsx2.PCSX2 -y
    # Dolphin Emulator (https://flathub.org/apps/details/org.DolphinEmu.dolphin-emu)
    flatpak install flathub org.DolphinEmu.dolphin-emu -y
    # RetroArch (https://flathub.org/apps/details/org.libretro.RetroArch)
    flatpak install flathub org.libretro.RetroArch -y
  fi
}

do_install_ubuntu_dev() {
  do_install_array ${UBUNTU_PACKAGES_DEVELOPMENT[@]}

  ## Snaps
  # Sublime Text (https://snapcraft.io/sublime-text)
  sudo snap install sublime-text --classic
  # Visual Studio Code (https://snapcraft.io/code)
  sudo snap install code --classic
  # Node.js (channel flag indicates which version to install)
  sudo snap install node --classic --channel=13
  # HUGO static website builder (extended channel adds SASS support)
  sudo snap install hugo --channel=extended
  # Fix NPM prepend node path
  npm config set scripts-prepend-node-path auto
  # SASS (Node.js implementation)
  sudo npm install -g sass
}

do_install_ubuntu_budgie() {
  ## Customization for Ubuntu Budgie
  sudo add-apt-repository ppa:ubuntubudgie/backports -y && sudo apt update -y
  # sudo add-apt-repository --remove ppa:ubuntubudgie/backports -y && sudo apt update
  do_install_array ${UBUNTU_PACKAGES_BUDGIE_PPA[@]}
  do_install_array ${UBUNTU_PACKAGES_BUDGIE[@]}
}

do_install_manjaro() {
  do_install_array ${MANJARO_PACKAGES[@]}
  
  if [ "$FLATPAK_ENABLE" == "true" ]; then
    # Zotero (https://flathub.org/apps/details/org.zotero.Zotero)
    flatpak install flathub org.zotero.Zotero -y
  fi
}

do_install_manjaro_gaming() {
  do_install_array ${MANJARO_PACKAGES_GAMING[@]}

  sudo systemctl stop zerotier-one
  sudo systemctl disable zerotier-one

  if [ "$FLATPAK_ENABLE" == "true" ]; then
    # PCSX2 (https://flathub.org/apps/details/net.pcsx2.PCSX2)
    flatpak install flathub net.pcsx2.PCSX2 -y
    # Dolphin Emulator (https://flathub.org/apps/details/org.DolphinEmu.dolphin-emu)
    flatpak install flathub org.DolphinEmu.dolphin-emu -y
    # RetroArch (https://flathub.org/apps/details/org.libretro.RetroArch)
    flatpak install flathub org.libretro.RetroArch -y
  fi
}

do_install_manjaro_development() {
  do_install_array ${MANJARO_PACKGES_DEVELOPMENT[@]}
  
  ## Snaps
  # Sublime Text (https://snapcraft.io/sublime-text)
  sudo snap install sublime-text --classic
  # Node.js (channel flag indicates which version to install)
  sudo snap install node --classic --channel=13
  # HUGO static website builder (extended channel adds SASS support)
  sudo snap install hugo --channel=extended
  # SASS (Node.js implementation)
  sudo npm install -g sass
  # Fix NPM prepend node path
  npm config set scripts-prepend-node-path auto
}

do_install_manjaro_gnome() {
  do_install_array ${MANJARO_PACKAGES_GNOME[@]}

  # Sets Nemo as default file browser (https://wiki.archlinux.org/index.php/Nemo)
  xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
  # Sets Tilix as default Nemo terminal
  gsettings set org.cinnamon.desktop.default-applications.terminal exec tilix

  # Fixes missing symbols
  yes | sudo pacman -Syu noto-fonts-cjk noto-fonts-emoji noto-fonts
}

do_install_extras() {
  # Sublime block on hosts (for license activation)
  # <https://gist.github.com/angrycoffeemonster/4f05896d233baf6bd9b0894e30b5fa63>
  # <https://gist.github.com/cantgis/fb17ab10287c512379fbefad7fa5be1c>
  echo '# Sublime Text 3
  127.0.0.1 www.sublimetext.com
  127.0.0.1 sublimetext.com
  127.0.0.1 sublimehq.com
  127.0.0.1 license.sublimehq.com
  127.0.0.1 telemetry.sublimehq.com
  127.0.0.1 45.55.255.55
  127.0.0.1 45.55.41.223
  0.0.0.0 license.sublimehq.com
  0.0.0.0 45.55.255.55
  0.0.0.0 45.55.41.223' | sudo tee -a /etc/hosts
}

## Update the system
echo "Running post install for ${MAGENTA}${BOLD}$USER_OS${RESET}"
echo "${BOLD}${YELLOW}Updating the system...${RESET}"
$TEST_MODE do_update
echo "${BOLD}${GREEN}Updating done!${RESET}"

## Install programs
if [ "$NORMAL_INSTALL" == "true" ]; then
  echo "${BOLD}${YELLOW}Installing shared software...${RESET}"
  $TEST_MODE do_install_global
fi

if [ "$GAMING_INSTALL" == "true" ]; then
  echo "${BOLD}${YELLOW}Installing shared gaming software...${RESET}"
  $TEST_MODE do_install_global_gaming
fi

if [ "$DEV_INSTALL" == "true" ]; then
  echo "${BOLD}${YELLOW}Installing shared development software...${RESET}"
  $TEST_MODE do_install_global_dev
fi

echo "${BOLD}${GREEN}Done!${RESET}"

## Customization per OS
case $USER_OS in
"Solus")
  if [ "$NORMAL_INSTALL" == "true" ]; then
    echo "${BOLD}${YELLOW}Installing Solus software...${RESET}"
    $TEST_MODE do_install_solus

    if [ "$FLAVOR_OS" == "Budgie" ]; then
      echo "${BOLD}${YELLOW}Installing Budgie software...${RESET}"
      $TEST_MODE do_install_solus_budgie
    fi
  fi
  ;;

"Ubuntu")
  if [ "$NORMAL_INSTALL" == "true" ]; then
    echo "${BOLD}${YELLOW}Installing Ubuntu software...${RESET}"
    $TEST_MODE do_install_ubuntu

    if [ "$FLAVOR_OS" == "Budgie" ]; then
      echo "${BOLD}${YELLOW}Installing Budgie software...${RESET}"
      $TEST_MODE do_install_ubuntu_budgie
    fi
  fi

  if [ "$GAMING_INSTALL" == "true" ]; then
    echo "${BOLD}${YELLOW}Installing gaming software...${RESET}"
    $TEST_MODE do_install_ubuntu_gaming
  fi

  if [ "$DEV_INSTALL" == "true" ]; then
    echo "${BOLD}${YELLOW}Installing development software...${RESET}"
    $TEST_MODE do_install_ubuntu_dev
  fi
  ;;
  
"Manjaro")
  if [ "$NORMAL_INSTALL" == "true" ]; then
    echo "${BOLD}${YELLOW}Installing Manjaro software...${RESET}"
    $TEST_MODE do_install_manjaro

    if [ "$FLAVOR_OS" == "GNOME" ]; then
      echo "${BOLD}${YELLOW}Installing Gnome software...${RESET}"
      $TEST_MODE do_install_manjaro_gnome
    fi
  fi

  if [ "$GAMING_INSTALL" == "true" ]; then
    echo "${BOLD}${YELLOW}Installing gaming software...${RESET}"
    $TEST_MODE do_install_manjaro_gaming
  fi

  if [ "$DEV_INSTALL" == "true" ]; then
    echo "${BOLD}${YELLOW}Installing development software...${RESET}"
    $TEST_MODE do_install_manjaro_development
  fi
  ;;

*)
  echo "${BOLD}${YELLOW}Unknown input, try again.${RESET}"
  ;;
esac

## Extra stuff
if [ "$EXTRA_STUFF" == "true" ]; then
  echo "${BOLD}${YELLOW}Installing extra stuff...${RESET}"
  $TEST_MODE do_install_extras
fi

echo "${BOLD}${GREEN}All done!${RESET}"
