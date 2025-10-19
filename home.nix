{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    # NvChad integration
    inputs.nix4nvchad.homeManagerModule

    # Home Manager modules
    ./homemanager/nvchad.nix
    ./homemanager/terminal.nix
    ./homemanager/browsers.nix
    ./homemanager/desktop-apps.nix
    ./homemanager/stylix.nix

    # Wayland/Hyprland modules
    ./homemanager/wayland.nix
    ./homemanager/hyprland.nix
    ./homemanager/waybar.nix
    ./homemanager/wofi.nix
    ./homemanager/dunst.nix
    ./homemanager/btop.nix
  ];

  # Enable modules
  modules = {
    nvchad.enable = true;
    terminal.enable = true;
    browsers.enable = true;
    desktop-apps.enable = true;
    wayland.enable = true;
    stylix-config.enable = true;
  };

  # Home Manager configuration
  # These should be set per-user in the host configuration
  # But we provide defaults for convenience
  home.username = lib.mkDefault "nix";
  home.homeDirectory = lib.mkDefault "/home/nix";
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Additional packages
  home.packages = [];

  # Session variables
  home.sessionVariables = {};

  # Plain files
  home.file = {};
}
