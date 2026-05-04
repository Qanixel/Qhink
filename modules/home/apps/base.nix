{pkgs, ...}: {
  # 1. 基础 GUI 软件包安装
  home.packages = with pkgs; [
    firefox # Firefox
    telegram-desktop # Telegram
    thunderbird # 邮件客户端
    localsend
  ];
}
