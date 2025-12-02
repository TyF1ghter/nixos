{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.hyprlock;
in
{
  options.modules.hyprlock = {
    enable = mkEnableOption "Hyprlock screen locker";

    background = {
      path = mkOption {
        type = types.str;
        default = "${config.wallpaperDir}/${cfg.background.fileName}";
        description = "Path to background image. Uses global wallpaper directory.";
      };

      fileName = mkOption {
        type = types.str;
        default = "lawson.jpg";
        description = "Filename of the wallpaper in the global wallpaper directory.";
      };

      blurPasses = mkOption {
        type = types.int;
        default = 0;
        description = "Number of blur passes";
      };

      contrast = mkOption {
        type = types.float;
        default = 0.8916;
        description = "Background contrast";
      };

      brightness = mkOption {
        type = types.float;
        default = 0.8172;
        description = "Background brightness";
      };

      vibrancy = mkOption {
        type = types.float;
        default = 0.1696;
        description = "Background vibrancy";
      };
    };

    general = {
      noFadeIn = mkOption {
        type = types.bool;
        default = false;
        description = "Disable fade in animation";
      };

      grace = mkOption {
        type = types.int;
        default = 0;
        description = "Grace period in seconds";
      };

      disableLoadingBar = mkOption {
        type = types.bool;
        default = false;
        description = "Disable loading bar";
      };

      hideCursor = mkOption {
        type = types.bool;
        default = true;
        description = "Hide cursor";
      };

      ignoreEmptyInputs = mkOption {
        type = types.bool;
        default = true;
        description = "Ignore empty password inputs";
      };
    };

    auth = {
      fingerprintEnabled = mkOption {
        type = types.bool;
        default = true;
        description = "Enable fingerprint authentication";
      };
    };

    inputField = {
      fontFamily = mkOption {
        type = types.str;
        default = "JetBrains Mono Nerd Font Mono";
        description = "Font family for input field";
      };

      fontColor = mkOption {
        type = types.str;
        default = "rgb(224, 222, 244)";
        description = "Input field font color";
      };

      placeholderText = mkOption {
        type = types.str;
        default = ''<i><span foreground="##908caa">Input Password...</span></i>'';
        description = "Placeholder text for input field";
      };
    };

    labels = {
      timeColor = mkOption {
        type = types.str;
        default = "rgba(156, 207, 216, 0.6)";
        description = "Time label color";
      };

      userColor = mkOption {
        type = types.str;
        default = "rgba(235, 188, 186, 0.6)";
        description = "User label color";
      };

      fontFamily = mkOption {
        type = types.str;
        default = "JetBrains Mono Nerd Font Mono";
        description = "Font family for labels";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprlock
    ];

    xdg.configFile."hypr/hyprlock.conf".text = ''
      # BACKGROUND
      background {
          monitor =
          path = ${cfg.background.path}
          blur_passes = ${toString cfg.background.blurPasses}
          contrast = ${toString cfg.background.contrast}
          brightness = ${toString cfg.background.brightness}
          vibrancy = ${toString cfg.background.vibrancy}
          vibrancy_darkness = 0.0
      }

      # GENERAL
      general {
          no_fade_in = ${boolToString cfg.general.noFadeIn}
          grace = ${toString cfg.general.grace}
          disable_loading_bar = ${boolToString cfg.general.disableLoadingBar}
          hide_cursor = ${boolToString cfg.general.hideCursor}
          ignore_empty_inputs = ${boolToString cfg.general.ignoreEmptyInputs}
      }

      # Auth
      auth {
          fingerprint {
              enabled = ${boolToString cfg.auth.fingerprintEnabled}
              ready_message = (Fingerprint ready)
              present_message = (Scanning fingerprint...)

          }
      }

      # FINGERPRINT STATUS
      label {
          monitor =
          text = $FPRINTPROMPT
          color = rgba(235, 188, 186, 0.9)
          font_size = 18
          font_family = ${cfg.labels.fontFamily}
          position = 0, -100
          halign = center
          valign = center
      }

      # INPUT FIELD
      input-field {
          monitor =
          size = 250, 60
          outline_thickness = 2
          dots_size = 0.2
          dots_spacing = 0.2
          dots_center = true
          outer_color = rgba(0, 0, 0, 0)
          inner_color = rgba(0, 0, 0, 0.5)
          font_color = ${cfg.inputField.fontColor}
          fade_on_empty = true
          font_family = ${cfg.inputField.fontFamily}
          placeholder_text = ${cfg.inputField.placeholderText}
          hide_input = false
          position = 0, 0
          halign = center
          valign = center
      }

      # TIME
      label {
          monitor =
          text = cmd[update:1000] echo "$(date +"%-I:%M%p")"
          color = ${cfg.labels.timeColor}
          font_size = 100
          font_family = ${cfg.labels.fontFamily} ExtraBold
          position = 0, -50
          halign = center
          valign = top
      }

      # USER
      label {
          monitor =
          text = cmd[update:] echo "$(fortune -s)"
          color = ${cfg.labels.userColor}
          font_size = 12
          font_family = ${cfg.labels.fontFamily}
          position = 0, 250
          halign = center
          valign = center
      }

      # fortune
      label {
          monitor =
          color = rgba(144, 140, 170, 0.4)
          font_size = 12
          font_family = ${cfg.labels.fontFamily}
          position = 0, -450
          halign = center
          valign = center
      }

      # lock icon
      label {
          monitor =
          text =
          color = rgba(255, 255, 255, 0.6)
          font_size = 20
          font_family = JetBrainsMono, Font Awesome 6 Free Solid
          position = 0, 70
          halign = center
          valign = bottom
      }
    '';
  };
}
