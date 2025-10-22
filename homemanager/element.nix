{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.element;
in
{
  options.modules.element = {
    enable = mkEnableOption "Element Matrix client";

    opacity = mkOption {
      type = types.float;
      default = 0.95;
      description = "Window opacity for Element";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      element-desktop
    ];

    # Window rule for Hyprland opacity (if hyprland is enabled)
    wayland.windowManager.hyprland = mkIf config.modules.hyprland.enable {
      settings.windowrulev2 = [
        "opacity ${toString cfg.opacity} ${toString cfg.opacity},class:^(Element)$"
      ];
    };
  };
}
