{ config, pkgs, lib, ... }:

{
  # Security and Authentication Configuration

  # Fingerprint Authentication (Goodix Fingerprint USB Device)
  services.fprintd = {
    enable = true;
    # TOD (Touch OEM Drivers) not needed for Goodix - uses libfprint directly
  };

  # PAM Configuration for Fingerprint Authentication
  # Using mkForce to override GDM's default fprintAuth = false
  security.pam.services = {
    # Enable fingerprint for login
    login.fprintAuth = lib.mkForce true;

    # Enable fingerprint for GDM (display manager login)
    gdm.fprintAuth = lib.mkForce true;

    # Enable fingerprint for sudo
    sudo.fprintAuth = lib.mkForce true;

    # Enable fingerprint for Hyprlock screen locker
    hyprlock.fprintAuth = lib.mkForce true;

    # Enable fingerprint for polkit (privilege escalation)
    polkit-1.fprintAuth = lib.mkForce true;
  };

  # Polkit for privilege escalation
  security.polkit.enable = true;

  # Security hardening
  security.sudo = {
    enable = true;
    execWheelOnly = true;  # Only allow wheel group to use sudo
  };
}
