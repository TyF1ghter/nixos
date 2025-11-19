{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.niri;
in
{
  options.modules.niri = {
    enable = mkEnableOption "Niri window manager configuration";

    terminal = mkOption {
      type = types.str;
      default = "kitty";
      description = "Default terminal emulator";
    };

    fileManager = mkOption {
      type = types.str;
      default = "thunar";
      description = "Default file manager";
    };

    menu = mkOption {
      type = types.str;
      default = "wofi --show drun";
      description = "Default application launcher";
    };

    preferDarkTheme = mkOption {
      type = types.bool;
      default = true;
      description = "Prefer dark theme for applications";
    };
  };

  config = mkIf cfg.enable {
    # Let Stylix manage theming by default
    stylix.targets.niri.enable = mkDefault true;

    # Niri configuration
    home.file.".config/niri/config.kdl".text = ''
      // Niri Configuration
      // https://github.com/YaLTeR/niri

      // Input configuration
      input {
          keyboard {
              xkb {
                  layout "us"
              }
          }

          touchpad {
              tap
              natural-scroll
              dwt
              dwtp
          }

          mouse {
              natural-scroll
          }

          focus-follows-mouse
      }

      // Output configuration
      output "eDP-1" {
          scale 1.5
          mode "3456x2160@60"
      }

      // Layout configuration
      layout {
          gaps 8
          center-focused-column "never"

          preset-column-widths {
              proportion 0.33333
              proportion 0.5
              proportion 0.66667
          }

          default-column-width { proportion 0.5; }

          focus-ring {
              width 2
              active-color "#7aa2f7"
              inactive-color "#414868"
          }

          border {
              width 1
              active-color "#7aa2f7"
              inactive-color "#414868"
          }
      }

      // Spawn programs at startup
      spawn-at-startup "${cfg.terminal}"
      spawn-at-startup "waybar"
      spawn-at-startup "dunst"
      spawn-at-startup "nm-applet"
      spawn-at-startup "blueman-applet"
      spawn-at-startup "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      // Note: swayidle is managed via systemd service (see swayidle.nix module)

      // Prefer dark theme
      prefer-no-csd

      // Screenshots
      screenshot-path "~/Pictures/Screenshots/screenshot-%Y-%m-%d_%H-%M-%S.png"

      // Animation settings
      animations {
          slowdown 1.0

          window-open {
              duration-ms 150
              curve "ease-out-quad"
          }

          window-close {
              duration-ms 150
              curve "ease-out-quad"
          }

          workspace-switch {
              duration-ms 250
              curve "ease-out-cubic"
          }
      }

      // Window rules
      window-rule {
          match app-id=".*"
          default-column-width { proportion 0.5; }
      }

      // Keybindings
      binds {
          // Mod key (Super/Windows key)
          Mod+Q { spawn "${cfg.terminal}"; }
          Mod+K { close-window; }
          Mod+M { quit; }
          Mod+E { spawn "${cfg.fileManager}"; }
          Mod+R { spawn "${cfg.menu}"; }
          Mod+Space { spawn "${cfg.menu}"; }
          Mod+L { spawn "swaylock"; }
          Mod+Escape { spawn "wlogout"; }
          Mod+N { spawn "${cfg.terminal}" "nvim"; }

          // Browser shortcuts
          Mod+F { spawn "brave"; }
          Mod+B { spawn "librewolf"; }
          Mod+Shift+B { spawn "mullvad-browser"; }

          // Focus movement
          Mod+Left { focus-column-left; }
          Mod+Right { focus-column-right; }
          Mod+Up { focus-window-up; }
          Mod+Down { focus-window-down; }
          Mod+H { focus-column-left; }
          Mod+L { focus-column-right; }
          Mod+J { focus-window-down; }
          Mod+K { focus-window-up; }

          // Window movement
          Mod+Shift+Left { move-column-left; }
          Mod+Shift+Right { move-column-right; }
          Mod+Shift+Up { move-window-up; }
          Mod+Shift+Down { move-window-down; }
          Mod+Shift+H { move-column-left; }
          Mod+Shift+L { move-column-right; }
          Mod+Shift+J { move-window-down; }
          Mod+Shift+K { move-window-up; }

          // Workspace switching
          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }

          // Move window to workspace
          Mod+Ctrl+1 { move-window-to-workspace 1; }
          Mod+Ctrl+2 { move-window-to-workspace 2; }
          Mod+Ctrl+3 { move-window-to-workspace 3; }
          Mod+Ctrl+4 { move-window-to-workspace 4; }
          Mod+Ctrl+5 { move-window-to-workspace 5; }
          Mod+Ctrl+6 { move-window-to-workspace 6; }
          Mod+Ctrl+7 { move-window-to-workspace 7; }
          Mod+Ctrl+8 { move-window-to-workspace 8; }
          Mod+Ctrl+9 { move-window-to-workspace 9; }

          // Column width adjustment
          Mod+Minus { set-column-width "-10%"; }
          Mod+Plus { set-column-width "+10%"; }
          Mod+Shift+Minus { set-window-height "-10%"; }
          Mod+Shift+Plus { set-window-height "+10%"; }

          // Workspace scrolling
          Mod+WheelScrollDown { focus-workspace-down; }
          Mod+WheelScrollUp { focus-workspace-up; }
          Mod+Ctrl+Left { focus-workspace-down; }
          Mod+Ctrl+Right { focus-workspace-up; }

          // Maximize/fullscreen
          Mod+Shift+F { maximize-column; }
          Mod+Alt+F { fullscreen-window; }

          // Screenshots
          Print { screenshot; }
          Mod+Print { screenshot-screen; }
          Mod+Shift+Print { screenshot-window; }

          // Media keys
          XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
          XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
          XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
          XF86AudioMicMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
          XF86MonBrightnessUp { spawn "brightnessctl" "s" "10%+"; }
          XF86MonBrightnessDown { spawn "brightnessctl" "s" "10%-"; }
          XF86AudioNext { spawn "playerctl" "next"; }
          XF86AudioPrev { spawn "playerctl" "previous"; }
          XF86AudioPlay { spawn "playerctl" "play-pause"; }
          XF86AudioPause { spawn "playerctl" "play-pause"; }
      }

      // Debug settings (disable in production)
      debug {
          render-drm-device "/dev/dri/card0"
      }
    '';

    # Additional packages for niri session
    home.packages = with pkgs; [
      niri
    ];

    # Session variables
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_TYPE = "wayland";
      XCURSOR_SIZE = "24";
      XCURSOR_THEME = "Adwaita";
    };

    # GTK settings
    gtk = mkIf cfg.preferDarkTheme {
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
}
