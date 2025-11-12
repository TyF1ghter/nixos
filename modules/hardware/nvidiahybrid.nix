{ config, pkgs, lib, ... }:

{
  # NVIDIA Hybrid Graphics Configuration (Intel iGPU + NVIDIA dGPU)
  # Uses NVIDIA PRIME with offload mode by default for power efficiency
  # Switch to 'gaming-time' specialization for full NVIDIA sync mode

  # Graphics hardware support
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;  # Required for 32-bit games/applications
      extraPackages = with pkgs; [
        libva-vdpau-driver      # VDPAU backend for VA-API
        libvdpau-va-gl  # VDPAU driver
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };

    # NVIDIA driver configuration
    nvidia = {
      modesetting.enable = true;  # Required for Wayland
      open = false;  # Use proprietary driver (open source not stable yet)
      nvidiaSettings = true;  # Enable nvidia-settings GUI
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      forceFullCompositionPipeline = true;
      powerManagement.enable = true;  # Enable power management features
    };
  };

  # NVIDIA PRIME Hybrid Graphics Configuration
  hardware.nvidia.prime = {
    # Offload mode: Intel iGPU primary, NVIDIA dGPU on-demand
    # Use 'nvidia-offload <command>' to run apps on NVIDIA GPU
    offload = {
      enable = true;
      enableOffloadCmd = true;  # Enables 'nvidia-offload' command
    };

    # Intel integrated GPU (iGPU)
    intelBusId = "PCI:0:02:0";

    # NVIDIA dedicated GPU (dGPU)
    nvidiaBusId = "PCI:1:0:0";
  };

  # Specialization: Switch to NVIDIA sync mode for gaming
  # Boot with: sudo nixos-rebuild boot --specialisation gaming-time
  specialisation = {
    gaming-time.configuration = {
      hardware.nvidia = {
        prime.sync.enable = lib.mkForce true;  # Always use NVIDIA GPU
        prime.offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };
      };
    };
  };

  # Video drivers
  services.xserver.videoDrivers = [ "nvidia" "modsetting" ];
}
