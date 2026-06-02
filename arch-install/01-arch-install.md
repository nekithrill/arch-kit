# Arch Linux Installation

This step-by-step guide is built directly on top of the [official ArchWiki Installation Guide](https://wiki.archlinux.org/title/Installation_guide). Its main purpose is to translate dry, technical documentation into plain, accessible language while maintaining absolute precision and relevance.

## Prerequisites

- Bootable Arch Linux USB (download from [archlinux.org](https://archlinux.org/download/))
- Active internet connection
- Basic familiarity with the terminal

## Preinstall

### 1. Boot & verify environment

Boot from the USB and verify you are in UEFI mode:

```bash
ls /sys/firmware/efi/efivars
```

> [!NOTE]
> If the directory exists, you are booted in UEFI mode. This guide assumes UEFI.

### 2. Connect to the Internet

**Ethernet:** connected automatically.

**WiFi:**

Launch the `iwctl` interactive shell and connect to your network:

```bash
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect YOUR_SSID
exit
```

> [!NOTE]
> `device list` shows your wireless interface name. Replace `wlan0` with yours if it differs.
>
> Replace `YOUR_SSID` with your network name. Use quotes if it contains spaces: `station wlan0 connect "My Network"`

Verify connection:

```bash
ping -c 3 archlinux.org
```

### 3. Sync System Clock

In the live environment, `systemd-timesyncd` is enabled by default and syncs automatically after connecting to the internet. Verify that the time is correct:

```bash
timedatectl
```

> [!NOTE]
> If the time is incorrect, ensure your internet connection is active and wait a moment for sync to complete.

### 4. Partition the Disk

List available disks:

```bash
lsblk
```

Open the target disk with `fdisk` (replace `sdX` with your disk):

```bash
fdisk /dev/sdX
```

> [!CAUTION]
> All data on the selected disk will be erased. Double-check the device name before proceeding.

**Recommended partition layout:**

| Partition   | Size      | Type             | Mount   |
| ----------- | --------- | ---------------- | ------- |
| `/dev/sdX1` | 1G        | EFI System       | `/boot` |
| `/dev/sdX2` | remainder | Linux filesystem | `/`     |

Commands inside `fdisk` - fdisk asks questions one by one, answer each in order:

```
g        # create new GPT partition table
```

**Partition 1 - EFI:**

```
n        # new partition
Enter    # number: 1 (default)
Enter    # first sector (default)
+1G      # size
t        # change type
1        # type: EFI System
```

**Partition 2 - root:**

```
n        # new partition
Enter    # number: 2 (default)
Enter    # first sector (default)
Enter    # last sector: use remaining space
```

**Write and exit:**

```
w
```

> [!NOTE]
> This guide uses a clean **EXT4** layout. If you decide to switch to **Btrfs** in the future, you can adapt these steps later.

> [!TIP]
> This layout has no swap partition. If you need swap (for hibernation or low RAM systems), you can either add a dedicated swap partition before root, or create a swapfile after installation - the swapfile approach is simpler and can be done at any time.

### 5. Format Partitions

**EFI partition:**

```bash
mkfs.fat -F 32 /dev/sdX1
```

> [!IMPORTANT]
> The EFI partition must be formatted as FAT32. The UEFI specification cannot read EXT4 or NTFS at firmware initialization stage.

**Root partition (EXT4)**

```bash
mkfs.ext4 /dev/sdX2
```

### 6. Mount Partitions

Mount the newly formatted EXT4 partitions into the live environment:

```bash
mount /dev/sdX2 /mnt
mount --mkdir /dev/sdX1 /mnt/boot
```

## Installation

### 1. Install Base System

```bash
pacstrap -K /mnt \
  base linux linux-firmware \
  networkmanager nano sudo git curl \
  YOUR_CPU_UCODE
```

> [!IMPORTANT]
> Replace `YOUR_CPU_UCODE` with the package matching your CPU:
>
> - AMD → `amd-ucode`
> - Intel → `intel-ucode`
>
> Only install the one that matches your hardware. Installing the wrong one won't break the system but will leave unnecessary files in the boot partition.

> [!TIP]
> Add `linux-lts` instead of `linux` if you prefer a long-term support kernel.

## System configuration

### 1. Generate fstab

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

Verify the output:

```bash
cat /mnt/etc/fstab
```

### 2. Enter chroot

```bash
arch-chroot /mnt
```

### 3. Set Timezone

Replace `YOUR_REGION/YOUR_CITY` with your location (e.g. `Europe/Warsaw`, `America/New_York`):

```bash
ln -sf /usr/share/zoneinfo/YOUR_REGION/YOUR_CITY /etc/localtime
hwclock --systohc
```

> [!TIP]
> To find your timezone: `timedatectl list-timezones | grep YOUR_CITY`

### 4. Set Locale

Open the locale file and uncomment your locale by removing the `#` at the beginning of the line (e.g. `en_US.UTF-8 UTF-8`):

```bash
nano /etc/locale.gen
```

Generate the locale and set it as default:

```bash
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

### 5. Set Hostname

```bash
echo "your-hostname" > /etc/hostname
```

> [!NOTE]
> **What is a Hostname?** It is simply the unique name of your physical computer on the network (like a device name in Windows). For example, `my-laptop`, `arch-desktop`, or `thinkpad`. It should be lowercase, without spaces or special characters.

### 6. Set Root Password

The root account is the system administrator with full access to everything. Set a strong password for it:

```bash
passwd
```

### 7. Create User

Create a new user and add them to the `wheel` group (required for sudo access):

```bash
useradd -m -G wheel -s /bin/bash your-username
passwd your-username
```

> [!NOTE]
> Replace `your-username` with your desired username. It should be lowercase, without spaces or special symbols.

Enable sudo for the `wheel` group:

```bash
EDITOR=nano visudo
```

Find and uncomment the following line by removing the `#`:

```
%wheel ALL=(ALL:ALL) ALL
```

### 8. Enable Network Services

NetworkManager was installed during `pacstrap` but needs to be enabled so it starts automatically on boot:

```bash
systemctl enable NetworkManager
```

> [!IMPORTANT]
> Without this step there will be no internet connection after reboot.

> [!NOTE]
> After reboot, use `nmtui` to connect to WiFi - it provides a simple terminal interface.
> `iwctl` is only available in the live environment.

### 9. Install Bootloader

```bash
bootctl install
```

Before creating the boot entry, get your root partition UUID:

```bash
lsblk -no UUID /dev/sdX2
```

Create a boot entry:

```bash
nano /boot/loader/entries/arch.conf
```

Add the following content, replacing `YOUR_ROOT_UUID` with the UUID from the previous step:

```
title   Arch Linux
linux   /vmlinuz-linux
initrd  /amd-ucode.img
initrd  /initramfs-linux.img
options root=UUID=YOUR_ROOT_UUID rw quiet
```

> [!NOTE]
> If you installed Intel microcode, replace `/amd-ucode.img` with `/intel-ucode.img`.

> [!IMPORTANT]
> The microcode line must come before the initramfs line. If reversed, CPU patches will not be applied at boot.

Update the loader config to set the default boot entry and timeout:

```bash
nano /boot/loader/loader.conf
```

Add the following content:

```
default arch.conf
timeout 3
console-mode max
```

> [!TIP]
> For GRUB instead of systemd-boot: `pacman -S grub efibootmgr && grub-install --target=x86_64-efi --efi-directory=/boot && grub-mkconfig -o /boot/grub/grub.cfg`

## Exit and Reboot

```bash
exit
umount -R /mnt
reboot
```

> [!IMPORTANT]
> Remove the USB drive before the system boots.
