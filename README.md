# 🌸 Dotfiles

Mi configuración de **Arch Linux + Hyprland**, con una paleta propia llamada **Sakura**.

![Escritorio](assets/fastfetch.png)

## Paleta Sakura

| Color | Hex | Uso |
|---|---|---|
| ![#1a1622](https://img.shields.io/badge/%20-1a1622?style=flat-square&color=1a1622) | `#1a1622` | Fondo |
| ![#f0e6e0](https://img.shields.io/badge/%20-f0e6e0?style=flat-square&color=f0e6e0) | `#f0e6e0` | Texto |
| ![#c9a8d4](https://img.shields.io/badge/%20-c9a8d4?style=flat-square&color=c9a8d4) | `#c9a8d4` | Lila (acento principal) |
| ![#b388c4](https://img.shields.io/badge/%20-b388c4?style=flat-square&color=b388c4) | `#b388c4` | Lila oscuro |
| ![#e8b88a](https://img.shields.io/badge/%20-e8b88a?style=flat-square&color=e8b88a) | `#e8b88a` | Dorado |
| ![#d47a9a](https://img.shields.io/badge/%20-d47a9a?style=flat-square&color=d47a9a) | `#d47a9a` | Rosa |
| ![#a8c9a0](https://img.shields.io/badge/%20-a8c9a0?style=flat-square&color=a8c9a0) | `#a8c9a0` | Verde |

## Componentes

| Qué | Cuál | Carpeta | Destino |
|---|---|---|---|
| Distro | Arch Linux | — | — |
| Compositor | [Hyprland](https://hyprland.org) (+ hypridle, hyprlock, hyprpaper) | [`hypr/`](hypr) | `~/.config/hypr/` |
| Barra | [Waybar](https://github.com/Alexays/Waybar) | [`waybar/`](waybar) | `~/.config/waybar/` |
| Lanzador | [Wofi](https://hg.sr.ht/~scoopta/wofi) | [`wofi/`](wofi) | `~/.config/wofi/` |
| Terminal | [kitty](https://sw.kovidgoyal.net/kitty/) | [`kitty/`](kitty) | `~/.config/kitty/` |
| Shell | zsh + Oh My Zsh + [Powerlevel10k](https://github.com/romkatv/powerlevel10k) | [`zsh/`](zsh) | `~/.zshrc`, `~/.p10k.zsh` |
| Notificaciones | [SwayNC](https://github.com/ErikReider/SwayNotificationCenter) | [`swaync/`](swaync) | `~/.config/swaync/` |
| Scratchpads | [pyprland](https://github.com/hyprland-community/pyprland) | [`pypr/`](pypr) | `~/.config/pypr/` |
| Editor | [Zed](https://zed.dev) (tema Sakura propio) | [`zed/`](zed) | `~/.config/zed/` |
| Fetch | [fastfetch](https://github.com/fastfetch-cli/fastfetch) | [`fastfetch/`](fastfetch) | `~/.config/fastfetch/` |
| Monitor | [btop](https://github.com/aristocratos/btop) (tema Sakura propio) | [`btop/`](btop) | `~/.config/btop/` |
| PDF | [Zathura](https://pwmt.org/projects/zathura/) | [`zathura/`](zathura) | `~/.config/zathura/` |
| Wallpaper | [`wallpapers/`](wallpapers) | [`wallpapers/`](wallpapers) | `~/.config/wallpapers/` |

> El módulo del gato de la barra es [runcat-text](https://github.com/bzglve/runcat-text) de **bzglve** (incluido en `waybar/modules/`).

## Capturas

### btop — tema Sakura

![btop](assets/btop.png)

### Wofi

![wofi](assets/wofi.png)

## Instalación

```bash
git clone git@github.com:hxst1/Dotfiles.git
cd Dotfiles

# Copia lo que quieras a ~/.config/, por ejemplo:
cp -r hypr kitty waybar wofi swaync fastfetch btop zathura pypr ~/.config/

# zsh va en $HOME
cp zsh/.zshrc zsh/.p10k.zsh ~/
```

> ⚠️ Las configs asumen rutas de mi máquina (`/home/eya`) en algunos scripts; revísalas antes de usarlas.

Extras que usa el `.zshrc`: `eza`, `bat`, `zoxide`, `fnm`, `fzf`, `fd`, `lazygit`, `direnv` y los plugins `zsh-autosuggestions` / `zsh-syntax-highlighting`.

## Legacy

- [`legacy/alacritty/`](legacy/alacritty) — mi antigua config de **Alacritty** (época macOS). **Desactualizada**, la conservo solo como archivo histórico. Ahora uso kitty.
