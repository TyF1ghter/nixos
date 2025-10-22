{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.hyprpaper;

  # Helper function to generate preload entries
  preloadEntries = map (img: "preload = ${img}") cfg.wallpapers;

  # Helper function to generate wallpaper entries
  wallpaperEntries = map (w: "wallpaper = ${w.monitor},${w.path}") cfg.monitors;
in
{
  options.modules.hyprpaper = {
    enable = mkEnableOption "Hyprpaper wallpaper daemon";

    wallpapers = mkOption {
      type = types.listOf types.str;
      default = [ "${config.home.homeDirectory}/Pictures/worldblue.png" ];
      description = "List of wallpaper paths to preload. Uses relative path from home directory.";
    };

    monitors = mkOption {
      type = types.listOf (types.submodule {
        options = {
          monitor = mkOption {
            type = types.str;
            default = "";
            description = "Monitor name (empty string for all monitors)";
          };

          path = mkOption {
            type = types.str;
            description = "Path to wallpaper for this monitor";
          };
        };
      });
      default = [
        {
          monitor = "eDP-1";
          path = "${config.home.homeDirectory}/Pictures/worldblue.png";
        }
        {
          monitor = "";
          path = "${config.home.homeDirectory}/Pictures/worldblue.png";
        }
      ];
      description = "Monitor-specific wallpaper configurations. Paths use home directory variable for reproducibility.";
    };

    splash = mkOption {
      type = types.bool;
      default = false;
      description = "Enable splash text rendering over the wallpaper";
    };

    ipc = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "IPC settings (set to 'off' to disable)";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprpaper
    ];

    xdg.configFile."hypr/hyprpaper.conf".text = ''
      ${concatStringsSep "\n" preloadEntries}

      # Set wallpaper(s) for monitor(s)
      ${concatStringsSep "\n" wallpaperEntries}

      # Enable splash text rendering over the wallpaper
      splash = ${boolToString cfg.splash}

      ${optionalString (cfg.ipc != null) "ipc = ${cfg.ipc}"}
    '';
  };
}
