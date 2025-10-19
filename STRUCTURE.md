# NixOS Multi-Host Configuration Structure

This repository is organized to support managing multiple NixOS hosts from a single configuration.

## Directory Structure

```
nixos/
├── flake.nix                    # Main flake with all host definitions
├── flake.lock                   # Flake lock file
├── hosts/                       # Host-specific configurations
│   └── xps9520/                 # Dell XPS 9520 configuration
│       ├── configuration.nix    # Host-specific system config
│       └── hardware-configuration.nix  # Hardware scan results
├── modules/                     # Shared system modules
│   ├── desktop/                 # Desktop environment modules
│   │   ├── hyprland.nix
│   │   ├── thunar.nix
│   │   └── xdg.nix
│   ├── gaming/                  # Gaming-related modules
│   │   └── gaming.nix
│   ├── hardware/                # Hardware configuration modules
│   │   ├── audio.nix
│   │   ├── bluetooth.nix
│   │   └── nvidia.nix
│   ├── services/                # System services
│   │   ├── display-manager.nix
│   │   ├── networking.nix
│   │   └── system-services.nix
│   ├── fonts.nix
│   ├── power.nix
│   ├── security.nix
│   ├── stylix.nix
│   └── virtualization.nix
├── home.nix                     # Home Manager user configuration
├── homemanager/                 # Home Manager modules
│   ├── browsers.nix
│   ├── desktop-apps.nix
│   ├── nvchad.nix
│   ├── stylix.nix
│   ├── terminal.nix
│   └── wayland.nix
└── assets/                      # Static files
    ├── bluesunset.jpg
    └── starship.toml
```

## Adding a New Host

1. Create a new directory under `hosts/` for your machine:
   ```bash
   mkdir -p hosts/hostname
   ```

2. Generate hardware configuration for the new host:
   ```bash
   nixos-generate-config --show-hardware-config > hosts/hostname/hardware-configuration.nix
   ```

3. Copy and customize a configuration file:
   ```bash
   cp hosts/xps9520/configuration.nix hosts/hostname/configuration.nix
   ```

4. Edit `hosts/hostname/configuration.nix`:
   - Update `networking.hostName` to match your hostname
   - Adjust hardware-specific settings (bootloader, kernel params, etc.)
   - Add/remove module imports based on the host's needs
   - Update time zone and locale if different
   - Modify system packages as needed

5. Add the new host to `flake.nix`:
   ```nix
   outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs: {
     nixosConfigurations = {
       xps9520 = { ... };  # Existing host

       hostname = nixpkgs.lib.nixosSystem {
         specialArgs = { inherit inputs; };
         system = "x86_64-linux";  # or "aarch64-linux" for ARM
         modules = [
           ./hosts/hostname/configuration.nix
           # Add any nixos-hardware modules if needed
           inputs.stylix.nixosModules.stylix
           inputs.home-manager.nixosModules.home-manager
           {
             home-manager.useGlobalPkgs = true;
             home-manager.useUserPackages = true;
             home-manager.backupFileExtension = "hm-backup";
           }
         ];
       };
     };
   };
   ```

6. Build and test the new configuration:
   ```bash
   sudo nixos-rebuild switch --flake /home/nix/nixos#hostname
   ```

## Building Configurations

### Rebuild current host
```bash
# Using the updoot alias (for xps9520)
updoot

# Or manually
sudo nixos-rebuild switch --flake /home/nix/nixos#xps9520
```

### Build specific host
```bash
sudo nixos-rebuild switch --flake /home/nix/nixos#hostname
```

### Update flake inputs
```bash
# Using the flakedoot alias
flakedoot

# Or manually
sudo nix flake update --flake /home/nix/nixos
```

## Sharing Modules Between Hosts

Modules in the `modules/` directory are shared across all hosts. Each host can selectively import the modules it needs:

```nix
# In hosts/hostname/configuration.nix
imports = [
  ./hardware-configuration.nix
  ../../modules/hardware/audio.nix      # Shared audio config
  ../../modules/services/networking.nix # Shared networking
  # ... other modules
];
```

## Per-Host Customization

Host-specific settings should go in `hosts/hostname/configuration.nix`:
- Hostname
- Bootloader configuration
- Hardware-specific kernel parameters
- Time zone and locale
- Host-specific packages
- User accounts

## Home Manager

Home Manager configurations are located at the root level:
- `home.nix` - Main home configuration
- `homemanager/` - Modular home-manager configs

To use the same home configuration across multiple hosts, just reference it in each host's configuration:

```nix
home-manager.users."username" = import ../../home.nix;
```

## Useful Commands

- Edit host config: `nixconf` (updates to point to current host)
- Edit home config: `homeconf`
- Edit flake: `flakeconf`
- Update system: `updoot`
- Update flake inputs: `flakedoot`

## Tips

1. Keep shared configuration in `modules/`
2. Keep host-specific config in `hosts/hostname/`
3. Test new hosts with `nixos-rebuild build` before switching
4. Use git to track configuration changes
5. Consider creating host-specific branches for major changes
