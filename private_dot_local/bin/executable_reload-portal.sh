#!/usr/bin/env zsh

dbus-update-activation-environment --systemd --all
systemctl --user import-environment QT_QPA_PLATFORMTHEME

pkill -f xdg-desktop-portal
