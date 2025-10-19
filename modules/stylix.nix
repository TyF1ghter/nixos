{ config, pkgs, ... }:

{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";
    autoEnable = true;
    homeManagerIntegration.autoImport = true;
  };
}
