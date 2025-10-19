{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.wayland;
in
{
  options.modules.wayland = {
    enable = mkEnableOption "Wayland/Hyprland components (wrapper module)";
  };

  config = mkIf cfg.enable {
    # Enable all Wayland-related modules
    modules.hyprland.enable = true;
    modules.waybar.enable = true;
    modules.wofi.enable = true;
    modules.dunst.enable = true;
    modules.btop.enable = true;
  };
}
