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

## Software

| Type | Software Used |
| :----- | :----- |
| Compositor | niri |
| Application launcher | rofi |
| Notification daemon | swaync |
| Lock screen | hyprlock |
| Shell | zsh /w Oh My Zsh |
| File picker | Dolphin |
| Web browser | Zen Browser |

---

## Preview

![Setup Preview Image](https://raw.githubusercontent.com/SatanAlphabet/dotfiles/main/assets/preview.png "Desktop Preview")

![Setup Preview Image 2](https://raw.githubusercontent.com/SatanAlphabet/dotfiles/main/assets/preview_2.png "Desktop Preview /w Dolphin & fastfetch")

![Setup Preview Image 3](https://raw.githubusercontent.com/SatanAlphabet/dotfiles/main/assets/preview_3.png "Dark Mode /w swaync & Zen Browser")
