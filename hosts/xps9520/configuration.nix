# Host-specific configuration for Dell XPS 9520
{ config, pkgs, inputs, lib, ... }:

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
  # Note: These assume the config is at /home/nix/nixos
  # Update the path if you clone to a different location
  programs.bash.shellAliases = {
    updoot = "sudo nixos-rebuild switch --flake ~/.config/nixos#$(hostname)";
    nixconf = "nvim ~/.config/nixos/hosts/$(hostname)/configuration.nix";
    homeconf = "nvim ~/.config/nixos/home.nix";
    flakeconf = "nvim ~/.config/nixos/flake.nix";
    flakedoot = "nix flake update ~/.config/nixos";
    win10 = "quickemu --vm windows-10.conf";
    rebar = "pkill waybar && hyprctl dispatch exec waybar";
    tdown = "sudo tailscale down";
    tup = "sudo tailscale up";
    mixer = "pulsemixer";
    vi = "nvim";
    vim = "nvim";
  };

  # User account
  users.users.nix = {
    isNormalUser = true;
    description = "nix";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Home Manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "nix" = import ../../home.nix;
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
    inputs.zen-browser.packages."${system}".default

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
