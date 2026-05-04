{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      # 符号与图标
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      noto-fonts-color-emoji

      # 英文与通用
      inter
      noto-fonts

      # 中日韩
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      # 编程字体
      maple-mono.CN
      maple-mono.NF
    ];

    fontconfig = {
      enable = true;

      # 使用 NixOS 原生选项配置渲染，替代冗长的 XML
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };

      defaultFonts = {
        monospace = [
          "Maple Mono NF"
          "Noto Sans Mono CJK SC"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Inter"
          "Noto Sans CJK SC"
          "Noto Sans"
          "Noto Color Emoji"
        ];
        serif = [
          "Noto Serif CJK SC"
          "Noto Serif"
          "Noto Color Emoji"
        ];
        emoji = [ "Noto Color Emoji" ];
      };

      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <!-- 强制中文环境下使用 Maple Mono 的等宽特性 -->
          <match target="pattern">
            <test name="lang" compare="contains"><string>zh</string></test>
            <test name="spacing" compare="eq"><int>100</int></test>
            <edit name="family" mode="prepend" binding="strong"><string>Maple Mono NF</string></edit>
          </match>
          <match target="pattern">
            <test name="lang" compare="contains"><string>zh-CN</string></test>
            <test name="family" compare="eq"><string>sans-serif</string></test>
            <edit name="family" mode="prepend" binding="strong"><string>Noto Sans CJK SC</string></edit>
          </match>
          <match target="pattern">
            <test name="lang" compare="contains"><string>ja</string></test>
            <test name="family" compare="eq"><string>sans-serif</string></test>
            <edit name="family" mode="prepend" binding="strong"><string>Noto Sans CJK JP</string></edit>
          </match>
          <match target="pattern">
            <test name="lang" compare="contains"><string>ko</string></test>
            <test name="family" compare="eq"><string>sans-serif</string></test>
            <edit name="family" mode="prepend" binding="strong"><string>Noto Sans CJK KR</string></edit>
          </match>
          
          <!-- 禁用位图字体以防止锯齿 -->
          <selectfont>
            <rejectfont><pattern><patelt name="scalable"><bool>false</bool></patelt></pattern></rejectfont>
          </selectfont>
        </fontconfig>
      '';
    };
  };
}
