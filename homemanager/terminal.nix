{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.terminal;
in
{
  options.modules.terminal = {
    enable = mkEnableOption "Terminal configuration (kitty)";

    theme = mkOption {
      type = types.str;
      default = "tokyo-night-storm";
      description = "Color theme for terminal";
    };

    opacity = mkOption {
      type = types.float;
      default = 0.8;
      description = "Background opacity";
    };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      settings = {
        color_theme = cfg.theme;
        confirm_os_window_close = 0;
        background_opacity = lib.mkForce cfg.opacity;
      };
    };
  };
}