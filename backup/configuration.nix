# ============================================================
# configuration.nix — NixOS 系统级主配置
# 涵盖：引导、硬件、网络、本地化、服务、字体、输入法等
# ============================================================
{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    # 硬件扫描生成文件（安装后由 nixos-generate-config 产生）
    ./hardware-configuration.nix

    # 各功能模块（建议拆分后取消注释）
    # ./modules/nvidia.nix
    # ./modules/fonts.nix
    # ./modules/locale.nix
  ];

  # ══════════════════════════════════════════════════════════
  # 1. Nix & Flakes 基础设置
  # ══════════════════════════════════════════════════════════
  nix = {
    package = pkgs.nix;

    settings = {
      # 启用 Flakes 实验特性
      experimental-features = [ "nix-command" "flakes" ];

      # ── 清华 TUNA 二进制缓存镜像 ────────────────────────────
      # 大幅加速国内构建，优先从 TUNA 拉取缓存
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" # TUNA 主镜像
        "https://cache.nixos.org"                                  # 官方缓存（兜底）
        "https://niri.cachix.org"                                  # Niri 专属缓存
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfx7LRyRRxdSAQQ1Ldx3X0/MRWXY0="
      ];

      # 允许普通用户使用 trusted substituters
      trusted-users = [ "root" "qanix" ];

      # 并发构建任务数（根据 CPU 核心数调整）
      max-jobs = "auto";
      cores = 0; # 0 = 使用所有可用核心
    };

    # 自动垃圾回收：每周清理旧世代
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # 自动优化 Nix Store（硬链接去重）
    optimise.automatic = true;
  };

  # ══════════════════════════════════════════════════════════
  # 2. 引导加载程序 (systemd-boot UEFI)
  # ══════════════════════════════════════════════════════════
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        # 最多保留 10 个引导条目，防止 EFI 分区占满
        configurationLimit = 10;
        # 编辑器安全：防止从引导界面直接修改内核参数
        editor = false;
      };
      efi.canTouchEfiVariables = true; # 允许写入 EFI 变量
    };

    # ── 内核：使用最新主线内核 ───────────────────────────────
    # RTX 5060 Ti (Blackwell 架构) 需要较新内核以获得最佳驱动支持
    kernelPackages = pkgs.linuxPackages_latest;

    # 内核参数
    kernelParams = [
      # NVIDIA 相关
      "nvidia-drm.modeset=1"         # 启用 DRM KMS（Wayland 必须）
      "nvidia-drm.fbdev=1"            # 启用 NVIDIA framebuffer 设备
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # 防止休眠/挂起后黑屏

      # 系统稳定性
      "quiet"                          # 减少启动日志输出
      "splash"
    ];

    # 内核模块在 initrd 阶段预加载（加速引导）
    initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

    # 开机即加载的内核模块
    kernelModules = [ "kvm-intel" ]; # Intel VT-x 虚拟化支持
  };

  # ══════════════════════════════════════════════════════════
  # 3. 硬件配置
  # ══════════════════════════════════════════════════════════

  # ── 3a. NVIDIA 显卡驱动 ──────────────────────────────────
  hardware.nvidia = {
    # 使用最新生产版驱动（支持 RTX 5060 Ti / Blackwell 架构）
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    # 启用 NVIDIA 开源内核模块（Blackwell 架构官方推荐）
    # RTX 5060 Ti (GB206) 属于 Blackwell，open 模块为首选
    open = true;

    # 启用 DRM KMS Modesetting（Wayland 的必要条件）
    modesetting.enable = true;

    # 节能功能（台式机可选关闭以追求性能）
    powerManagement = {
      enable = true;          # 启用电源管理（配合休眠防黑屏）
      finegrained = false;    # 台式独显无需细粒度节能
    };

    # 关闭 nouveau 开源驱动（避免与 NVIDIA 私有驱动冲突）
    nvidiaSettings = true;    # 安装 nvidia-settings GUI 工具
  };

  # ── 3b. OpenGL / 硬件加速 ────────────────────────────────
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # 启用 32 位 OpenGL（Wine / Steam 等需要）
    extraPackages = with pkgs; [
      nvidia-vaapi-driver   # VAAPI 视频硬件解码（Firefox/MPV 使用）
      libvdpau-va-gl        # VDPAU 兼容层
    ];
  };

  # ── 3c. 音频 (PipeWire) ──────────────────────────────────
  # 现代音频服务器，完全替代 PulseAudio，对 Wayland 更友好
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;  # PulseAudio 兼容层（大部分软件需要）
    jack.enable = true;   # JACK 兼容层（专业音频）
  };
  # 禁用旧式 PulseAudio（与 PipeWire 互斥）
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true; # 实时优先级（PipeWire 低延迟）

  # ── 3d. 蓝牙 ─────────────────────────────────────────────
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # ══════════════════════════════════════════════════════════
  # 4. 网络配置
  # ══════════════════════════════════════════════════════════
  networking = {
    hostName = "qhink"; # 主机名

    # 使用 NetworkManager 管理网络（桌面环境标配）
    networkmanager.enable = true;

    # 防火墙（保持默认启用，按需开放端口）
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ]; # SSH
    };
  };

  # ══════════════════════════════════════════════════════════
  # 5. 本地化与时区
  # ══════════════════════════════════════════════════════════
  time.timeZone = "Asia/Shanghai"; # 上海时区（北京时间 UTC+8）

  # 系统语言环境
  i18n = {
    defaultLocale = "zh_CN.UTF-8"; # 主语言：简体中文

    # 细粒度 locale 控制（消息、时间、货币格式全部使用中文）
    extraLocaleSettings = {
      LC_ADDRESS        = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT    = "zh_CN.UTF-8";
      LC_MONETARY       = "zh_CN.UTF-8";
      LC_NAME           = "zh_CN.UTF-8";
      LC_NUMERIC        = "zh_CN.UTF-8";
      LC_PAPER          = "zh_CN.UTF-8";
      LC_TELEPHONE      = "zh_CN.UTF-8";
      LC_TIME           = "zh_CN.UTF-8";
      # 终端输出保持英文，便于排查错误
      LC_MESSAGES       = "en_US.UTF-8";
    };
  };

  # ══════════════════════════════════════════════════════════
  # 6. 桌面环境 (Niri Wayland 合成器)
  # ══════════════════════════════════════════════════════════
  # 启用 Wayland 显示服务器协议支持
  programs.niri = {
    enable = true; # 由 niri flake 模块提供
  };

  # 启用 XDG Desktop Portal（屏幕共享、文件选择器等）
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome  # 文件选择器
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # SDDM 显示管理器（登录界面），Wayland 会话
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true; # 以 Wayland 模式运行 SDDM
      theme = "breeze";       # Breeze 主题（KDE 风格）
    };
    defaultSession = "niri"; # 默认启动 Niri 会话
  };

  # ── Polkit：授权服务（Wayland 应用提权需要）──────────────
  security.polkit.enable = true;

  # ══════════════════════════════════════════════════════════
  # 7. 输入法框架 (Fcitx5)
  # ══════════════════════════════════════════════════════════
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5"; # 使用 Fcitx5

    fcitx5 = {
      waylandFrontend = true; # 启用原生 Wayland 前端（比 XIM 更稳定）

      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons    # 拼音、五笔等中文输入法套件
        fcitx5-pinyin-zhwiki     # 基于中文维基百科的超大词库（约 40 万词条）
        fcitx5-gtk               # GTK im module（GTK 应用集成）
        fcitx5-qt                # Qt im module（Qt/KDE 应用集成）
        fcitx5-configtool        # 图形化配置工具
      ];
    };
  };

  # ══════════════════════════════════════════════════════════
  # 8. 字体配置
  # ══════════════════════════════════════════════════════════
  fonts = {
    # 预装字体包
    packages = with pkgs; [
      # ── 编程字体 ──
      maple-mono.CN           # Maple Mono：同时支持 ASCII 和中文的编程字体
      maple-mono.NF        # Nerd Font 版本（终端图标支持）

      # ── 中文字体 ──
      noto-fonts           # Noto Sans / Serif（无豆腐块方案）
      noto-fonts-cjk-sans  # Noto Sans CJK（中日韩无衬线）
      noto-fonts-cjk-serif # Noto Serif CJK（中日韩衬线）
      noto-fonts-emoji     # Noto Emoji（彩色表情符号）

      # ── UI / 系统字体 ──
      inter                # Inter：现代 UI 西文字体
      (nerdfonts.override { fonts = [ "JetBrainsMono" "NerdFontsSymbolsOnly" ]; })
    ];

    # Fontconfig 精细配置
    fontconfig = {
      enable = true;
      defaultFonts = {
        # 西文等宽字体（终端、代码编辑器）
        monospace  = [ "Maple Mono NF" "Noto Sans Mono CJK SC" ];
        # 西文无衬线（UI、标题）
        sansSerif  = [ "Inter" "Noto Sans CJK SC" "Noto Sans" ];
        # 西文衬线（正文阅读）
        serif      = [ "Noto Serif CJK SC" "Noto Serif" ];
        # 表情符号
        emoji      = [ "Noto Color Emoji" ];
      };

      # ── 解决中日文字形冲突的 XML 规则 ──────────────────────
      # 问题：同一 Unicode 码位在中文/日文/韩文中字形不同
      # 方案：通过 font-lang 绑定，强制不同语言使用对应区域字形
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>

          <!-- ① 将 Maple Mono 绑定为中文等宽字体（编辑器代码区首选）-->
          <match target="pattern">
            <test name="lang" compare="contains">
              <string>zh</string>
            </test>
            <test name="spacing" compare="eq">
              <int>100</int> <!-- monospace -->
            </test>
            <edit name="family" mode="prepend" binding="strong">
              <string>Maple Mono NF</string>
            </edit>
          </match>

          <!-- ② 中文（简体）界面字体：优先 Noto Sans CJK SC -->
          <match target="pattern">
            <test name="lang" compare="contains">
              <string>zh-CN</string>
            </test>
            <test name="family" compare="eq">
              <string>sans-serif</string>
            </test>
            <edit name="family" mode="prepend" binding="strong">
              <string>Noto Sans CJK SC</string>
            </edit>
          </match>

          <!-- ③ 日文界面字体：使用 Noto Sans CJK JP 避免中文字形 -->
          <match target="pattern">
            <test name="lang" compare="contains">
              <string>ja</string>
            </test>
            <test name="family" compare="eq">
              <string>sans-serif</string>
            </test>
            <edit name="family" mode="prepend" binding="strong">
              <string>Noto Sans CJK JP</string>
            </edit>
          </match>

          <!-- ④ 韩文界面字体：使用 Noto Sans CJK KR -->
          <match target="pattern">
            <test name="lang" compare="contains">
              <string>ko</string>
            </test>
            <test name="family" compare="eq">
              <string>sans-serif</string>
            </test>
            <edit name="family" mode="prepend" binding="strong">
              <string>Noto Sans CJK KR</string>
            </edit>
          </match>

          <!-- ⑤ 禁用点阵字体（避免低分辨率字体在高 DPI 下显示模糊）-->
          <selectfont>
            <rejectfont>
              <pattern>
                <patelt name="scalable"><bool>false</bool></patelt>
              </pattern>
            </rejectfont>
          </selectfont>

          <!-- ⑥ 字体渲染质量：开启次像素渲染（LCD 屏幕）-->
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

  # ══════════════════════════════════════════════════════════
  # 9. 用户配置
  # ══════════════════════════════════════════════════════════
  users.users.qanix = {
    isNormalUser = true;
    description  = "qanix";

    # 初始密码（首次登录后请立即用 passwd 修改）
    initialPassword = "xqapp";

    # 用户组
    extraGroups = [
      "wheel"          # sudo 权限
      "networkmanager" # 管理网络连接
      "audio"          # 音频设备
      "video"          # 视频设备（VAAPI 解码）
      "input"          # 输入设备（触摸板等）
      "render"         # GPU 渲染
    ];

    shell = pkgs.zsh; # 默认 Shell 设置为 Zsh
  };

  # ── Sudo 免密配置 ─────────────────────────────────────────
  # wheel 组成员 sudo 时无需输入密码（开发机推荐）
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false; # wheel 组免密 sudo
    extraConfig = ''
      # 保留 HOME 环境变量，方便 sudo 后仍能找到用户配置
      Defaults env_keep += "HOME"
      # 延长 sudo 凭据缓存时间至 30 分钟
      Defaults timestamp_timeout=30
    '';
  };

  # ══════════════════════════════════════════════════════════
  # 10. 系统级程序与服务
  # ══════════════════════════════════════════════════════════

  # ── Zsh（系统级启用）────────────────────────────────────
  programs.zsh.enable = true; # 必须系统级启用，否则无法作为登录 Shell

  # ── SSH 服务 ─────────────────────────────────────────────
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;  # 允许密码登录
      PermitRootLogin         = "no"; # 禁止 root 直接 SSH（安全）
      X11Forwarding           = false;
    };
  };

  # ── 通用系统服务 ──────────────────────────────────────────
  services = {
    # D-Bus 消息总线（几乎所有桌面应用都依赖）
    dbus.enable = true;

    # 打印机服务（可选，按需启用）
    printing.enable = false;

    # Udev 规则（硬件热插拔事件处理）
    udev.enable = true;

    # 文件系统自动挂载
    gvfs.enable = true; # GNOME 虚拟文件系统（Nautilus/Thunar 网络浏览）

    # 通知守护进程
    gnome.gnome-keyring.enable = true; # 密钥环（保存 Wi-Fi / SSH 密码）
  };

  # ── Flatpak（可选，部分国内应用通过 Flatpak 分发）────────
  # services.flatpak.enable = true;

  # ══════════════════════════════════════════════════════════
  # 11. 系统环境变量（全局）
  # ══════════════════════════════════════════════════════════
  environment.sessionVariables = {
    # ── NVIDIA + Wayland 必备 ────────────────────────────────
    # 强制使用 NVIDIA 私有驱动的 EGL 后端（Wayland 渲染必要）
    GBM_BACKEND        = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # 禁用 Firefox/Electron 的 WebGL 软件回退（使用 GPU）
    MOZ_DISABLE_RND_WINDOW = "1";
    MOZ_ENABLE_WAYLAND = "1"; # Firefox 原生 Wayland 模式

    # Electron 应用（VSCode、Obsidian 等）使用 Wayland 原生模式
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    NIXOS_OZONE_WL = "1";      # NixOS 专用：通知 Electron 应用启用 Wayland

    # ── Ghostty 终端 ─────────────────────────────────────────
    # Ghostty 使用 GPU 渲染，需要 Wayland 后端
    TERM     = "xterm-256color";
    COLORTERM = "truecolor";

    # ── Fcitx5 输入法集成 ────────────────────────────────────
    # 确保所有框架均能找到 Fcitx5 的输入法模块
    GTK_IM_MODULE  = "fcitx";
    QT_IM_MODULE   = "fcitx";
    XMODIFIERS     = "@im=fcitx";
    INPUT_METHOD   = "fcitx";
    # Wayland 原生输入法协议（text-input-v3）
    SDL_IM_MODULE  = "fcitx";
    GLFW_IM_MODULE = "ibus"; # Glfw 暂不支持 fcitx，退回 ibus 协议

    # ── Qt 主题 ──────────────────────────────────────────────
    QT_QPA_PLATFORM            = "wayland;xcb"; # 优先 Wayland，回退 X11
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # 客户端绘制窗口装饰（Wayland 规范）

    # ── XDG 规范 ─────────────────────────────────────────────
    XDG_SESSION_TYPE   = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_DESKTOP = "niri";
  };

  # ══════════════════════════════════════════════════════════
  # 12. 系统级软件包
  # ══════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    # ── 基础工具 ──────────────────────────────────────────────
    wget curl git vim neovim
    htop btop            # 系统监控
    unzip zip p7zip      # 归档工具
    file tree            # 文件信息
    lshw pciutils usbutils inxi # 硬件信息
    man-pages man-pages-posix   # 手册页

    # ── 网络工具 ──────────────────────────────────────────────
    nmap traceroute      # 网络诊断
    networkmanager       # 网络管理

    # ── Wayland 工具链 ────────────────────────────────────────
    wayland-utils        # Wayland 调试工具
    wl-clipboard         # Wayland 剪贴板（wl-copy / wl-paste）
    xwayland             # X11 兼容层（运行不支持 Wayland 的旧应用）
    xdg-utils            # xdg-open 等工具

    # ── 主题与图标 ────────────────────────────────────────────
    gnome-themes-extra   # GNOME/GTK 主题
    adwaita-icon-theme   # Adwaita 图标集
    papirus-icon-theme   # Papirus 图标集（更美观）

    # ── NVIDIA 工具 ───────────────────────────────────────────
    nvtopPackages.nvidia # GPU 监控（类似 htop）
    vulkan-tools         # Vulkan 信息查询 vulkaninfo

    # ── 开发基础 ──────────────────────────────────────────────
    gcc gnumake cmake    # C/C++ 编译工具链
    python3              # Python 3
    nodejs               # Node.js

    # ── 其他实用工具 ──────────────────────────────────────────
    brightnessctl        # 亮度控制
    playerctl            # 媒体播放器控制
    libnotify            # notify-send 通知工具
    grim slurp           # Wayland 截图工具
    swappy               # 截图标注工具
  ];

  # ══════════════════════════════════════════════════════════
  # 13. 系统版本标记（不要随意修改，影响状态迁移）
  # ══════════════════════════════════════════════════════════
  system.stateVersion = "25.05"; # 初始安装时的 NixOS 版本
}
