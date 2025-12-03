{ config, pkgs, ... }:

{
  # Thunar File Manager Configuration
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin  # Archive support (create/extract)
      thunar-volman          # Removable media management
    ];
  };



  # Required services for Thunar functionality
  services = {
    dbus.enable = true;      # D-Bus message bus (required for inter-process communication)
    gvfs.enable = true;      # Virtual filesystem (trash, remote filesystems, etc.)
    tumbler.enable = true;   # Thumbnail generation service

    gnome.sushi.enable = true;  # File previewer (spacebar to preview files)
  };

  # Additional file management utilities
  environment.systemPackages = with pkgs; [
    dysk               # Disk usage analyzer
    fzf                # Fuzzy finder
    gvfs               # Virtual filesystem utilities
    udiskie            # Automounter for removable media
    xorg.xhost         # X server access control
    dracula-icon-theme # Icon theme
  ];
}
