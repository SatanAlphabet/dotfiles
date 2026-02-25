<div align="center"><h1>SatanAlphabet's Dotfiles</h1></div>

_This setup is currently a work in progress and is subject to constant changes._

A comfy setup built on [niri](https://github.com/YaLTeR/niri "A scrollable-tiling wayland compositor"), managed by [chezmoi](https://www.chezmoi.io/). Featuring

- Coherent & dynamic theming using `matugen`
- Keyboard-driven workflow that does not sacrifice on mouse-only actions
- Modular & extensible configuration

---

## Installation

Install [chezmoi](https://www.chezmoi.io/) and proceed to install the setup using the following commands

      chezmoi init SatanAlphabet
      chezmoi apply

This will additionally run a script to install necessary packages on your first time running `chezmoi apply`.

> [!CAUTION]
> The install script only supports Arch-based distros.

> [!IMPORTANT]
> Zen requires changing `toolkit.legacyUserProfileCustomizations.stylesheets` in `about:config` to true for theming changes to apply.

---

## Software

| Type                 | Software Used         |
| :------------------- | :-------------------- |
| Compositor           | `niri`                |
| Status bar           | `waybar`              |
| Launcher             | `Rofi`                |
| Notification daemon  | `SwayNC`              |
| Lock screen          | `Hyprlock`            |
| Wallpaper management | `Waypaper`            |
| Color generation     | `Matugen`             |
| Text editor          | `Neovim` / `VSCodium` |
| Shell                | `zsh`                 |
| File picker          | `Dolphin` / `Yazi`    |
| Web browser          | `Zen Browser`         |

---

## Preview

<table>
      <th colspan=2>Desktop</th>
      <tr>
            <td><img src="https://raw.githubusercontent.com/SatanAlphabet/dotfiles/main/assets/preview.png"/></td>
            <td><img src="https://raw.githubusercontent.com/SatanAlphabet/dotfiles/main/assets/preview-2.png"/></td>
      </tr>
      <tr>
            <td><img src="https://raw.githubusercontent.com/SatanAlphabet/dotfiles/main/assets/preview-3.png"/></td>
            <td><img src="https://raw.githubusercontent.com/SatanAlphabet/dotfiles/main/assets/preview-4.png"/></td>
      </tr>
</table>

<table>
      <th colspan=3>Hyprlock</th>
      <tr>
            <td><img src="https://raw.githubusercontent.com/SatanAlphabet/dotfiles/main/assets/preview-hyprlock.png"/></td>
            <td><img src="https://raw.githubusercontent.com/SatanAlphabet/dotfiles/main/assets/preview-hyprlock-2.png"/></td>
            <td><img src="https://raw.githubusercontent.com/SatanAlphabet/dotfiles/main/assets/preview-hyprlock-3.png"/></td>
      </tr>
</table>

---

_Special thanks to [adi1090x](https://github.com/adi1090x/rofi) and [HyDE](https://github.com/HyDE-Project/HyDE) for some of the assets used in this setup._
