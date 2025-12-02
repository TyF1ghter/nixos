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

    defaultFileName = mkOption {
      type = types.str;
      default = "worldblue.png";
      description = "Default wallpaper filename in the global wallpaper directory.";
    };

    extraWallpapers = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of additional wallpaper filenames (relative to wallpaperDir) to preload.";
    };

    monitors = mkOption {
      type = types.listOf (types.submodule {
        options = {
          monitor = mkOption {
            type = types.str;
            default = "";
            description = "Monitor name (empty string for all monitors)";
          };

          fileName = mkOption {
            type = types.str;
            description = "Wallpaper filename for this monitor (relative to wallpaperDir)";
          };
        };
      });
      default = [];
      description = "Monitor-specific wallpaper configurations. Uses filenames relative to wallpaperDir.";
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
      # Preload default wallpaper
      preload = ${config.wallpaperDir}/${cfg.defaultFileName}
      ${concatStringsSep "\n" (map (f: "preload = ${config.wallpaperDir}/${f}") cfg.extraWallpapers)}

      # Set default wallpaper for all monitors
      wallpaper = *,${config.wallpaperDir}/${cfg.defaultFileName}

      # Set monitor-specific wallpapers
      ${concatStringsSep "\n" (map (m: "wallpaper = ${m.monitor},${config.wallpaperDir}/${m.fileName}") cfg.monitors)}

      # Enable splash text rendering over the wallpaper
      splash = ${boolToString cfg.splash}

      ${optionalString (cfg.ipc != null) "ipc = ${cfg.ipc}"}
    '';
  };
}
