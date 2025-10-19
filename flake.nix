{
  description = "NixOS Multi-Host Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    stylix.url = "github:danth/stylix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs: {
    nixosConfigurations = {
      # Dell XPS 9520
      xps9520 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./hosts/xps9520/configuration.nix
          nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
          }
        ];
      };

      # Add additional hosts here following the same pattern:
      # hostname = nixpkgs.lib.nixosSystem {
      #   specialArgs = { inherit inputs; };
      #   system = "x86_64-linux";
      #   modules = [
      #     ./hosts/hostname/configuration.nix
      #     inputs.stylix.nixosModules.stylix
      #     inputs.home-manager.nixosModules.home-manager
      #     {
      #       home-manager.useGlobalPkgs = true;
      #       home-manager.useUserPackages = true;
      #       home-manager.backupFileExtension = "hm-backup";
      #     }
      #   ];
      # };
    };
  };
}
