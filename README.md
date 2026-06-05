# 🛠️ Arch-kit

This repository is a modular Arch Linux installation toolkit designed as a simple, step-by-step system setup guide with optional automation via an interactive installer.

It provides a clearly structured sequence of independent installation layers - from base system initialization to a fully configured Hyprland desktop environment and personal dotfiles.

Each layer is self-contained and can be executed independently or as part of a guided installation process through the root `install.sh` wizard. The wizard acts only as a convenient orchestrator for selecting and running predefined installation steps; it does not perform system detection or make autonomous configuration decisions.

The project follows a linear, human-readable workflow (01 → 06), prioritizing transparency, simplicity, and full user control over installation choices.

> [!NOTE]
> This setup is intended for personal use and reproducible Arch Linux installations. While it aims to be reliable and modular, it does not perform disk partitioning or fully automated system provisioning. Users are responsible for initial system preparation and for selecting appropriate installation options during setup.
>
> Hardware differences and configuration choices may require manual adjustments. Always review scripts before execution.

---

## 📂 Repository Structure

```text
dotfiles/
├── 01-system-init/       # Base env initialization (pacman, AUR/yay, zsh, sudo setup)
├── 02-hardware-setup/    # Hardware-specific setup (common tools, PC vs. Laptop profiles)
├── 03-drivers-install/   # Graphics driver deployment (AMD / Nvidia profiles)
├── 04-post-install/      # System fixes, font configurations, and audio engines (Pipewire)
├── 05-hypr-starter/      # Universal graphical skeleton (Hyprland + Wayland baseline)
├── 06-dotfiles/          # Personal deep-custom application configurations
├── docs/                 # Internal Knowledge Base & Step-by-step installation Wiki
├── scripts/              # Shared Bash helpers library (core automation modules)
├── install.sh            # Main interactive orchestrator (central installation wizard)
└── update.sh             # Fast configuration synchronization and package updater
```

---

## 📋 Prerequisites & Warning

> [!CAUTION]
> This repository **does NOT automatically partition your disks or install the base Linux kernel**. Automated partition scripts are highly dangerous and can lead to accidental data loss.
>
> Before running any scripts from this repository, you **MUST manually install** a clean, bootable Arch Linux system on your machine.

> [!NOTE]
> Please follow our detailed step-by-step **[00 | Clean Arch Linux Installation Manual](docs/00-arch-install.md)** to handle your disk layout, formatting, `pacstrap`, and chroot configuration safely and manually.
>
> Once you have successfully booted into your fresh, clean Arch Linux installation as a normal user with `sudo` privileges, you can proceed to the automation wizard.

---

## 🚀 Getting Started

The primary `install.sh` script in the root directory provides an interactive installation wizard. It automatically scans the available numbered layers and builds a dynamic menu supporting multiple deployment methodologies.

### 1. Running the Orchestrator

To deploy your environment, clone the repository, navigate into the project root, and execute the interactive wizard. You can also switch repository branches or origins before running the installer if you need to deploy a specific configuration state.

```bash
# Clone the repository to your local machine
git clone https://github.com/nekithrill/arch-kit.git

# Navigate into the project root directory
cd arch-kit

# Optional: Switch to a specific branch or repository configuration if needed
# git checkout development

# Make the orchestrator executable (if not already)
chmod +x install.sh

# Launch the wizard
./install.sh
```

### 2. Available Installation Presets:

1. **Full Setup (01-06):** Sequentially deploys every single layer in the repository completely unattended for a fully loaded, personalized system.
2. **Base System Only (01-04):** Installs the core environment, hardware tools, graphics drivers, and system fixes.
3. **Hyprland Starter Environment (01-05):** Deploys the entire base operating system alongside a completely clean, vanilla Hyprland + Wayland desktop layout - ideal for sharing with friends or starting a raw desktop build.
4. **Manual Mode:** Drops into a sub-menu allowing you to explicitly select and run a single standalone layer of your choosing.

---

## 🔄 Keeping System and Dotfiles Updated

Whenever you alter any software lists or pull new configuration tweaks down from Git, you can rapidly sync everything up using the synchronization engine:

```bash
./update.sh
```

> [!TIP]
> You don't need to re-run the entire installation wizard to apply minor tweaks. Just run `./update.sh` anytime you pull new changes from GitHub or modify your local package sheets.

> [!NOTE]
> **Under the Hood Automation:**
> The sync engine executes a full rolling package upgrade (`pacman`/`yay`), automatically scans all `packages.txt` files across layers `01` to `06` to install newly added dependencies, and forcefully refreshes config symlinks for `05-hypr-starter` and `06-dotfiles` while preserving your custom tweaks in safe `.bak` files.

---

## 📖 Project Wiki & Documentation

Detailed execution manuals, architectural decisions, and guides for each deployment phase are maintained in our internal knowledge base:

👉 **[Explore the Repository Wiki Index](docs/README.md)** - Click here to navigate through the comprehensive step-by-step guides, configuration manifests, and system setup notes.

---

## 🛠️ Automation Architecture (`scripts/` folder)

> [!IMPORTANT]
> To keep individual layer setups lightweight and purely declarative, all heavy-lifting logic is abstractly separated into modular Bash modules managed through a single gateway file. Do not modify these core modules unless you want to change global installation behaviors.

- `main.sh` - The master dispatcher that handles automated loading of the neighboring modules.
- `colors.sh` - Standardized color logging utilities (`log`, `success`, `warn`, `error`, `die`).
- `packages.sh` - Smart parser for `packages.txt` lists that separates official repo tracking from AUR packages.
- `symlinks.sh` - Safe symbolic link manager that automatically backs up any existing clashing targets to `.bak`.
- `system.sh` - High-level environment handling (root privilege checks, background sudo `keep-alive`, shell adjustments, systemd management).
