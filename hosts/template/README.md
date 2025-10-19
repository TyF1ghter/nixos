# New Host Setup Guide

This template provides a starting point for adding a new host to your NixOS configuration.

## Quick Setup

1. **Copy this template:**
   ```bash
   cp -r hosts/template hosts/YOUR-HOSTNAME
   ```

2. **Generate hardware configuration:**
   ```bash
   nixos-generate-config --show-hardware-config > hosts/YOUR-HOSTNAME/hardware-configuration.nix
   ```

3. **Edit configuration.nix:**
   ```bash
   nvim hosts/YOUR-HOSTNAME/configuration.nix
   ```

   Update the following:
   - `networking.hostName` - Change "HOSTNAME" to your actual hostname
   - `users.users.USERNAME` - Change "USERNAME" to your username (appears twice)
   - `time.timeZone` - Set your timezone
   - Uncomment hardware modules you need (NVIDIA, laptop power management, etc.)
   - Add any hardware-specific kernel parameters in `boot.kernelParams`

4. **Add to flake.nix:**
   ```bash
   nvim flake.nix
   ```

   Add a new entry in `nixosConfigurations`:
   ```nix
   YOUR-HOSTNAME = nixpkgs.lib.nixosSystem {
     specialArgs = { inherit inputs; };
     system = "x86_64-linux";  # or "aarch64-linux" for ARM
     modules = [
       ./hosts/YOUR-HOSTNAME/configuration.nix
       inputs.stylix.nixosModules.stylix
       inputs.home-manager.nixosModules.home-manager
       {
         home-manager.useGlobalPkgs = true;
         home-manager.useUserPackages = true;
         home-manager.backupFileExtension = "hm-backup";
       }
     ];
   };
   ```

5. **Build and activate:**
   ```bash
   sudo nixos-rebuild switch --flake ~/.config/nixos#YOUR-HOSTNAME
   ```

## Customization

### Hardware-Specific Modules

Uncomment in `configuration.nix` based on your hardware:

- **NVIDIA Hybrid Graphics:** `../../modules/hardware/nvidiahybrid.nix`
- **Laptop Power Management:** `../../modules/laptoppower.nix`
- **Gaming (Steam):** `../../modules/gaming/steam.nix`
- **Virtualization:** `../../modules/virtualization.nix`

### nixos-hardware Integration

If your hardware is supported by [nixos-hardware](https://github.com/NixOS/nixos-hardware), add it to your flake entry:

```nix
YOUR-HOSTNAME = nixpkgs.lib.nixosSystem {
  modules = [
    ./hosts/YOUR-HOSTNAME/configuration.nix
    nixos-hardware.nixosModules.dell-xps-15-9520  # Example
    # ... rest of modules
  ];
};
```

### Home Manager

The template uses the shared `home.nix` configuration. To create a user-specific config:

1. Create `hosts/YOUR-HOSTNAME/home.nix`
2. Update the home-manager user import in `configuration.nix`:
   ```nix
   home-manager.users."USERNAME" = import ./home.nix;
   ```

## Troubleshooting

### Build fails with "undefined variable"
Make sure you updated all instances of `HOSTNAME` and `USERNAME` in `configuration.nix`.

### Hardware not detected
Review your `hardware-configuration.nix` and ensure all necessary hardware modules are imported.

### Flake not found
Ensure the path in shell aliases and rebuild commands matches where you cloned the repository.
