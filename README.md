# NixOS Multi-Host Configuration

Modular NixOS configuration with support for multiple hosts. Currently configured for Dell XPS 15 9520 with NVIDIA hybrid graphics, Hyprland desktop environment, and comprehensive gaming support.

## Features

- **Multi-host support** - Easy to add new machines
- **Modular design** - Enable/disable features per host
- **Home Manager integration** - Declarative user configuration
- **Comprehensive modules** - Hardware, desktop, gaming, and more
- **Well-documented** - Extensive documentation and examples

## Directory Structure

```
/home/nix/nixos/
├── configuration.nix          # Main system configuration
├── flake.nix                  # Flake inputs and outputs
├── hardware-configuration.nix # Auto-generated hardware config
├── home.nix                   # Home Manager entry point
├── starship.toml             # Starship prompt configuration
├── modules/                   # System-level modules
│   ├── hardware/             # Hardware configuration modules
│   ├── services/             # System services modules
│   ├── desktop/              # Desktop environment modules
│   ├── gaming/               # Gaming-related modules
│   └── *.nix                 # Individual feature modules
└── homemanager/              # User-level modules
    └── *.nix                 # Home Manager feature modules
```

## Quick Start

### First Time Setup

1. **Clone this repository:**
   ```bash
   git clone https://github.com/YOUR-USERNAME/nixos-config ~/.config/nixos
   cd ~/.config/nixos
   ```

2. **Create your host configuration:**
   ```bash
   # Copy the template
   cp -r hosts/template hosts/$(hostname)

   # Generate hardware config
   nixos-generate-config --show-hardware-config > hosts/$(hostname)/hardware-configuration.nix

   # Edit configuration (update HOSTNAME and USERNAME)
   nvim hosts/$(hostname)/configuration.nix
   ```

3. **Add your host to flake.nix:**
   ```bash
   nvim flake.nix
   # See hosts/template/README.md for detailed instructions
   ```

4. **Build and activate:**
   ```bash
   sudo nixos-rebuild switch --flake ~/.config/nixos#$(hostname)
   ```

### Daily Usage

```bash
updoot       # Rebuild system
nixconf      # Edit host configuration
homeconf     # Edit home-manager config
flakeconf    # Edit flake.nix
flakedoot    # Update flake inputs
```

## System Modules

### Hardware Modules (`modules/hardware/`)

<details id="nvidia">
<summary><strong>nvidia.nix</strong> - NVIDIA GPU configuration with hybrid graphics support</summary>

**Features:**
- NVIDIA proprietary drivers (stable)
- PRIME offload mode for battery saving
- Intel integrated GPU (primary)
- Gaming specialisation with PRIME sync

**Usage:**
```bash
# Normal mode (offload, battery efficient)
nvidia-offload <application>

# Gaming mode (sync, high performance)
sudo nixos-rebuild switch --specialisation gaming-time
```

**Configuration:**
- Integrated GPU: Intel (PCI:0:02:0)
- Dedicated GPU: NVIDIA (PCI:1:0:0)
- Force full composition pipeline enabled
- Power management enabled

</details>

<details id="audio">
<summary><strong>audio.nix</strong> - PipeWire audio system configuration</summary>

**Features:**
- PipeWire with WirePlumber
- ALSA support (including 32-bit)
- PulseAudio compatibility layer
- Real-time kit (rtkit) enabled

</details>

<details id="bluetooth">
<summary><strong>bluetooth.nix</strong> - Bluetooth hardware support</summary>

**Features:**
- Bluetooth hardware enabled
- Blueman GUI manager

</details>

### Services Modules (`modules/services/`)

<details id="networking">
<summary><strong>networking.nix</strong> - Network configuration and VPN support</summary>

**Features:**
- NetworkManager with multiple VPN plugins:
  - FortiSSL VPN
  - Iodine
  - L2TP
  - OpenConnect
  - OpenVPN
  - SSTP
  - VPNC
- Tailscale VPN
- WireGuard Netmanager
- Firewall enabled

</details>

<details id="display-manager">
<summary><strong>display-manager.nix</strong> - Display server and input configuration</summary>

**Features:**
- GDM (GNOME Display Manager) with Wayland
- Libinput touchpad configuration:
  - Two-finger scrolling
  - Natural scrolling enabled
  - Click-finger method
  - Typing detection disabled
- GNOME services (keyring, sushi, gvfs, tumbler)

</details>

<details id="system-services">
<summary><strong>system-services.nix</strong> - Miscellaneous system services</summary>

**Features:**
- Hypridle (idle daemon)
- Firmware support
- ACPI light controls
- Xbox One controller support

</details>

### Desktop Modules (`modules/desktop/`)

<details id="hyprland">
<summary><strong>hyprland.nix</strong> - Hyprland Wayland compositor configuration</summary>

**Features:**
- Hyprland with XWayland support
- Hyprlock screen locker
- PAM authentication integration
- Hyprland ecosystem tools:
  - hyprpicker (color picker)
  - hyprpaper (wallpaper)
  - hyprcursor (cursor theme)
  - hyprshot (screenshot)
- Wayland utilities:
  - waybar (status bar)
  - wofi (launcher)
  - swww (wallpaper daemon)
  - grim (screenshot)
  - dunst (notifications)
  - wlogout (logout menu)

</details>

<details id="xdg">
<summary><strong>xdg.nix</strong> - XDG portal configuration for desktop integration</summary>

**Features:**
- XDG Desktop Portal (Hyprland)
- GTK portal fallback
- Proper file picker and screen sharing support

</details>

<details id="thunar">
<summary><strong>thunar.nix</strong> - File manager and file utilities</summary>

**Features:**
- Thunar file manager with plugins:
  - Archive plugin
  - Volume manager
- File-roller (archive manager)
- File management utilities (dysk, fzf, gvfs, udiskie)

</details>

### Gaming Module (`modules/gaming/`)

<details id="gaming">
<summary><strong>gaming.nix</strong> - Complete gaming setup with Steam and related tools</summary>

**Features:**
- Steam with:
  - Remote Play
  - Dedicated server support
  - Local network game transfers
  - Gamescope session
- Gamemode (performance optimization)
- Steam hardware support
- Additional packages:
  - MangoHud (performance overlay)
  - Lutris (game launcher)
  - ProtonUp (Proton manager)
  - Unigine Heaven (benchmark)

**Environment Variables:**
- `STEAM_EXTRA_COMPAT_TOOLS_PATHS` - Custom Proton tools location

</details>

### System Feature Modules

<details id="fonts">
<summary><strong>fonts.nix</strong> - Font configuration</summary>

**Installed Fonts:**
- Font Awesome
- Fira Code Nerd Font

</details>

<details id="power">
<summary><strong>power.nix</strong> - Laptop power management</summary>

**Features:**
- System power management enabled
- auto-cpufreq (CPU frequency scaling)

</details>

<details id="security">
<summary><strong>security.nix</strong> - Security and authentication</summary>

**Note:** Fingerprint authentication is commented out but available.

**To Enable Fingerprint:**
Uncomment lines in `modules/security.nix` and ensure you have the correct driver.

</details>

<details id="stylix">
<summary><strong>stylix.nix</strong> - System-wide theming with Stylix</summary>

**Features:**
- Tokyo Night Storm theme
- Automatic theme application
- Home Manager integration

**Theme:** `tokyo-night-storm.yaml` from base16-schemes

</details>

<details id="virtualization">
<summary><strong>virtualization.nix</strong> - Virtual machine support</summary>

**Features:**
- libvirtd (KVM/QEMU)
- virt-manager GUI
- quickemu (quick VM setup)

</details>

## Home Manager Modules

Home Manager modules use an option-based system for flexibility.

<details id="nvchad">
<summary><strong>nvchad.nix</strong> - NeoVim with NvChad and Claude Code integration</summary>

**Enable:**
```nix
modules.nvchad.enable = true;
```

**Features:**
- NvChad configuration framework
- Claude Code plugin
- Language servers:
  - Bash (bash-language-server)
  - Docker (docker-compose, dockerfile)
  - Emmet
  - Nix (nixd)
  - Python (python-lsp-server, flake8)

**Keybindings:**
- `<leader>cc` - Toggle Claude Code
- `<C-,>` - Toggle from terminal
- `<leader>cC` - Continue conversation
- `<leader>cV` - Verbose mode

</details>

<details id="terminal">
<summary><strong>terminal.nix</strong> - Terminal emulator configuration (Kitty)</summary>

**Enable:**
```nix
modules.terminal.enable = true;
```

**Options:**
```nix
modules.terminal = {
  enable = true;
  theme = "tokyo-night-storm";  # Color theme
  opacity = 0.8;                 # Background opacity (0.0-1.0)
};
```

</details>

<details id="browsers">
<summary><strong>browsers.nix</strong> - Web browser configuration</summary>

**Enable:**
```nix
modules.browsers.enable = true;
```

**Options:**
```nix
modules.browsers = {
  enable = true;
  enableBrave = true;       # Brave browser
  enableQutebrowser = true; # Qutebrowser
};
```

**Qutebrowser Features:**
- Ad blocking with multiple filter lists
- Privacy-focused settings
- Private browsing enabled
- Dark mode enabled
- Custom search engines (DDG, GitHub, YouTube, etc.)

**Search Shortcuts:**
- `map <query>` - Google Maps
- `yt <query>` - YouTube
- `git <query>` - GitHub
- `wiki <query>` - Wikipedia
- `reddit <query>` - Reddit
- And many more...

</details>

<details id="desktop-apps">
<summary><strong>desktop-apps.nix</strong> - Desktop applications</summary>

**Enable:**
```nix
modules.desktop-apps.enable = true;
```

**Options:**
```nix
modules.desktop-apps = {
  enable = true;
  theme = "tokyo-night-storm";  # App theme
};
```

**Includes:**
- Vesktop (Discord client)

</details>

<details id="wayland">
<summary><strong>wayland.nix</strong> - Wayland compositor tools</summary>

**Enable:**
```nix
modules.wayland.enable = true;
```

**Includes:**
- Waybar (status bar)
- Wofi (application launcher)

</details>

<details id="stylix-hm">
<summary><strong>stylix.nix</strong> - Stylix theme targets for user applications</summary>

**Enable:**
```nix
modules.stylix-config.enable = true;
```

**Themed Applications:**
- Kitty (terminal)
- Neovim
- XFCE/Thunar
- Vesktop
- Hyprland
- Hyprlock
- Waybar
- Wofi
- Qutebrowser
- GTK applications

</details>

## Shell Aliases

Configured in `configuration.nix`:

| Alias | Command | Description |
|-------|---------|-------------|
| `updoot` | `sudo nixos-rebuild switch --flake /etc/nixos` | Rebuild system |
| `nixconf` | `sudo nvim /etc/nixos/configuration.nix` | Edit main config |
| `homeconf` | `sudo nvim /etc/nixos/home.nix` | Edit home config |
| `flakeconf` | `sudo nvim /etc/nixos/flake.nix` | Edit flake config |
| `win10` | `quickemu --vm windows-10.conf` | Start Windows 10 VM |
| `rebar` | `pkill waybar && hyprctl dispatch exec waybar` | Restart Waybar |
| `tdown` | `sudo tailscale down` | Stop Tailscale |
| `tup` | `sudo tailscale up` | Start Tailscale |
| `mixer` | `pulsemixer` | Audio mixer |
| `vi` | `nvim` | NeoVim |

## Package Management

### System Packages
Installed via `environment.systemPackages` in `configuration.nix`.

**Categories:**
- Core tools (vim, git, htop, btop)
- Editors (vscodium)
- Browsers (brave, librewolf, mullvad-browser, qutebrowser, zen-browser)
- System utilities (polkit, wl-clipboard, brightnessctl)
- Security (bitwarden, proton-pass)
- Development (ripgrep, xclip, claude-code)

### User Packages
Managed through Home Manager modules or `home.packages` in `home.nix`.

## Maintenance

### Garbage Collection
Automatic weekly cleanup configured in `configuration.nix`:
```nix
nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 7d";
};
```

**Manual Cleanup:**
```bash
sudo nix-collect-garbage -d
nix-collect-garbage -d  # User profile
```

### Updating System
```bash
# Update flake inputs
sudo nix flake update /etc/nixos

# Rebuild with updates
updoot
```

## Customization

### Adding a New Module

1. **Create module file** in appropriate directory:
```nix
# modules/myfeature.nix
{ config, pkgs, ... }:

{
  # Your configuration here
  programs.myapp.enable = true;
}
```

2. **Import in configuration.nix:**
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
in
{
  options.modules.myapp = {
    enable = mkEnableOption "My application";
  };

  config = mkIf cfg.enable {
    programs.myapp.enable = true;
  };
}
```

2. **Import in home.nix:**
```nix
imports = [
  # ... other imports ...
  ./homemanager/myapp.nix
];

modules.myapp.enable = true;
```

### Disabling Features

To disable a module, simply comment out or remove its import line.

**Example - Disable Gaming:**
```nix
# configuration.nix
imports = [
  # ...
  # ./modules/gaming/gaming.nix  # Commented out
];
```

**Example - Disable Home Manager Module:**
```nix
# home.nix
modules = {
  nvchad.enable = false;  # Disabled
  terminal.enable = true;
  # ...
};
```

## Troubleshooting

### Build Failures
```bash
# Check for syntax errors
nix flake check /etc/nixos

# Show detailed error messages
sudo nixos-rebuild switch --flake /etc/nixos --show-trace
```

### NVIDIA Issues
```bash
# Check if NVIDIA driver is loaded
nvidia-smi

# Use NVIDIA for specific app
nvidia-offload <application>

# Switch to gaming mode
sudo nixos-rebuild switch --specialisation gaming-time

# Switch back to normal
sudo nixos-rebuild switch
```

### Hyprland Issues
```bash
# Restart Hyprland
hyprctl reload

# Check Hyprland version
hyprctl version

# View logs
journalctl --user -u hyprland
```

### Audio Issues
```bash
# Restart PipeWire
systemctl --user restart pipewire pipewire-pulse wireplumber

# Check audio status
pactl info
```

## System Specifications

- **Model:** Dell XPS 15 9520
- **CPU:** Intel (with integrated graphics)
- **GPU:** NVIDIA (hybrid graphics)
- **Display:** GDM + Hyprland (Wayland)
- **Shell:** Bash with Starship prompt
- **Theme:** Tokyo Night Storm

## Additional Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Stylix Documentation](https://github.com/danth/stylix)

## Adding a New Host

See the detailed guide in [hosts/template/README.md](hosts/template/README.md) for step-by-step instructions on adding a new host to this configuration.

## Contributing

Feel free to fork this repository and adapt it to your needs! If you make improvements to the shared modules, consider contributing back via pull requests.

## State Versions

- **System:** 25.11 (`configuration.nix`)
- **Home Manager:** 24.11 (`home.nix`)

**Note:** Do not change these versions unless you understand the implications. See NixOS documentation for details.

## License

This configuration is provided as-is for educational and personal use. See [LICENSE](LICENSE) for details.
