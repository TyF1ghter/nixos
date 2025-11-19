# Host-specific configuration for XPS 9310
{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    # Hardware scan
    ./hardware-configuration.nix

    # Hardware modules
    ../../modules/hardware/integrated-graphics.nix
    ../../modules/hardware/audio.nix
    ../../modules/hardware/bluetooth.nix

    # Services modules
    ../../modules/services/networking.nix
    ../../modules/services/display-manager.nix
    ../../modules/services/system-services.nix

    # Desktop modules
    # ../../modules/desktop/hyprland.nix    # Disabled - using Niri
    ../../modules/desktop/niri.nix
    ../../modules/desktop/xdg.nix
    ../../modules/desktop/thunar.nix

    # System modules
    ../../modules/fonts.nix
    ../../modules/laptoppower.nix
    ../../modules/security.nix
    ../../modules/stylix.nix
    ../../modules/virtualization.nix
  ];

  # Networking
  networking.hostName = "9310";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Localization
  time.timeZone = "America/Chicago";
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

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Starship prompt configuration
  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ../../starship.toml;
  };

  # Shell aliases
  # These automatically use the hostname from config.networking.hostName for portability
  # Paths assume the config is at ~/nixos
  programs.bash.shellAliases = {
    # NixOS management
    updoot = "sudo nixos-rebuild switch --flake ~/nixos#" + config.networking.hostName;
    nixconf = "nvim ~/nixos/hosts/" + config.networking.hostName + "/configuration.nix";
    homeconf = "nvim ~/nixos/home.nix";
    flakeconf = "nvim ~/nixos/flake.nix";
    flakedoot = "nix flake update ~/nixos";

    # Editor aliases
    vi = "nvim";
    vim = "nvim";

    # VM and services
    win10 = "quickemu --vm windows-10.conf";
    rebar = "pkill waybar && hyprctl dispatch exec waybar";

    # Tailscale
    tdown = "sudo tailscale down";
    tup = "sudo tailscale up";

    # Utilities
    mixer = "pulsemixer";
  };

  # User account
  users.users.ty = {
    isNormalUser = true;
    description = "ty";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "libvirt"
    ];
    packages = with pkgs; [];
  };

  # Home Manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.ty = import ../../home.nix;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Core utilities
    vim
    git
    gnumake

    # System monitoring
    htop
    btop
    fastfetch
    lshw
    pciutils

    # File management
    dysk
    fzf
    gvfs
    udiskie

    # System utilities
    usbutils
    rpi-imager

    # Browsers
    qutebrowser
    brave
    mullvad-browser
    librewolf

    # Hyprland ecosystem
    hyprland-protocols
    hyprpicker
    xdg-desktop-portal-hyprland
    hyprpaper
    hyprcursor
    hyprshot

    # Wayland utilities
    waybar
    wofi
    swww
    grim
    dunst
    wlogout

    # Terminal
    kitty

    # System tools
    polkit_gnome
    brightnessctl
    ydotool
    wl-clipboard

    # XDG & Qt support
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    qt5.qtwayland
    qt6.qmake
    qt6.qtwayland
    adwaita-qt
    adwaita-qt6

    # Theming
    gnome-themes-extra
    adwaita-icon-theme
    dracula-icon-theme
    base16-schemes
    nwg-look

    # Graphics
    libva-utils

    # Communication
    vesktop
    element-desktop

    # Productivity
    obsidian
    vscodium

    # Entertainment
    spotify
    ncspot

    # Utilities
    pavucontrol

    # Virtualization
    qemu
    quickemu
    libvirt
    minikube
    docker-machine-kvm2

    # Networking
    networkmanager
    networkmanagerapplet
    networkmanager-vpnc

    # VPN & Security
    protonvpn-gui
    bitwarden-desktop
    proton-pass

    # Fingerprint authentication
    fprintd
    fprintd-tod

    # Security tools
    pipx
    python3
    exegol

    # AI
    claude-code
  ];

  # Additional programs
  programs.file-roller.enable = true;
  programs.nm-applet.enable = true;
  programs.waybar.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable firewall
  networking.firewall.enable = true;

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # System state version
  system.stateVersion = "24.11";
}
