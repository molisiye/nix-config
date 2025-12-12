{
  inputs,
  lib,
  username,
  ...
}:
let
  # Homebrew Mirror
  homebrew_mirror_env = {
    HOMEBREW_API_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
    HOMEBREW_BOTTLE_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles";
    HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
    HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
    HOMEBREW_PIP_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple";
  };
in
{

  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  # Set variables for you to manually install homebrew packages.
  environment.variables = homebrew_mirror_env;

  # Set environment variables for nix-darwin before run `brew bundle`.
  system.activationScripts.homebrew.text =
    let
      env_script = lib.attrsets.foldlAttrs (
        acc: name: value:
        acc + "\nexport ${name}=${value}"
      ) "" homebrew_mirror_env;
    in
    lib.mkBefore ''
      echo >&2 '${env_script}'
      ${env_script}
    '';

  nix-homebrew = {
    enable = true;
    user = username;
    autoMigrate = true;
  };

  # TODO To make this work, homebrew need to be installed manually, see https://brew.sh
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = false; # Upgrade outdated casks, formulae, and App Store app
      # 'zap': uninstalls all formulae(and related files) not listed here.
      cleanup = "zap";
    };

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
    masApps = {
      # TODO Feel free to add your favorite apps here.

      # Xcode = 497799835;
      # Wechat = 836500024;
      # QQ = 451108668;
    };

    # taps = [
    # ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    brews = [
      # "aria2"  # download tool
      "icu4c@76"
      "mas"
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      "clash-party"
      "another-redis-desktop-manager"
      "baidunetdisk"
      "dbeaver-community"
      "firefox"
      "free-download-manager"
      "iina"
      "listen1"
      "macfuse"
      "microsoft-edge"
      "obsidian"
      "openmtp"
      "postman"
      "qbittorrent"
      "reqable"
      "rider"
      "snipaste"
      "squirrel-app"
      "tableplus"
      "telegram-desktop"
      "visual-studio-code"
      "wechatwebdevtools"
      "wezterm"
      "hammerspoon"
      "the-unarchiver"
    ];
  };
}
