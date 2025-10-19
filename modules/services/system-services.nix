{ config, pkgs, ... }:

{
  # Hardware support
  hardware.enableAllFirmware = true;
  hardware.acpilight.enable = true;
  hardware.xone.enable = true;
}
