{ pkgs, ...}: {

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

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    git
    kitty

    fish
    neovim
    just # use justfile to simplify nix-darwin's commands
    lsd
    bat
    starship
    # archives
    zip
    xz
    unzip
    p7zip

    gh
    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder
    lsd
    bat
    btop
    thefuck

    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    caddy
    gnupg

    # productivity
    glow # markdown previewer in terminal
    yazi
    dotnet-sdk
    nh
    m-cli
    coreutils
    # asciicam # Terminal webcam
    # asciinema-agg # Convert asciinema to .gif
    # asciinema # Terminal recorder
    bc # Terminal calculator
    # bandwhich # Modern Unix `iftop`
    # bmon # Modern Unix `iftop`
    # breezy # Terminal bzr client
    # #butler # Terminal Itch.io API client
    # chafa # Terminal image viewer
    # chroma # Code syntax highlighter
    # clinfo # Terminal OpenCL info
    # cpufetch # Terminal CPU info
    # croc # Terminal file transfer
    # curlie # Terminal HTTP client
    cyme # Modern Unix `lsusb`
    # dconf2nix # Nix code from Dconf files
    # deadnix # Nix dead code finder
    # difftastic # Modern Unix `diff`
    # dogdns # Modern Unix `dig`
    # dotacat # Modern Unix lolcat
    dua # Modern Unix `du`
    duf # Modern Unix `df`
    du-dust # Modern Unix `du`
    # editorconfig-core-c # EditorConfig Core
    # entr # Modern Unix `watch`
    fastfetch # Modern Unix system info
    fd # Modern Unix `find`
    file # Terminal file info
    # frogmouth # Terminal mardown viewer
    # glow # Terminal Markdown renderer
    # girouette # Modern Unix weather
    # gocryptfs # Terminal encrypted filesystem
    gping # Modern Unix `ping`
    # git-igitt # Modern Unix git log/graph
    # h # Modern Unix autojump for git projects
    # hexyl # Modern Unix `hexedit`
    # hr # Terminal horizontal rule
    # httpie # Terminal HTTP client
    # hueadm # Terminal Philips Hue client
    # hyperfine # Terminal benchmarking
    # iperf3 # Terminal network benchmarking
    # ipfetch # Terminal IP info
    # jpegoptim # Terminal JPEG optimizer
    jiq # Modern Unix `jq`
    # lastpass-cli # Terminal LastPass client
    # lima-bin # Terminal VM manager
    # marp-cli # Terminal Markdown presenter
    # mtr # Modern Unix `traceroute`
    # neo-cowsay # Terminal ASCII cows
    # netdiscover # Modern Unix `arp`
    nixfmt-rfc-style # Nix code formatter
    nixpkgs-review # Nix code review
    nix-prefetch-scripts # Nix code fetcher
    nurl # Nix URL fetcher
    # nyancat # Terminal rainbow spewing feline
    onefetch # Terminal git project info
    # optipng # Terminal PNG optimizer
    # procs # Modern Unix `ps`
    # quilt # Terminal patch manager
    # rclone # Modern Unix `rsync`
    # rsync # Traditional `rsync`
    sd # Modern Unix `sed`
    # speedtest-go # Terminal speedtest.net
    # terminal-parrot # Terminal ASCII parrot
    # timer # Terminal timer
    tldr # Modern Unix `man`
    tokei # Modern Unix `wc` for code
    # tty-clock # Terminal clock
    # ueberzugpp # Terminal image viewer integration
    # unzip # Terminal ZIP extractor
    # upterm # Terminal sharing
    # wget # Terminal HTTP client
    # wget2 # Terminal HTTP client
    # wormhole-william # Terminal file transfer
    # yq-go # Terminal `jq` for YAML
     "aria2"
 "icu4c@76"
 "bat"
 "chezmoi"
 "curl"
 "dash"
 "dockutil"
 "docutils"
 "fd"
 "gnutls"
 "librist"
 "ffmpeg"
 "fzf"
 "gh"
 "lsd"
 "lua"
 "neovim"
 "nginx"
 "node"
 "nvm"
 "prettyping"
 "pyenv"
 "python@3.11"
 "ripgrep"
 "ruby"
 "rustup"
 "starship"
 "thefuck"
 "websocat"
  ];

  # TODO To make this work, homebrew need to be installed manually, see https://brew.sh
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      # cleanup = "zap";
    };

    taps = [
      "homebrew/services"
    ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    brews = [
      # "aria2"  # download tool
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      # "google-chrome"
"another-redis-desktop-manager"
"baidunetdisk"
 "dbeaver-community"
"docker"
 "dotnet-sdk"
 "double-commander"
 "firefox"
 "free-download-manager"
 "go2shell"
 "iina"
 "listen1"
 "macfuse"
 "microsoft-edge"
 "navicat-premium-lite"
 "obsidian"
 "onedrive"
 "openmtp"
 "postman"
 "qbittorrent"
 "reqable"
 "rider"
 "snipaste"
 "squirrel"
 "tableplus"
 "telegram-desktop"
 "visual-studio-code"
 "wechatwebdevtools"
 "wezterm"
    ];
  };
}
