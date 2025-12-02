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
    stylix.enableReleaseChecks = false;
    stylix.targets = {
      kitty.enable = false;
      kitty.variant256Colors = true;
      xfce.enable = true;
      vesktop.enable = true;  # Stylix handles TokyoNight theme, transparency via window rules
      hyprland.enable = true;
      hyprlock.enable = true;
      waybar.enable = true;
      wofi.enable = true;
      qutebrowser.enable = true;
      gtk.enable = true;
    };
  };
}
