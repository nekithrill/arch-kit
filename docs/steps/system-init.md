# 01 - System Initialization

This layer sets up the foundational user environment on top of a fresh Arch Linux installation. It installs core utilities, configures the shell, sets up the AUR helper, and links base dotfiles.

> [!NOTE]
> This step assumes you have completed [00 — Arch Installation](./00-arch-install.md) and are logged in as a normal user with `sudo` privileges.

## What This Layer Does

- Updates the Arch Linux keyring
- Installs `yay` as the AUR helper
- Installs base packages
- Sets up `zsh` with `oh-my-zsh`
- Links base dotfiles and configs

## Automated Setup

```bash
./01-system-init/install.sh
```

## Manual Setup

### 1. Update Keyring

Before installing anything, update the package signing keys to avoid signature errors:

```bash
sudo pacman -Sy archlinux-keyring
```

### 2. Install yay

`yay` is an AUR helper that extends `pacman` with support for user-contributed packages:

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si --noconfirm
cd .. && rm -rf yay
```

### 3. Install Base Packages

**System core:** `base-devel`, `wget`, `openssh`, `unzip`, `zip`, `p7zip`, `unrar`, `man-db`, `man-pages`

**File system:** `dosfstools`, `exfatprogs`, `udisks2`, `smartmontools`

**Shell:** `zsh`

**Fonts:** `ttf-jetbrains-mono-nerd`, `noto-fonts`, `noto-fonts-emoji`, `noto-fonts-cjk`, `fontconfig`

**CLI utilities:** `eza`, `bat`, `fd`, `ripgrep`, `fzf`, `btop`, `jq`, `bc`

**Media:** `mpv`, `imv`

**System utilities:** `gnome-keyring`, `xdg-user-dirs`, `xdg-desktop-portal-gtk`, `xdg-utils`, `upower`, `timeshift`

```bash
sudo pacman -S --needed base-devel wget openssh unzip zip p7zip unrar \
    man-db man-pages dosfstools exfatprogs udisks2 smartmontools \
    zsh ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji noto-fonts-cjk fontconfig \
    eza bat fd ripgrep fzf btop jq bc mpv imv \
    gnome-keyring xdg-user-dirs xdg-desktop-portal-gtk xdg-utils upower timeshift
```

### 4. Install oh-my-zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

### 5. Set zsh as Default Shell

```bash
sudo chsh -s "$(command -v zsh)" "$USER"
```

> [!NOTE]
> Log out and back in for the shell change to take effect.

### 6. Link Dotfiles

```bash
./01-system-init/install.sh --links-only
```

> [!TIP]
> The automated script handles symlinking automatically. If running manually, link `config/` to `~/.config/` and `home/` dotfiles to `~/`.

## Installed CLI Tools Reference

| Tool      | Replaces | Description                                   |
| --------- | -------- | --------------------------------------------- |
| `eza`     | `ls`     | Modern file listing with icons and git status |
| `bat`     | `cat`    | Syntax-highlighted file viewer                |
| `fd`      | `find`   | Fast and user-friendly file finder            |
| `ripgrep` | `grep`   | Extremely fast text search                    |
| `fzf`     | —        | Fuzzy finder for terminal                     |
| `btop`    | `top`    | Resource monitor with a clean UI              |
| `jq`      | —        | JSON processor for scripts                    |
| `bc`      | —        | Terminal calculator                           |
