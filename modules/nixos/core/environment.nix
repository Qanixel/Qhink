{ pkgs, ... }:

{
  environment.sessionVariables = {
    GBM_BACKEND        = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    
    MOZ_DISABLE_RND_WINDOW = "1";
    MOZ_ENABLE_WAYLAND = "1";

    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    NIXOS_OZONE_WL = "1";

    TERM     = "xterm-256color";
    COLORTERM = "truecolor";

    GTK_IM_MODULE  = "fcitx";
    QT_IM_MODULE   = "fcitx";
    XMODIFIERS     = "@im=fcitx";
    INPUT_METHOD   = "fcitx";
    SDL_IM_MODULE  = "fcitx";
    GLFW_IM_MODULE = "ibus";

    QT_QPA_PLATFORM            = "wayland;xcb";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    XDG_SESSION_TYPE   = "wayland";
    # XDG_CURRENT_DESKTOP = "niri";
    # XDG_SESSION_DESKTOP = "niri";
  };

  environment.systemPackages = with pkgs; [
    wget curl git vim neovim
    htop btop unzip zip p7zip file tree
    lshw pciutils usbutils inxi
    man-pages man-pages-posix
    nmap traceroute networkmanager
    wayland-utils wl-clipboard xwayland xdg-utils
    gnome-themes-extra adwaita-icon-theme papirus-icon-theme
    nvtopPackages.nvidia vulkan-tools
    gcc gnumake cmake python3 nodejs
    brightnessctl playerctl libnotify grim slurp swappy
  ];
}
