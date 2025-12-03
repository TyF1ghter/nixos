{ config, pkgs, ... }:

{
  # Hyprland window manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Hyprlock screen locker
  programs.hyprlock.enable = true;

  # PAM configuration for hyprlock
  security.pam.services.hyprlock = {
    text = ''
      auth include login
    '';
  };

  # Hypridle idle daemon
  services.hypridle.enable = true;

  # Network manager applet for Hyprland
  programs.nm-applet.enable = true;

  # System packages for Hyprland ecosystem
  environment.systemPackages = with pkgs; [
    # Hyprland core utilities
    hyprland-protocols
    hyprpicker
    hyprcursor
    hyprshot
    hyprpaper        # Wallpaper daemon

    # Portal and desktop integration
    xdg-desktop-portal-hyprland

    # Wayland utilities
    waybar           # Status bar
    wofi             # Application launcher
    dunst            # Notification daemon
    wlogout          # Logout menu
    swww             # Wallpaper switcher
    grim             # Screenshot utility
    wl-clipboard     # Clipboard manager
    brightnessctl    # Brightness control

    # Configuration tools
    nwg-displays     # Display configuration
    nwg-look         # GTK theme configuration

    # Network and Bluetooth management (for Hyprland)
    networkmanagerapplet
    blueman

    # Input utilities
    ydotool          # Input automation
  ];
}
