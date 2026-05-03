{ ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      font-family          = "Maple Mono NF";
      font-size            = 14;
      font-family-fallback = "Noto Sans CJK SC";
      theme                = "catppuccin-mocha";
      background-opacity   = 0.92;
      window-padding-x     = 8;
      window-padding-y     = 8;
      window-decoration    = "client";
      gtk-adwaita          = false;
      cursor-style         = "block";
      cursor-blink         = false;
      shell-integration    = "zsh";
    };
  };
}
