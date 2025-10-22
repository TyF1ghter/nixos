{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.vdesktop;
in
{
  options.modules.vdesktop = {
    enable = mkEnableOption "Vesktop (Discord client) with custom theming";

    theme = mkOption {
      type = types.str;
      default = "tokyo-night-storm";
      description = "Color theme for Vesktop";
    };

    settings = {
      enableMenu = mkOption {
        type = types.bool;
        default = true;
        description = "Enable menu bar in Vesktop";
      };

      minimizeToTray = mkOption {
        type = types.bool;
        default = true;
        description = "Minimize Vesktop to system tray";
      };

      discordBranch = mkOption {
        type = types.str;
        default = "stable";
        description = "Discord branch to use (stable, canary, ptb)";
      };
    };

    vencord = {
      useQuickCss = mkOption {
        type = types.bool;
        default = true;
        description = "Enable custom CSS for Vesktop";
      };

      enableReactDevtools = mkOption {
        type = types.bool;
        default = false;
        description = "Enable React DevTools";
      };

      frameless = mkOption {
        type = types.bool;
        default = false;
        description = "Use frameless window";
      };

      noTrack = mkOption {
        type = types.bool;
        default = true;
        description = "Enable NoTrack plugin to disable Discord tracking";
      };
    };

    opacity = mkOption {
      type = types.float;
      default = 0.80;
      description = "Window opacity for Vesktop - balanced with CSS for selective transparency";
    };
  };

  config = mkIf cfg.enable {
    programs.vesktop = {
      enable = true;

      # Main Vesktop settings
      settings = {
        enableMenu = cfg.settings.enableMenu;
        minimizeToTray = cfg.settings.minimizeToTray;
        discordBranch = cfg.settings.discordBranch;
        # Use "none" to allow CSS transparency to work on Linux
        transparencyOption = "none";
      };

      # Vencord settings for transparency theme
      vencord.settings = {
        useQuickCss = cfg.vencord.useQuickCss;
        enableReactDevtools = cfg.vencord.enableReactDevtools;
        frameless = cfg.vencord.frameless;
        plugins = {
          # Core plugins that might be needed
          NoTrack.enabled = cfg.vencord.noTrack;
        };
      };
    };

    # Custom QuickCSS for Tokyo Night Storm theme matching nvchad.nix and terminal.nix
    xdg.configFile."vesktop/settings/quickCss.css".text = ''
      /* Tokyo Night Storm Theme - Matching NvChad and Kitty with blue backgrounds */
      :root {
        /* Background Colors - Tokyo Night Storm blue-tinted backgrounds with transparency */
        --background-primary: rgba(36, 40, 59, 0.7) !important;      /* #24283b - main bg */
        --background-secondary: rgba(30, 33, 48, 0.7) !important;    /* #1e2130 - secondary bg */
        --background-secondary-alt: rgba(26, 29, 41, 0.7) !important; /* #1a1d29 - alt bg */
        --background-tertiary: rgba(22, 25, 37, 0.7) !important;     /* #161925 - tertiary bg */
        --background-accent: rgba(42, 195, 222, 0.2) !important;     /* #2AC3DE from nvchad */
        --background-floating: rgba(30, 33, 48, 0.85) !important;    /* #1e2130 - floating elements */
        --background-mobile-primary: rgba(36, 40, 59, 0.7) !important;
        --background-mobile-secondary: rgba(30, 33, 48, 0.7) !important;

        /* Selection and Hover - Matching NvChad Visual selection #343A52 */
        --background-modifier-selected: rgba(52, 58, 82, 0.9) !important;  /* #343A52 */
        --background-modifier-hover: rgba(68, 75, 106, 0.5) !important;    /* #444B6A */
        --background-modifier-active: rgba(52, 58, 82, 0.7) !important;
        --channeltextarea-background: rgba(30, 33, 48, 0.6) !important;
        --deprecated-card-bg: rgba(36, 40, 59, 0.6) !important;
        --deprecated-card-editable-bg: rgba(36, 40, 59, 0.6) !important;

        /* Text Colors - Brighter for better readability */
        --text-normal: #212736 !important;           /* Brighter main text */
        --text-muted: #2AC3DE !important;            /* Brighter muted text */
        --text-link: #7DCFFF !important;             /* Bright cyan for links */
        --text-positive: #9ECE6A !important;         /* Green */
        --text-warning: #E0AF68 !important;          /* Yellow */
        --text-danger: #F7768E !important;           /* Red */
        --header-primary: #C0CAF5 !important;        /* Bright header text */
        --header-secondary: #A9B1D6 !important;      /* Secondary header */

        /* Interactive Colors - Brighter for visibility */
        --interactive-normal: #C0CAF5 !important;    /* Bright normal state */
        --interactive-hover: #7DCFFF !important;     /* Bright cyan on hover */
        --interactive-active: #7AA2F7 !important;    /* Bright blue when active */
        --interactive-muted: #565F89 !important;     /* Slightly brighter muted */

        /* Brand Colors - Using brighter Tokyo Night colors */
        --brand-experiment: #7AA2F7 !important;      /* Bright blue accent */
        --brand-experiment-hover: #7DCFFF !important; /* Brighter cyan on hover */
        --brand-experiment-560: #7AA2F7 !important;

        /* Status Colors - Keep vibrant */
        --status-positive: #9ECE6A !important;       /* Green */
        --status-warning: #E0AF68 !important;        /* Yellow */
        --status-danger: #F7768E !important;         /* Red */

        /* Channel/Server Colors - Brighter */
        --channels-default: #A9B1D6 !important;      /* Brighter default */
        --channel-icon: #7AA2F7 !important;          /* Bright blue icon */

        /* Special Colors */
        --mention-foreground: #7AA2F7 !important;    /* Bright mentions */
        --mention-background: rgba(122, 162, 247, 0.15) !important;
      }

      /* Make main app background transparent like NvChad */
      .appMount_ea7e65,
      .app_de4237,
      .layers_a23c37,
      .base_a4d4d9 {
        background-color: transparent !important;
      }

      /* Sidebar and server list should be transparent */
      .sidebar_a4d4d9,
      .panels_a4d4d9,
      .container_cbd271,
      [class*="guilds"],
      [class*="sidebar"] {
        background-color: rgba(30, 33, 48, 0.3) !important;  /* More transparent */
      }

      /* Improve text contrast and readability */
      .messageContent_f9f2ca,
      .content_f12fa1 {
        color: #7DCFFF !important;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
      }

      /* Make usernames much brighter and higher contrast */
      .username_d30d99,
      .name_d8bfb3,
      .title_a7d72e,
      h3[class*="username"],
      [class*="username"],
      [class*="headerText"] {
        color: #E0E6F8 !important;  /* Much brighter white */
        font-weight: 600 !important;
        text-shadow: 0 1px 3px rgba(0, 0, 0, 0.8) !important;
      }

      /* Brighter icons for visibility */
      svg {
        filter: brightness(1.3);
      }

      /* Scrollbar styling - Using NvChad colors */
      ::-webkit-scrollbar-thumb {
        background-color: rgba(42, 195, 222, 0.3) !important;  /* #2AC3DE */
      }

      ::-webkit-scrollbar-thumb:hover {
        background-color: rgba(42, 195, 222, 0.5) !important;
      }

      ::-webkit-scrollbar-track {
        background-color: rgba(68, 75, 106, 0.2) !important;  /* #444B6A */
      }

      /* Accent elements - Purple from NvChad (#BB9AF7, #9D7CD8) */
      .selected_ae80f7,
      .wrapper_c51b4e:hover {
        background-color: rgba(187, 154, 247, 0.2) !important;  /* #BB9AF7 */
      }

      /* Search highlighting - Matching NvChad */
      mark {
        background-color: rgba(68, 75, 106, 0.6) !important;  /* #444B6A */
        color: #0DB9D7 !important;
      }

      /* Force images and media to have full opacity - no transparency */
      img,
      video,
      .imageWrapper_d4597d,
      .imageContent_dc5d92,
      .mediaPlayer_e8476d,
      .embedWrapper_b4c0d8,
      .embedImage_d4b6c5,
      .originalLink_d60142,
      .imageAccessory_ada163,
      [class*="image"],
      [class*="Image"],
      [class*="media"],
      [class*="Media"],
      [class*="attachment"],
      [class*="Attachment"],
      [class*="embed"] img,
      [class*="Embed"] img {
        opacity: 1 !important;
      }

      /* The main chat/message area needs to NOT be transparent */
      /* These selectors target the message/content containers */
      .chat_a7d72e,
      .content_a4d4d9,
      .container_fdd4bf,
      .messagesWrapper_ea2b0e,
      .scrollerInner_e2e187,
      .message_ccca67,
      [class*="chatContent"],
      [class*="messagesWrapper"] {
        background-color: rgba(36, 40, 59, 1) !important;  /* Fully opaque */
      }

      /* Message content and images must be opaque */
      .messageContent_f9f2ca,
      .imageWrapper_d4597d,
      .imageContent_dc5d92,
      .messageAttachment_c900c7,
      .embedWrapper_b4c0d8,
      .imageAccessory_ada163 {
        background-color: rgba(36, 40, 59, 1) !important;  /* Fully opaque */
      }

      /* Images themselves must be fully visible */
      img,
      video {
        opacity: 1 !important;
        background-color: rgba(30, 33, 48, 1) !important;  /* Fully opaque */
      }

      /* Icons should also be fully opaque */
      svg,
      [class*="icon"] {
        opacity: 1 !important;
      }
    '';

    # Window rule for Hyprland opacity (if hyprland is enabled)
    # Apply window transparency at compositor level
    wayland.windowManager.hyprland = mkIf config.modules.hyprland.enable {
      settings.windowrulev2 = [
        "opacity ${toString cfg.opacity} ${toString cfg.opacity},class:^(vesktop)$"
      ];
    };
  };
}
