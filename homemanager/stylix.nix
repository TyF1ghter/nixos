{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.stylix-config;
in
{
  options.modules.stylix-config = {
    enable = mkEnableOption "Stylix theming configuration";
  };

  config = mkIf cfg.enable {
    stylix.targets = {
      kitty.enable = true;
      kitty.variant256Colors = true;
      xfce.enable = true;
      vesktop.enable = true;
      hyprland.enable = true;
      hyprlock.enable = true;
      waybar.enable = true;
      wofi.enable = true;
      qutebrowser.enable = true;
      gtk.enable = true;
    };
  };
}
