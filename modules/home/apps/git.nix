{...}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "qanix";
        email = "qanix@qhink.local";
      };
      core = {
        editor = "hx";
        pager = "delta";
        autocrlf = "input";
      };
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
