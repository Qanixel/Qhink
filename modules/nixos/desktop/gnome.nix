{pkgs, ...}: {
  # 桌面环境配置 (临时)
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    dbus.enable = true;
    gvfs.enable = true; # GNOME 虚拟文件系统（网络共享、文件操作等）
    gnome.gnome-keyring.enable = true; # GNOME 密钥环（Wi-Fi、SSH 密码、凭据缓存）
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "GNOME";
    XDG_SESSION_DESKTOP = "gnome";
  };

  environment.systemPackages = with pkgs; [
    gnome-themes-extra
    adwaita-icon-theme
    papirus-icon-theme
    xdg-utils
    libnotify
  ];
}
