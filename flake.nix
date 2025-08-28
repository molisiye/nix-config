{
  description = "molisiye's Nix for macOS configuration";

  ##################################################################################################################
  #
  # Want to know Nix in details? Looking for a beginner-friendly tutorial?
  # Check out https://github.com/ryan4yin/nixos-and-flakes-book !
  #
  ##################################################################################################################

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    substituters = [
      # Query the mirror of USTC first, and then the official cache.
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nix-your-shell = {
      url = "github:MercuryTechnologies/nix-your-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-darwin,
      darwin,
      home-manager,
      nix-homebrew,
      nixGL,
      sops-nix,
      ...
    }:
    let
      inherit (self) outputs;
      # TODO replace with your own username, system and hostname
      username = "molisiye";
      system = "x86_64-darwin"; # aarch64-darwin or x86_64-darwin
      hostname = "zhm-mbp2017";
      helper = import ./lib { inherit inputs outputs nixGL; };

      specialArgs = inputs // {
        inherit username hostname;
        # useremail will be managed by sops
      };

      allSystemNames = [
        "x86_64-darwin"
        "x86_64-linux"
      ];
      # Helper function to generate a set of attributes for each system
      forAllSystems = func: (nixpkgs-darwin.lib.genAttrs allSystemNames func);
    in
    {
      # home-manager build --flake $HOME/Zero/nix-config -L
      # home-manager switch -b backup --flake $HOME/Zero/nix-config
      # nix run nixpkgs#home-manager -- switch -b backup --flake "${HOME}/Zero/nix-config"
      # homeConfigurations = let
      #   # system = "x86_64-linux";
      #   pkgs = import nixpkgs {
      #     inherit system;
      #     config.allowUnfree = true;
      #   };
      # in {
      #   "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
      #     extraSpecialArgs = {
      #       inherit inputs username;
      #     };
      #     pkgs = inputs.nixpkgs-darwin.legacyPackages.${system};
      #     modules = [./home];
      #   };
      #
      #   "molisiye@arch-home" = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     extraSpecialArgs = {inherit inputs username;};
      #     # pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      #     modules = [
      #       ./home
      #       {
      #         nixGL = {
      #           packages = nixGL.packages;
      #           installScripts = ["mesa"];
      #         };
      #       }
      #     ];
      #   };

      homeConfigurations = {
        "molisiye@zhm-mbp2017" = helper.mkHome {
          hostname = "zhm-mbp2017";
          username = "molisiye";
        };

        "molisiye@arch-home" = helper.mkHome {
          hostname = "arch-home";
          username = "molisiye";
        };
      };
      darwinConfigurations."${hostname}" = darwin.lib.darwinSystem {
        inherit system specialArgs;
        modules = [
          sops-nix.darwinModules.sops
          ./darwin/nix-core.nix
          ./darwin/system.nix
          ./darwin/apps.nix
          ./darwin/homebrew.nix
          ./darwin/homebrew-mirror.nix # comment this line if you don't need a homebrew mirror
          ./darwin/host-users.nix
        ];
      };

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs-darwin.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              bc
              git
              just
              pkgs.home-manager
              micro
              nh
              nixpkgs-fmt
              nil
              nix-output-monitor
              nvd
              tree
            ];
          };
        }
      );

      # nix code formatter
      formatter.${system} = nixpkgs-darwin.legacyPackages.${system}.alejandra;
    };
}
