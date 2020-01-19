#!/bin/bash

## echo color
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)
BOLD=$(tput bold)

mkdir "toCompress"
cd ./toCompress
echo "${BOLD}${YELLOW}To which format do you want to compress all folders in the directory? (Only folders will be compressed!)${RESET}"
echo "${BOLD}1${RESET}: 7z; ${BOLD}2${RESET}: zip; ${BOLD}3${RESET}: tar; ${BOLD}4${RESET}: tar.gz; ${BOLD}5${RESET} tar.xz; ${BOLD}6${RESET}: tar.bz2${RESET} (Ex: Input 1 will select 7z)"
read OPTION

case $OPTION in
1)
  ## 7z
  echo "${BOLD}${YELLOW}Compressing to 7z...${RESET}"
  for i in */; do 7z a "${i%/}.7z" "$i"; done
  ;;

2)
  ## zip
  echo "${BOLD}${YELLOW}Compressing to zip...${RESET}"
  for i in */; do zip -r "${i%/}.zip" "$i"; done
  ;;

3)
  ## tar
  echo "${BOLD}${YELLOW}Compressing to tar...${RESET}"
  for i in */; do tar -cvf "${i%/}.tar" "$i"; done
  ;;

4)
  ## tar.gz
  echo "${BOLD}${YELLOW}Compressing to tar.gz...${RESET}"
  for i in */; do tar -czvf "${i%/}.tar.gz" "$i"; done
  ;;

5)
  ## tar.xz
  echo "${BOLD}${YELLOW}Compressing to tar.xz...${RESET}"
  for i in */; do tar -cJvf "${i%/}.tar.xz" "$i"; done
  ;;

6)
  ## tar.bz2
  echo "${BOLD}${YELLOW}Compressing to tar.bz2...${RESET}"
  for i in */; do tar -cjvf "${i%/}.tar.bz2" "$i"; done
  ;;

*)
  echo "${BOLD}${YELLOW}Unknown input, try again.${RESET}"
  ;;
esac
