{ config, pkgs, lib, inputs, ... }:

with lib;
let
  cfg = config.modules.niri;
in
{
  options.modules.niri = {
    enable = mkEnableOption "Niri (DankMaterialShell) desktop environment";
  };

  imports = [
    # Niri home-manager module (provides lib.niri.actions)
    inputs.niri.homeModules.config

    # DankMaterialShell modules
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
  ];

  config = mkIf cfg.enable {
    # DankMaterialShell configuration
    programs.dankMaterialShell = {
      enable = true;
      niri = {
        enableKeybinds = true;
        enableSpawn = true;
      };
    };

    # Additional niri window rules and keybinds (merged with DankMaterialShell)
    programs.niri.settings = {
      # Disable client-side decorations (remove window title bars)
      prefer-no-csd = true;

      # Input configuration - disable natural scrolling for traditional scroll direction
      input = {
        mouse = {
          natural-scroll = false;
        };
        touchpad = {
          natural-scroll = false;
          tap = true;
          dwt = true;
          dwtp = true;
        };
      };

      # Layout settings - default to half screen columns
      layout = {
        default-column-width = { proportion = 0.5; };
       # gaps = 5;
      };

      # Window rules for transparency
      window-rules = [
        {
          draw-border-with-background = false;
        }
        # Vesktop transparency
        {
          matches = [
            { app-id = "^vesktop$"; }
          ];
          opacity = 0.95;
        }
        # Spotify transparency
        {
          matches = [
            { app-id = "^[Ss]potify$"; }
          ];
          opacity = 0.85;
        }
      ];
    };

    # Additional niri keybinds for window management (merged with DankMaterialShell)
    programs.niri.settings.binds = with config.lib.niri.actions; {
      # Power menu
      "Mod+Escape".action = spawn "dms" "ipc" "powermenu" "toggle";

      # Terminal and basic window management
      "Mod+Q".action = spawn "kitty";
      "Mod+T".action = spawn "alacritty";
      "Mod+K".action = close-window;
      "Mod+E".action = spawn "thunar";
      "Mod+F".action = spawn "brave";
      "Mod+B".action = spawn "librewolf";
      "Mod+Shift+B".action = spawn "mullvad-browser";
      "Mod+Shift+D".action = spawn "vesktop";

      # Focus movement (vim keys)
      "Mod+H".action = focus-column-left;
      "Mod+J".action = focus-window-down;
      "Mod+C".action = focus-window-up;
      "Mod+L".action = focus-column-right;

      # Focus movement (arrow keys)
      "Mod+Left".action = focus-column-left;
      "Mod+Right".action = focus-column-right;
      "Mod+Up".action = focus-window-up;
      "Mod+Down".action = focus-window-down;

      # Window movement
      "Mod+Shift+Left".action = move-column-left;
      "Mod+Shift+Right".action = move-column-right;
      "Mod+Shift+Up".action = move-window-up;
      "Mod+Shift+Down".action = move-window-down;
      "Mod+Alt+H".action = move-column-left;
      "Mod+Alt+L".action = move-column-right;
      "Mod+Alt+J".action = move-window-down;
      "Mod+Alt+K".action = move-window-up;

      # Workspace switching
      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;

      # Move window to workspace
      "Mod+Shift+1".action.move-window-to-workspace = 1;
      "Mod+Shift+2".action.move-window-to-workspace = 2;
      "Mod+Shift+3".action.move-window-to-workspace = 3;
      "Mod+Shift+4".action.move-window-to-workspace = 4;
      "Mod+Shift+5".action.move-window-to-workspace = 5;
      "Mod+Shift+6".action.move-window-to-workspace = 6;
      "Mod+Shift+7".action.move-window-to-workspace = 7;
      "Mod+Shift+8".action.move-window-to-workspace = 8;
      "Mod+Shift+9".action.move-window-to-workspace = 9;

      # Window sizing
      "Mod+Minus".action.set-column-width = "-10%";
      "Mod+Equal".action.set-column-width = "+10%";

      # Fullscreen and maximize
      "Mod+Shift+F".action = fullscreen-window;
      "Mod+Alt+F".action = maximize-column;

      # Screenshot
      "Mod+Shift+S".action = spawn "grim" "-g" "$(slurp)";
    };
  };
}
