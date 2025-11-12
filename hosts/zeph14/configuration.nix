# Template Host Configuration
# Copy this directory to create a new host configuration
# Example: cp -r hosts/template hosts/my-new-host

{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    # Hardware scan - Generate with:
    # nixos-generate-config --show-hardware-config > hosts/HOSTNAME/hardware-configuration.nix
    ./hardware-configuration.nix

    # === Graphics Configuration ===
    # IMPORTANT: Choose ONE graphics module based on your hardware
    # Do NOT enable both modules at the same time!

    # Option 1: Integrated graphics only (Intel or AMD)
    # Use this for laptops/systems without dedicated GPU
    ../../modules/hardware/amd.nix

    # Option 2: NVIDIA hybrid graphics (Intel + NVIDIA)
    # Use this for laptops with NVIDIA + Intel dual graphics
    # Remember to update PCI bus IDs in the module!
    # ../../modules/hardware/nvidiahybrid.nix

    # === Other Hardware Modules ===
    ../../modules/hardware/audio.nix
    ../../modules/hardware/bluetooth.nix

    # === Services modules ===
    ../../modules/services/networking.nix
    ../../modules/services/display-manager.nix
    ../../modules/services/system-services.nix
    ../../modules/services/asusd.nix

    # === Desktop modules ===
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/xdg.nix
    ../../modules/desktop/thunar.nix

    # === Gaming module ===
    # Uncomment if you want gaming support
    # ../../modules/gaming/gaming.nix

    # === System modules ===
    ../../modules/fonts.nix
    # ../../modules/laptoppower.nix  # Uncomment for laptops
    ../../modules/security.nix
    ../../modules/stylix.nix
    # ../../modules/virtualization.nix  # Uncomment for VMs/containers
  ];

  # === System Configuration ===

  # Networking
  networking.hostName = "zeph14";  # CHANGE THIS to your hostname

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelParams = [ ];  # Add hardware-specific kernel parameters if needed

  # Localization
  time.timeZone = "America/Chicago";  # Change to your timezone
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ../../starship.toml;
  };

  # Shell aliases
  # These automatically use the hostname from config.networking.hostName for portability
  # Update paths if you clone to a different location than ~/nixos
  programs.bash.shellAliases = {
    updoot = "sudo nixos-rebuild switch --flake ~/nixos#" + config.networking.hostName;
    nixconf = "nvim ~/nixos/hosts/" + config.networking.hostName + "/configuration.nix";
    homeconf = "nvim ~/nixos/home.nix";
    flakeconf = "nvim ~/nixos/flake.nix";
    flakedoot = "nix flake update ~/nixos";
    rebar = "pkill waybar && hyprctl dispatch exec waybar";
    vi = "nvim";
    vim = "nvim";
  };

  # === User Configuration ===

  # User account - CHANGE THIS to your username
  users.users.ty = {  # CHANGE THIS
    isNormalUser = true;
    description = "";  # CHANGE THIS
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Home Manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "ty" = import ../../home.nix;  # CHANGE THIS to match username above
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # === System Packages ===

  environment.systemPackages = with pkgs; [
    # Core tools
    vim
    git
    gnumake
    htop
    btop

    # Editors
    vscodium

    # Browsers
    brave
    librewolf
    qutebrowser

    # Terminal
    kitty

    # System utilities
    polkit_gnome
    libva-utils
    udiskie
    ydotool
    wl-clipboard

    # Theming
    gnome-themes-extra
    adwaita-icon-theme

    # Qt support
    qt5.qtwayland
    qt6.qmake
    qt6.qtwayland
    adwaita-qt
    adwaita-qt6

    # Applications
    fastfetch

    # Networking
    networkmanager
    networkmanagerapplet

    # Security
    bitwarden-desktop
    fprintd

    # Audio
    pavucontrol

    # Hardware info
    lshw
    pciutils

    # Development
    ripgrep
    xclip
    claude-code
  ];

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # System state version - DO NOT CHANGE after installation
  system.stateVersion = "25.11";
}
