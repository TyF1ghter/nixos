{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.btop;
in
{
  options.modules.btop = {
    enable = mkEnableOption "Btop system monitor";

    theme = mkOption {
      type = types.str;
      default = "tokyo-night";
      description = "Color theme for btop";
    };

    vimKeys = mkOption {
      type = types.bool;
      default = true;
      description = "Enable vim keybindings";
    };

    updateInterval = mkOption {
      type = types.int;
      default = 2000;
      description = "Update interval in milliseconds";
    };
  };

  config = mkIf cfg.enable {
    # Let Stylix manage theming by default
    stylix.targets.btop.enable = mkDefault true;

    programs.btop = {
      enable = true;
      settings = {
        color_theme = mkDefault cfg.theme;
        theme_background = mkDefault false;
        truecolor = mkDefault true;
        vim_keys = cfg.vimKeys;
        rounded_corners = mkDefault true;
        update_ms = cfg.updateInterval;
      };
    };
  };
}
