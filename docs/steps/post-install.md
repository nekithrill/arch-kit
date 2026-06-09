# Post Install

This layer applies final system configuration - package manager tuning, optional mirror optimization, firewall setup, font rendering preferences, and SSD maintenance [1].

> [!NOTE]
> This step assumes you have completed [Drivers Installation](./drivers.md).

## What This Layer Does

- Configures `pacman.conf` (color output, parallel downloads, Easter egg) [1]
- Configures `makepkg.conf` (parallel compilation using all CPU threads) [1]
- Updates mirrorlist via `reflector` (optional) [1]
- Sets up `ufw` firewall with default rules [1]
- Enables `fstrim.timer` for SSD health [1]
- Configures advanced font rendering and emoji fallbacks (`fonts.conf`)
- Updates XDG user directories [1]

## Automated Setup

If running this step as part of the main installer, mirror optimization will be skipped unless a country is specified via the orchestrator. To run this step completely standalone:

```bash
./steps/post-install.sh
```

> [!NOTE]
> If executed standalone, the script will interactively ask for your country name to select the fastest mirrors. You can press `Enter` to skip mirror optimization.

## Manual Setup

### 1. Configure pacman

Edit `/etc/pacman.conf` and uncomment or add the following parameters under the `[options]` section:

```ini
Color
ParallelDownloads = 5
ILoveCandy
```

### 2. Configure makepkg

Edit `/etc/makepkg.conf` to enable parallel compilation across all available CPU threads:

```bash
sudo sed -i "s/^#MAKEFLAGS=.*/MAKEFLAGS=\"-j\$(nproc)\"/" /etc/makepkg.conf
```

> [!TIP]
> `$(nproc)` automatically detects your CPU core count. This significantly speeds up AUR package builds via `yay`.

### 3. Update Mirrors (Optional)

If your download speeds are slow, you can optimize your mirror list:

```bash
sudo pacman -S --needed reflector
sudo reflector --country YOUR_COUNTRY --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
sudo systemctl enable reflector.timer
```

> [!NOTE]
> Replace `YOUR_COUNTRY` with your country name (e.g. `Germany`, `Poland`). The systemd timer will automatically refresh these mirrors weekly.

### 4. Firewall

```bash
sudo pacman -S --needed ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw --force enable
sudo systemctl enable ufw
```

> [!TIP]
> If you need to allow incoming SSH connections later, run: `sudo ufw allow ssh`

### 5. SSD Maintenance

Enable weekly TRIM to maintain SSD performance and longevity:

```bash
sudo systemctl enable fstrim.timer
```

> [!NOTE]
> `fstrim` releases unused blocks on SSD drives. It runs automatically once a week in the background via a systemd timer.

### 6. Font Configuration

To ensure crisp text rendering, proper subpixel antialiasing, and correct emoji fallbacks across all system applications, copy the provided `fonts.conf` file into your local configuration directory:

```bash
mkdir -p ~/.config/fontconfig
cp fonts.conf ~/.config/fontconfig/fonts.conf
```

### 7. XDG User Directories

Generate default user folders (Desktop, Downloads, Documents, etc.) in your home directory:

```bash
xdg-user-dirs-update
```
