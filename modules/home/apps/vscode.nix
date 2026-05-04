{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    extensions = with pkgs.vscode-extensions; [

      ms-ceintl.vscode-language-pack-zh-hans
      
      # 语言基础
      jnoortheen.nix-ide
      
      # Git 与工具
      eamodio.gitlens
      mhutchie.git-graph
      ms-vscode-remote.remote-ssh
      usernamehw.errorlens
      gruntfuggly.todo-tree
      
      # UI 与主题
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
    ];

    userSettings = {
      "locale" = "zh-cn";
      
      # Nix IDE 核心配置
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {
            "command" = [ "alejandra" ]; # 改用你在 nixd.nix 中安装的 alejandra
          };
          "options" = {
            "nixos" = {
              "expr" = "import <nixpkgs/nixos> { }";
            };
            "home-manager" = {
              "expr" = "import <home-manager/modules> { }";
            };
          };
        };
      };

      # 针对 Nix 文件的默认格式化器
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
        "editor.formatOnSave" = true;
      };
    };
  };
}