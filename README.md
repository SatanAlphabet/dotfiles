# SatanAlphabet's Dotfiles

_This setup is currently a work in progress and is subject to constant changes._

A comfy setup built on [niri](https://github.com/YaLTeR/niri "A scrollable-tiling wayland compositor"), featuring coherent & dynamic theming using `matugen`, and a keyboard driven workflow that does not sacrifice on the mouse.

---

## Installation

- This setup is managed by `chezmoi`. Install [chezmoi](https://www.chezmoi.io/) and proceed to install the setup using the following commands

      chezmoi init SatanAlphabet
       chezmoi apply

  This will additionally run a script to install necessary packages on your first time running `chezmoi apply`.  
  **Note that the install script only supports Arch-based distros and is currently untested on a minimal setup.**

- `niri-git` may be required for config [`include`](https://yalter.github.io/niri/Configuration%3A-Include.html) to work.

---

## Software

| Type                 | Software Used  |
| :------------------- | :------------- |
| Compositor           | niri           |
| Application launcher | rofi           |
| Notification daemon  | swaync         |
| Lock screen          | hyprlock       |
| Wallpaper management | waypaper       |
| Dynamic theming      | matugen        |
| Shell                | zsh            |
| File picker          | Dolphin & yazi |
| Web browser          | Zen Browser    |

---

## Preview

![Setup Preview Image](https://raw.githubusercontent.com/SatanAlphabet/dotfiles/main/assets/preview.png "Desktop Preview")

![Setup Preview Image 2](https://raw.githubusercontent.com/SatanAlphabet/dotfiles/main/assets/preview_2.png "Desktop Preview /w Dolphin & fastfetch")

![Setup Preview Image 3](https://raw.githubusercontent.com/SatanAlphabet/dotfiles/main/assets/preview_3.png "Dark Mode /w swaync & Zen Browser")

![Setup Preview Image 4](https://raw.githubusercontent.com/SatanAlphabet/dotfiles/main/assets/preview_4.png "Hyprlock Preview")

---

**Special thanks to [adi1090x](https://github.com/adi1090x/rofi) and [HyDE](https://github.com/HyDE-Project/HyDE) for some of the assets used in this setup.**
