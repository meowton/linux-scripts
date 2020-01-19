#!/bin/bash

## echo color
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
MAGENTA=`tput setaf 5`
RESET=`tput sgr0`
BOLD=`tput bold`

## Flathub (https://flatpak.org/setup/)
#echo "${BOLD}${YELLOW}Adding Flathub repository...${RESET}"
#flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "${BOLD}${YELLOW}Installing programs...${RESET}"
# PCSX2 (https://flathub.org/apps/details/net.pcsx2.PCSX2)
#flatpak install flathub net.pcsx2.PCSX2 -y
# Dolphin Emulator (https://flathub.org/apps/details/org.DolphinEmu.dolphin-emu)
#flatpak install flathub org.DolphinEmu.dolphin-emu -y
# RetroArch (https://flathub.org/apps/details/org.libretro.RetroArch)
#flatpak install flathub org.libretro.RetroArch -y
# Foliate (https://flathub.org/apps/details/com.github.johnfactotum.Foliate)
flatpak install flathub com.github.johnfactotum.Foliate -y
# Zotero (https://flathub.org/apps/details/org.zotero.Zotero)
flatpak install flathub org.zotero.Zotero -y
# Dropbox (https://flathub.org/apps/details/com.dropbox.Client)
#flatpak install flathub com.dropbox.Client -y
echo "${BOLD}${GREEN}Installation done!${RESET}"