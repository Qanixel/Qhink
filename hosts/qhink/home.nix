{ inputs, ... }:

{
  imports = [
    ../../modules/home/core/zsh.nix
    ../../modules/home/core/xdg.nix
    ../../modules/home/core/packages.nix
    ../../modules/home/core/nixd.nix
    

    ../../modules/home/apps/ghostty.nix
    ../../modules/home/apps/vscode.nix
    ../../modules/home/apps/git.nix
    ../../modules/home/apps/dolphin.nix
    ../../modules/home/apps/base.nix
    ../../modules/home/apps/editor.nix
    ../../modules/home/apps/zed.nix

    ../../modules/home/desktop/waybar.nix
    ../../modules/home/desktop/mako.nix
    ../../modules/home/desktop/fuzzel.nix
  ];

  home = {
    username = "qanix";
    homeDirectory = "/home/qanix";
    stateVersion = "25.05";
    sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
      PAGER = "less";
      HISTFILE = "$HOME/.zsh_history";
    };
  };

  programs.home-manager.enable = true;
}
