{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
  # 暂时不使用 nixGlWrap，使用的时候将如下例子加入 packages即可：(nixGlWrap calibre)
  # nixGlWrap = lib.nixGL.wrap;
in
{
  home.packages =
    with pkgs;
    [
      # archives
      zip
      xz
      p7zip

      # ai
      gemini-cli

      # language-server
      nil

      # VM
      #lima

      # nix fmt
      alejandra

      # utils
      ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      yq-go # yaml processer https://github.com/mikefarah/yq
      fzf # A command-line fuzzy finder
      aria2 # A lightweight multi-protocol & multi-source command-line download utility
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing

      # misc
      cowsay
      which
      tree
      gnused
      gnutar
      zstd
      caddy
      gnupg

      # productivity

      fish
      # just # use justfile to simplify nix-darwin's commands
      lsd
      bat
      starship
      # archives

      gh
      # utils
      btop
      thefuck

      #aria2 # A lightweight multi-protocol & multi-source command-line download utility

      # productivity
      yazi
      dotnet-sdk
      nh
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
      chezmoi
      curl
      dash
      docutils
      fd
      gnutls
      librist
      ffmpeg
      lua
      nginx
      #node
      #nvm
      prettyping
      pyenv
      python3
      ruby
      rustup
      websocat
      nix-your-shell
    ]
    ++ lib.optionals isLinux [

    ]
    ++ lib.optionals isDarwin [
      m-cli
      coreutils
      dockutil
    ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    atuin = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      flags = [ "--disable-up-arrow" ];
      package = pkgs.atuin;
      settings = {
        auto_sync = true;
        dialect = "uk";
        show_preview = true;
        style = "compact";
        sync_frequency = "1h";
        sync_address = "https://api.atuin.sh";
        update_check = false;
      };
    };
    # modern vim
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };

    # A modern replacement for ‘ls’
    # useful in bash/zsh prompt, not in nushell.
    #    eza = {
    # enable = true;
    # git = true;
    # icons = "auto";
    #  enableZshIntegration = true;
    # };
    lsd = {
      enable = true;
      enableZshIntegration = true;
    };
    bat = {
      enable = true;
    };
    z-lua = {
      enable = true;
      enableZshIntegration = true;
      enableAliases = true;
    };

    # terminal file manager
    yazi = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        manager = {
          show_hidden = true;
          sort_dir_first = true;
        };
      };
    };

    # skim provides a single executable: sk.
    # Basically anywhere you would want to use grep, try sk instead.
    skim = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
