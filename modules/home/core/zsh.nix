{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      share = true;
      extended = true;
    };

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
        "sudo"
        "docker"
        "docker-compose"
        "npm"
        "python"
        "systemd"
        "history"
        "colored-man-pages"
        "extract"
        "fzf"
        "zoxide"
      ];
    };

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
    ];

    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake .#qhink";
      nrt = "sudo nixos-rebuild test --flake .#qhink";
      nrb = "sudo nixos-rebuild boot --flake .#qhink";
      nfu = "nix flake update";
      ngc = "sudo nix-collect-garbage -d";
      nse = "nix search nixpkgs";
      v = "hx";
      vi = "hx";
    };

    initContent = ''
      eval "$(zoxide init zsh)"
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
      export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded"
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      if [[ -o interactive ]]; then
        echo "🚀 欢迎回来，qanix！ NixOS on qhink"
        echo "📅 $(date '+%Y年%m月%d日 %H:%M')"
      fi
    '';
  };
}
