#!/bin/bash

## echo color
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
RESET=`tput sgr0`
BOLD=`tput bold`

## Do stuff
cd ~
ls
echo "Opened ${BOLD}HOME${RESET} folder!"
echo "${BOLD}Do you want to backup? (y/n)${RESET}"
read YESNO

if [ "$YESNO" == "y" ]; then
  echo "${BOLD}${YELLOW}Backuping...${RESET}"
  backup_date=$(date +'%m-%d-%Y')
  7z a BACKUP_${backup_date}.7z -p -mhe=on Apps Documents Downloads Dropbox Pictures Programming Templates Wine/drive_c/users Zotero .config/cantata .config/dolphin-emu .config/filezilla .config/gnome-mpv .config/keepassxc .config/lutris .config/mpv .config/qBittorrent .config/QtProject .config/StardewValley .config/sublime-text-3 .config/vivaldi .fonts .local/share/data/qBittorrent .local/share/dolphin-emu .local/share/Terraria .mozilla .ssh .var/app/net.pcsx2.PCSX2/config/PCSX2 .var/app/org.DolphinEmu.dolphin-emu/config/dolphin-emu .var/app/org.DolphinEmu.dolphin-emu/data/dolphin-emu .vscode .zotero .gitconfig .gitconfig-github .gitconfig-gitlab
  echo "${BOLD}${GREEN}Done!${RESET}"
else
  echo "${BOLD}${YELLOW}Canceled!${RESET}"; fi