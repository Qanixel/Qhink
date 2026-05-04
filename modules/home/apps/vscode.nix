{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    extensions = with pkgs.vscode-extensions; [
      ms-ceintl.vscode-language-pack-zh-hans

      # 语言基础
      jnoortheen.nix-ide
      christian-kohler.path-intellisense

      gruntfuggly.todo-tree
      usernamehw.errorlens
      w88975.code-translate

      # Git 与工具
      eamodio.gitlens
      mhutchie.git-graph
      ms-vscode-remote.remote-ssh

      # UI 与主题
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      pkief.material-icon-theme
    ];

    userSettings = {
      "locale" = "zh-cn";
      "editor.formatOnSave" = true;
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "catppuccin-vsc-icons"; # 显式启用图标主题

      # Nix IDE 核心配置
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";

      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {"command" = ["alejandra"];};
        };
      };

      # 针对 Nix 文件的默认格式化器
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
        "editor.formatOnSave" = true;
      };

      "workbench.settings.useSplitJSON" = true;
      "editor.semanticHighlighting.enabled" = true;
    };
  };
}
