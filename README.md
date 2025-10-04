# SatanAlphabet's Dotfiles

*This setup is currently a work in progress and is subject to constant changes.*

A comfy setup built on [niri](https://github.com/YaLTeR/niri "A scrollable-tiling wayland compositor"), featuring coherent & dynamic theming using `matugen`, and a keyboard driven workflow that does not sacrifice on the mouse.

---

## Installation
- **`install.sh` IS UNTESTED. USE AT YOUR OWN RISK.**
- `niri-git` may be required for config `includes` to work.
- a post-hook command is required in `~/.config/waypaper/config.ini` for dynamic theming to work properly

		[Settings]
  		post_command = ~/.scripts/wallswitch.sh $wallpaper
   
---

## Preview

![Setup Preview Image](https://raw.githubusercontent.com/SatanAlphabet/dotfiles/main/assets/preview.png "Desktop Preview")
