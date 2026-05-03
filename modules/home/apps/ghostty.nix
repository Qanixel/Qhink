{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    
    # 启用集成，这会让 Ghostty 在 shell 环境中表现更好
    enableBashIntegration = true;
    enableZshIntegration = true;

    # 所有的配置项都写在 settings 里面
    settings = {
      # --- 外观与主题 ---
      theme = "catppuccin-mocha"; # 保持与 VSCode 主题一致
      background-opacity = 0.9;
      background-blur-radius = 20;
      window-decoration = false; # 如果你配合 Niri 使用，通常可以关掉边框

      # --- 字体配置 ---
      # 引用你喜欢的 Maple Mono
      font-family = "Maple Mono NF";
      font-size = 13;
      font-feature = [ "ss01" "ss02" "ss03" "cv01" ]; # 开启 Maple Mono 的特殊字形特性
      font-thicken = true; # 让字体看起来更扎实一点

      # --- 鼠标与光标 ---
      cursor-style = "ibeam";
      cursor-blink = true;
      mouse-hide-while-typing = true;

      # --- 性能优化 (非常适合 4060 Ti 的环境) ---
      # Ghostty 默认支持硬件加速，但可以微调渲染行为
      fps-limit = 60; # 如果你的显示器是高刷，记得调整这个数值
      render-relative = "buffer-only";

      # --- 实用功能 ---
      confirm-close-surface = false; # 关闭窗口时不弹出确认框
      copy-on-select = true;         # 选中即复制
      
      # --- 快捷键映射 ---
      # 可以根据你的 macOS 习惯或 Niri 习惯进行调整
      keybind = [
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
        "alt+one=goto_tab:1"
        "alt+two=goto_tab:2"
        "alt+three=goto_tab:3"
      ];
    };
  };
}