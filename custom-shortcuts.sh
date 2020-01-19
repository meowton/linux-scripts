#!/bin/bash
## Enables light night toggle ('Primary>Menu' = CTRL + MENU, '<Shift>Menu' = SHIFT + MENU)
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'Night Light Toggle'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'<Primary>Menu'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'bash -c \"if [[ \$(gsettings get org.gnome.settings-daemon.plugins.color night-light-enabled) == \"true\" ]]; then gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false; else gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true; fi\"'"

## Disable built-in screenshot tool and enables Flameshot as default
gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot '[]'
gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot '[]'
gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot-clip '[]'
gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot-clip '[]'
gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot '[]'
gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot-clip '[]'

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "'Flameshot'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "'Print'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "'flameshot gui'"
