{ pkgs, lib, config, ... }:
{
  home.sessionVariables = {
    EDITOR = "nvim";
    DOTNET_ROOT = "$HOME/.dotnet";
  };

  home.extraProfileCommands = ''
    # Source secrets from sops
    if [ -f "${config.sops.secrets.google_env.path}" ]; then
      source "${config.sops.secrets.google_env.path}"
    fi
  '';

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$HOME/.dotnet"
    "$HOME/.dotnet/tools"
    "/usr/local/sbin"
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      nix-your-shell zsh | source /dev/stdin

      # proxy
      proxy () {
         export http_proxy="http://127.0.0.1:7890"
         export https_proxy=$http_proxy
         export socks5_proxy="socks5://127.0.0.1.1:7890"
         echo "HTTP Proxy on"
      }

      # noproxy
      noproxy () {
        unset http_proxy
        unset https_proxy
        echo "HTTP Proxy off"
      }

      function run_diso {
        sh -c "$@" &
        disown
      }

      function pbcopydir {
        pwd | tr -d "\r\n" | pbcopy
      }

      function from-where {
          echo $^fpath/$_comps[$1](N)
          whence -v $_comps[$1]
          which $_comps[$1] 2>&1 | head
      }

    '';
  };
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        nix-your-shell fish | source

        # 设置代理
        function proxy
          set -gx http_proxy "http://127.0.0.1:7890"
          set -gx https_proxy $http_proxy
          set -gx socks5_proxy "socks5://127.0.0.1:7890"
          echo "HTTP Proxy on"
        end

        # 取消代理
        function noproxy
          set -e http_proxy
          set -e https_proxy
          set -e socks5_proxy
          echo "HTTP Proxy off"
        end

        # 复制当前路径
        function pbcopydir
          pwd | tr -d "\r\n" | pbcopy
        end
      '';
    };

  home.shellAliases = {
    # ==== Aliases ====

    # chezmoi
    cm = "chezmoi";
    cme = "cm edit";

    cat = "bat";
    #    preview="fzf --preview "bat --color \"always\" {}"";
    # 支持在 VS Code 里用 ctrl + o 来打开选择的文件
    #export FZF_DEFAULT_OPTS="--bind=\"ctrl-o:execute(code {})+abort\""
    # --color dark 使用颜色方案
    # -rr 只读模式（防止误删和运行新的 shell 程序）
    # --exclude 忽略不想操作的目录
    help = "tldr";

    # Edit shortcuts for config files
    sshconfig = "${"EDITOR:-vim"} ~/.ssh/config";
    zshrc = "${"EDITOR:-vim"} ~/.zshrc && source ~/.zshrc && echo Zsh config edited and reloaded.";

    # SSH helper
    sshclear = "rm ~/.ssh/multiplex/* -f && echo SSH connection cache cleared;";
    sshlist = "echo Currently open ssh connections && echo && l ~/.ssh/multiplex/";

    c = "clear";
    h = "history";

    # Date and Time
    d = "date +%F";
    now = "date +%T";
    nowtime = "now";
    nowdate = "date + '%m-%d-%Y'";

    snv = "sudo nvim";

    # Show open ports
    ports = "netstat -tulanp";

    # Prettify the Output of Various Commands
    dfc = "df -hP | column -t";
    mount = "mount | column -t";

    # lsd
    #ls = "lsd";
    #l = "ls -l";
    #la = "ls -a";
    #lla = "ls -la";
    #lt = "ls --tree";

    gz = "tar -xzvf";
    tgz = "tar -xzvf";
    zip = "unzip";
    bz2 = "tar -xjvf";
    xz = "tar -xzJf";

    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
  };
}
