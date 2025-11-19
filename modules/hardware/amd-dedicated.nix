{ config, pkgs, lib, ... }:

{
  # AMD Dedicated GPU Configuration
  # Optimized for desktop systems with dedicated AMD Radeon GPUs

  # Graphics hardware support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    # AMD graphics packages
    extraPackages = with pkgs; [
      mesa                      # AMD drivers (radeonsi, radv)
      libvdpau-va-gl           # Video acceleration
      rocmPackages.clr.icd     # OpenCL support
    ];

    # 32-bit support for games
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa
      libvdpau-va-gl
    ];
  };

  # Load AMD GPU driver
  boot.initrd.kernelModules = [ "amdgpu" ];

  # AMD GPU kernel parameters
  boot.kernelParams = [
    "amdgpu.dc=1"              # Display core
    "amdgpu.dpm=1"             # Power management
    "amdgpu.ppfeaturemask=0xffffffff"
  ];

  # Hardware acceleration environment variables
  environment.variables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
  };

  # Video drivers
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Useful tools
  environment.systemPackages = with pkgs; [
    vulkan-tools      # vulkaninfo
    mesa-demos        # glxgears
    libva-utils       # vainfo
    radeontop         # GPU monitoring
    clinfo            # OpenCL info
  ];
}
