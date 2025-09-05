{
  inputs,
  # nixGL,
  outputs,
  ...
}:
{
  # Helper function for generating home-manager configs
  mkHome =
    {
      hostname,
      username ? "molisiye",
      desktop ? null,
      system ? "x86_64-darwin",
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit
          inputs
          outputs
          desktop
          hostname
          system
          username
          # nixGL
          ;
      };
      modules = [
        ../home
      ];
    };

  # Helper function for generating NixOS configs
  # mkNixos =
  #   {
  #     hostname,
  #     username ? "martin",
  #     desktop ? null,
  #     system ? "x86_64-linux",
  #   }:
  # let
  #   isISO = builtins.substring 0 4 hostname == "iso-";
  #   isInstall = !isISO;
  #   isLaptop = hostname != "vader" && hostname != "phasma" && hostname != "revan" && hostname != "malak" && hostname != "maul";
  #   isWorkstation = builtins.isString desktop;
  #   tailNet = "drongo-gamma.ts.net";
  # in
  # inputs.nixpkgs.lib.nixosSystem {
  #   specialArgs = {
  #     inherit
  #       inputs
  #       outputs
  #       desktop
  #       hostname
  #       system
  #       username
  #       stateVersion
  #       isInstall
  #       isISO
  #       isLaptop
  #       isWorkstation
  #       tailNet
  #       ;
  #   };
  #   # If the hostname starts with "iso-", generate an ISO image
  #   modules =
  #     let
  #       cd-dvd =
  #         if (desktop == null) then
  #           inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  #         else
  #           inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix";
  #     in
  #     [ ../nixos ] ++ inputs.nixpkgs.lib.optionals isISO [ cd-dvd ];
  # };

  mkDarwin =
    {
      desktop ? "aqua",
      hostname,
      username ? "molisiye",
      system ? "x86_64-darwin",
    }:
    inputs.darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          outputs
          desktop
          hostname
          username
          ;
      };
      modules = [
        ../darwin
      ];
    };

  forAllSystems = inputs.nixpkgs.lib.genAttrs [
    "x86_64-linux"
    "x86_64-darwin"
  ];
}
