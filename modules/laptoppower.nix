{ config, pkgs, ... }:

{
  # Laptop Power Management Configuration
  # Enables system-wide power management and automatic CPU frequency scaling
  # for optimal battery life and performance balance

  # Enable system power management
  powerManagement.enable = true;

  # Auto CPU frequency scaling for laptops
  # Automatically adjusts CPU frequency based on load and power state
  services.auto-cpufreq.enable = true;
}
