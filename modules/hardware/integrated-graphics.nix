{ config, pkgs, lib, ... }:

{
  # Integrated graphics configuration for Wayland-only systems
  # Supports Intel and AMD integrated graphics without dedicated GPU
  # Optimized for laptops and systems using Wayland compositors (Hyprland, Sway, etc.)

  # Enable OpenGL/graphics drivers
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # Required for 32-bit applications and games

    # Additional packages for hardware video acceleration
    extraPackages = with pkgs; [
      # Intel hardware acceleration
      intel-media-driver    # VAAPI driver for newer Intel GPUs (Broadwell+)
      intel-vaapi-driver    # VAAPI driver for older Intel GPUs
      libvdpau-va-gl        # VDPAU driver

      # AMD hardware acceleration (safe to include even on Intel systems)
      mesa                  # Mesa drivers including AMD
    ];

    # 32-bit driver support for compatibility
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  # Environment variables for hardware acceleration
  environment.variables = {
    # Enable VA-API for video acceleration
    # For Intel: use "iHD" (newer) or "i965" (older)
    LIBVA_DRIVER_NAME = lib.mkDefault "iHD";

    # AMD users should change to:
    # LIBVA_DRIVER_NAME = "radeonsi";

    # VDPAU configuration
    VDPAU_DRIVER = lib.mkDefault "va_gl";
  };

  # Intel-specific optimizations
  boot.kernelParams = [
    # Enable GuC/HuC firmware for newer Intel GPUs (improves performance)
    "i915.enable_guc=3"
  ];

  # Load Intel graphics modules early in boot
  boot.initrd.kernelModules = [ "i915" ];

  # AMD users should uncomment:
  # boot.initrd.kernelModules = [ "amdgpu" ];

  # Install useful graphics utilities
  environment.systemPackages = with pkgs; [
    vulkan-tools      # Vulkan utilities (vulkaninfo, etc.)
    mesa-demos        # Mesa demos and glxgears
    libva-utils       # VA-API utilities (vainfo)
  ];
}
