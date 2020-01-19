#!/bin/bash

## Copy preserving directory structure
do_copy_backup() {
  arr=("$@")
  for i in "${arr[@]}"; do 
  cp --parents -r "$i" "EXPORT"; done
}

## Move preserving directory structure
do_move_backup() {
  arr=("$@")
  for i in "${arr[@]}"; do 
  find "$i" -type d -print0 | xargs -0 -I'{}' mkdir -p './EXPORT/{}'
  find "$i" -type f -print0 | xargs -0 -I'{}' mv '{}' './EXPORT/{}'; done
}

## Array of folders and files
USER_MOVE=(Apps Documents Downloads Dropbox Pictures Programming Templates Wine/drive_c/users Zotero .config/cantata .config/dolphin-emu .config/filezilla .config/gnome-mpv .config/keepassxc .config/lutris .config/mpv .config/qBittorrent .config/QtProject .config/StardewValley .config/sublime-text-3 .config/vivaldi .fonts .local/share/data/qBittorrent .local/share/dolphin-emu .local/share/Terraria .mozilla .ssh .var/app/net.pcsx2.PCSX2/config/PCSX2 .var/app/org.DolphinEmu.dolphin-emu/config/dolphin-emu .var/app/org.DolphinEmu.dolphin-emu/data/dolphin-emu .vscode .zotero .gitconfig .gitconfig-github .gitconfig-gitlab)

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
echo "${BOLD}${RED}CAUTION!!! THERE'S NO GOING BACK!${RESET}"
echo "${BOLD}Are you sure you want to move folders/files? (y/n)${RESET}"
read YESNO

if [ "$YESNO" == "y" ]; then
  echo "${BOLD}${YELLOW}Moving...${RESET}"
  #mkdir "EXPORT"
  #do_copy_backup ${USER_MOVE[@]}
  do_move_backup ${USER_MOVE[@]}
  echo "${BOLD}${GREEN}Moving done!${RESET}"
else
  echo "${BOLD}${YELLOW}Canceled!${RESET}"; fi