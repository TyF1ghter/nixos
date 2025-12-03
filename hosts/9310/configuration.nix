# Host-specific configuration for XPS 9310
{ config, pkgs, inputs, lib, username, ... }:

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
    # ../../modules/desktop/hyprland.nix # Disabled - using Niri
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

  # Suppress version mismatch warnings for Stylix
  stylix.enableReleaseChecks = false;

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

  # Shell aliases (portable)
  programs.bash.shellAliases = {
    updoot = "sudo nixos-rebuild switch --flake ~/nixos#" + config.networking.hostName;
    nixconf = "nvim ~/nixos/hosts/" + config.networking.hostName + "/configuration.nix";
    homeconf = "nvim ~/nixos/home.nix";
    flakeconf = "nvim ~/nixos/flake.nix";
    flakedoot = "nix flake update ~/nixos";
    win10 = "quickemu --vm windows-10.conf";
    rebar = "pkill waybar && hyprctl dispatch exec waybar";
    tdown = "sudo tailscale down";
    tup = "sudo tailscale up";
    mixer = "pulsemixer";
    vi = "nvim";
    vim = "nvim";
  };

  # User account
  users.users.${username} = {
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
    users.${username} = {
      imports = [ ../../home.nix ];
      config.modules = {
        # --- Desktop Environment ---
        niri.enable = true;

        # --- Core Components ---
        nvchad.enable = true;
        waybar.enable = true;
        terminal.enable = true;
        browsers.enable = true;
        wofi.enable = true;
        dunst.enable = true;

        # --- Theming ---
        dankshell-tokyonight.enable = true;
      };
    };
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
    file-roller

    # System utilities
    usbutils
    rpi-imager
    polkit_gnome
    brightnessctl
    ydotool
    wl-clipboard

    # Browsers
    qutebrowser
    brave
    mullvad-browser
    librewolf

    # Wayland / Hyprland / Niri ecosystem
    hyprland-protocols
    hyprpicker
    xdg-desktop-portal-hyprland
    hyprpaper
    hyprcursor
    hyprshot
    waybar
    wofi
    swww
    grim
    dunst
    wlogout
    
    # Terminal
    kitty

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
    # networkmanagerapplet  # Moved to hyprland.nix - only needed for Hyprland
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
    gemini-cli
  ];

  # Additional programs
  # programs.nm-applet.enable = true; # Managed by desktop modules

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
