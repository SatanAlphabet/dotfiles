#!/usr/bin/env bash
sed -Ei "s|color_scheme_path=/|color_scheme_path=//|" "$HOME/.config/qt6ct/qt6ct.conf"
sed -Ei "s|color_scheme_path=/|color_scheme_path=//|" "$HOME/.config/qt5ct/qt5ct.conf"
sleep 5
sed -Ei "s|color_scheme_path=/+|color_scheme_path=/|" "$HOME/.config/qt6ct/qt6ct.conf"
sed -Ei "s|color_scheme_path=/+|color_scheme_path=/|" "$HOME/.config/qt5ct/qt5ct.conf"
