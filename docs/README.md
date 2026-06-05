# Arch-kit / docs

Detailed guides for each installation layer.

> [!IMPORTANT]
> Follow the guides in order. Each step assumes the previous one is complete.

## Guides

| Step | Guide                                     | Description                      |
| :--: | ----------------------------------------- | -------------------------------- |
|  0   | [Arch Installation](./00-arch-install.md) | Bootable USB → working system    |
|  1   | [System Init](./01-system-init.md)        | Base packages, zsh, oh-my-zsh    |
|  2   | [Hardware Setup](./02-hardware-setup.md)  | Audio, bluetooth, laptop profile |
|  3   | [Drivers](./03-drivers-install.md)        | GPU drivers                      |
|  4   | [Post Install](./04-post-install.md)      | pacman, mirrors, firewall, fonts |
|  5   | [Hyprland Starter](./05-hypr-starter.md)  | Hyprland + Wayland desktop       |
|  6   | [Dotfiles](./06-hypr-custom.md)           | Personal configurations          |

> [!NOTE]
> Step 0 must always be done manually. Steps 1-6 can be followed manually via the guides or automated via `./install.sh`.
