{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      ms-python.python
      ms-python.vscode-pylance
      rust-lang.rust-analyzer
      jnoortheen.nix-ide
      bradlc.vscode-tailwindcss
      esbenp.prettier-vscode
      eamodio.gitlens
      mhutchie.git-graph
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      ms-vscode-remote.remote-ssh
      ms-azuretools.vscode-docker
      usernamehw.errorlens
      gruntfuggly.todo-tree
    ];
    userSettings = {
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "catppuccin-mocha";
      "editor.fontFamily" = "'Maple Mono NF', 'Noto Sans CJK SC', monospace";
      "editor.fontSize" = 14;
      "editor.lineHeight" = 1.6;
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "terminal.external.linuxExec" = "ghostty";
      "terminal.integrated.fontFamily" = "Maple Mono NF";
      "window.titleBarStyle" = "custom";
    };
  };
}
