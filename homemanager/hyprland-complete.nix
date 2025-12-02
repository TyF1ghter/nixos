{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.hyprland-complete;
in
{
  options.modules.hyprland-complete = {
    enable = mkEnableOption "Complete Hyprland environment with all tools";

    # Terminal options
    terminal = {
      theme = mkOption {
        type = types.str;
        default = "tokyo-night-storm";
        description = "Color theme for kitty terminal";
      };

      opacity = mkOption {
        type = types.float;
        default = 0.8;
        description = "Terminal background opacity";
      };

      defaultTerminal = mkOption {
        type = types.str;
        default = "kitty";
        description = "Default terminal emulator command";
      };
    };

    # Hyprland options
    hyprland = {
      monitor = mkOption {
        type = types.str;
        default = "desc:Sharp Corporation 0x14F9,1920x1200@60,0x0,1";
        description = "Monitor configuration";
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

      gapsIn = mkOption {
        type = types.int;
        default = 2;
        description = "Inner gaps between windows";
      };

      gapsOut = mkOption {
        type = types.int;
        default = 5;
        description = "Outer gaps around windows";
      };

      borderSize = mkOption {
        type = types.int;
        default = 2;
        description = "Window border size";
      };

      rounding = mkOption {
        type = types.int;
        default = 10;
        description = "Window corner rounding";
      };

      activeBorderColor = mkOption {
        type = types.str;
        default = "rgba(7aa2f7aa)";
        description = "Active window border color";
      };

      inactiveBorderColor = mkOption {
        type = types.str;
        default = "rgba(414868aa)";
        description = "Inactive window border color";
      };

      layout = mkOption {
        type = types.str;
        default = "dwindle";
        description = "Default layout (dwindle or master)";
      };
    };

    # Waybar options
    waybar = {
      position = mkOption {
        type = types.enum [ "top" "bottom" "left" "right" ];
        default = "top";
        description = "Position of the waybar";
      };

      height = mkOption {
        type = types.int;
        default = 30;
        description = "Height of the waybar";
      };
    };

    # Dunst options
    dunst = {
      position = mkOption {
        type = types.str;
        default = "top-right";
        description = "Position of notifications";
      };

      offset = mkOption {
        type = types.str;
        default = "16x16";
        description = "Offset from the origin";
      };
    };

    # Wofi options
    wofi = {
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

    # Hyprlock options
    hyprlock = {
      background = {
        path = mkOption {
          type = types.str;
          default = "${config.home.homeDirectory}/nixos/walls/lawsons.jpg";
          description = "Path to lock screen background image";
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

      fingerprintEnabled = mkOption {
        type = types.bool;
        default = true;
        description = "Enable fingerprint authentication";
      };
    };

    # Hyprpaper options
    hyprpaper = {
      wallpapers = mkOption {
        type = types.listOf types.str;
        default = [ "${config.home.homeDirectory}/nixos/walls/worldblue.png" ];
        description = "List of wallpaper paths to preload";
      };

      defaultWallpaper = mkOption {
        type = types.str;
        default = "${config.home.homeDirectory}/nixos/walls/worldblue.png";
        description = "Default wallpaper path";
      };
    };

    # Hypridle options
    hypridle = {
      lockTimeout = mkOption {
        type = types.int;
        default = 300;
        description = "Lock screen after N seconds of inactivity";
      };

      displayOffTimeout = mkOption {
        type = types.int;
        default = 600;
        description = "Turn off display after N seconds of inactivity";
      };

      suspendTimeout = mkOption {
        type = types.int;
        default = 900;
        description = "Suspend system after N seconds of inactivity";
      };
    };
  };

  config = mkIf cfg.enable {
    # Kitty terminal configuration
    programs.kitty = {
      enable = true;
      settings = {
        color_theme = cfg.terminal.theme;
        confirm_os_window_close = 0;
        background_opacity = cfg.terminal.opacity;
      };
    };

    # Waybar configuration
    stylix.targets.waybar.enable = mkDefault true;

    programs.waybar = {
      enable = true;
      settings = [{
        layer = "top";
        position = cfg.waybar.position;
        mod = "dock";
        exclusive = true;
        gtk-layer-shell = true;
        height = cfg.waybar.height;
        spacing = 4;

        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [
          "idle_inhibitor"
          "cpu"
          "temperature"
          "memory"
          "battery"
          "pulseaudio#microphone"
          "pulseaudio"
          "backlight"
          "tray"
        ];

        "hyprland/window" = {
          format = "{}";
          max-length = 40;
          separate-outputs = true;
          icon = true;
          icon-size = 18;
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰈈 ";
            deactivated = "󰈉 ";
          };
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          on-click = "activate";
          format = "{icon}";
        };

        tray = {
          icon-size = 18;
          spacing = 10;
        };

        clock = {
          format = "{:%I:%M%p  %a,%b %e}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          interval = 60;
        };

        cpu = {
          interval = 10;
          icon-size = 18;
          format = "󰍛 {usage}%";
          max-length = 10;
        };

        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          on-scroll-up = "brightnessctl set 5%+";
          on-scroll-down = "brightnessctl set 5%-";
          min-length = 6;
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󱈑" ];
        };

        pulseaudio = {
          format = "<span size='larger'>{icon}</span>{volume}%";
          tooltip = true;
          format-muted = "<span size='larger'>󰝟</span> {volume}%";
          on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
          on-scroll-up = "${pkgs.wireplumber}/bin/wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "${pkgs.wireplumber}/bin/wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
          scroll-step = 5;
          format-icons = {
            headphone = "󰋋 ";
            hands-free = "󰋎 ";
            headset = "󰋎 ";
            phone = "󰄜 ";
            portable = "󰄜 ";
            car = "󰄋 ";
            default = [ "󰕿 " "󰖀 " "󰕾 " ];
          };
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = "󰍬 {volume}%";
          format-source-muted = "󰍭 {volume}%";
          on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          on-scroll-up = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+";
          on-scroll-down = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
          scroll-step = 5;
        };

        temperature = {
          thermal-zone = 1;
          hwmon-path = "/sys/class/hwmon/hwmon6/temp1_input";
          format = "󰔏 {temperatureC}°C";
          critical-threshold = 80;
          format-critical = "󰔏 {temperatureC}°C";
        };

        memory = {
          interval = 30;
          format = " {}%";
          max-length = 10;
          tooltip = true;
          tooltip-format = "Memory - {used:0.1f}GB used";
          on-click = "kitty -e btop";
        };
      }];
    };

    # Dunst notification daemon
    stylix.targets.dunst.enable = mkDefault true;

    services.dunst = {
      enable = true;
      settings = {
        global = {
          monitor = "1,2,0";
          follow = "none";
          width = "(0,300)";
          height = 256;
          origin = cfg.dunst.position;
          offset = cfg.dunst.offset;
          scale = 0;
          notification_limit = 20;

          progress_bar = true;
          progress_bar_height = 10;
          progress_bar_frame_width = 1;
          progress_bar_min_width = 150;
          progress_bar_max_width = 300;
          progress_bar_corner_radius = mkDefault 4;
          progress_bar_corners = "all";

          icon_corner_radius = mkDefault 4;
          icon_corners = "all";
          indicate_hidden = true;

          transparency = mkDefault 0;
          separator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          text_icon_padding = 2;
          frame_width = mkDefault 2;
          frame_color = mkDefault "#89b4fa";
          gap_size = 2;
          separator_color = mkDefault "auto";
          sort = true;

          font = mkDefault "BitStromWera Nerd Font 12";
          line_height = 0;
          markup = "full";
          format = "%a\\n<b>%s</b>\\n%b\\n%p";
          alignment = "left";
          vertical_alignment = "center";
          show_age_threshold = 60;
          ellipsize = "middle";
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = true;

          enable_recursive_icon_lookup = true;
          icon_theme = mkDefault "Dracula";
          icon_position = "left";
          min_icon_size = 16;
          max_icon_size = 32;

          sticky_history = true;
          history_length = 20;

          dmenu = "/usr/bin/dmenu -p dunst:";
          browser = "/usr/bin/xdg-open";
          always_run_script = true;
          title = "Dunst";
          class = "Dunst";
          corner_radius = mkDefault 8;
          corners = "all";
          ignore_dbusclose = false;
          force_xwayland = false;
          force_xinerama = false;

          mouse_left_click = "do_action, close_current";
          mouse_middle_click = "close_all";
          mouse_right_click = "close_current";
        };

        experimental = {
          per_monitor_dpi = false;
        };

        urgency_low = {
          background = mkDefault "#1e1e2e";
          foreground = mkDefault "#cdd6f4";
          timeout = 5;
        };

        urgency_normal = {
          background = mkDefault "#1e1e2e";
          foreground = mkDefault "#cdd6f4";
          timeout = 8;
          override_pause_level = 30;
        };

        urgency_critical = {
          background = mkDefault "#1e1e2e";
          foreground = mkDefault "#cdd6f4";
          frame_color = mkDefault "#fab387";
          timeout = 0;
          override_pause_level = 60;
        };
      };
    };

    # Wofi application launcher
    stylix.targets.wofi.enable = mkDefault true;

    programs.wofi = {
      enable = true;
      settings = {
        width = cfg.wofi.width;
        height = cfg.wofi.height;
        location = cfg.wofi.location;
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

    # Hyprland window manager
    stylix.targets.hyprland.enable = mkDefault true;

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        monitor = cfg.hyprland.monitor;

        env = [
          "XCURSOR_SIZE,24"
          "XCURSOR_THEME,Adwaita"
          "HYPRCURSOR_SIZE,24"
          "HYPRCURSOR_THEME,Adwaita"
          "AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1"
        ];

        "$terminal" = cfg.terminal.defaultTerminal;
        "$fileManager" = cfg.hyprland.fileManager;
        "$menu" = cfg.hyprland.menu;
        "$mainMod" = "SUPER";

        exec-once = [
          "waybar"
          "dunst"
          "nm-applet"
          "blueman-applet"
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          "hyprpaper"
          "hypridle"
          "hyprctl setcursor Adwaita 24"
          "systemctl --user start hyprland-session.target"
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        ];

        general = {
          gaps_in = cfg.hyprland.gapsIn;
          gaps_out = cfg.hyprland.gapsOut;
          border_size = cfg.hyprland.borderSize;
          "col.active_border" = cfg.hyprland.activeBorderColor;
          "col.inactive_border" = cfg.hyprland.inactiveBorderColor;
          resize_on_border = false;
          allow_tearing = false;
          layout = cfg.hyprland.layout;
        };

        decoration = {
          rounding = cfg.hyprland.rounding;
          active_opacity = 1.0;
          inactive_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

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

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = false;
        };

        input = {
          kb_layout = "us";
          follow_mouse = 1;
          sensitivity = 0;

          touchpad = {
            natural_scroll = false;
          };
        };

        device = {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        };

        bind = [
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
          "$mainMod, SPACE, exec, wofi --show drun"
          "$mainMod, ESCAPE, exec, wlogout"
          "$mainMod, D, exec, vesktop"
          "$mainMod SHIFT, B, exec, mullvad-browser"
          "$mainMod SHIFT, S, exec, hyprshot -m region"
          "$mainMod SHIFT, F, fullscreen, 0"

          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod, H, movefocus, l"
          "$mainMod SHIFT, L, movefocus, r"
          "$mainMod SHIFT, K, movefocus, u"
          "$mainMod SHIFT, J, movefocus, d"

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

          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

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

        windowrulev2 = [
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        ];
      };
    };

    # Hyprlock configuration
    home.packages = with pkgs; [
      hyprlock
      hyprpaper
      wlogout
      hyprshot
      brightnessctl
      playerctl
      networkmanagerapplet
      blueman
      polkit_gnome
      pavucontrol
      wireplumber
    ];

    xdg.configFile."hypr/hyprlock.conf".text = ''
      # BACKGROUND
      background {
          monitor =
          path = ${cfg.hyprlock.background.path}
          blur_passes = ${toString cfg.hyprlock.background.blurPasses}
          contrast = ${toString cfg.hyprlock.background.contrast}
          brightness = ${toString cfg.hyprlock.background.brightness}
          vibrancy = ${toString cfg.hyprlock.background.vibrancy}
          vibrancy_darkness = 0.0
      }

      # GENERAL
      general {
          no_fade_in = false
          grace = 0
          disable_loading_bar = false
          hide_cursor = true
          ignore_empty_inputs = true
      }

      # Auth
      auth {
          fingerprint {
              enabled = ${boolToString cfg.hyprlock.fingerprintEnabled}
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
          font_family = JetBrains Mono Nerd Font Mono
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
          font_color = rgb(224, 222, 244)
          fade_on_empty = true
          font_family = JetBrains Mono Nerd Font Mono
          placeholder_text = <i><span foreground="##908caa">Input Password...</span></i>
          hide_input = false
          position = 0, 0
          halign = center
          valign = center
      }

      # TIME
      label {
          monitor =
          text = cmd[update:1000] echo "$(date +"%-I:%M%p")"
          color = rgba(156, 207, 216, 0.6)
          font_size = 100
          font_family = JetBrains Mono Nerd Font Mono ExtraBold
          position = 0, -50
          halign = center
          valign = top
      }

      # USER/FORTUNE
      label {
          monitor =
          text = cmd[update:] echo "$(fortune -s)"
          color = rgba(235, 188, 186, 0.6)
          font_size = 12
          font_family = JetBrains Mono Nerd Font Mono
          position = 0, 250
          halign = center
          valign = center
      }
    '';

    # Hyprpaper configuration
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      ${concatMapStringsSep "\n" (img: "preload = ${img}") cfg.hyprpaper.wallpapers}

      # Set wallpaper for all monitors
      wallpaper = eDP-1,${cfg.hyprpaper.defaultWallpaper}
      wallpaper = ,${cfg.hyprpaper.defaultWallpaper}

      splash = false
    '';

    # Hypridle configuration
    xdg.configFile."hypr/hypridle.conf".text = ''
      general {
          lock_cmd = pidof hyprlock || hyprlock
          before_sleep_cmd = loginctl lock-session
          after_sleep_cmd = hyprctl dispatch dpms on
      }

      # Lock screen
      listener {
          timeout = ${toString cfg.hypridle.lockTimeout}
          on-timeout = loginctl lock-session
      }

      # Turn off display
      listener {
          timeout = ${toString cfg.hypridle.displayOffTimeout}
          on-timeout = hyprctl dispatch dpms off
          on-resume = hyprctl dispatch dpms on
      }

      # Suspend system
      listener {
          timeout = ${toString cfg.hypridle.suspendTimeout}
          on-timeout = systemctl suspend
      }
    '';

    # Session variables
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XCURSOR_SIZE = "24";
      XCURSOR_THEME = "Adwaita";
    };
  };
}
