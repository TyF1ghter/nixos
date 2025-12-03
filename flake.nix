{
  description = "NixOS Multi-Host Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    stylix.url = "github:danth/stylix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # Inputs from the old /home/ty/nixos/flake.nix
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dgop.follows = "dgop";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      # Dell XPS 9310 (updated from /home/ty/nixos)
      "9310" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; username = "ty"; };
        system = "x86_64-linux";
        modules = [
          ./hosts/9310/configuration.nix
          nixos-hardware.nixosModules.dell-xps-13-9310 # Keep specific hardware module
          inputs.stylix.nixosModules.stylix
          inputs.spicetify-nix.nixosModules.default # Add spicetify
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
          }
        ];
      };

      # Dell XPS 9520 (existing in nixos-repo)
      xps9520 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; username = "nix"; };
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

      mika = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; username = "ty"; };
        system = "x86_64-linux";
        modules = [
          ./hosts/mika/configuration.nix
          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
          }
        ];
      };

      zeph14 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; username = "ty"; };
        system = "x86_64-linux";
        modules = [
          ./hosts/zeph14/configuration.nix
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
      #   specialArgs = { inherit inputs; username = "someuser"; };
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