# NixOS Multi-Host Configuration

A modular NixOS configuration using flakes for managing multiple machines.

## Overview

This repository contains a multi-host NixOS configuration that uses Nix Flakes for reproducibility and Home Manager for user-specific configurations. It is designed to be easily extensible for new hosts and provides a set of reusable modules for common functionalities.

## Structure

The repository is structured as follows:

```
.
├── flake.nix                 # Flake configuration and inputs
├── flake.lock                # Locked dependency versions
├── hosts/                    # Host-specific configurations
│   ├── 9310/                 # Example host configuration
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── xps9520/
├── modules/                  # System-level modules
│   ├── hardware/
│   ├── services/
│   ├── desktop/
│   └── ...
├── homemanager/             # Home Manager modules
│   ├── hyprland.nix
│   ├── niri.nix
│   └── ...
└── home.nix                 # Home Manager entry point
```

## Adding a New Host

To add a new host, follow these steps:

1.  **Create a new directory for your host** under `hosts/`:

    ```bash
    cp -r hosts/template hosts/YOUR_HOSTNAME
    ```

2.  **Edit the `configuration.nix`** file in your new host's directory to set the hostname, username, timezone, and other system-specific settings.

3.  **Generate a hardware configuration** for your new host:

    ```bash
    nixos-generate-config --show-hardware-config > hosts/YOUR_HOSTNAME/hardware-configuration.nix
    ```

4.  **Add your new host to `flake.nix`** under the `nixosConfigurations` section:

    ```nix
    nixosConfigurations = {
      YOUR_HOSTNAME = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/YOUR_HOSTNAME/configuration.nix
        ];
      };
    };
    ```

5.  **Rebuild your system** with the new flake:

    ```bash
    sudo nixos-rebuild switch --flake .#YOUR_HOSTNAME
    ```

## Available Modules

This configuration includes a variety of modules that can be enabled per-host.

### Desktop Environments

*   **Hyprland:** A dynamic tiling Wayland compositor.
*   **Niri:** A scrollable-tiling Wayland compositor, configured with DankMaterialShell.

### System Modules

*   Hardware-specific configurations (audio, bluetooth, graphics)
*   System services (networking, display manager)
*   Gaming support (Steam, Gamemode)
*   And more...

### Home Manager Modules

*   Shell and terminal configuration (starship, kitty)
*   Editor configuration (NvChad)
*   Browser configuration
*   And more...

## Customization

Most customization is done within the `hosts/<hostname>/configuration.nix` file for system-level settings, and in `home.nix` for user-level settings. You can enable or disable modules and tweak their settings as needed.