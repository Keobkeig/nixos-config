{
  description = "NixOS configuration with Flakes + Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { self, nixpkgs, home-manager, nix-cachyos-kernel, dms, catppuccin, spicetify-nix, zen-browser, ... }@inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
      };
      overlays = [
        nix-cachyos-kernel.overlays.default
      ];
    };

    # User-specific configuration
    userConfig = {
      # Directories for tmux-sessionizer to search
      sessionizerPaths = [
        "~/Documents/Programming"
        "~/Documents/Textbooks"
        "~/Projects"
        "~/nixos-config"
      ];
    };
  in
  {
    nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs pkgs; };
      modules = [
        ./hosts/workstation

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs userConfig; };
          home-manager.users.rxue = import ./home;
        }
      ];
    };
  };
}
