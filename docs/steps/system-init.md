# System Initialization

This layer sets up the foundational user environment on top of a fresh Arch Linux installation. It installs core utilities, configures the shell, sets up the AUR helper, and links base dotfiles.

> [!NOTE]
> This step assumes you have completed [00 — Arch Installation](./00-arch-install.md) and are logged in as a normal user with `sudo` privileges.

## What This Layer Does

- Updates the Arch Linux keyring
- Installs `yay` as the AUR helper
- Installs base packages

## Automated Setup

```bash
./steps/system-init.sh
```

## Manual Setup

### 1. Enable multilib

Open the pacman configuration file in a text editor:

```bash
sudo nano /etc/pacman.conf
```

Scroll down to the bottom, find the `[multilib]` section, and uncomment it by removing the `#` symbol from both lines so it looks like this:

```ini
[multilib]
Include = /etc/pacman.d/mirrorlist
```

Save the changes (`Ctrl+O`, then `Enter`) and close the editor (`Ctrl+X`). Finally, update your package databases and system:

```bash
sudo pacman -Syu
```

### 2. Update Keyring

Update the package signing keys to avoid signature verification errors:

```bash
sudo pacman -S archlinux-keyring
```

### 3. Install yay

`yay` is an AUR helper. To build it, you first need `git` and development tools (`base-devel`):

```bash
sudo pacman -S --needed --noconfirm git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si --noconfirm
cd .. && rm -rf yay
```

### 4. Install Base Packages

**System core:** `dkms`, `wget`, `openssh`, `unzip`, `zip`, `p7zip`, `man-db`, `man-pages`

**File system:** `dosfstools`, `exfatprogs`, `udisks2`

**Fonts:** `ttf-jetbrains-mono-nerd`, `noto-fonts`, `noto-fonts-emoji`, `noto-fonts-cjk`, `fontconfig`

**CLI utilities:** `eza`, `bat`, `fd`, `ripgrep`, `fzf`, `btop`, `jq`

**Media:** `mpv`, `imv`

**System utilities:** `gnome-keyring`, `xdg-user-dirs`, `xdg-desktop-portal-gtk`, `xdg-utils`, `upower`, `timeshift`

```bash
sudo pacman -S --needed dkms wget openssh unzip zip p7zip unrar \
    man-db man-pages dosfstools exfatprogs udisks2 \
    zsh ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji noto-fonts-cjk fontconfig \
    eza bat fd ripgrep fzf btop jq mpv imv \
    gnome-keyring xdg-user-dirs xdg-desktop-portal-gtk xdg-utils upower timeshift
```

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
