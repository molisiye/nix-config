{ config,inputs, username, ... }:

{
  # import sub modules
  imports = [
        inputs.catppuccin.homeModules.catppuccin
    ./core.nix
    ./shell.nix
    ./kitty.nix
    ./git.nix
    ./starship.nix
  ];

    # Enable the Catppuccin theme
  catppuccin = {
    accent = "blue";
    flavor = "mocha";
    bat.enable = config.programs.bat.enable;
    bottom.enable = config.programs.bottom.enable;
    btop.enable = config.programs.btop.enable;
    cava.enable = config.programs.cava.enable;
    fish.enable = config.programs.fish.enable;
    fzf.enable = config.programs.fzf.enable;
    starship.enable = config.programs.starship.enable;
    yazi.enable = config.programs.yazi.enable;
    kitty.enable = config.programs.kitty.enable;
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = username;
    homeDirectory = "/Users/${username}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
