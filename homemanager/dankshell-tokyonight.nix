{ config, pkgs, lib, inputs, ... }:

with lib;

let
  cfg = config.modules.dankshell-tokyonight;
in
{
  options.modules.dankshell-tokyonight = {
    enable = mkEnableOption "DankMaterialShell Tokyo Night theme configuration";
  };

  config = mkIf cfg.enable {
    # Add upower for battery monitoring
    home.packages = with pkgs; [
      upower
    ];

    # DankMaterialShell settings managed by home-manager
    # Settings are always sourced from this nix configuration
    # GUI changes will NOT persist - edit this file to make permanent changes

    # Generate pretty-printed JSON using runCommand
    home.file.".config/DankMaterialShell/settings.json" = {
      force = true;  # Always overwrite without backing up
      source = pkgs.runCommand "dms-settings.json" { buildInputs = [ pkgs.python3 ]; } ''
        cat > settings.json <<'EOF'
${builtins.toJSON {
      currentThemeName = "tokyonight";
      customThemeFile = "";
      matugenScheme = "scheme-tonal-spot";
      runUserMatugenTemplates = false;
      matugenTargetMonitor = "";
      dankBarTransparency = 0.70;
      dankBarWidgetTransparency = 1;
      popupTransparency = 0.95;
      dockTransparency = 1;
      widgetBackgroundColor = "sch";
      cornerRadius = 12;
      use24HourClock = false;
      showSeconds = false;
      useFahrenheit = true;
      nightModeEnabled = false;
      animationSpeed = 1;
      customAnimationDuration = 500;
      wallpaperFillMode = "Fill";
      blurredWallpaperLayer = false;
      blurWallpaperOnOverview = false;
      showLauncherButton = true;
      showWorkspaceSwitcher = true;
      showFocusedWindow = true;
      showWeather = true;
      showMusic = true;
      showClipboard = true;
      showCpuUsage = true;
      showMemUsage = true;
      showCpuTemp = true;
      showGpuTemp = true;
      selectedGpuIndex = 0;
      enabledGpuPciIds = [];
      showSystemTray = true;
      showClock = true;
      showNotificationButton = true;
      showBattery = true;
      showControlCenterButton = true;
      showCapsLockIndicator = true;
      controlCenterShowNetworkIcon = true;
      controlCenterShowBluetoothIcon = true;
      controlCenterShowAudioIcon = true;
      showPrivacyButton = true;
      privacyShowMicIcon = false;
      privacyShowCameraIcon = false;
      privacyShowScreenShareIcon = false;
      controlCenterWidgets = [
        { id = "volumeSlider"; enabled = true; width = 50; }
        { id = "brightnessSlider"; enabled = true; width = 50; }
        { id = "wifi"; enabled = true; width = 50; }
        { id = "bluetooth"; enabled = true; width = 50; }
        { id = "audioOutput"; enabled = true; width = 50; }
        { id = "audioInput"; enabled = true; width = 50; }
        { id = "nightMode"; enabled = true; width = 50; }
        { id = "darkMode"; enabled = true; width = 50; }
      ];
      showWorkspaceIndex = false;
      showWorkspacePadding = false;
      workspaceScrolling = false;
      showWorkspaceApps = false;
      maxWorkspaceIcons = 3;
      workspacesPerMonitor = true;
      dwlShowAllTags = false;
      workspaceNameIcons = {};
      waveProgressEnabled = true;
      clockCompactMode = false;
      focusedWindowCompactMode = false;
      runningAppsCompactMode = true;
      keyboardLayoutNameCompactMode = false;
      runningAppsCurrentWorkspace = false;
      runningAppsGroupByApp = false;
      clockDateFormat = "";
      lockDateFormat = "";
      mediaSize = 1;
      dankBarLeftWidgets = [ "launcherButton" "workspaceSwitcher" "focusedWindow" ];
      dankBarCenterWidgets = [ "music" "clock" "weather" ];
      dankBarRightWidgets = [ "idleInhibitor" "systemTray" "clipboard" "cpuUsage" "memUsage" "notificationButton" "battery" "controlCenterButton" ];
      dankBarWidgetOrder = [];
      appLauncherViewMode = "list";
      spotlightModalViewMode = "list";
      sortAppsAlphabetically = false;
      appLauncherGridColumns = 4;
      weatherLocation = "San Antonio, TX";
      weatherCoordinates = "29.4246002,-98.4951405";
      useAutoLocation = false;
      weatherEnabled = true;
      networkPreference = "auto";
      vpnLastConnected = "";
      iconTheme = "System Default";
      launcherLogoMode = "os";
      launcherLogoCustomPath = "";
      launcherLogoColorOverride = "primary";
      launcherLogoColorInvertOnMode = false;
      launcherLogoBrightness = 0.5;
      launcherLogoContrast = 1;
      launcherLogoSizeOffset = 0;
      fontFamily = "Inter Variable";
      monoFontFamily = "Fira Code";
      fontWeight = 400;
      fontScale = 1;
      dankBarFontScale = 1;
      notepadUseMonospace = true;
      notepadFontFamily = "";
      notepadFontSize = 14;
      notepadShowLineNumbers = false;
      notepadTransparencyOverride = -1;
      notepadLastCustomTransparency = 0.7;
      soundsEnabled = true;
      useSystemSoundTheme = false;
      soundNewNotification = true;
      soundVolumeChanged = true;
      soundPluggedIn = true;
      acMonitorTimeout = 300;
      acLockTimeout = 120;
      acSuspendTimeout = 0;
      acSuspendBehavior = 0;
      batteryMonitorTimeout = 300;
      batteryLockTimeout = 100;
      batterySuspendTimeout = 0;
      batterySuspendBehavior = 0;
      showBatteryPercentage = true;
      lockBeforeSuspend = false;
      preventIdleForMedia = true;
      loginctlLockIntegration = false;
      launchPrefix = "";
      brightnessDevicePins = {};
      wifiNetworkPins = {};
      bluetoothDevicePins = {};
      audioInputDevicePins = {};
      audioOutputDevicePins = {};
      gtkThemingEnabled = false;
      qtThemingEnabled = false;
      syncModeWithPortal = true;
      terminalsAlwaysDark = false;
      showDock = false;
      dockAutoHide = false;
      dockGroupByApp = false;
      dockOpenOnOverview = false;
      dockPosition = 1;
      dockSpacing = 4;
      dockBottomGap = 0;
      dockMargin = 0;
      dockIconSize = 40;
      dockIndicatorStyle = "circle";
      notificationOverlayEnabled = false;
      dankBarAutoHide = false;
      dankBarAutoHideDelay = 250;
      dankBarOpenOnOverview = false;
      dankBarVisible = true;
      dankBarSpacing = 0;
      dankBarBottomGap = -11;
      dankBarInnerPadding = 2;
      dankBarPosition = 0;
      dankBarSquareCorners = false;
      dankBarNoBackground = false;
      dankBarGothCornersEnabled = false;
      dankBarGothCornerRadiusOverride = false;
      dankBarGothCornerRadiusValue = 12;
      dankBarBorderEnabled = false;
      dankBarBorderColor = "surfaceText";
      dankBarBorderOpacity = 1;
      dankBarBorderThickness = 1;
      popupGapsAuto = true;
      popupGapsManual = 4;
      modalDarkenBackground = true;
      lockScreenShowPowerActions = true;
      enableFprint = true;
      maxFprintTries = 3;
      hideBrightnessSlider = false;
      notificationTimeoutLow = 5000;
      notificationTimeoutNormal = 5000;
      notificationTimeoutCritical = 0;
      notificationPopupPosition = 0;
      osdAlwaysShowValue = false;
      osdPosition = 5;
      osdVolumeEnabled = true;
      osdBrightnessEnabled = true;
      osdIdleInhibitorEnabled = true;
      osdMicMuteEnabled = true;
      osdCapsLockEnabled = true;
      osdPowerProfileEnabled = true;
      powerActionConfirm = true;
      powerMenuActions = [ "reboot" "logout" "poweroff" "lock" "suspend" "restart" ];
      powerMenuDefaultAction = "lock";
      powerMenuGridLayout = false;
      customPowerActionLock = "swaylock";
      customPowerActionLogout = "";
      customPowerActionSuspend = "";
      customPowerActionHibernate = "";
      customPowerActionReboot = "";
      customPowerActionPowerOff = "";
      updaterUseCustomCommand = false;
      updaterCustomCommand = "";
      updaterTerminalAdditionalParams = "";
      displayNameMode = "system";
      screenPreferences = {};
      showOnLastDisplay = {};
      configVersion = 1;
    }}
EOF
        python3 -c "import json; print(json.dumps(json.load(open('settings.json')), indent=4))" > $out
      '';
    };

    # Spicetify with Tokyo Night Moon colors (matching kitty)
    programs.spicetify = {
      enable = true;

      # Use the simple Dribbblish theme as base (override Stylix)
      theme = mkForce inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system}.themes.dribbblish;
      colorScheme = mkForce "custom";

      customColorScheme = {
        # Tokyo Night Storm colors matching kitty
        text = "c0caf5";              # Foreground
        subtext = "a9b1d6";           # Color7
        sidebar-text = "c0caf5";
        main = "24283b";              # Background
        sidebar = "1f2335";           # Darker background
        player = "24283b";
        card = "292e42";              # Inactive tab background
        shadow = "1d202f";            # Color0
        selected-row = "364a82";      # Selection background
        button = "7aa2f7";            # Color4 (blue)
        button-active = "7aa2f7";
        button-disabled = "414868";   # Color8
        tab-active = "7aa2f7";
        notification = "e0af68";      # Color3 (yellow)
        notification-error = "f7768e"; # Color1 (red)
        misc = "7dcfff";              # Color6 (cyan)
      };

      enabledExtensions = with inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system}.extensions; [
        shuffle
        hidePodcasts
        adblock
      ];
    };

    # Configure kitty with Tokyo Night Moon colors
    programs.kitty = {
      enable = true;
      settings = {
        # Tokyo Night Moon colors
        background = mkForce "#222436";
        foreground = mkForce "#c8d3f5";
        selection_background = mkForce "#2d3f76";
        selection_foreground = mkForce "#c8d3f5";
        url_color = mkForce "#4fd6be";
        cursor = mkForce "#c8d3f5";
        cursor_text_color = mkForce "#222436";

        # Tabs
        active_tab_background = mkForce "#82aaff";
        active_tab_foreground = mkForce "#1e2030";
        inactive_tab_background = mkForce "#2f334d";
        inactive_tab_foreground = mkForce "#545c7e";

        # Windows
        active_border_color = mkForce "#82aaff";
        inactive_border_color = mkForce "#2f334d";

        # Normal colors
        color0 = mkForce "#1b1d2b";
        color1 = mkForce "#ff757f";
        color2 = mkForce "#c3e88d";
        color3 = mkForce "#ffc777";
        color4 = mkForce "#82aaff";
        color5 = mkForce "#c099ff";
        color6 = mkForce "#86e1fc";
        color7 = mkForce "#828bb8";

        # Bright colors
        color8 = mkForce "#444a73";
        color9 = mkForce "#ff8d94";
        color10 = mkForce "#c7fb6d";
        color11 = mkForce "#ffd8ab";
        color12 = mkForce "#9ab8ff";
        color13 = mkForce "#caabff";
        color14 = mkForce "#b2ebff";
        color15 = mkForce "#c8d3f5";

        # Extended colors
        color16 = mkForce "#ff966c";
        color17 = mkForce "#c53b53";

        # Settings
        confirm_os_window_close = mkForce 0;
        background_opacity = mkForce 0.85;
        background_blur = mkForce 20;
      };
    };
  };
}
