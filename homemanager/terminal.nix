{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.terminal;
in
{
  options.modules.terminal = {
    enable = mkEnableOption "Terminal configuration (kitty)";

    opacity = mkOption {
      type = types.float;
      default = 0.8;
      description = "Background opacity";
    };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      themeFile = "tokyo_night_storm";
      settings = {
        confirm_os_window_close = 0;
        background_opacity = lib.mkDefault cfg.opacity;
      };
    };
  };
}