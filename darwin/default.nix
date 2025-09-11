{
  pkgs,
  username,
  ...
}:
{
  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  # TODO Fell free to modify this file to fit your needs.
  #
  ##########################################################################
  imports = [
    ./nix-core.nix
    ./system.nix
    ./host-users.nix
    ./homebrew.nix
  ];

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    neovim
    git
    just
  ];
  environment.shells = [
    pkgs.zsh
    pkgs.fish
  ];

    users.users.${username}.shell = pkgs.fish;
    programs.fish.enable = true;
}
