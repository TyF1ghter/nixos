{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.wofi;
in
{
  options.modules.wofi = {
    enable = mkEnableOption "Wofi application launcher";

    width = mkOption {
      type = types.int;
      default = 420;
      description = "Width of the wofi window";
    };

    height = mkOption {
      type = types.int;
      default = 550;
      description = "Height of the wofi window";
    };

    location = mkOption {
      type = types.enum [ "center" "top" "bottom" "left" "right" ];
      default = "center";
      description = "Location of the wofi window";
    };
  };

  config = mkIf cfg.enable {
    # Let Stylix manage styling by default
    stylix.targets.wofi.enable = mkDefault true;

    programs.wofi = {
      enable = true;
      settings = {
        width = cfg.width;
        height = cfg.height;
        location = cfg.location;
        show = "drun";
        matching = "fuzzy";
        prompt = "Search...";
        filter_rate = 100;
        allow_markup = true;
        no_actions = true;
        halign = "fill";
        orientation = "vertical";
        content_halign = "fill";
        insensitive = true;
        allow_images = true;
        image_size = 28;
        gtk_dark = false;
        term = "kitty";
      };
    };
  };
}
