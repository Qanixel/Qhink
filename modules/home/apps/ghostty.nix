{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;

    # 配置选项 (对应 ghostty 的 config 文件格式)
    settings = {
      # 字体配置 (对应你 VS Code 的 Maple Mono)
      font-family = "Maple Mono CN";
      font-size = 14;
      
      # # 主题 (Ghostty 内置支持很多主题，包括 Catppuccin)
      # theme = "catppuccin-mocha";
      
      # 窗口样式
      window-decoration = true; # 配合你 VS Code 的极简风格
      window-padding-x = 10;
      window-padding-y = 10;
      
      # 光标
      cursor-style = "block";
      cursor-style-blink = true; # 开启光标闪烁，更有灵动感
      
      # 背景透明度 (可选)
      # window-background-opacity = 0.9;
      # window-background-blur = true;
    };
  };
}
