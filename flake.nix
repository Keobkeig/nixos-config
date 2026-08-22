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

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # herdr — agent-aware terminal multiplexer (not in our pinned nixpkgs yet).
    # Pinned by tag; bump the tag to update. Deliberately does NOT follow our
    # nixpkgs: herdr pins a newer nixpkgs + rust-overlay to build against.
    herdr = {
      url = "github:herdrdev/herdr/v0.8.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-cachyos-kernel, dms, catppuccin, spicetify-nix, zen-browser, nix-index-database, herdr, ... }@inputs:
  let
    # Change this to set up for a different user
    username = "rxue";

    # Facts shared by every machine.
    baseUserConfig = {
      inherit username;
      # Directories for the tmux/herdr sessionizers to search
      # Missing paths are silently ignored (find ... 2>/dev/null)
      sessionizerPaths = [
        "~/Documents/Work"
        "~/Documents/Programming"
        "/Users/Programming"
        "~/Documents/Textbooks"
      ];
    };

    # Per-machine facts. These live here rather than in one shared attrset so that
    # no machine ever has to edit a committed line to describe itself: to bring
    # back work mode, add a host with isWork = true instead of flipping a flag.
    # (isWork gates the Anduril git identity and tooling — see home/git.nix.)
    hostConfigs = {
      workstation = { isWork = false; };
      macbook = { isWork = false; };
    };

    userConfigFor = host: baseUserConfig // hostConfigs.${host};

    # NixOS-specific pkgs
    linuxPkgs = import nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
      };
      overlays = [
        nix-cachyos-kernel.overlays.default
      ];
    };

    # macOS-specific pkgs
    darwinPkgs = import nixpkgs {
      system = "aarch64-darwin";
      config.allowUnfree = true;
    };
  in
  {
    # NixOS (integrated Home Manager)
    nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; userConfig = userConfigFor "workstation"; pkgs = linuxPkgs; };
      modules = [
        ./hosts/workstation

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; userConfig = userConfigFor "workstation"; isNixOS = true; };
          home-manager.users.${username} = import ./home;
        }
      ];
    };

    # macOS (standalone Home Manager)
    homeConfigurations."${username}@macbook" = home-manager.lib.homeManagerConfiguration {
      pkgs = darwinPkgs;
      extraSpecialArgs = { inherit inputs; userConfig = userConfigFor "macbook"; isNixOS = false; };
      modules = [ ./home ];
    };
  };
}
