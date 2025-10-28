{ config, pkgs, lib, ... }:

{
  # AMD CPU and GPU Configuration
  # Optimized for systems with AMD Ryzen CPUs and AMD Radeon GPUs
  # Includes hardware acceleration, power management, and performance optimizations

  # Graphics hardware support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # Required for 32-bit games/applications

    # AMD-specific graphics packages
    extraPackages = with pkgs; [
      # AMD hardware video acceleration
      mesa.drivers              # Mesa drivers (includes radeonsi, radv)
      libvdpau-va-gl           # VDPAU driver
      rocmPackages.clr.icd     # ROCm OpenCL ICD for compute tasks

      # Additional AMD acceleration libraries
      amdvlk                   # AMD official Vulkan driver (alternative to radv)
    ];

    # 32-bit driver support for gaming compatibility
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa.drivers
      libvdpau-va-gl
    ];
  };

  # AMD GPU kernel driver configuration
  boot = {
    # Load AMD GPU module early in boot for better stability
    initrd.kernelModules = [ "amdgpu" ];

    # Kernel parameters for AMD GPU optimization
    kernelParams = [
      # Enable AMD GPU display core functionality
      "amdgpu.dc=1"

      # Enable GPU power management (DPM)
      "amdgpu.dpm=1"

      # Power profile mode: 0=default, 1=auto, 2=low, 3=high, 4=manual, 5=custom
      "amdgpu.ppfeaturemask=0xffffffff"  # Enable all power features
    ];
  };

  # Environment variables for AMD hardware acceleration
  environment.variables = {
    # Use radeonsi driver for VA-API video acceleration
    LIBVA_DRIVER_NAME = "radeonsi";

    # VDPAU configuration for AMD
    VDPAU_DRIVER = "radeonsi";

    # Use RADV (Mesa Vulkan driver) by default - generally better performance
    # Uncomment below to use AMD's official AMDVLK driver instead
    # AMD_VULKAN_ICD = "AMDVLK";

    # Enable AMD FreeSync/VRR support on Wayland
    WLR_DRM_NO_ATOMIC = "0";
  };

  # Video drivers for X11/Xorg
  services.xserver.videoDrivers = [ "amdgpu" "modesetting" ];

  # AMD CPU optimizations
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Enable AMD CPU frequency scaling
  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";  # Better than ondemand for modern AMD

  # Useful system packages for AMD systems
  environment.systemPackages = with pkgs; [
    # Graphics utilities
    glxinfo           # OpenGL information
    vulkan-tools      # Vulkan utilities (vulkaninfo)
    mesa-demos        # Mesa demos and glxgears
    libva-utils       # VA-API utilities (vainfo)

    # AMD-specific tools
    radeontop         # AMD GPU monitoring tool (like nvidia-smi)
    lm_sensors        # Hardware monitoring (temperatures, fans)
    clinfo            # OpenCL information for compute tasks
  ];

  # Specialization: Performance mode for gaming
  # Boot with: sudo nixos-rebuild boot --specialisation gaming
  specialisation = {
    gaming.configuration = {
      # Set CPU governor to performance mode
      powerManagement.cpuFreqGovernor = lib.mkForce "performance";

      # Add performance-focused kernel parameters
      boot.kernelParams = [
        # Force highest GPU performance level
        "amdgpu.gpu_recovery=1"        # Enable GPU recovery
        "amdgpu.lockup_timeout=10000"  # Longer timeout for heavy workloads
      ];

      # Disable power management features for maximum performance
      environment.variables = {
        # Force maximum GPU performance
        AMD_PERFORMANCE_PROFILE = "high";
      };
    };
  };
}
