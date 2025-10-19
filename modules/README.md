# System Modules

System-level NixOS modules for hardware, services, desktop environment, and features.

## Module Organization

```
modules/
├── hardware/              # Hardware-specific configuration
│   ├── nvidia.nix        # NVIDIA GPU + hybrid graphics
│   ├── audio.nix         # PipeWire audio system
│   └── bluetooth.nix     # Bluetooth support
├── services/             # System services
│   ├── networking.nix    # Network + VPN configuration
│   ├── display-manager.nix  # GDM + input devices
│   └── system-services.nix  # Misc system services
├── desktop/              # Desktop environment
│   ├── hyprland.nix      # Hyprland compositor + tools
│   ├── xdg.nix           # XDG portals
│   └── thunar.nix        # File manager
├── gaming/               # Gaming configuration
│   └── steam.nix         # Steam + gaming tools
├── fonts.nix             # Font configuration
├── power.nix             # Power management
├── security.nix          # Security settings
├── stylix.nix            # System theming
└── virtualization.nix    # VM support
```

## Usage

All modules are imported in `configuration.nix`:

```nix
imports = [
  ./modules/hardware/nvidia.nix
  ./modules/services/networking.nix
  # ... etc
];
```

## Module Details

### hardware/nvidia.nix

**Purpose:** NVIDIA GPU configuration with Intel+NVIDIA hybrid graphics (PRIME).

**Key Settings:**
- Modesetting enabled
- Proprietary driver (stable)
- PRIME offload mode (default)
- Gaming specialisation with PRIME sync

**Specialisations:**
```bash
# High-performance gaming mode
sudo nixos-rebuild switch --specialisation gaming-time
```

**Variables:**
- `intelBusId`: PCI bus ID for Intel GPU
- `nvidiaBusId`: PCI bus ID for NVIDIA GPU

### hardware/audio.nix

**Purpose:** Modern audio stack with PipeWire.

**Features:**
- Replaces PulseAudio with PipeWire
- WirePlumber session manager
- ALSA compatibility (32-bit support)
- Real-time scheduling (rtkit)

### hardware/bluetooth.nix

**Purpose:** Bluetooth hardware and management.

**Simple module enabling:**
- Bluetooth kernel modules
- Blueman GUI manager

### services/networking.nix

**Purpose:** Complete networking stack with VPN support.

**Features:**
- NetworkManager with 7 VPN plugins
- Tailscale mesh VPN
- WireGuard Netmanager
- Firewall (enabled)
- OpenVPN3 CLI
- Network Manager applet

### services/display-manager.nix

**Purpose:** Display manager and input device configuration.

**Components:**
- GDM with Wayland enabled
- Libinput touchpad settings
- GNOME services (keyring, gvfs, sushi, tumbler)
- US keyboard layout

**Touchpad Configuration:**
- Natural scrolling: Yes
- Tap to click: No
- Two-finger scrolling
- Click-finger method
- Continue typing while touching

### services/system-services.nix

**Purpose:** Miscellaneous system services.

**Includes:**
- Hypridle (idle management)
- All firmware enabled
- ACPI light controls
- Xbox One controller (xone)

### desktop/hyprland.nix

**Purpose:** Hyprland Wayland compositor with ecosystem.

**Core:**
- Hyprland with XWayland
- Hyprlock screen locker
- PAM authentication

**Tools Installed:**
- **Status:** waybar
- **Launcher:** wofi
- **Screenshots:** grim, hyprshot
- **Wallpaper:** swww, hyprpaper
- **Notifications:** dunst
- **Utilities:** hyprpicker, nwg-displays, nwg-look, brightnessctl

### desktop/xdg.nix

**Purpose:** XDG desktop integration.

**Portals:**
- xdg-desktop-portal-hyprland (primary)
- xdg-desktop-portal-gtk (fallback)

**Enables:**
- File picker dialogs
- Screen sharing
- Screenshot portals

### desktop/thunar.nix

**Purpose:** File management with Thunar.

**Features:**
- Thunar file manager
- Archive plugin (compression support)
- Volume manager plugin
- File-roller for archives
- CLI tools: dysk, fzf, gvfs, udiskie

### gaming/steam.nix

**Purpose:** Complete gaming setup.

**Steam Configuration:**
- Remote Play (firewall opened)
- Dedicated server support
- Local network transfers
- Gamescope session

**Additional Tools:**
- MangoHud (FPS/performance overlay)
- Lutris (game launcher)
- ProtonUp (Proton-GE manager)
- Unigine Heaven (GPU benchmark)

**Optimizations:**
- Gamemode (CPU governor switching)
- Steam hardware drivers

### fonts.nix

**Purpose:** System font installation.

**Fonts:**
- Font Awesome (icons)
- Fira Code Nerd Font (terminal/coding)

### power.nix

**Purpose:** Laptop power management.

**Features:**
- System power management
- auto-cpufreq (automatic CPU frequency scaling)

**Benefits:**
- Better battery life
- Thermal management
- Performance when needed

### security.nix

**Purpose:** Security and authentication.

**Current Status:** Placeholder for fingerprint auth (commented out).

**To Enable Fingerprint:**
1. Uncomment lines
2. Set correct driver path
3. Enroll fingerprints: `fprintd-enroll`

### stylix.nix

**Purpose:** System-wide theming with Stylix.

**Configuration:**
- Theme: Tokyo Night Storm
- Auto-enable for supported programs
- Home Manager integration

**Theming Philosophy:**
- One theme definition
- Automatic application
- Consistent colors everywhere

### virtualization.nix

**Purpose:** Virtual machine support.

**Features:**
- libvirtd (KVM/QEMU backend)
- virt-manager (GUI)
- quickemu (easy VM creation)

**Usage:**
```bash
# Using virt-manager
virt-manager

# Using quickemu
quickemu --vm myvm.conf
```

## Creating New Modules

### Basic Module Template

```nix
{ config, pkgs, ... }:

{
  # Configuration here
  programs.myapp.enable = true;

  environment.systemPackages = with pkgs; [
    mypackage
  ];
}
```

### Module with Options

```nix
{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.myfeature;
in
{
  options.modules.myfeature = {
    enable = mkEnableOption "My feature";

    setting = mkOption {
      type = types.str;
      default = "value";
      description = "A setting";
    };
  };

  config = mkIf cfg.enable {
    # Configuration when enabled
  };
}
```

## Best Practices

1. **One Concern Per Module:** Each module should configure one feature or related set of features.

2. **Minimal Dependencies:** Modules should be as independent as possible.

3. **Reasonable Defaults:** Choose sensible defaults that work for most users.

4. **Document Assumptions:** Comment any hardware-specific settings (e.g., PCI bus IDs).

5. **Group Related Packages:** Keep package lists in the relevant module, not in main config.

6. **Use Options for Flexibility:** For reusable modules, add options rather than hardcoding values.

## Module Interactions

Some modules depend on or enhance others:

- `hyprland.nix` works best with `xdg.nix` for proper portals
- `nvidia.nix` integrates with `display-manager.nix` for video drivers
- `audio.nix` requires `security.nix` (rtkit) for real-time scheduling
- `stylix.nix` themes applications configured in all modules

## Disabling Modules

To disable a module, remove or comment its import from `configuration.nix`:

```nix
imports = [
  # ./modules/gaming/steam.nix  # Disabled
];
```

Some modules can be safely removed without affecting others:
- `gaming/steam.nix` - Self-contained
- `virtualization.nix` - Self-contained
- `bluetooth.nix` - If you don't use Bluetooth

Other modules are more foundational:
- `hardware/audio.nix` - Required for sound
- `services/display-manager.nix` - Required for GUI login
- `desktop/hyprland.nix` - Required for desktop environment
