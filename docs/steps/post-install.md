# 04 - Post Install

This layer applies final system configuration - package manager tuning, mirror optimization, firewall setup, font rendering, and SSD maintenance.

> [!NOTE]
> This step assumes you have completed [03 - Drivers Installation](./03-drivers-install.md).

## What This Layer Does

- Configures `pacman.conf` (color output, parallel downloads)
- Configures `makepkg.conf` (parallel compilation)
- Updates mirrorlist via `reflector`
- Sets up `ufw` firewall with default rules
- Enables `fstrim.timer` for SSD health
- Updates XDG user directories
- Links `fontconfig` for font rendering

## Automated Setup

```bash
./04-post-install/install.sh
```

> [!NOTE]
> The script will ask for your country name to select the fastest mirrors.

## Manual Setup

### 1. Configure pacman

Edit `/etc/pacman.conf` and uncomment or add the following:

```ini
Color
ParallelDownloads = 5
ILoveCandy
```

### 2. Configure makepkg

Edit `/etc/makepkg.conf` to enable parallel compilation:

```bash
sudo sed -i "s/^#MAKEFLAGS=.*/MAKEFLAGS=\"-j$(nproc)\"/" /etc/makepkg.conf
```

> [!TIP]
> `$(nproc)` automatically uses all available CPU threads. This significantly speeds up AUR package builds.

### 3. Update Mirrors

```bash
sudo pacman -S --needed reflector
sudo reflector --country YOUR_COUNTRY --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
sudo systemctl enable reflector.timer
```

> [!NOTE]
> Replace `YOUR_COUNTRY` with your country name (e.g. `Germany`, `Poland`, `France`). The timer will automatically refresh mirrors weekly.

### 4. Firewall

```bash
sudo pacman -S --needed ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo systemctl enable ufw
```

> [!TIP]
> To allow SSH access: `sudo ufw allow ssh`

### 5. SSD Maintenance

Enable weekly TRIM to maintain SSD performance:

```bash
sudo systemctl enable fstrim.timer
```

> [!NOTE]
> `fstrim` releases unused blocks on SSDs. It runs automatically once a week via systemd timer and requires no further configuration.

### 6. XDG User Directories

```bash
xdg-user-dirs-update
```

### 7. Font Rendering

Link the fontconfig configuration:

```bash
mkdir -p ~/.config/fontconfig
ln -sfn /path/to/arch-kit/04-post-install/config/fontconfig/fonts.conf \
    ~/.config/fontconfig/fonts.conf
```

The configuration applies the following rendering policy:

| Setting            | Value        | Effect                          |
| ------------------ | ------------ | ------------------------------- |
| Antialiasing       | enabled      | Smooth font edges               |
| Hinting            | `hintslight` | Subtle sharpness at small sizes |
| Subpixel rendering | `rgb`        | Optimized for RGB monitors      |
| LCD filter         | `lcddefault` | Reduces color fringing          |

**Default font families:**

| Family       | Primary                 | Fallback                          |
| ------------ | ----------------------- | --------------------------------- |
| `sans-serif` | Noto Sans               | Noto Color Emoji                  |
| `serif`      | Noto Serif              | Noto Color Emoji                  |
| `monospace`  | JetBrainsMono Nerd Font | JetBrains Mono → Noto Color Emoji |
| `emoji`      | Noto Color Emoji        | -                                 |

> [!TIP]
> If your monitor uses BGR subpixel layout instead of RGB, change `rgba` to `bgr` in `fonts.conf`.
