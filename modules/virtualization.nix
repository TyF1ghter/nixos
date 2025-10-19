{ config, pkgs, ... }:

{
  # Virtualization Settings
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    qemu
    quickemu
  ];
}
