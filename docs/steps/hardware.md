# Hardware Setup

This layer installs hardware support packages - audio stack, bluetooth, and device-specific tools depending on whether you are running a laptop or desktop.

> [!NOTE]
> This step assumes you have completed [System Initialization](./system-init.md).

## What This Layer Does

- Installs the full Pipewire audio stack
- Installs Bluetooth support
- Enables the `bluetooth` service
- Installs laptop-specific packages if selected (power management, backlight, touchpad)

## Automated Setup

```bash
./steps/hardware.sh
```

> [!NOTE]
> If executed standalone, the script will interactively ask whether you are on a laptop or desktop to install the appropriate packages.

## Manual Setup

### 1. Drive Diagnostics

```bash
sudo pacman -S --needed smartmontools
```

### 2. Audio (Pipewire)

```bash
# Remove jack2 first if it causes a conflict, then install the pipewire stack
sudo pacman -Rdd --noconfirm jack2 2>/dev/null || true
sudo pacman -S --needed pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
```

> [!TIP]
> Pipewire replaces PulseAudio and JACK. No additional configuration is needed - it works out of the box after installation.

### 3. Bluetooth

```bash
sudo pacman -S --needed bluez bluez-utils
sudo systemctl enable --now bluetooth
```

### 4. Laptop Profile (optional)

Skip this section if you are on a desktop.

**Power management:**

```bash
sudo pacman -S --needed power-profiles-daemon acpi acpid acpi_call
sudo systemctl enable --now acpid power-profiles-daemon
```

**Backlight control:**

```bash
sudo pacman -S --needed brightnessctl
```

**Touchpad input:**

```bash
sudo pacman -S --needed libinput
```

> [!TIP]
> `power-profiles-daemon` integrates natively with both KDE Plasma and Hyprland. Use `powerprofilesctl` to switch between `power-saver`, `balanced`, and `performance` profiles from the terminal.

> [!NOTE]
> `acpi_call` is required for battery charge threshold control on some laptops (e.g. ThinkPads).
