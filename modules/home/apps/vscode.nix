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
      # 1. 语言设置
      "locale" = "zh-cn";

      # 2. 界面与主题
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "catppuccin-vsc-icons";
      "editor.semanticHighlighting.enabled" = true;
      "workbench.settings.useSplitJSON" = true;
      "files.autoSave" = "onFocusChange";
      "editor.fontSize" = 14;
      "editor.tabSize" = 2;
      "editor.renderWhitespace" = "all"; # 显示空格，避免混用空格和制表符
      "editor.wordWrap" = "on"; # 自动换行，不用左右滚动屏幕
      "editor.formatOnSave" = true;

      # --- 视觉美化 ---
      "editor.cursorBlinking" = "expand"; # 很有质感的光标闪烁方式
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = "active";
      "editor.smoothScrolling" = true;
      "workbench.list.smoothScrolling" = true;
      "terminal.integrated.smoothScrolling" = true;

      # 3. Nix IDE & nixd 核心增强
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {"command" = ["alejandra"];};
          # 2026 推荐配置：让 nixd 能够实时显示 nixpkgs 的文档和选项
          "options" = {
            "nixos" = {
              "expr" = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.qhink.options";
            };
            "home-manager" = {
              "expr" = "(builtins.getFlake \"/path/to/your/flake\").homeConfigurations.qanix.options";
            };
          };
        };
      };

      # 4. 针对 Nix 文件的行为
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
        "editor.formatOnSave" = true;
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
        "editor.semanticHighlighting.enabled" = true;
      };
    };
  };
}
