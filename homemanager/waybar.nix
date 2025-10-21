{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.waybar;
in
{
  options.modules.waybar = {
    enable = mkEnableOption "Waybar status bar";

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

  config = mkIf cfg.enable {
    # Let Stylix manage styling by default
    stylix.targets.waybar.enable = mkDefault true;

    programs.waybar = {
      enable = true;
      settings = [{
        layer = "top";
        position = cfg.position;
        mod = "dock";
        exclusive = true;
        gtk-layer-shell = true;
        height = cfg.height;
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
          format = "󰍛 {usage}%";
          max-length = 10;
        };

        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
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
          format = " {}%";
          max-length = 10;
          tooltip = true;
          tooltip-format = "Memory - {used:0.1f}GB used";
          on-click = "${pkgs.kitty}/bin/kitty -e ${pkgs.btop}/bin/btop";
        };
      }];
    };
  };
}
