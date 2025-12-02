{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.browsers;
in
{
  options.modules.browsers = {
    enable = mkEnableOption "Browser applications";

    enableBrave = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Brave browser";
    };

    enableQutebrowser = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Qutebrowser";
    };
  };

  config = mkIf cfg.enable {
    programs.brave.enable = cfg.enableBrave;

    programs.qutebrowser = mkIf cfg.enableQutebrowser {
      enable = true;
      settings = {
        auto_save.interval = 0;
        content.blocking.enabled = true;
        content.blocking.method = "both";
      };
    };
  };
}
