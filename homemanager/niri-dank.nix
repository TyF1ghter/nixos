{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.niri-dank;
in
{
  options.modules.niri-dank = {
    enable = mkEnableOption "Dank Material Niri + Shell configuration";

    # Terminal options
    # NOTE: Kitty is configured by DankMaterialShell, these options are for reference only
    terminal = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable kitty terminal configuration (conflicts with DankMaterialShell)";
      };

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

    # Niri options (managed by DankMaterialShell)
    # DankMaterialShell handles niri config, waybar, dunst, wofi, etc.
    niri = {
      preferDarkTheme = mkOption {
        type = types.bool;
        default = true;
        description = "Prefer dark theme for applications";
      };
    };

    # Lock screen options
    swaylock = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable swaylock screen locker";
      };

      image = mkOption {
        type = types.str;
        default = "${config.home.homeDirectory}/nixos/walls/cat_lofi_cafe.jpg";
        description = "Lock screen background image";
      };

      blur = mkOption {
        type = types.str;
        default = "5x3";
        description = "Lock screen blur effect";
      };

      fadeIn = mkOption {
        type = types.float;
        default = 0.2;
        description = "Lock screen fade in time";
      };
    };

    # Idle daemon options
    swayidle = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable swayidle daemon";
      };

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

  # Auto-enable when niri is enabled (but allow manual override)
  config = mkIf (cfg.enable || config.modules.niri.enable or false) {
    # Disable modular components that conflict with DankMaterialShell
    modules.swaylock.enable = mkForce false;  # Using niri-dank's integrated swaylock
    modules.swayidle.enable = mkForce false;  # Using niri-dank's integrated swayidle
    modules.dunst.enable = mkForce false;      # DMS has built-in notifications
    modules.waybar.enable = mkForce false;     # DMS has built-in bar (DankBar)

    # Kitty terminal configuration (disabled by default - DankMaterialShell handles this)
    programs.kitty = mkIf cfg.terminal.enable {
      enable = true;
      settings = {
        color_theme = cfg.terminal.theme;
        confirm_os_window_close = 0;
        background_opacity = cfg.terminal.opacity;
      };
    };

    # Niri window manager configuration
    # NOTE: Niri config.kdl is managed by DankMaterialShell
    programs.niri = {
      package = mkDefault pkgs.niri;
    };

    # Swaylock configuration - Modern DE-style lock screen
    programs.swaylock = mkIf cfg.swaylock.enable {
      enable = true;
      package = mkDefault pkgs.swaylock-effects;
      settings = {
        # Screenshot and blur current screen (faster than loading wallpaper)
        screenshots = mkForce true;
        effect-blur = mkForce cfg.swaylock.blur;
        fade-in = mkForce cfg.swaylock.fadeIn;

        # Clock
        clock = mkForce true;
        timestr = mkForce "%I:%M %p";
        datestr = mkForce "%A, %B %e";

        # Indicator - make it look like a text box
        indicator = mkForce true;
        indicator-radius = mkForce 150;
        indicator-thickness = mkForce 3;  # Thin border
        indicator-caps-lock = mkForce true;

        # Display options
        show-failed-attempts = mkForce true;
        show-keyboard-layout = mkForce true;
        daemonize = mkForce false;

        # NOTE: ignore-empty-password is NOT set
        # This allows pressing Enter without typing to trigger PAM fingerprint auth

        # Colors - Soft pastel theme matching hyprlock
        color = mkForce "00000000";  # Transparent background

        # Ring colors - border that changes with input
        ring-color = mkForce "9ccfd899";         # Cyan border (semi-transparent)
        ring-ver-color = mkForce "9ccfd8";       # Cyan when verifying
        ring-wrong-color = mkForce "ebbcba";     # Peachy for errors
        ring-clear-color = mkForce "9ccfd866";   # Lighter cyan when cleared

        # Inside indicator colors - semi-transparent black like hyprlock
        inside-color = mkForce "00000080";
        inside-ver-color = mkForce "00000080";
        inside-wrong-color = mkForce "00000080";
        inside-clear-color = mkForce "00000080";

        # Text colors - soft light gray like hyprlock
        text-color = mkForce "e0def4";
        text-ver-color = mkForce "e0def4";
        text-wrong-color = mkForce "e0def4";
        text-clear-color = mkForce "e0def4";
        text-caps-lock-color = mkForce "9ccfd8";  # Cyan

        # Key highlight - cyan like hyprlock
        key-hl-color = mkForce "9ccfd8";
        bs-hl-color = mkForce "ebbcba";          # Peachy for backspace

        # Separator (transparent)
        separator-color = mkForce "00000000";

        # Line colors (transparent for clean look)
        line-color = mkForce "00000000";
        line-ver-color = mkForce "00000000";
        line-wrong-color = mkForce "00000000";
        line-clear-color = mkForce "00000000";

        # Font
        font = mkForce "Inter Variable";
        font-size = mkForce 24;

        # Grace period disabled to ensure PAM is always called for fingerprint auth
        grace = mkForce 0;

        # Indicator text to show fingerprint is available
        indicator-idle-visible = mkForce true;
      };
    };

    # Swayidle configuration - triggers swaylock directly
    services.swayidle = mkIf cfg.swayidle.enable {
      enable = true;
      events = {
        before-sleep = "${pkgs.swaylock-effects}/bin/swaylock -f";
        lock = "${pkgs.swaylock-effects}/bin/swaylock -f";
      };
      timeouts = [
        {
          timeout = cfg.swayidle.lockTimeout;
          command = "${pkgs.swaylock-effects}/bin/swaylock -f";
        }
        {
          timeout = cfg.swayidle.displayOffTimeout;
          command = "${pkgs.niri}/bin/nirictl action power-off-monitors";
          resumeCommand = "${pkgs.niri}/bin/nirictl action power-on-monitors";
        }
        {
          timeout = cfg.swayidle.suspendTimeout;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };

    # Essential packages for Niri session
    home.packages = with pkgs; [
      niri
      swww              # Wallpaper daemon
      wlogout           # Logout menu
      brightnessctl     # Brightness control
      playerctl         # Media control
      # networkmanagerapplet  # Disabled - DankMaterialShell has built-in network widget
      # blueman           # Disabled - DankMaterialShell has built-in bluetooth widget
      polkit_gnome      # Polkit authentication agent
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
    gtk = mkIf cfg.niri.preferDarkTheme {
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
}
