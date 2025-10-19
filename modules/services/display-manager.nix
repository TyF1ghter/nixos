{ config, pkgs, ... }:

{
  services = {
    # Input device configuration
    libinput = {
      enable = true;
      touchpad.tapping = false;
      touchpad.naturalScrolling = true;
      touchpad.scrollMethod = "twofinger";
      touchpad.disableWhileTyping = false;
      touchpad.clickMethod = "clickfinger";
    };

    # X server configuration
    xserver = {
      xkb.layout = "us";
      xkb.variant = "";
      excludePackages = [ pkgs.xterm ];
    };

    # Display manager (GDM with Wayland)
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  # GNOME Keyring for credential management
  services.gnome.gnome-keyring.enable = true;
}
