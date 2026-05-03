{ ... }:

{
  programs.git = {
    enable = true;
    userName = "qanix";
    userEmail = "qanix@qhink.local";
    extraConfig = {
      core = { editor = "hx"; pager = "delta"; autocrlf = "input"; };
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      delta = {
        enable = true;
        navigate = true;
        line-numbers = true;
        syntax-theme = "Catppuccin Mocha";
      };
    };
  };
}
