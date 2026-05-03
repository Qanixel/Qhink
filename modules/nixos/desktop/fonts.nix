{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      maple-mono.CN
      maple-mono.NF
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      inter
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace  = [ "Maple Mono NF" "Noto Sans Mono CJK SC" ];
        sansSerif  = [ "Inter" "Noto Sans CJK SC" "Noto Sans" ];
        serif      = [ "Noto Serif CJK SC" "Noto Serif" ];
        emoji      = [ "Noto Color Emoji" ];
      };

      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
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
          <selectfont>
            <rejectfont><pattern><patelt name="scalable"><bool>false</bool></patelt></pattern></rejectfont>
          </selectfont>
          <match target="font">
            <edit name="antialias" mode="assign"><bool>true</bool></edit>
            <edit name="hinting" mode="assign"><bool>true</bool></edit>
            <edit name="hintstyle" mode="assign"><const>hintslight</const></edit>
            <edit name="rgba" mode="assign"><const>rgb</const></edit>
            <edit name="lcdfilter" mode="assign"><const>lcddefault</const></edit>
            <edit name="embeddedbitmap" mode="assign"><bool>false</bool></edit>
          </match>
        </fontconfig>
      '';
    };
  };
}
