# 🛠️ Arch-kit

> [!WARNING]
> This project is currently under active development and has undergone minimal testing. Some features may be unstable or work unexpectedly.

This repository is a modular Arch Linux installation toolkit designed as a simple, step-by-step system setup guide with optional automation via an interactive installer.

It provides a clearly structured sequence of independent installation layers - from base system initialization to a fully configured and optimized base system ready for a desktop environment.

Each layer is self-contained and can be executed independently or as part of a guided installation process through the root `install.sh` wizard. The wizard acts only as a convenient orchestrator for selecting and running predefined installation steps; it does not perform system detection or make autonomous configuration decisions.

The project follows a linear, human-readable workflow (01 → 04), prioritizing transparency, simplicity, and full user control over installation choices.

> [!NOTE]
> This setup is intended for personal use and reproducible Arch Linux installations. While it aims to be reliable and modular, it does not perform disk partitioning or fully automated system provisioning. Users are responsible for initial system preparation and for selecting appropriate installation options during setup.
>
> Hardware differences and configuration choices may require manual adjustments. Always review scripts before execution.

---

## 📂 Repository Structure

```text
arch-kit/
├── steps/
│   ├── base.sh          # Base env initialization (pacman, AUR/yay, zsh, sudo setup)
│   ├── hardware.sh      # Hardware-specific setup (common tools, PC vs. Laptop profiles)
│   ├── drivers.sh       # Graphics driver deployment (AMD / Nvidia profiles)
│   └── postinstall.sh   # System fixes, font configurations, and audio engines (Pipewire)
├── docs/                # Internal Knowledge Base & Step-by-step installation Wiki
├── scripts/             # Shared Bash helpers library (core automation modules)
├── install.sh           # Main interactive orchestrator (central installation wizard)
└── update.sh            # Fast configuration synchronization and package updater
```

---

## 📋 Prerequisites & Warning

> [!CAUTION]
> This repository **does NOT automatically partition your disks or install the base Linux kernel**. Automated partition scripts are highly dangerous and can lead to accidental data loss.
>
> Before running any scripts from this repository, you **MUST manually install** a clean, bootable Arch Linux system on your machine.

> [!NOTE]
> Please follow our detailed step-by-step **[Arch Linux Installation Manual](docs/arch-install.md)** to handle your disk layout, formatting, `pacstrap`, and chroot configuration safely and manually.
>
> Once you have successfully booted into your fresh, clean Arch Linux installation as a normal user with `sudo` privileges, you can proceed to the automation wizard.

---

## 🚀 Getting Started

The primary `install.sh` script in the root directory provides an interactive installation wizard. It automatically scans the available numbered layers and builds a dynamic menu supporting multiple deployment methodologies.

### 1. Running the Orchestrator

```bash
git clone https://github.com/nekithrill/arch-kit.git
cd arch-kit
chmod +x install.sh
./install.sh
```

### 2. Available Installation Presets

1. **Full Setup (01-04):** Sequentially deploys every layer completely unattended for a fully configured base system.
2. **System Only (01-02):** Installs the core environment and hardware tools, skipping driver configuration.
3. **Manual Mode:** Drops into a sub-menu allowing you to explicitly select and run a single standalone layer of your choosing.

---

## 🔄 Keeping System Updated

```bash
./update.sh
```

> [!TIP]
> You don't need to re-run the entire installation wizard to apply minor tweaks. Just run `./update.sh` anytime you pull new changes from GitHub or modify your local package sheets.

> [!NOTE]
> **Under the Hood:** The sync engine executes a full rolling package upgrade (`pacman`/`yay`) and automatically scans all `packages.txt` files across layers `01` to `04` to install newly added dependencies.

---

## 📖 Documentation

👉 **[Explore the Repository Wiki](docs/README.md)**

---

## 🛠️ Automation Architecture (`scripts/` folder)

> [!IMPORTANT]
> All heavy-lifting logic is abstractly separated into modular Bash modules managed through a single gateway file. Do not modify these core modules unless you want to change global installation behaviors.

- `main.sh` - The master dispatcher that handles automated loading of the neighboring modules.
- `colors.sh` - Standardized color logging utilities (`log`, `success`, `warn`, `error`, `die`).
- `packages.sh` - Smart parser for `packages.txt` lists that separates official repo tracking from AUR packages.
- `system.sh` - High-level environment handling (root privilege checks, background sudo `keep-alive`, shell adjustments, systemd management).
