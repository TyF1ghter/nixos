{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.alacritty;
in
{
  options.modules.alacritty = {
    enable = mkEnableOption "Alacritty terminal with Tokyo Night theme";

    opacity = mkOption {
      type = types.float;
      default = 0.85;
      description = "Terminal background opacity";
    };

    fontSize = mkOption {
      type = types.float;
      default = 11.0;
      description = "Font size";
    };
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        # Window settings
        window = {
          opacity = mkForce cfg.opacity;
          blur = mkForce true;
          padding = {
            x = mkForce 10;
            y = mkForce 10;
          };
        };

        # Font configuration
        font = {
          size = mkForce cfg.fontSize;
        };

        # Tokyo Night Moon colors (matching kitty) - using mkForce to override Stylix
        colors = {
          primary = {
            background = mkForce "#222436";
            foreground = mkForce "#c8d3f5";
          };

          cursor = {
            text = mkForce "#222436";
            cursor = mkForce "#c8d3f5";
          };

          selection = {
            text = mkForce "#c8d3f5";
            background = mkForce "#2d3f76";
          };

          normal = {
            black = mkForce "#1b1d2b";
            red = mkForce "#ff757f";
            green = mkForce "#c3e88d";
            yellow = mkForce "#ffc777";
            blue = mkForce "#82aaff";
            magenta = mkForce "#c099ff";
            cyan = mkForce "#86e1fc";
            white = mkForce "#828bb8";
          };

          bright = {
            black = mkForce "#444a73";
            red = mkForce "#ff8d94";
            green = mkForce "#c7fb6d";
            yellow = mkForce "#ffd8ab";
            blue = mkForce "#9ab8ff";
            magenta = mkForce "#caabff";
            cyan = mkForce "#b2ebff";
            white = mkForce "#c8d3f5";
          };
        };
      };
    };
  };
}
