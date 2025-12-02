{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.dunst;
in
{
  options.modules.dunst = {
    enable = mkEnableOption "Dunst notification daemon";

    position = mkOption {
      type = types.str;
      default = "top-right";
      description = "Position of notifications (top-right, top-left, bottom-right, bottom-left, top-center, bottom-center)";
    };

    offset = mkOption {
      type = types.str;
      default = "16x16";
      description = "Offset from the origin";
    };
  };

  config = mkIf cfg.enable {
    # Let Stylix manage theming by default
    stylix.targets.dunst.enable = mkDefault true;

    services.dunst = {
      enable = true;
      settings = {
        global = {
          monitor = "1,2,0";
          follow = "none";
          width = "(0,300)";
          height = 256;
          origin = cfg.position;
          offset = cfg.offset;
          scale = 0;
          notification_limit = 20;

          # Progress bar
          progress_bar = true;
          progress_bar_height = 10;
          progress_bar_frame_width = 1;
          progress_bar_min_width = 150;
          progress_bar_max_width = 300;
          progress_bar_corner_radius = mkDefault 4;
          progress_bar_corners = "all";

          # Icons
          icon_corner_radius = mkDefault 4;
          icon_corners = "all";
          indicate_hidden = true;

          # Appearance
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

          # Text
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

          # Icon settings
          enable_recursive_icon_lookup = true;
          icon_theme = mkDefault "Dracula";
          icon_position = "left";
          min_icon_size = 16;
          max_icon_size = 32;

          # History
          sticky_history = true;
          history_length = 20;

          # Misc
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

          # Mouse actions
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
  };
}