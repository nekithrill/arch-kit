# 02 - Hardware Setup

This layer installs hardware support packages - audio stack, bluetooth, and device-specific tools depending on whether you are running a laptop or desktop.

> [!NOTE]
> This step assumes you have completed [01 - System Initialization](./01-system-init.md).

## What This Layer Does

- Installs the full Pipewire audio stack
- Installs Bluetooth support
- Enables the `bluetooth` service
- Installs laptop-specific packages if selected (power management, backlight, touchpad)

## Automated Setup

```bash
./02-hardware-setup/install.sh
```

> [!NOTE]
> The script will ask whether you are on a laptop or desktop and install the appropriate packages.

## Manual Setup

### 1. Audio (Pipewire)

```bash
sudo pacman -S --needed pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
```

> [!TIP]
> Pipewire replaces PulseAudio and JACK. No additional configuration is needed - it works out of the box after installation.

### 2. Bluetooth

```bash
sudo pacman -S --needed bluez bluez-utils libspa-0.2-bluetooth
sudo systemctl enable --now bluetooth
```

> [!NOTE]
> `libspa-0.2-bluetooth` enables high-quality audio codecs (LDAC, aptX) for wireless headphones via Pipewire.

### 3. Laptop Profile (optional)

Skip this section if you are on a desktop.

**Power management:**

```bash
sudo pacman -S --needed power-profiles-daemon acpi acpid acpi_call-dkms
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
> `acpi_call-dkms` is required for battery charge threshold control on some laptops (e.g. ThinkPads). It rebuilds automatically on kernel updates thanks to DKMS.
