{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.hyprland;
in
{
  options.modules.hyprland = {
    enable = mkEnableOption "Hyprland window manager configuration";

    monitor = mkOption {
      type = types.str;
      default = "desc:Sharp Corporation 0x14F9,1920x1200@60,0x0,1";
      description = "Monitor configuration";
    };

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
  };

  config = mkIf cfg.enable {
    # Automatically enable supporting modules for a complete desktop experience
    modules = {
      waybar.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;
      dunst.enable = true;
      wofi.enable = true;
    };

    services.blueman-applet.enable = true;
    services.network-manager-applet.enable = true;

    # Let Stylix manage theming by default
    stylix.targets.hyprland.enable = mkDefault true;

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        # Monitor configuration
        monitor = cfg.monitor;

        # Environment variables
        env = [
          "XCURSOR_SIZE,24"
          "XCURSOR_THEME,Adwaita"
          "HYPRCURSOR_SIZE,24"
          "HYPRCURSOR_THEME,Adwaita"
          "AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1"
        ];

        # Programs
        "$terminal" = cfg.terminal;
        "$fileManager" = cfg.fileManager;
        "$menu" = cfg.menu;
        "$mainMod" = "SUPER";

        # Autostart
        exec-once = [
          "systemctl --user start blueman-applet.service"
          "systemctl --user start nm-applet.service"
          "dunst"
          "polkit_gnome"
          "hypridle"
          "hyprshot"
          "hyprctl setcursor Adwaita 24"
          "systemctl --user start hyprland-session.target"
          "~/.config/hypr/xdg-portal-hyprland"
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        ] ++ optional config.modules.hyprpaper.enable "hyprpaper";

        # General settings
        general = {
          gaps_in = mkDefault 2;
          gaps_out = mkDefault 5;
          border_size = mkDefault 2;
          "col.active_border" = mkDefault "rgba(7aa2f7aa)";
          "col.inactive_border" = mkDefault "rgba(414868aa)";
          resize_on_border = mkDefault false;
          allow_tearing = mkDefault false;
          layout = mkDefault "dwindle";
        };

        # Decoration
        decoration = {
          rounding = mkDefault 10;
          active_opacity = mkDefault 1.0;
          inactive_opacity = mkDefault 1.0;

          shadow = {
            enabled = mkDefault true;
            range = mkDefault 4;
            render_power = mkDefault 3;
            color = mkDefault "rgba(1a1a1aee)";
          };

          blur = {
            enabled = mkDefault true;
            size = mkDefault 3;
            passes = mkDefault 1;
            vibrancy = mkDefault 0.1696;
          };
        };

        # Animations
        animations = {
          enabled = true;

          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];

          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces, 1, 1.94, almostLinear, fade"
            "workspacesIn, 1, 1.21, almostLinear, fade"
            "workspacesOut, 1, 1.94, almostLinear, fade"
          ];
        };

        # Dwindle layout
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        # Master layout
        master = {
          new_status = "master";
        };

        # Misc settings
        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = false;
        };

        # Input configuration
        input = {
          kb_layout = "us";
          follow_mouse = 1;
          sensitivity = 0;

          touchpad = {
            natural_scroll = false;
          };
        };

        # Device config
        device = {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        };

        # Key bindings
        bind = [
          # Apps
          "$mainMod, Q, exec, $terminal"
          "$mainMod, K, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, V, togglefloating,"
          "$mainMod, R, exec, $menu"
          "$mainMod, N, exec, $terminal nvim"
          "$mainMod, P, pseudo,"
          "$mainMod, J, togglesplit,"
          "$mainMod, F, exec, brave"
          "$mainMod, B, exec, librewolf"
          "$mainMod, L, exec, hyprlock"
          "$mainMod, SPACE, exec, wofi --show-drun"
          "$mainMod, ESCAPE, exec, wlogout"
          "$mainMod SHIFT, B, exec, mullvad-browser"
          "$mainMod SHIFT, S, exec, hyprshot -m region"
          "$mainMod SHIFT, D, exec, vesktop"
          "$mainMod SHIFT, J, exec, jellyfinmediaplaye"
          "$mainMod SHIFT, W, exec, $HOME/.config/hypr/scripts/win11.sh"
          "$mainMod SHIFT, F, fullscreen, 0"
          "$mainMod CTRL,  S, exec, steam"

          # Focus movement
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Workspace switching
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Move window to workspace
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # Special workspace
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          # Workspace scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];

        # Mouse bindings
        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        # Media keys
        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
          ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ];

        bindl = [
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];

        # Window rules
        windowrulev2 = [
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        ];
      };
    };
  };
}
