# NixOS Multi-Host Configuration

A modular NixOS configuration using flakes for managing multiple machines. This guide will walk you through reproducing this configuration on a fresh NixOS minimal installation.

## Before You Begin

This guide assumes you have booted into the NixOS minimal installer and have an internet connection. You should be at a command prompt.

## Step 1: Partition and Format Your Drives

This is the most variable step, as it depends on your specific hardware and preferences. Here is a common example for a system with a single NVMe drive (`/dev/nvme0n1`).

**Warning:** This will erase all data on the drive.

1.  **Create a GPT partition table.**
2.  **Create a 512MB EFI partition.** This is for your bootloader.
3.  **Create a root partition with the rest of the space.**

You can use a tool like `gdisk` or `parted` to do this.

Once partitioned, you need to format and mount the partitions.

```bash
# Format the EFI partition as FAT32
mkfs.fat -F 32 /dev/nvme0n1p1

# Format the root partition as ext4
mkfs.ext4 /dev/nvme0n1p2

# Mount the root partition
mount /dev/nvme0n1p2 /mnt

# Create the boot directory and mount the EFI partition
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

## Step 2: Clone the Configuration

Now that your drives are mounted, you need to clone this repository into the `/mnt/etc/nixos` directory.

```bash
# Install git
nix-shell -p git

# Clone the repository
git clone https://github.com/TyF1ghter/nixos.git /mnt/etc/nixos

# Navigate into the new directory
cd /mnt/etc/nixos
```

## Step 3: Configure Your System

This is where you will adapt the configuration to your specific hardware and preferences.

### 1. Choose a Host Configuration

This repository contains several host configurations under the `hosts/` directory. For a new installation, it is recommended to start with the `9310` configuration as it is the most up-to-date.

### 2. Edit `configuration.nix`

You need to edit the `hosts/9310/configuration.nix` file to match your system.

```bash
# Use nano to edit the file
nano hosts/9310/configuration.nix
```

Here are the key things you need to change:

*   **`networking.hostName`**: Change this to your desired hostname.
*   **`time.timeZone`**: Set this to your timezone (e.g., "America/New_York").
*   **`users.users.your_username`**: Change `ty` to your desired username.
*   **`home-manager.users.your_username`**: Change `ty` to your desired username here as well.

### 3. Generate Hardware Configuration

NixOS can detect your hardware and generate a configuration file for it.

```bash
nixos-generate-config --show-hardware-config > hosts/9310/hardware-configuration.nix
```

This will create a `hardware-configuration.nix` file in the `hosts/9310` directory, which will be automatically included in your build.

### 4. Edit `flake.nix`

The `flake.nix` file is the entry point for your configuration. You need to make sure it's set to build the correct host.

```bash
# Use nano to edit the file
nano flake.nix
```

Look for the `nixosConfigurations` section. It should look like this:

```nix
nixosConfigurations = {
  "9310" = nixpkgs.lib.nixosSystem {
    # ...
  };
  # ... other hosts
};
```

The name `"9310"` is the name of the host configuration we are using. You will use this name during installation.

## Step 4: Install NixOS

Now you are ready to install NixOS.

```bash
# Run the installer
nixos-install --flake .#9310
```

**Note:** The `.#9310` at the end tells the installer to use the `9310` host configuration from your `flake.nix` file.

The installation will take some time as it downloads and builds all the packages.

## Step 5: Reboot

Once the installation is complete, you can reboot your system.

```bash
reboot
```

You should now boot into your new NixOS system, configured with this repository.

## Post-Installation

After rebooting, you will be greeted with the desktop environment. You can open a terminal and run the following command to apply any future changes you make to your configuration:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#9310
```

Welcome to NixOS!
