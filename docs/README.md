# Arch-kit

Detailed guides for each installation layer.

> [!IMPORTANT]
> Follow the guides in order. Each step assumes the previous one is complete.

## Guides

| Step | Guide                                        | Description                      |
| :--: | -------------------------------------------- | -------------------------------- |
|  0   | [Arch Installation](./steps/arch-install.md) | Bootable USB → working system    |
|  1   | [System Init](./steps/system-init.md)        | Base packages, zsh, oh-my-zsh    |
|  2   | [Hardware](./steps/hardware.md)              | Audio, bluetooth, laptop profile |
|  3   | [Drivers](./steps/drivers.md)                | GPU drivers                      |
|  4   | [Post Install](./steps/post-install.md)      | pacman, mirrors, firewall, fonts |

> [!NOTE]
> **Step 0** must always be done manually. **Steps 1-4** can be followed manually via the guides or automated via `./install.sh`.
