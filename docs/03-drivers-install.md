# 03 - Drivers Installation

This layer installs GPU drivers based on your hardware. The install script automatically selects the correct driver profile - AMD, NVIDIA, or hybrid AMD+NVIDIA.

> [!NOTE]
> This step assumes you have completed [02 - Hardware Setup](./02-hardware-setup.md).

## What This Layer Does

- Installs the appropriate GPU drivers based on your selection
- Configures Early KMS modules in `mkinitcpio.conf` for NVIDIA
- Adds `nvidia_drm.modeset=1` kernel parameter for Wayland compatibility (NVIDIA only)
- Regenerates `initramfs` if NVIDIA modules were added

## Automated Setup

```bash
./03-drivers-install/install.sh
```

> [!NOTE]
> The script will ask you to select your GPU configuration: `amd`, `nvidia`, or `amd + nvidia (hybrid)`.

## Manual Setup

### AMD

```bash
sudo pacman -S --needed mesa vulkan-radeon libva-mesa-driver mesa-vdpau \
    lib32-mesa lib32-vulkan-radeon \
    vulkan-icd-loader lib32-vulkan-icd-loader libva libva-utils
```

### NVIDIA

```bash
sudo pacman -S --needed nvidia-dkms nvidia-utils lib32-nvidia-utils opencl-nvidia \
    vulkan-icd-loader lib32-vulkan-icd-loader libva libva-utils
yay -S --needed libva-nvidia-driver
```

Configure Early KMS:

```bash
sudo nano /etc/mkinitcpio.conf
# Add to MODULES=(): nvidia nvidia_modeset nvidia_uvm nvidia_drm
sudo mkinitcpio -P
```

Add kernel parameter for Wayland:

```bash
# systemd-boot: edit /boot/loader/entries/arch.conf
# append to options line:
nvidia_drm.modeset=1
```

> [!IMPORTANT]
> Without `nvidia_drm.modeset=1` NVIDIA will not work correctly on Wayland. This parameter must be set before booting into a graphical session.

### AMD + NVIDIA (Hybrid)

Install both AMD and NVIDIA packages:

```bash
sudo pacman -S --needed mesa vulkan-radeon libva-mesa-driver mesa-vdpau \
    lib32-mesa lib32-vulkan-radeon \
    nvidia-dkms nvidia-utils nvidia-prime lib32-nvidia-utils opencl-nvidia \
    vulkan-icd-loader lib32-vulkan-icd-loader libva libva-utils
yay -S --needed libva-nvidia-driver envycontrol
```

> [!TIP]
> On hybrid systems, Hyprland renders on the AMD iGPU by default. To run a specific application on the NVIDIA GPU use: `prime-run <application>`

> [!TIP]
> `envycontrol` allows switching between integrated, dedicated, and hybrid GPU modes system-wide: `sudo envycontrol --switch integrated`

## Package Reference

| Package               | Profile | Description                                       |
| --------------------- | ------- | ------------------------------------------------- |
| `mesa`                | AMD     | OpenGL and Vulkan implementation                  |
| `vulkan-radeon`       | AMD     | Vulkan driver for AMD                             |
| `libva-mesa-driver`   | AMD     | Hardware video decode for AMD                     |
| `nvidia-dkms`         | NVIDIA  | NVIDIA kernel module (rebuilds on kernel updates) |
| `nvidia-prime`        | Hybrid  | NVIDIA PRIME render offload support               |
| `opencl-nvidia`       | NVIDIA  | OpenCL support for NVIDIA                         |
| `libva-nvidia-driver` | NVIDIA  | Hardware video decode for NVIDIA on Wayland       |
| `envycontrol`         | Hybrid  | GPU switching utility                             |
