#!/bin/bash
read -p "Rename files and directories to lower-case? (y/N)" x
if [ "$x" = "y" ]; then
    find . -type d | \
    while read oname; do
        nname=$(echo "${oname}" | tr [:upper:] [:lower:])
        mv -v "${oname}" "${nname}"
    done
    find . -type f | \
    while read oname; do
        nname=$(echo "${oname}" | tr [:upper:] [:lower:])
        mv -v "${oname}" "${nname}"
    done
fi