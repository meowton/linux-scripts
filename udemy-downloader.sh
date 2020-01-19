#!/bin/bash

login=name@mail.com
password=password

# Insert course URL. Ex: https://www.udemy.com/somecourse
course_url=""
# The size of the course playlist
playlist_size=999
# How many passes are need to download. Divide playlist_size by 11.
pass_needed=90
# How many passes was already done. Default 1 if none.
pass_done=0
# Playlist position to start downloading.
playlist_start=0
# Last playlist position to download.
playlist_end=999

# Set if download is completed or not.
COMPLETED=false
# Set the time limit to wait between downloads, in minutes.
download_wait=5

if [ "$COMPLETED" = false ]; then
  while [ $pass_done -le $pass_needed ]; do
    youtube-dl -u $login -p $password -o '~/Videos/%(playlist)s/%(chapter_number)s - %(chapter)s/%(title)s.%(ext)s' -f 'bestvideo[height<=720]+bestaudio/best[height<=720]' --playlist-start $playlist_start --playlist-end $playlist_end $course_url
    let playlist_start+=11
    echo "Playlist start is at position:" $playlist_start "."
    let playlist_end+=11
    echo "Playlist end is at position:" $playlist_end "."
    let pass_done+=1
    echo "Done pass" $pass_done "of" $pass_needed "needed."
    if [ "$pass_done" -ge "$pass_needed" ]; then
      COMPLETED=true
      echo "Finished downloading!"
      exit 0
    fi
    # sleep $download_wait
    # echo "Waiting" $download_wait "minute/s before continuing..."
  done
fi
