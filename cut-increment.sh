#!/bin/bash

## echo color
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)
BOLD=$(tput bold)

mkdir "toRename"
cd ./toRename
echo "${BOLD}${YELLOW}What do you want to do?${RESET}"
echo "${BOLD}1 - Cut numebers from the of files names."
echo "2 - Increment counter to the beginning of files names.${RESET}"
read OPTION

case $OPTION in

  1)
    ## Cut filenames at the beginning of a file
    echo "${BOLD}${YELLOW}How many characters? (Index starts at 1)${RESET} ${BOLD}${RED}ATTENTION: THERE'S NO GOING BACK!!!${RESET}"
    read CUT
    # for f in *; do mv "$f" "${f:$CUT}"; done
    for fname in *; do mv "$fname" "$(echo "$fname" | sed -r "s/[0-9]{${CUT}}//")" ; done
    echo "${BOLD}${GREEN}Done!${RESET}"
    ;;

  2)
    ## Increment counter to the beginning of a file name (sorted by modification date)
    echo "${BOLD}${YELLOW}Start at what number? (Index starts at 0)${RESET} ${BOLD}${RED}ATTENTION: THERE'S NO GOING BACK!!!${RESET}"
    read START
    # Use ls -tr for reverse
    n=$START-1; ls -tr | while read i; do n=$((n+1)); mv -- "$i" "$(printf '%04d' "$n")"_"$i"; done
    echo "${BOLD}${GREEN}Done!${RESET}"
    ;;

  *)
    echo "${BOLD}${YELLOW}Unknown input, try again.${RESET}"
    ;;
esac