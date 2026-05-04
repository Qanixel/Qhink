{pkgs, ...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Maple Mono NF:size=13";
        icon-theme = "Papirus";
        terminal = "ghostty -e";
        width = 50;
        lines = 10;
        horizontal-pad = 20;
        vertical-pad = 12;
        inner-pad = 4;
      };
      colors = {
        background = "1e1e2eee";
        text = "cdd6f4ff";
        selection = "313244ff";
        selection-text = "89b4faff";
        border = "89b4faff";
        match = "89b4faff";
      };
      border = {
        width = 2;
        radius = 10;
      };
    };
  };
}
