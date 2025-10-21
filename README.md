# NixOS Configuration

> Modular NixOS configuration with flakes, Home Manager, Hyprland, and NVIDIA hybrid graphics support.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Screenshots](#screenshots)
- [Installation](#installation)
  - [Fresh Install](#fresh-install)
  - [Adding to Existing System](#adding-to-existing-system)
- [Structure](#structure)
- [Usage](#usage)
  - [Daily Commands](#daily-commands)
  - [System Updates](#system-updates)
  - [NVIDIA Graphics](#nvidia-graphics)
- [Modules](#modules)
  - [System Modules](#system-modules)
  - [Home Manager Modules](#home-manager-modules)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)

## Overview

This is a fully declarative NixOS configuration featuring a modern Hyprland desktop environment, comprehensive gaming support, and a modular architecture that makes it easy to adapt to different systems.

**Key Technologies:**
- **Nix Flakes** - Reproducible builds and dependency management
- **Home Manager** - Declarative dotfiles and user configuration
- **Hyprland** - Tiling Wayland compositor
- **Stylix** - System-wide theming (Tokyo Night Storm)
- **NVIDIA PRIME** - Hybrid graphics with gaming specialization (optional)

## Features

- ✨ **Flake-based configuration** with pinned dependencies
- 🏠 **Home Manager integration** for user-level packages and dotfiles
- 🎨 **Unified theming** via Stylix (Tokyo Night Storm)
- 🖥️ **Hyprland desktop** with Waybar, Wofi, and complete Wayland tooling
- 🎮 **Gaming ready** - Steam, MangoHud, Gamemode, Lutris
- 🔋 **NVIDIA hybrid graphics** - Battery-efficient offload + gaming mode (optional)
- 📦 **Modular design** - Enable/disable features per host
- 🔐 **Security hardening** - Firewall, polkit, optional fingerprint auth
- 🌐 **VPN support** - Tailscale, OpenVPN, WireGuard, and more
- 📝 **NvChad** with Claude Code integration
- 🎯 **Multi-host support** - Easy templates for adding new machines

## Screenshots

![Desktop Environment](screenshot1.png)
![Desktop Environment](screenshot2.png)

## Installation

### Option 1: Fresh NixOS Install

1. **Boot NixOS installer** and partition your drive according to the [NixOS installation guide](https://nixos.org/manual/nixos/stable/#sec-installation)

2. **Clone this repository:**
   ```bash
   # Enter a shell with git available
   nix-shell -p git

   # Clone to the installation target
   git clone https://github.com/TyF1ghter/nixos.git /mnt/etc/nixos
   cd /mnt/etc/nixos
   ```

3. **Create your host configuration from the template:**
   ```bash
   # Copy the template directory to create your host configuration
   cp -r hosts/template hosts/YOUR_HOSTNAME
   ```

   > **Important:** All your customization will start from editing the template files. The template provides a starting point that you'll modify for your specific system.

4. **Edit the template configuration for your system:**
   ```bash
   # Use your preferred editor (nano or vim)
   nano hosts/YOUR_HOSTNAME/configuration.nix
   # OR
   vim hosts/YOUR_HOSTNAME/configuration.nix
   ```

   **Required changes in `configuration.nix`:**
   - **hostname**: Change `"nixos"` to `"YOUR_HOSTNAME"`
   - **username**: Change the username to your desired username
   - **timezone**: Set your timezone (e.g., `"America/Chicago"`, `"Europe/London"`)
   - **locale**: Set your locale (e.g., `"en_US.UTF-8"`)

   **Hardware modules to review (in the `imports` section):**

   **Graphics:**
   - **Use** `../../modules/hardware/integrated-graphics.nix` for Intel/AMD integrated graphics
   - **OR use** `../../modules/hardware/nvidiahybrid.nix` for NVIDIA hybrid graphics
   - **Choose only ONE** graphics module based on your hardware

   **Other modules:**
   - **Remove** `../../modules/laptoppower.nix` if you're on a desktop PC
   - **Remove** `../../modules/gaming/gaming.nix` if you don't want gaming support
   - Keep `../../modules/hardware/audio.nix` and `../../modules/hardware/bluetooth.nix` (most systems need these)

5. **Generate hardware configuration:**
   ```bash
   # This detects your hardware and creates the configuration
   nixos-generate-config --show-hardware-config > hosts/YOUR_HOSTNAME/hardware-configuration.nix
   ```

6. **Update hardware-specific settings (if needed):**

   If you have NVIDIA hybrid graphics and kept the module, you need to update PCI bus IDs:
   ```bash
   # Use your preferred editor
   nano modules/hardware/nvidiahybrid.nix
   # OR
   vim modules/hardware/nvidiahybrid.nix
   ```

   Find your PCI bus IDs:
   ```bash
   lspci | grep -E "VGA|3D"
   # Example output:
   # 00:02.0 VGA compatible controller: Intel Corporation ...
   # 01:00.0 3D controller: NVIDIA Corporation ...
   ```

   Update the PCI bus IDs in the file:
   ```nix
   hardware.nvidia.prime = {
     intelBusId = "PCI:0:2:0";   # Your Intel GPU bus ID
     nvidiaBusId = "PCI:1:0:0";  # Your NVIDIA GPU bus ID
   };
   ```

7. **Add your host to `flake.nix`:**
   ```bash
   # Use your preferred editor
   nano flake.nix
   # OR
   vim flake.nix
   ```

   Add your host to the `nixosConfigurations` section:
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

8. **Customize home-manager configuration:**
   ```bash
   # Use your preferred editor
   nano home.nix
   # OR
   vim home.nix
   ```

   Enable or disable Home Manager modules based on your preferences:
   ```nix
   modules = {
     nvchad.enable = true;          # Neovim with Claude Code integration
     terminal.enable = true;         # Kitty terminal emulator
     browsers.enable = true;         # Brave and Qutebrowser
     vdesktop.enable = true;         # Vesktop Discord client
     wayland.enable = true;          # Wayland compositor tools
     stylix-config.enable = true;    # System-wide theme integration
   };
   ```

   > **Tip:** You can disable any module by setting it to `false`. Start with all enabled and disable what you don't want.

9. **Install NixOS:**
   ```bash
   nixos-install --flake .#YOUR_HOSTNAME
   ```

10. **Reboot:**
    ```bash
    reboot
    ```

### Option 2: Add to Existing NixOS System

1. **Backup your current configuration:**
   ```bash
   sudo mv /etc/nixos /etc/nixos.bak
   ```

2. **Clone this repository:**
   ```bash
   sudo git clone https://github.com/TyF1ghter/nixos.git /etc/nixos
   cd /etc/nixos
   ```

3. **Create your host configuration:**
   ```bash
   # Copy the template
   sudo cp -r hosts/template hosts/$(hostname)

   # Copy your existing hardware config or generate a new one
   sudo cp /etc/nixos.bak/hardware-configuration.nix hosts/$(hostname)/hardware-configuration.nix
   # OR generate fresh:
   # sudo nixos-generate-config --show-hardware-config > hosts/$(hostname)/hardware-configuration.nix
   ```

4. **Edit the template configuration for your system:**
   ```bash
   # Use your preferred editor (nano or vim)
   sudo nano hosts/$(hostname)/configuration.nix
   # OR
   sudo vim hosts/$(hostname)/configuration.nix
   ```

   Follow the same customization steps from Option 1 (steps 4-8)

   > **Remember:** Start by editing the template to match your system's hostname, username, timezone, and hardware modules.

5. **Add your host to `flake.nix`:**
   ```bash
   # Use your preferred editor
   sudo nano flake.nix
   # OR
   sudo vim flake.nix
   ```

   Add your hostname to `nixosConfigurations` as shown in Option 1, step 7

6. **Test the configuration:**
   ```bash
   # Check for syntax errors
   sudo nix flake check /etc/nixos
   ```

7. **Rebuild your system:**
   ```bash
   sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)
   ```

### Quick Checklist

Before installing, make sure you've edited the template and:
- [ ] Copied `hosts/template` to `hosts/YOUR_HOSTNAME`
- [ ] Edited the template: Set hostname in `hosts/YOUR_HOSTNAME/configuration.nix`
- [ ] Edited the template: Set username in `hosts/YOUR_HOSTNAME/configuration.nix`
- [ ] Edited the template: Set timezone and locale
- [ ] Edited the template: Choose correct graphics module (integrated-graphics OR nvidiahybrid)
- [ ] Edited the template: Removed incompatible hardware modules (laptop power, gaming, etc.)
- [ ] Generated `hardware-configuration.nix` for your system
- [ ] Updated PCI bus IDs if using NVIDIA hybrid graphics
- [ ] Uncommented AMD settings if using AMD integrated graphics
- [ ] Added your host to `flake.nix`
- [ ] Reviewed and customized `home.nix`

> **Key Point:** The template files in `hosts/template/` are your starting point. Copy them, then edit to match your specific system configuration.

## Structure

```
.
├── flake.nix                 # Flake configuration and inputs
├── flake.lock                # Locked dependency versions
├── hosts/                    # Host-specific configurations
│   ├── xps9520/             # Example host configuration
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── template/            # Template for new hosts
├── modules/                  # System-level modules
│   ├── hardware/            # Hardware configs (audio, bluetooth, nvidia)
│   ├── services/            # System services (networking, display-manager)
│   ├── desktop/             # Desktop environment (hyprland, thunar, xdg)
│   ├── gaming/              # Gaming setup (steam, gamemode)
│   ├── fonts.nix
│   ├── laptoppower.nix
│   ├── security.nix
│   ├── stylix.nix
│   └── virtualization.nix
├── homemanager/             # Home Manager modules
│   ├── browsers.nix         # Brave, Qutebrowser
│   ├── btop.nix
│   ├── dunst.nix
│   ├── hyprland.nix
│   ├── nvchad.nix           # Neovim with Claude Code
│   ├── stylix.nix
│   ├── terminal.nix         # Kitty
│   ├── vdesktop.nix         # Vesktop Discord client
│   ├── waybar.nix
│   ├── wayland.nix
│   └── wofi.nix
├── home.nix                 # Home Manager entry point
└── starship.toml            # Starship prompt config
```

## Usage

### Daily Commands

| Alias | Command | Description |
|-------|---------|-------------|
| `updoot` | `sudo nixos-rebuild switch --flake /etc/nixos` | Rebuild system |
| `nixconf` | `sudo nvim /etc/nixos/hosts/$(hostname)/configuration.nix` | Edit host config |
| `homeconf` | `sudo nvim /etc/nixos/home.nix` | Edit home config |
| `flakeconf` | `sudo nvim /etc/nixos/flake.nix` | Edit flake |
| `flakedoot` | `sudo nix flake update /etc/nixos` | Update flake inputs |
| `rebar` | `pkill waybar && hyprctl dispatch exec waybar` | Restart Waybar |
| `tup` / `tdown` | Tailscale commands | VPN control |

### System Updates

```bash
# Update flake inputs
sudo nix flake update /etc/nixos

# Rebuild with updates
updoot

# Garbage collection
sudo nix-collect-garbage -d
```

### NVIDIA Graphics

> **Note:** Only applicable if you have NVIDIA hybrid graphics and have enabled the `modules/hardware/nvidiahybrid.nix` module.

```bash
# Normal mode (battery efficient, offload)
nvidia-offload <application>

# Gaming mode (high performance, sync)
sudo nixos-rebuild switch --specialisation gaming-time

# Switch back to normal
sudo nixos-rebuild switch
```

## Modules

### System Modules

<details>
<summary><b>Hardware Modules</b> (<code>modules/hardware/</code>)</summary>

#### integrated-graphics.nix
**For systems with integrated graphics only (Intel/AMD)**
- Optimized for Wayland compositors
- Hardware video acceleration (VA-API, VDPAU)
- 32-bit support for gaming
- Intel: GuC/HuC firmware enabled for better performance
- AMD: Mesa drivers with radeonsi support

> **Usage:** Import this module for laptops/systems without dedicated GPU. Works with Intel or AMD integrated graphics.
>
> **For AMD users:** Edit the module and uncomment AMD-specific lines:
> ```nix
> LIBVA_DRIVER_NAME = "radeonsi";
> boot.initrd.kernelModules = [ "amdgpu" ];
> ```

#### nvidiahybrid.nix
**For laptops with NVIDIA + Intel hybrid graphics**
- NVIDIA proprietary drivers (stable)
- PRIME offload mode (battery saving)
- Gaming specialization with PRIME sync
- Intel integrated GPU as primary

> **Configuration required:** Update PCI bus IDs in the module to match your hardware. Find them with:
> ```bash
> lspci | grep -E "VGA|3D"
> ```
>
> **Note:** Use `integrated-graphics.nix` instead if you don't have NVIDIA hardware.

#### audio.nix
- PipeWire with WirePlumber
- ALSA support (32-bit)
- PulseAudio compatibility layer

#### bluetooth.nix
- Bluetooth hardware support
- Blueman GUI manager

</details>

<details>
<summary><b>Services Modules</b> (<code>modules/services/</code>)</summary>

#### networking.nix
- NetworkManager with VPN plugins (OpenVPN, L2TP, OpenConnect, SSTP, etc.)
- Tailscale VPN
- WireGuard support
- Firewall enabled

#### display-manager.nix
- GDM with Wayland
- Libinput touchpad config (natural scrolling, tap-to-click)
- GNOME services (keyring, gvfs, tumbler)

#### system-services.nix
- Hypridle (idle daemon)
- Firmware updates
- ACPI controls
- Xbox controller support

</details>

<details>
<summary><b>Desktop Modules</b> (<code>modules/desktop/</code>)</summary>

#### hyprland.nix
- Hyprland with XWayland
- Hyprlock screen locker
- Hyprland ecosystem (hyprpicker, hyprpaper, hyprshot)
- Wayland utilities (waybar, wofi, swww, grim, dunst, wlogout)

#### xdg.nix
- XDG Desktop Portal (Hyprland)
- GTK portal fallback
- File picker and screen sharing

#### thunar.nix
- Thunar file manager with plugins
- File-roller archive manager
- File utilities (dysk, fzf, gvfs, udiskie)

</details>

<details>
<summary><b>Gaming Module</b> (<code>modules/gaming/</code>)</summary>

#### gaming.nix
- Steam (Remote Play, dedicated server, gamescope)
- Gamemode performance optimization
- MangoHud overlay
- Lutris game launcher
- ProtonUp Proton manager
- Unigine Heaven benchmark

</details>

<details>
<summary><b>System Feature Modules</b></summary>

#### fonts.nix
- Font Awesome
- Fira Code Nerd Font

#### laptoppower.nix
**For laptops only**
- Power management
- auto-cpufreq CPU frequency scaling

> **Note:** Desktop users should disable this module.

#### security.nix
- Security hardening
- Optional fingerprint authentication (commented out by default)

#### stylix.nix
- Tokyo Night Storm theme
- Automatic theme application
- Home Manager integration

#### virtualization.nix
- libvirtd (KVM/QEMU)
- virt-manager GUI
- quickemu for quick VMs

</details>

### Home Manager Modules

<details>
<summary><b>Home Manager Configuration</b> (<code>homemanager/</code>)</summary>

#### nvchad.nix
NeoVim with NvChad and Claude Code integration

**Enable:**
```nix
modules.nvchad.enable = true;
```

**LSP Servers:** Bash, Docker, Nix (nixd), Python

**Keybindings:**
- `<leader>cc` - Toggle Claude Code
- `<C-,>` - Toggle from terminal
- `<leader>cC` - Continue conversation

#### terminal.nix
Kitty terminal emulator

**Options:**
```nix
modules.terminal = {
  enable = true;
  theme = "tokyo-night-storm";
  opacity = 0.8;
};
```

#### browsers.nix
Web browser configuration

**Options:**
```nix
modules.browsers = {
  enable = true;
  enableBrave = true;
  enableQutebrowser = true;  # Privacy-focused, ad-blocking
};
```

**Qutebrowser search shortcuts:** `map`, `yt`, `git`, `wiki`, `reddit`, etc.

#### vdesktop.nix
Vesktop Discord client with custom theming

**Options:**
```nix
modules.vdesktop = {
  enable = true;
  theme = "tokyo-night-storm";
  opacity = 0.80;  # Window opacity

  settings = {
    enableMenu = true;
    minimizeToTray = true;
    discordBranch = "stable";
  };

  vencord = {
    useQuickCss = true;
    noTrack = true;  # Disable Discord tracking
  };
};
```

**Features:**
- Enhanced Discord client with better Linux/Wayland support
- Custom Tokyo Night Storm theme matching terminal and NvChad
- Vencord integration for privacy and customization
- NoTrack plugin to disable Discord telemetry

#### wayland.nix
Wayland compositor tools (Waybar, Wofi)

```nix
modules.wayland.enable = true;
```

#### stylix.nix
Stylix theme targets for user applications

**Themed apps:** Kitty, Neovim, Thunar, Hyprland, Hyprlock, Waybar, Wofi, Qutebrowser, GTK

**Note:** Vesktop uses a custom Tokyo Night Storm theme (configured in vdesktop.nix) instead of Stylix for better Discord-specific styling.

</details>

## Customization

### Adding a New Module

1. **Create module file:**
   ```nix
   # modules/myfeature.nix
   { config, pkgs, ... }:
   {
     # Your configuration
     programs.myapp.enable = true;
   }
   ```

2. **Import in your host configuration:**
   ```nix
   imports = [
     # ... other imports ...
     ./modules/myfeature.nix
   ];
   ```

### Adding a Home Manager Module

1. **Create module with options:**
   ```nix
   # homemanager/myapp.nix
   { config, pkgs, lib, ... }:
   with lib;
   let
     cfg = config.modules.myapp;
   in {
     options.modules.myapp = {
       enable = mkEnableOption "My application";
     };

     config = mkIf cfg.enable {
       programs.myapp.enable = true;
     };
   }
   ```

2. **Import and enable in `home.nix`:**
   ```nix
   imports = [ ./homemanager/myapp.nix ];
   modules.myapp.enable = true;
   ```

### Disabling Features

**System module:**
```nix
# Comment out in imports
# ./modules/gaming/gaming.nix
```

**Home Manager module:**
```nix
modules.nvchad.enable = false;
```

### Hardware-Specific Configurations

When adapting this configuration to your hardware:

1. **Graphics Configuration:**
   - **Intel/AMD integrated only:** Use `./modules/hardware/integrated-graphics.nix`
   - **NVIDIA hybrid graphics:** Use `./modules/hardware/nvidiahybrid.nix` and update PCI bus IDs
   - **Important:** Only import ONE graphics module, not both

2. **Laptop Power:** Desktop users should remove `./modules/laptoppower.nix`

3. **PCI Bus IDs (NVIDIA only):** If using NVIDIA hybrid graphics, update PCI addresses in the module

4. **AMD Graphics:** If using AMD integrated graphics, edit `integrated-graphics.nix` and uncomment AMD-specific settings

5. **Bluetooth/WiFi:** Adjust as needed for your hardware

### Adding a New Host

See [hosts/template/README.md](hosts/template/README.md) for detailed instructions.

## Troubleshooting

<details>
<summary><b>Build Failures</b></summary>

```bash
# Check for syntax errors
nix flake check /etc/nixos

# Show detailed errors
sudo nixos-rebuild switch --flake /etc/nixos --show-trace
```

</details>

<details>
<summary><b>NVIDIA Issues</b></summary>

```bash
# Check if driver is loaded
nvidia-smi

# Test offload
nvidia-offload glxinfo | grep "OpenGL renderer"

# Switch to gaming mode
sudo nixos-rebuild switch --specialisation gaming-time

# Switch back
sudo nixos-rebuild switch
```

</details>

<details>
<summary><b>Hyprland Issues</b></summary>

```bash
# Restart Hyprland
hyprctl reload

# Check version
hyprctl version

# View logs
journalctl --user -u hyprland
```

</details>

<details>
<summary><b>Audio Issues</b></summary>

```bash
# Restart PipeWire
systemctl --user restart pipewire pipewire-pulse wireplumber

# Check status
pactl info

# Audio mixer
pulsemixer
```

</details>

## Example Configurations

This repository includes an example configuration for a **Dell XPS 15 9520** in `hosts/xps9520/`. Use it as a reference when creating your own host configuration.

**Hardware specifics in the example:**
- Intel integrated graphics + NVIDIA dedicated GPU
- Laptop power management enabled
- All desktop and gaming modules enabled

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Stylix Documentation](https://github.com/danth/stylix)
- [Nix Flakes Guide](https://nixos.wiki/wiki/Flakes)

## License

This configuration is provided as-is for educational and personal use. See [LICENSE](LICENSE) for details.

---

**Repository:** [github.com/TyF1ghter/nixos](https://github.com/TyF1ghter/nixos)
