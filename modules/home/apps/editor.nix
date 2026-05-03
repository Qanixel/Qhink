{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    
    settings = {
      theme = "catppuccin_mocha"; # 保持与 VSCode 和 Ghostty 一致
      editor = {
        line-number = "relative"; # 相对行号，方便 Vim 式跳转
        cursorline = true;
        color-modes = true; # 进入不同模式时显示不同颜色
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
        lsp.display-messages = true;
      };
      keys.normal = {
        "space"."f" = "file_picker"; # 类似 VSCode 的 Ctrl+P
        "space"."w" = ":w";         # 快速保存
      };
    };
    
    # 语言服务器配置
    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = { command = "alejandra"; };
          language-servers = [ "nixd" ];
        }
      ];
    };
  };
}