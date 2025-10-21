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

    hyprlock = {
      enable = true;
      background.path = "~/Pictures/lawsons.jpg";
    };

    hyprpaper = {
      enable = true;
      wallpapers = [
        "/home/ty/Pictures/worldblue.png"
        "/home/nix/Pictures/wolrdblue.png"
      ];
      monitors = [
        {
          monitor = "eDP-1";
          path = "/home/ty/Pictures/worldblue.png";
        }
        {
          monitor = "";
          path = "/home/ty/Pictures/worldblue.png";
        }
      ];
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
