{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.desktop-apps;
in
{
  options.modules.desktop-apps = {
    enable = mkEnableOption "Desktop applications";

    theme = mkOption {
      type = types.str;
      default = "tokyo-night-storm";
      description = "Color theme for applications";
    };
  };

  config = mkIf cfg.enable {
    programs.vesktop = {
      enable = true;
      settings = {
        color_theme = cfg.theme;
      };
    };
  };
}
