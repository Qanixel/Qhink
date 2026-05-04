{inputs, ...}: {
  imports = [
    ../../modules/home
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

  manual.manpages.enable = false;
}
