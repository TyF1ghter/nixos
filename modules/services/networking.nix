{ config, pkgs, ... }:

{
  networking = {
    # hostName is defined per-host in hosts/*/configuration.nix
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-fortisslvpn
        networkmanager-iodine
        networkmanager-l2tp
        networkmanager-openconnect
        networkmanager-openvpn
        networkmanager-sstp
        networkmanager-vpnc
      ];
    };
    firewall.enable = true;
  };

  services.tailscale.enable = true;
  services.wg-netmanager.enable = true;

  programs.openvpn3.enable = true;
  # programs.nm-applet.enable = true;  # Moved to hyprland.nix - only needed for Hyprland
}
