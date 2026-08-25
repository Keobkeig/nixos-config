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

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      # Linux theming engine: one scheme drives GTK, Qt, cursors, fonts and apps.
      # Pinned to the release matching our nixpkgs, same discipline as nix-darwin;
      # bump both in lockstep.
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      # nix-darwin enforces that its release matches nixpkgs'. Our nixpkgs pin is
      # currently 26.05, so this tracks the matching nix-darwin-26.05 branch.
      # IMPORTANT: bump this branch in lockstep whenever nixpkgs moves to a new
      # release (master pairs with nixpkgs-unstable), or eval will fail loudly.
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Determinate's own module, so nix-darwin can opt out of managing Nix.
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

    # herdr — agent-aware terminal multiplexer (not in our pinned nixpkgs yet).
    # Pinned by tag; bump the tag to update. Deliberately does NOT follow our
    # nixpkgs: herdr pins a newer nixpkgs + rust-overlay to build against.
    herdr = {
      url = "github:herdrdev/herdr/v0.8.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      determinate,
      treefmt-nix,
      stylix,
      nix-cachyos-kernel,
      dms,
      catppuccin,
      spicetify-nix,
      zen-browser,
      nix-index-database,
      herdr,
      ...
    }@inputs:
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
        workstation = {
          isWork = false;
        };
        # Keyed by hostname so `nh darwin switch` / `darwin-rebuild` need no
        # -H flag, matching how workstation already works.
        richie-mpb = {
          isWork = false;
        };
      };

      userConfigFor = host: baseUserConfig // hostConfigs.${host};

      # NixOS-specific pkgs. Used only by treefmt below -- the workstation builds
      # its own pkgs through the module system (see hosts/workstation), so that
      # nixpkgs.config and nixpkgs.overlays actually take effect there.
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

      treefmtFor = pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      treefmtDarwin = treefmtFor darwinPkgs;
      treefmtLinux = treefmtFor linuxPkgs;

    in
    {
      # `nix fmt`
      formatter = {
        aarch64-darwin = treefmtDarwin.config.build.wrapper;
        x86_64-linux = treefmtLinux.config.build.wrapper;
      };

      # Checks.
      #
      #   nix flake check                 # this system only
      #   nix flake check --all-systems   # both hosts (see below)
      #
      # The x86_64-linux entries cannot be *built* on macOS, but --all-systems
      # still evaluates them, which is what catches option typos, renamed
      # attributes and conflicting definitions in the shared home/ modules.
      # That is exactly the class of bug that reached master unnoticed before
      # the workstation config became evaluable.
      checks = {
        aarch64-darwin = {
          formatting = treefmtDarwin.config.build.check self;
          # Covers Home Manager too: it runs as a nix-darwin module.
          darwin-system = self.darwinConfigurations.richie-mpb.system;
        };
        x86_64-linux = {
          formatting = treefmtLinux.config.build.check self;
          # Evaluable from macOS since Stylix replaced catppuccin-nix, which used
          # import-from-derivation and would have required building Linux
          # derivations mid-evaluation.
          workstation = self.nixosConfigurations.workstation.config.system.build.toplevel;
        };
      };

      # NixOS (integrated Home Manager)
      #
      # No `system` and no `pkgs` here on purpose: both are set through the
      # module system in hosts/workstation (nixpkgs.hostPlatform, nixpkgs.config,
      # nixpkgs.overlays). Handing nixosSystem a pre-built pkgs via specialArgs
      # silently disables those options, so an overlay added in a module would
      # have been discarded with no error.
      nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          userConfig = userConfigFor "workstation";
        };
        modules = [
          ./hosts/workstation

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              userConfig = userConfigFor "workstation";
              isNixOS = true;
            };
            home-manager.users.${username} = import ./home;
          }
        ];
      };

      # macOS (nix-darwin with Home Manager as a module)
      darwinConfigurations.richie-mpb = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs;
          userConfig = userConfigFor "richie-mpb";
        };
        modules = [
          ./hosts/richie-mpb

          inputs.determinate.darwinModules.default

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Standalone HM already owns some of these paths; back them up rather
            # than failing activation (cf. the lazygit config clobber).
            home-manager.backupFileExtension = "bak";
            home-manager.extraSpecialArgs = {
              inherit inputs;
              userConfig = userConfigFor "richie-mpb";
              isNixOS = false;
            };
            home-manager.users.${username} = import ./home;
          }
        ];
      };
    };
}
