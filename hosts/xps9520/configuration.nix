{ config, pkgs, inputs, lib, username, ... }:

{
  imports = [
    # Hardware scan
    ./hardware-configuration.nix

    # Hardware modules
    ../../modules/hardware/nvidiahybrid.nix
    ../../modules/hardware/audio.nix
    ../../modules/hardware/bluetooth.nix

    # Services modules
    ../../modules/services/networking.nix
    ../../modules/services/display-manager.nix
    ../../modules/services/system-services.nix

    # Desktop modules
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/xdg.nix
    ../../modules/desktop/thunar.nix

    # Gaming module
    ../../modules/gaming/gaming.nix

    # System modules
    ../../modules/fonts.nix
    ../../modules/laptoppower.nix
    ../../modules/security.nix
    ../../modules/stylix.nix
    ../../modules/virtualization.nix
  ];

  # Networking
  networking.hostName = "xps9520";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

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

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ../../starship.toml;
  };

  # Shell aliases
  # These use the hostname from config.networking.hostName for portability
  # Paths assume the config is at ~/nixos
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
    description = "nix";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Home Manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users."${username}" = {
      imports = [ ../../home.nix ];
      config.modules = {
        # Enable the DankMaterialShell Niri desktop environment
        niri.enable = false;
        # Disable other desktop environments
        hyprland.enable = true;
        vdesktop = {
          enable = true;
          opacity = 0.85;
        };
        stylix-config.enable = true;
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
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
    qutebrowser
    brave
    mullvad-browser
    librewolf
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default

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
    vesktop
    obsidian
    fastfetch

    # Networking
    networkmanager
    networkmanagerapplet
    networkmanager-vpnc
    protonvpn-gui

    # Security
    bitwarden-desktop
    proton-pass

    # Audio
    pavucontrol

    # Hardware info
    lshw
    pciutils
    fprintd

    # Theming
    base16-schemes

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

  system.stateVersion = "25.11";
}
