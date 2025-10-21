# Home Manager Modules

User-level configuration modules using Home Manager's option system.

## Module Organization

```
homemanager/
├── nvchad.nix          # NeoVim with NvChad + Claude Code
├── terminal.nix        # Kitty terminal emulator
├── browsers.nix        # Brave + Qutebrowser
├── vdesktop.nix        # Vesktop (Discord client)
├── wayland.nix         # Waybar + Wofi
└── stylix.nix          # Stylix theme targets
```

## Philosophy

These modules use a **consistent option-based system** for easy customization:

```nix
# home.nix
modules.modulename = {
  enable = true;           # Turn feature on/off
  option1 = "value";       # Customize settings
};
```

## Usage

All modules are imported and configured in `home.nix`:

```nix
imports = [
  ./homemanager/nvchad.nix
  ./homemanager/terminal.nix
  # ... etc
];

modules = {
  nvchad.enable = true;
  terminal.enable = true;
  browsers.enable = true;
  vdesktop.enable = true;
  wayland.enable = true;
  stylix-config.enable = true;
};
```

## Module Details

### nvchad.nix

**Module Name:** `modules.nvchad`

**Purpose:** NeoVim editor with NvChad configuration framework and Claude Code AI assistant.

**Options:**
```nix
modules.nvchad = {
  enable = true;  # Enable/disable NvChad
};
```

**Features:**
- NvChad base configuration
- Claude Code plugin for AI assistance
- Multiple language servers (LSPs)
- Syntax highlighting and completion

**Language Support:**
- Bash (bash-language-server)
- Docker (docker-compose, dockerfile)
- Emmet (HTML/CSS)
- Nix (nixd)
- Python (python-lsp-server, flake8)

**Claude Code Keybindings:**
| Keybinding | Mode | Action |
|------------|------|--------|
| `<leader>cc` | Normal | Toggle Claude Code |
| `<C-,>` | Terminal | Toggle Claude Code |
| `<leader>cC` | Normal | Continue conversation |
| `<leader>cV` | Normal | Verbose mode |

**Window Configuration:**
- Position: Bottom right
- Split ratio: 30%
- Auto-enter insert mode

### terminal.nix

**Module Name:** `modules.terminal`

**Purpose:** Kitty terminal emulator configuration.

**Options:**
```nix
modules.terminal = {
  enable = true;
  theme = "tokyo-night-storm";  # Color theme
  opacity = 0.8;                 # Background opacity (0.0-1.0)
};
```

**Settings:**
- Disable close confirmation
- Transparent background (configurable)
- Theme integration with Stylix

**Customization Examples:**
```nix
# Fully opaque terminal
modules.terminal.opacity = 1.0;

# More transparent
modules.terminal.opacity = 0.6;

# Different theme
modules.terminal.theme = "nord";
```

### browsers.nix

**Module Name:** `modules.browsers`

**Purpose:** Web browser configuration with privacy focus.

**Options:**
```nix
modules.browsers = {
  enable = true;
  enableBrave = true;       # Chromium-based browser
  enableQutebrowser = true; # Keyboard-driven browser
};
```

**Brave Browser:**
- Chromium-based
- Built-in ad blocking
- Crypto wallet (optional)

**Qutebrowser Features:**
- Keyboard-driven (Vim-like)
- Extensive ad blocking (multiple filter lists)
- Private browsing enabled
- Dark mode forced
- Custom search engines

**Search Engine Shortcuts:**
| Prefix | Engine | Example |
|--------|--------|---------|
| (default) | DuckDuckGo | `search term` |
| `map` | Google Maps | `map new york` |
| `yt` | YouTube | `yt tutorial` |
| `git` | GitHub | `git nixos` |
| `wiki` | Wikipedia | `wiki linux` |
| `reddit` | Reddit | `reddit nixos` |
| `arch` | Arch packages | `arch firefox` |
| `aur` | AUR packages | `aur yay` |
| `archwiki` | Arch Wiki | `archwiki nvidia` |
| `steam` | Steam Store | `steam cyberpunk` |
| `protondb` | ProtonDB | `protondb elden ring` |
| `stack` | Stack Overflow | `stack python error` |
| `imdb` | IMDb | `imdb inception` |

**Ad Blocking:**
- EasyList
- EasyPrivacy
- uBlock Origin filters
- Fanboy's lists
- StevenBlack hosts

**Privacy Features:**
- Private browsing by default
- No autosave
- Strict content blocking
- Hosts-based blocking

### vdesktop.nix

**Module Name:** `modules.vdesktop`

**Purpose:** Vesktop (Discord client) with custom theming and configuration.

**Options:**
```nix
modules.vdesktop = {
  enable = true;
  theme = "tokyo-night-storm";  # Color theme
  opacity = 0.80;                # Window opacity (0.0-1.0)

  settings = {
    enableMenu = true;           # Enable menu bar
    minimizeToTray = true;       # Minimize to system tray
    discordBranch = "stable";    # Discord branch (stable/canary/ptb)
  };

  vencord = {
    useQuickCss = true;          # Enable custom CSS
    enableReactDevtools = false; # React DevTools
    frameless = false;           # Frameless window
    noTrack = true;              # Disable Discord tracking
  };
};
```

**Features:**
- Enhanced Discord client with better Linux support
- Native Wayland support with transparency
- Better screen sharing
- Custom Tokyo Night Storm theme matching NvChad and Kitty
- Vencord integration for customization and privacy
- Configurable window opacity via Hyprland
- NoTrack plugin to disable Discord telemetry

**Theme Integration:**
- Automatically matches Tokyo Night Storm colors from NvChad and terminal
- Transparent backgrounds with configurable opacity
- Custom scrollbar styling
- Enhanced text readability with proper contrast

### wayland.nix

**Module Name:** `modules.wayland`

**Purpose:** Wayland compositor utilities.

**Options:**
```nix
modules.wayland = {
  enable = true;
};
```

**Components:**
- **Waybar:** Status bar for Wayland compositors
- **Wofi:** Application launcher (dmenu/rofi alternative)

**Waybar Features:**
- Modules: workspaces, clock, system tray, battery, network, etc.
- Styled by Stylix
- Configured per-compositor

**Wofi Features:**
- Application launcher
- Run dialog
- SSH selector
- Power menu integration

### stylix.nix

**Module Name:** `modules.stylix-config`

**Purpose:** Configure which applications receive Stylix theming.

**Options:**
```nix
modules.stylix-config = {
  enable = true;
};
```

**Themed Applications:**
- Kitty terminal (with 256-color variant)
- XFCE/Thunar file manager
- Hyprland compositor
- Hyprlock screen locker
- Waybar status bar
- Wofi launcher
- Qutebrowser
- GTK applications (system-wide)

**Note:** Vesktop uses a custom Tokyo Night Storm theme (configured in vdesktop.nix) instead of Stylix for better Discord-specific styling.

**How It Works:**
Stylix reads the base16 theme defined in system config and automatically generates color schemes for all enabled targets.

**Benefits:**
- Consistent colors across all apps
- One-place theme changes
- Automatic dark/light theme support

## Creating Custom Modules

### Basic Module Template

```nix
{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.mymodule;
in
{
  options.modules.mymodule = {
    enable = mkEnableOption "My module description";
  };

  config = mkIf cfg.enable {
    # Configuration here
    programs.myapp.enable = true;
  };
}
```

### Module with Options

```nix
{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.mymodule;
in
{
  options.modules.mymodule = {
    enable = mkEnableOption "My module description";

    setting = mkOption {
      type = types.str;
      default = "default value";
      description = "What this setting does";
    };

    enableFeature = mkOption {
      type = types.bool;
      default = false;
      description = "Enable optional feature";
    };
  };

  config = mkIf cfg.enable {
    programs.myapp = {
      enable = true;
      settings = {
        option = cfg.setting;
      };
    };

    # Conditional configuration
    programs.feature.enable = cfg.enableFeature;
  };
}
```

### Using the Module

1. **Create module file** in `homemanager/`:
```bash
nvim homemanager/mymodule.nix
```

2. **Import in home.nix:**
```nix
imports = [
  ./homemanager/mymodule.nix
];
```

3. **Enable and configure:**
```nix
modules.mymodule = {
  enable = true;
  setting = "custom value";
  enableFeature = true;
};
```

## Module Best Practices

### 1. Use Semantic Names
```nix
# Good
modules.terminal.opacity = 0.8;

# Bad
modules.term.op = 0.8;
```

### 2. Provide Sensible Defaults
```nix
opacity = mkOption {
  type = types.float;
  default = 0.8;  # Good default for most users
  description = "Background opacity";
};
```

### 3. Add Descriptions
```nix
enable = mkEnableOption "Terminal emulator configuration";  # Good

enable = mkEnableOption "";  # Bad - no description
```

### 4. Use Appropriate Types
```nix
# String option
theme = mkOption {
  type = types.str;
  default = "tokyo-night-storm";
};

# Boolean option
enableFeature = mkOption {
  type = types.bool;
  default = false;
};

# Integer option
fontSize = mkOption {
  type = types.int;
  default = 12;
};

# List option
packages = mkOption {
  type = types.listOf types.package;
  default = [];
};
```

### 5. Group Related Options
```nix
modules.browsers = {
  enable = true;
  enableBrave = true;      # Related to browsers
  enableQutebrowser = true;  # Related to browsers
};
```

## Disabling Modules

### Temporary Disable
```nix
modules.nvchad.enable = false;
```

### Permanent Disable
Comment out or remove the import and enable:
```nix
imports = [
  # ./homemanager/nvchad.nix  # Removed
];

modules = {
  # nvchad.enable = true;  # Removed
  terminal.enable = true;
};
```

## Module Dependencies

Some modules work better together:

- `stylix.nix` themes apps configured in other modules
- `wayland.nix` complements system `hyprland.nix`
- `terminal.nix` benefits from `stylix.nix` theming

## Troubleshooting

### Module Not Loading
```bash
# Check for syntax errors
home-manager build --flake /etc/nixos

# Rebuild with verbose output
home-manager switch --flake /etc/nixos -v
```

### Option Not Working
Check that:
1. Module is imported in `home.nix`
2. Module is enabled: `modules.modulename.enable = true;`
3. Option name is spelled correctly
4. Option value is the correct type

### Conflicts Between Modules
If two modules try to configure the same program:
```nix
# Module A
programs.kitty.enable = true;

# Module B
programs.kitty.enable = true;  # Conflict!
```

**Solution:** Use `mkIf` and ensure only one module manages each program:
```nix
config = mkIf cfg.enable {
  programs.kitty.enable = true;
};
```

## Advanced: Sharing Options

To share options between modules:

```nix
# homemanager/shared.nix
{ lib, ... }:

{
  options.modules.shared = {
    theme = lib.mkOption {
      type = lib.types.str;
      default = "tokyo-night-storm";
      description = "Global theme";
    };
  };
}
```

```nix
# homemanager/terminal.nix
{ config, ... }:

{
  # Use shared option
  programs.kitty.theme = config.modules.shared.theme;
}
```

## Resources

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [NixOS Options Search](https://search.nixos.org/options)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
