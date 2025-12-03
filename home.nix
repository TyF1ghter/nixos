# Global Home Manager Configuration
#
# This file acts as a central manifest for all possible user-level modules.
# It should import all modular components that any host might want to use.
#
# Enabling/disabling modules is done on a per-host basis in the host's
# `configuration.nix` file, within the `home-manager.users.<user>.config` block.
#
# Example in a host's configuration.nix:
#
# home-manager.users.ty.config = {
#   modules.desktop-niri.enable = true;
#   modules.hyprland.enable = false;
# };
#
{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    # --- Core Integrations ---
    inputs.nix4nvchad.homeManagerModule
    inputs.spicetify-nix.homeManagerModules.default

    # --- Common Modules ---
    ./homemanager/nvchad.nix
    ./homemanager/terminal.nix
    ./homemanager/browsers.nix
    ./homemanager/vdesktop.nix
    ./homemanager/element.nix
    ./homemanager/stylix.nix
    ./homemanager/btop.nix
    ./homemanager/alacritty.nix

    # --- Desktop Environment Modules ---
    # (These are the "switches" for different desktops)
    
    # Niri (DankMaterialShell version)
    ./homemanager/niri.nix

    # Hyprland
    ./homemanager/hyprland.nix

    # --- Desktop Component Modules ---
    # (These can be enabled by the desktop modules above)
    ./homemanager/wayland.nix
    ./homemanager/waybar.nix
    ./homemanager/wofi.nix
    ./homemanager/dunst.nix
    ./homemanager/hyprlock.nix
    ./homemanager/hyprpaper.nix
    ./homemanager/swaylock.nix
    ./homemanager/swayidle.nix
    ./homemanager/dankshell-tokyonight.nix
  ];

  options = {
    wallpaperDir = lib.mkOption {
      type = lib.types.path;
      default = "/home/ty/nixos-repo/walls";
      description = "Directory where wallpapers are stored for use across modules.";
    };
  };

  config = {
    # --- Basic Home Manager Configuration ---
    # These are common settings for all users.
    # Username and homeDirectory are inferred from the host config.
    home.stateVersion = "24.11";
    programs.home-manager.enable = true;

    # Suppress version mismatch warnings for Stylix
    stylix.enableReleaseChecks = false;

    # Define any other global settings, packages, or session variables here
    # if you want them to apply to ALL hosts that use this file.
    home.packages = [];
    home.sessionVariables = {};
    home.file = {};
  };
}