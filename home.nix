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

    # Wayland/Hyprland modules (Hyprland-specific commented out)
    ./homemanager/wayland.nix
    # ./homemanager/hyprland.nix
    ./homemanager/waybar.nix
    ./homemanager/wofi.nix
    ./homemanager/dunst.nix
    # ./homemanager/hyprlock.nix
    # ./homemanager/hyprpaper.nix
    ./homemanager/btop.nix

    # Niri modules
    ./homemanager/niri.nix
    ./homemanager/swaylock.nix
    ./homemanager/swayidle.nix
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
      enable = false;  # Disabled - using swaylock
      # background.path can be overridden per-host or left as default
    };

    # Wallpaper daemon configuration
    # Note: Override wallpapers and monitors per-host if needed
    # Default configuration works for most laptops with eDP-1 display
    hyprpaper = {
      enable = false;  # Disabled for Niri
      # Default wallpapers and monitor config are set in homemanager/hyprpaper.nix
      # Uncomment and customize below to override:
      # wallpapers = [ "${config.home.homeDirectory}/Pictures/yourimage.png" ];
      # monitors = [
      #   { monitor = "eDP-1"; path = "${config.home.homeDirectory}/Pictures/yourimage.png"; }
      #   { monitor = ""; path = "${config.home.homeDirectory}/Pictures/yourimage.png"; }
      # ];
    };

    # Niri compositor
    niri = {
      enable = true;
      terminal = "kitty";
      fileManager = "thunar";
      menu = "wofi --show drun";
    };

    # Screen locker (swaylock instead of hyprlock)
    swaylock = {
      enable = true;
      image.path = "${config.home.homeDirectory}/Pictures/lawson.jpg";
      effects = {
        blur = "5x3";
        clock = true;
        fadeIn = 0.2;
      };
    };

    # Idle daemon (swayidle instead of hypridle)
    swayidle = {
      enable = true;
      timeouts = {
        lock = 300;        # Lock after 5 minutes
        displayOff = 600;  # Turn off display after 10 minutes
        suspend = 900;     # Suspend after 15 minutes
      };
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
