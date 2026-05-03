{ pkgs, lib, ... }:

{
  home.packages = [ pkgs.zed-editor ];

  # Zed 的配置文件通常位于 ~/.config/zed/settings.json
  # 我们通过 Nix 强制生成它
  xdg.configFile."zed/settings.json".text = builtins.toJSON {
    "theme" = "Catppuccin Mocha";
    "ui_font_size" = 16;
    "buffer_font_family" = "Maple Mono NF";
    "buffer_font_size" = 14;
    "terminal" = {
      "font_family" = "Maple Mono NF";
      "copy_on_select" = true;
    };
    "format_on_save" = "on";
    "languages" = {
      "Nix" = {
        "language_servers" = [ "nixd" "..." ];
      };
    };
    # 开启 Vim 模式 (如果你习惯的话)
    "vim_mode" = true;
  };
}