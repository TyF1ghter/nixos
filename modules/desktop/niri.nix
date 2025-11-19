{ config, pkgs, ... }:

{
  # Niri scrollable-tiling Wayland compositor
  programs.niri = {
    enable = true;
  };

  # XWayland support for X11 apps
  programs.xwayland.enable = true;

  # System packages for Niri ecosystem
  environment.systemPackages = with pkgs; [
    # Niri compositor
    niri

    # Portal and desktop integration
    xdg-desktop-portal-gnome

    # Wayland utilities
    waybar           # Status bar
    wofi             # Application launcher
    dunst            # Notification daemon
    swaylock         # Screen locker
    swayidle         # Idle daemon
    wlogout          # Logout menu
    grim             # Screenshot utility
    slurp            # Screen area selector
    wl-clipboard     # Clipboard manager
    brightnessctl    # Brightness control
    playerctl        # Media player control

    # Configuration tools
    nwg-displays     # Display configuration
    nwg-look         # GTK theme configuration

    # Network management
    networkmanagerapplet

    # Bluetooth
    blueman

    # Polkit agent
    polkit_gnome
  ];

  # Enable required services
  services.gnome.gnome-keyring.enable = true;

  # XDG portal configuration
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
