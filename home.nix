{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    # NvChad integration
    inputs.nix4nvchad.homeManagerModule

    # Home Manager modules
    ./homemanager/nvchad.nix
    ./homemanager/terminal.nix
    ./homemanager/browsers.nix
    ./homemanager/vdesktop.nix
    ./homemanager/element.nix
    ./homemanager/stylix.nix

    # Wayland/Hyprland modules
    ./homemanager/wayland.nix
    ./homemanager/hyprland.nix
    ./homemanager/waybar.nix
    ./homemanager/wofi.nix
    ./homemanager/dunst.nix
    ./homemanager/hyprlock.nix
    ./homemanager/hyprpaper.nix
    ./homemanager/btop.nix
  ];

  # Enable modules
  modules = {
    nvchad.enable = true;
    terminal.enable = true;
    browsers.enable = true;
    vdesktop.enable = true;
    element.enable = true;
    wayland.enable = true;
    stylix-config.enable = true;
    waybar.enable = true;
    dunst.enable = true;
    wofi.enable = true;
    hyprland.enable = true;

    # Screen locker configuration
    # Note: Override background.path with your preferred wallpaper
    # Default uses worldblue.png from ~/Pictures/
    hyprlock = {
      enable = true;
      # background.path can be overridden per-host or left as default
    };

    # Wallpaper daemon configuration
    # Note: Override wallpapers and monitors per-host if needed
    # Default configuration works for most laptops with eDP-1 display
    hyprpaper = {
      enable = true;
      # Default wallpapers and monitor config are set in homemanager/hyprpaper.nix
      # Uncomment and customize below to override:
      # wallpapers = [ "${config.home.homeDirectory}/Pictures/yourimage.png" ];
      # monitors = [
      #   { monitor = "eDP-1"; path = "${config.home.homeDirectory}/Pictures/yourimage.png"; }
      #   { monitor = ""; path = "${config.home.homeDirectory}/Pictures/yourimage.png"; }
      # ];
    };
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
