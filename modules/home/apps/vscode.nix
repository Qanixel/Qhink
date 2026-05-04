{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    extensions = with pkgs.vscode-extensions; [

      ms-ceintl.vscode-language-pack-zh-hans
      
      # 语言基础
      ms-ceintl.vscode-language-pack-zh-hans
      jnoortheen.nix-ide
      
      # 前端与格式化
      bradlc.vscode-tailwindcss
      esbenp.prettier-vscode
      
      # Git 与工具
      eamodio.gitlens
      mhutchie.git-graph
      ms-vscode-remote.remote-ssh
      ms-azuretools.vscode-docker
      usernamehw.errorlens
      gruntfuggly.todo-tree
      
      # UI 与主题
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
    ];

    userSettings = {
      # 界面语言
      "locale" = "zh-cn";
      
      # 主题与外观
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "catppuccin-mocha";
      "editor.fontFamily" = "'Maple Mono CN', 'Noto Sans CJK SC', monospace";
      "editor.fontSize" = 14;
      "editor.lineHeight" = 1.6;
      "editor.fontLigatures" = true;
      "window.titleBarStyle" = "custom";
      
      # 编辑器行为
      "editor.formatOnSave" = true;
      "editor.bracketPairColorization.enabled" = true; # 社区推荐：原生括号着色
      "editor.guides.bracketPairs" = "active";
      "editor.minimap.enabled" = false; # 现代极简风格通常关闭缩略图
      
      # 针对不同语言的格式化器优化
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      
      # Nix IDE 特定配置 (推荐配合 nixd 或 nil 使用)
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd"; # 或 "nil"s
            
      # 新增以下部分来修复错误：
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = [ "nixpkgs-fmt" ]; # 或者 "nixfmt"
            };
          };
      };

      # 终端
      "terminal.external.linuxExec" = "ghostty";
      "terminal.integrated.fontFamily" = "Maple Mono CN";
      "terminal.integrated.cursorStyle" = "line";
      
    };
  };
}