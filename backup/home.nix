# ============================================================
# home.nix — Home Manager 用户级配置
# 用户: qanix | 管理: Shell、终端、编辑器、桌面应用、Niri等
# ============================================================
{ config, pkgs, inputs, lib, ... }:

{
  # ══════════════════════════════════════════════════════════
  # 1. Home Manager 基本信息
  # ══════════════════════════════════════════════════════════
  home = {
    username    = "qanix";
    homeDirectory = "/home/qanix";

    # Home Manager 状态版本（与 NixOS stateVersion 对应）
    stateVersion = "25.05";

    # ── 用户级环境变量 ─────────────────────────────────────
    sessionVariables = {
      # 默认编辑器
      EDITOR  = "nvim";
      VISUAL  = "nvim";
      PAGER   = "less";

      # Zsh 历史记录位置（显式指定防止丢失）
      HISTFILE = "$HOME/.zsh_history";

      # Go 语言路径（如果使用 Go 开发）
      # GOPATH = "$HOME/go";
    };

    # ── 用户级软件包 ───────────────────────────────────────
    packages = with pkgs; [
      # ── 桌面应用 ─────────────────────────────────────────
      google-chrome        # Google Chrome 浏览器
      obsidian             # Obsidian 知识管理/双链笔记
      logseq               # 可选：另一款双链笔记工具

      # ── 思源笔记（SiYuan Note）────────────────────────────
      # 注：若 nixpkgs 中无 siyuan，使用以下方式安装 AppImage
      # 或通过 nix-alien / flatpak 安装
      siyuan              # 思源笔记（需 nixpkgs 包含此包时启用）

      # ── 媒体工具 ─────────────────────────────────────────
      mpv                  # 轻量级视频播放器（支持硬解）
      imv                  # Wayland 图片查看器
      pavucontrol          # PipeWire/PulseAudio 音量控制 GUI

      # ── 文件管理 ─────────────────────────────────────────
      # nautilus             # GNOME 文件管理器（GTK）
      thunar             # 可选：XFCE 文件管理器（更轻量）

      # ── 开发工具（用户级）────────────────────────────────
      lazygit              # Git TUI 客户端
      ripgrep              # 超快文本搜索（rg）
      fd                   # 现代化 find 替代品
      bat                  # cat 的升级版（语法高亮）
      eza                  # 现代化 ls 替代品（彩色 + 图标）
      fzf                  # 模糊查找器（Zsh 集成）
      zoxide               # 智能目录跳转（z 命令）
      starship             # 跨 Shell 提示符（可选，见下方配置）
      delta                # Git diff 语法高亮
      jq                   # JSON 处理工具
      yq                   # YAML 处理工具

      # ── 系统监控 ─────────────────────────────────────────
      # bottom               # 现代化系统监控 TUI（btm）

      # ── 网络 ─────────────────────────────────────────────
      aria2                # 多线程下载工具

      # ── Wayland / Niri 工具 ───────────────────────────────
      # fuzzel               # Wayland 应用启动器（Rofi 替代品）
      # mako                 # Wayland 通知守护进程
      # waybar               # 状态栏（也可使用 dms-shell 自带状态栏）
      # swww                 # 动态壁纸管理器（Wayland）
      # wlogout              # Wayland 登出/关机界面

      # ── 字体相关工具 ──────────────────────────────────────
      fontpreview          # 字体预览工具（可选）
    ];
  };

  # ══════════════════════════════════════════════════════════
  # 2. Zsh 配置（含 oh-my-zsh + 插件）
  # ══════════════════════════════════════════════════════════
  programs.zsh = {
    enable = true;

    # ── 历史记录设置 ──────────────────────────────────────
    history = {
      size       = 50000;   # 内存历史条数
      save       = 50000;   # 文件历史条数
      ignoreDups = true;    # 忽略重复命令
      share      = true;    # 多终端共享历史
      extended   = true;    # 记录时间戳
    };

    # ── Oh-My-Zsh 配置 ────────────────────────────────────
    oh-my-zsh = {
      enable = true;

      # 主题：使用 agnoster（简洁但信息丰富）
      # 如果使用 Starship，将 theme 注释掉
      theme = "agnoster";

      # 内置插件列表（Oh-My-Zsh 自带）
      plugins = [
        "git"            # Git 快捷命令和提示
        "sudo"           # 双击 ESC 自动在命令前加 sudo
        "docker"         # Docker 补全
        "docker-compose" # Docker Compose 补全
        "npm"            # NPM 补全
        "python"         # Python 快捷命令
        "systemd"        # systemctl 别名（e.g. sc-status）
        "history"        # 历史记录增强命令（h, hsi）
        "colored-man-pages" # man 页面彩色输出
        "extract"        # 万能解压命令 extract
        "fzf"            # fzf 集成（Ctrl+R 历史搜索）
        "zoxide"         # zoxide 集成（z 命令智能跳转）
      ];
    };

    # ── 额外插件（nixpkgs 提供，Oh-My-Zsh 没有内置）────────
    plugins = [
      # 命令自动补全建议（灰色提示，按 → 确认）
      {
        name = "zsh-autosuggestions";
        src  = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      # 语法高亮（合法命令绿色，错误命令红色）
      {
        name = "zsh-syntax-highlighting";
        src  = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
      # 历史记录子串搜索（↑↓ 根据已输入内容搜索历史）
      {
        name = "zsh-history-substring-search";
        src  = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
    ];

    # ── Shell 别名 ────────────────────────────────────────
    shellAliases = {
      # # 文件操作
      # ls    = "eza --icons --group-directories-first";
      # ll    = "eza -la --icons --group-directories-first";
      # la    = "eza -a --icons";
      # lt    = "eza --tree --icons --level=2";
      # cat   = "bat --paging=never";
      # grep  = "grep --color=auto";

      # # 目录导航
      # ".."  = "cd ..";
      # "..." = "cd ../..";
      # "~"   = "cd ~";

      # # Git
      # g     = "git";
      # gs    = "git status";
      # ga    = "git add";
      # gc    = "git commit";
      # gp    = "git push";
      # gl    = "git pull";
      # glog  = "git log --oneline --graph --decorate";
      # lg    = "lazygit";

      # Nix 相关（常用操作）
      nrs   = "sudo nixos-rebuild switch --flake ~/.config/nixos#qhink";  # 应用配置
      nrt   = "sudo nixos-rebuild test --flake ~/.config/nixos#qhink";    # 测试配置
      nrb   = "sudo nixos-rebuild boot --flake ~/.config/nixos#qhink";    # 下次启动生效
      nfu   = "nix flake update --flake ~/.config/nixos";                 # 更新 flake.lock
      ngc   = "sudo nix-collect-garbage -d";                              # 垃圾回收
      nse   = "nix search nixpkgs";                                       # 搜索包

      # # 系统
      # myip  = "curl ifconfig.me";
      # ports = "ss -tlnp";
      # df    = "df -h";
      # du    = "du -sh";
      # free  = "free -h";
      # top   = "btop";

      # 编辑器
      v     = "nvim";
      vi    = "nvim";
    };

    # ── 额外 Zsh 初始化代码 ───────────────────────────────
    initContent = ''
      # ── zoxide 初始化（智能目录跳转）──────────────────────
      eval "$(zoxide init zsh)"

      # ── fzf 配置 ──────────────────────────────────────────
      # 使用 fd 替代 find 作为 fzf 文件查找后端（更快、尊重 .gitignore）
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
      # fzf 预览（文件内容 bat，目录 eza tree）
      export FZF_DEFAULT_OPTS="
        --height 40%
        --layout=reverse
        --border=rounded
        --preview '([[ -d {} ]] && eza --tree --icons --level=2 {}) || bat --color=always --style=numbers {}'
        --preview-window=right:50%
        --color=dark
      "

      # ── 历史记录子串搜索：绑定上下箭头 ────────────────────
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # ── 自动补全增强 ──────────────────────────────────────
      # 补全菜单使用方向键导航
      zstyle ':completion:*' menu select
      # 补全时忽略大小写
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

      # ── Fcitx5：Zsh 环境变量（部分终端需要重申）──────────
      export GTK_IM_MODULE=fcitx
      export QT_IM_MODULE=fcitx
      export XMODIFIERS=@im=fcitx

      # ── 欢迎信息（可选，删除此块关闭）────────────────────
      if [[ -o interactive ]]; then
        echo "🚀 欢迎回来，qanix！ NixOS on qhink"
        echo "📅 $(date '+%Y年%m月%d日 %H:%M')"
      fi
    '';
  };

  # ══════════════════════════════════════════════════════════
  # 3. Ghostty 终端配置
  # ══════════════════════════════════════════════════════════
  programs.ghostty = {
    enable = true;

    settings = {
      # ── 字体 ──────────────────────────────────────────────
      font-family          = "Maple Mono NF";
      font-size            = 14;
      # 中文字体回退（Ghostty 支持多字体 fallback）
      font-family-fallback = "Noto Sans CJK SC";

      # ── 外观 ──────────────────────────────────────────────
      theme                = "catppuccin-mocha"; # 主题
      background-opacity   = 0.92;              # 轻微透明效果
      window-padding-x     = 8;
      window-padding-y     = 8;
      window-decoration    = "client";          # 客户端窗口装饰（Wayland）

      # ── Wayland ───────────────────────────────────────────
      gtk-adwaita          = false;

      # ── 渲染 ──────────────────────────────────────────────
      cursor-style         = "block";
      cursor-blink         = false;             # 不闪烁游标（个人偏好）

      # ── 输入法 ────────────────────────────────────────────
      # Ghostty 原生支持 Wayland text-input-v3 协议，Fcitx5 可直接工作

      # ── Shell 集成 ────────────────────────────────────────
      shell-integration    = "zsh";

      # ── 性能（NVIDIA GPU 渲染）───────────────────────────
      # Ghostty 默认使用 GPU 渲染，NVIDIA + Wayland 下应自动工作
    };
  };

  # ══════════════════════════════════════════════════════════
  # 4. Niri 合成器配置（Home Manager）
  # ══════════════════════════════════════════════════════════
  # Niri 的 Home Manager 模块由 niri flake 提供
  programs.niri = {
    settings = {
      # ── 输出（显示器）配置 ────────────────────────────────
      outputs = {
        # 2560x1080 宽屏（21:9 超宽显示器）
        # 请将 "DP-1" 替换为你的实际显示器名称（运行 niri msg outputs 查看）
        "DP-1" = {
          enable  = true;
          mode    = {
            width   = 2560;
            height  = 1080;
            refresh = 60.000; # 刷新率（Hz），按实际调整
          };
          scale   = 1.0;      # HiDPI 缩放比（超宽 1080p 保持 1.0）
          position = { x = 0; y = 0; }; # 主屏原点
        };
      };

      # ── 输入设备 ──────────────────────────────────────────
      input = {
        keyboard = {
          xkb = {
            layout  = "us";   # 键盘布局：US 英文（输入法由 Fcitx5 处理）
            options = "caps:escape"; # 将 CapsLock 映射为 Escape（Vim 用户友好）
          };
          repeat-delay    = 250; # 按键重复延迟（ms）
          repeat-rate     = 50;  # 按键重复速率（次/秒）
        };
        mouse = {
          accel-speed  = 0.0;   # 鼠标加速度（0 = 禁用加速）
          accel-profile = "flat"; # 线性鼠标移动（游戏和精确操作推荐）
        };
        # 触摸板（台式机可忽略）
        # touchpad = {
        #   tap = true;
        #   natural-scroll = true;
        # };
      };

      # ── 布局 ──────────────────────────────────────────────
      layout = {
        # 窗口间间距
        gaps = 8;
        # 是否默认居中窗口（超宽屏推荐开启，防止窗口过宽）
        center-focused-column = "never";

        # 预设列宽（超宽 2560 屏幕常用比例）
        preset-column-widths = [
          { proportion = 0.33333; } # 三分之一
          { proportion = 0.5;     } # 一半
          { proportion = 0.66667; } # 三分之二
          { proportion = 1.0;     } # 全屏
        ];

        # 默认列宽
        default-column-width = { proportion = 0.5; };

        # 边框样式
        border = {
          enable = true;
          width  = 2;
          active-color   = "#89b4fa"; # Catppuccin Mocha Blue（活动窗口）
          inactive-color = "#45475a"; # Catppuccin Mocha Surface 1（非活动）
        };

        # 阴影效果（需 NVIDIA 支持）
        shadow = {
          enable = true;
          offset = { x = 0; y = 4; };
          softness = 20;
          color = "rgba(0, 0, 0, 60%)";
        };
      };

      # ── 动画效果 ──────────────────────────────────────────
      animations = {
        slowdown = 1.0; # 动画速度系数（>1 更慢，<1 更快）

        # 窗口打开动画
        window-open-anim    = { spring = { damping-ratio = 1.0; stiffness = 800; epsilon = 0.0001; }; };
        window-close-anim   = { spring = { damping-ratio = 1.0; stiffness = 800; epsilon = 0.0001; }; };
        # 滚动动画
        horizontal-view-movement = { spring = { damping-ratio = 1.0; stiffness = 800; epsilon = 0.0001; }; };
        window-movement-throttle = { spring = { damping-ratio = 1.0; stiffness = 800; epsilon = 0.0001; }; };
      };

      # ── 键位绑定 ──────────────────────────────────────────
      binds = with config.lib.niri.actions; let
        # 修饰键：Super（Win 键）
        mod = "Super";
      in {
        # 应用启动
        "${mod}+Return".action        = spawn "ghostty";              # 终端
        "${mod}+Space".action         = spawn "fuzzel";               # 应用启动器
        "${mod}+E".action             = spawn "nautilus";             # 文件管理器
        "${mod}+B".action             = spawn "google-chrome-stable"; # 浏览器

        # 窗口操作
        "${mod}+Q".action             = close-window;                 # 关闭窗口
        "${mod}+F".action             = maximize-column;              # 最大化列
        "${mod}+Shift+F".action       = fullscreen-window;            # 全屏
        "${mod}+C".action             = center-column;                # 居中列（超宽屏常用）

        # 焦点移动
        "${mod}+H".action             = focus-column-left;
        "${mod}+L".action             = focus-column-right;
        "${mod}+J".action             = focus-window-down;
        "${mod}+K".action             = focus-window-up;
        "${mod}+Left".action          = focus-column-left;
        "${mod}+Right".action         = focus-column-right;
        "${mod}+Down".action          = focus-window-down;
        "${mod}+Up".action            = focus-window-up;

        # 窗口移动
        "${mod}+Shift+H".action       = move-column-left;
        "${mod}+Shift+L".action       = move-column-right;
        "${mod}+Shift+J".action       = move-window-down;
        "${mod}+Shift+K".action       = move-window-up;

        # 工作区切换（1-9）
        "${mod}+1".action             = focus-workspace 1;
        "${mod}+2".action             = focus-workspace 2;
        "${mod}+3".action             = focus-workspace 3;
        "${mod}+4".action             = focus-workspace 4;
        "${mod}+5".action             = focus-workspace 5;
        "${mod}+6".action             = focus-workspace 6;
        "${mod}+Shift+1".action       = move-window-to-workspace 1;
        "${mod}+Shift+2".action       = move-window-to-workspace 2;
        "${mod}+Shift+3".action       = move-window-to-workspace 3;
        "${mod}+Shift+4".action       = move-window-to-workspace 4;

        # 列宽调整
        "${mod}+R".action             = switch-preset-column-width;
        "${mod}+Minus".action         = set-column-width "-5%";
        "${mod}+Equal".action         = set-column-width "+5%";
        "${mod}+Shift+Minus".action   = set-window-height "-5%";
        "${mod}+Shift+Equal".action   = set-window-height "+5%";

        # 截图
        "Print".action                = screenshot;                   # 全屏截图
        "${mod}+Print".action         = screenshot-window;            # 窗口截图
        "${mod}+Shift+S".action       = screenshot-screen;            # 选区截图

        # 系统
        "${mod}+Shift+E".action       = quit;                         # 退出 Niri
        "${mod}+Shift+R".action       = reload-config;                # 重载配置

        # 媒体键
        "XF86AudioRaiseVolume".action  = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+";
        "XF86AudioLowerVolume".action  = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
        "XF86AudioMute".action         = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
        "XF86AudioPlay".action         = spawn "playerctl" "play-pause";
        "XF86AudioNext".action         = spawn "playerctl" "next";
        "XF86AudioPrev".action         = spawn "playerctl" "previous";
      };

      # ── 自动启动（桌面环境必要组件）──────────────────────
      spawn-at-startup = [
        { command = [ "fcitx5" "-d" "--replace" ]; }  # 输入法
        { command = [ "mako" ]; }                      # 通知守护
        { command = [ "waybar" ]; }                    # 状态栏
        { command = [ "swww-daemon" ]; }               # 壁纸服务
        # 壁纸设置（替换为你的壁纸路径）
        # { command = [ "swww" "img" "/home/qanix/Pictures/wallpaper.jpg" ]; }
        { command = [ "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1" ]; } # 授权弹窗
      ];

      # ── 窗口规则 ──────────────────────────────────────────
      window-rules = [
        # 浮动窗口（部分工具性窗口默认浮动）
        {
          matches = [
            { app-id = "org.gnome.Nautilus"; title = "Properties"; }
            { app-id = "pavucontrol"; }
            { app-id = "nm-connection-editor"; }  # 网络连接编辑器
            { app-id = "fcitx5-config"; }         # 输入法配置
          ];
          open-floating = true;
        }
        # Chrome 画中画模式：始终置顶
        {
          matches = [{ app-id = "google-chrome"; title = "画中画"; }];
          open-floating = true;
        }
      ];

      # ── 触摸板手势（台式机无触摸板可忽略）──────────────
      # gestures = { hot-corners.enable = false; };

      # ── 屏幕角落快捷操作 ──────────────────────────────────
      # hot-corners = {
      #   top-left     = { action = toggle-overview; };
      #   top-right    = { action = spawn "wlogout"; };
      # };
    };
  };

  # ══════════════════════════════════════════════════════════
  # 5. VSCode 配置
  # ══════════════════════════════════════════════════════════
  programs.vscode = {
    enable = true;
    package = pkgs.vscode; # 使用 nixpkgs 中的 VSCode（非自由软件）

    # ── 扩展列表 ──────────────────────────────────────────
    extensions = with pkgs.vscode-extensions; [
      # 语言支持
      ms-python.python              # Python
      ms-python.vscode-pylance      # Python 语言服务器
      rust-lang.rust-analyzer       # Rust
      jnoortheen.nix-ide            # Nix 语法高亮 + 格式化
      bradlc.vscode-tailwindcss     # Tailwind CSS
      esbenp.prettier-vscode        # 代码格式化

      # Git
      eamodio.gitlens               # Git 增强（行内 blame、历史）
      mhutchie.git-graph            # Git 图形化历史

      # 主题与图标
      catppuccin.catppuccin-vsc     # Catppuccin Mocha 主题
      catppuccin.catppuccin-vsc-icons # 配套图标主题

      # 实用工具
      ms-vscode-remote.remote-ssh   # SSH 远程开发
      ms-azuretools.vscode-docker   # Docker 支持
      usernamehw.errorlens          # 内联错误提示
      gruntfuggly.todo-tree         # TODO 注释高亮
    ];

    # ── VSCode 用户设置 ───────────────────────────────────
    userSettings = {
      # 外观
      "workbench.colorTheme"         = "Catppuccin Mocha";
      "workbench.iconTheme"          = "catppuccin-mocha";
      "editor.fontFamily"            = "'Maple Mono NF', 'Noto Sans CJK SC', monospace";
      "editor.fontSize"              = 14;
      "editor.lineHeight"            = 1.6;
      "editor.fontLigatures"         = true;   # 连字符（Maple Mono 支持）
      "editor.renderWhitespace"      = "boundary";
      "editor.cursorBlinking"        = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";

      # 编辑器行为
      "editor.formatOnSave"          = true;
      "editor.defaultFormatter"      = "esbenp.prettier-vscode";
      "editor.tabSize"               = 2;
      "editor.wordWrap"              = "off";
      "editor.minimap.enabled"       = false; # 关闭缩略图（超宽屏空间富裕）
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs"   = "active";

      # 终端（使用 Ghostty）
      "terminal.external.linuxExec"  = "ghostty";
      "terminal.integrated.fontFamily" = "Maple Mono NF";
      "terminal.integrated.fontSize" = 13;

      # 文件
      "files.autoSave"               = "afterDelay";
      "files.autoSaveDelay"          = 1000;
      "files.trimTrailingWhitespace" = true;
      "files.insertFinalNewline"     = true;

      # Git
      "git.autofetch"                = true;
      "git.enableSmartCommit"        = true;

      # Nix
      "nix.enableLanguageServer"     = true;
      "nix.serverPath"               = "nil";

      # 性能（Wayland + NVIDIA）
      "window.titleBarStyle"         = "custom"; # 客户端标题栏
    };
  };

  # ══════════════════════════════════════════════════════════
  # 6. Git 配置
  # ══════════════════════════════════════════════════════════
  programs.git = {
    enable   = true;
    userName = "qanix";
    userEmail = "qanix@qhink.local"; # 替换为你的 Git 邮箱

    extraConfig = {
      core = {
        editor   = "nvim";
        pager    = "delta"; # 使用 delta 美化 diff 输出
        autocrlf = "input"; # Linux 统一使用 LF
      };
      init.defaultBranch = "main";
      pull.rebase        = false;
      push.autoSetupRemote = true;

      # Delta diff 配置
      delta = {
        enable         = true;
        navigate       = true; # n/N 在 diff 块间跳转
        line-numbers   = true;
        side-by-side   = false; # 超宽屏可开启并排 diff
        syntax-theme   = "Catppuccin Mocha";
      };
      merge.conflictstyle = "diff3";
      diff.colorMoved     = "default";
    };
  };

  # ══════════════════════════════════════════════════════════
  # 7. Waybar 状态栏配置（超宽 2560x1080 屏幕优化）
  # ══════════════════════════════════════════════════════════
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer    = "top";
        position = "top";
        height   = 36;
        # 超宽屏：状态栏不需要填满整个宽度，留出边距
        margin-left  = 8;
        margin-right = 8;
        margin-top   = 4;

        modules-left   = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right  = [
          "cpu" "memory" "temperature"
          "pulseaudio" "network"
          "tray" "custom/notification"
        ];

        # 工作区
        "niri/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };

        # 当前窗口标题
        "niri/window" = {
          format = "{title}";
          max-length = 60; # 超宽屏可设置更大值
        };

        # 时钟
        "clock" = {
          format      = "{:%Y年%m月%d日  %H:%M}"; # 中文日期格式
          tooltip-format = "<big>{:%Y年%m月}</big>\n<tt>{calendar}</tt>";
          locale      = "zh_CN.UTF-8";
        };

        # CPU
        "cpu" = {
          format   = " {usage}%";
          interval = 2;
        };

        # 内存
        "memory" = {
          format   = " {percentage}%";
          interval = 10;
          tooltip-format = "已用: {used:0.1f}G / 总计: {total:0.1f}G";
        };

        # 温度
        "temperature" = {
          format          = " {temperatureC}°C";
          critical-threshold = 80;
          format-critical = " {temperatureC}°C";
        };

        # 音量
        "pulseaudio" = {
          format        = "{icon} {volume}%";
          format-muted  = " 静音";
          format-icons  = { default = [ "" "" "" ]; };
          on-click      = "pavucontrol";
        };

        # 网络
        "network" = {
          format-wifi        = " {essid}";
          format-ethernet    = " {ifname}";
          format-disconnected = "⚠ 断开";
          tooltip-format     = "{ipaddr}/{cidr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
        };

        # 系统托盘
        "tray" = {
          spacing = 6;
        };
      };
    };

    # Waybar 样式（Catppuccin Mocha 主题）
    style = ''
      * {
        font-family: "Maple Mono NF", "Noto Sans CJK SC";
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background: rgba(30, 30, 46, 0.90); /* Catppuccin Mocha Base */
        color: #cdd6f4;                      /* Catppuccin Mocha Text */
        border-radius: 8px;
      }

      #workspaces button {
        padding: 2px 10px;
        color: #6c7086; /* 非活动：Overlay 0 */
        border-radius: 6px;
        margin: 4px 2px;
      }

      #workspaces button.active {
        color: #89b4fa;  /* 活动：Catppuccin Blue */
        background: rgba(137, 180, 250, 0.15);
        font-weight: bold;
      }

      #workspaces button:hover {
        background: rgba(137, 180, 250, 0.10);
        color: #cdd6f4;
      }

      #clock {
        font-weight: bold;
        color: #89dceb; /* Sky */
      }

      #cpu, #memory, #temperature,
      #pulseaudio, #network, #tray {
        padding: 2px 12px;
        margin: 4px 2px;
        border-radius: 6px;
        background: rgba(49, 50, 68, 0.6); /* Surface 0 */
      }

      #temperature.critical {
        color: #f38ba8; /* Red */
      }
    '';
  };

  # ══════════════════════════════════════════════════════════
  # 8. Mako 通知守护进程配置
  # ══════════════════════════════════════════════════════════
  services.mako = {
    enable = true;

    settings = {
      # 位置：右上角
      anchor   = "top-right";
      # 超宽屏：通知宽度适中
      width    = 380;
      height   = 120;
      margin   = "12";
      padding  = "12,16";

      # 外观
      background-color = "#1e1e2e";  # Catppuccin Mocha Base
      text-color       = "#cdd6f4";  # Text
      border-color     = "#89b4fa";  # Blue
      border-radius    = 8;
      border-size      = 1;

      # 字体
      font = "Maple Mono NF 12";

      # 行为
      default-timeout  = 5000; # 5 秒自动消失
      ignore-timeout   = false;
      max-visible      = 5;    # 最多同时显示 5 条通知
    };
  };

  # ══════════════════════════════════════════════════════════
  # 9. Fuzzel 应用启动器配置
  # ══════════════════════════════════════════════════════════
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font            = "Maple Mono NF:size=13";
        dpi-aware       = "auto";
        icon-theme      = "Papirus";
        terminal        = "ghostty -e";
        # 超宽屏：启动器居中显示，宽度适中
        width           = 50;  # 字符数
        lines           = 10;  # 显示候选数
        horizontal-pad  = 20;
        vertical-pad    = 12;
        inner-pad       = 4;
        prompt          = "  "; # 搜索图标
      };
      colors = {
        background    = "1e1e2eee"; # Catppuccin Mocha Base（带透明）
        text          = "cdd6f4ff"; # Text
        selection     = "313244ff"; # Surface 0
        selection-text = "89b4faff"; # Blue
        border        = "89b4faff"; # Blue
        match         = "89b4faff"; # Blue（匹配高亮）
      };
      border = {
        width  = 2;
        radius = 10;
      };
    };
  };

  # ══════════════════════════════════════════════════════════
  # 10. XDG 目录规范
  # ══════════════════════════════════════════════════════════
  xdg = {
    enable = true;
    userDirs = {
      enable       = true;
      createDirectories = true;
      desktop      = "$HOME/Desktop";
      documents    = "$HOME/Documents";
      download     = "$HOME/Downloads";
      music        = "$HOME/Music";
      pictures     = "$HOME/Pictures";
      videos       = "$HOME/Videos";
      templates    = "$HOME/Templates";
      publicShare  = "$HOME/Public";
    };

    # 默认应用关联
    mimeApps = {
      enable = true;
      defaultApplications = {
        # 浏览器
        "text/html"              = "google-chrome.desktop";
        "x-scheme-handler/http"  = "google-chrome.desktop";
        "x-scheme-handler/https" = "google-chrome.desktop";
        # 图片
        "image/jpeg"             = "imv.desktop";
        "image/png"              = "imv.desktop";
        "image/gif"              = "imv.desktop";
        "image/webp"             = "imv.desktop";
        # 视频
        "video/mp4"              = "mpv.desktop";
        "video/mkv"              = "mpv.desktop";
        "video/webm"             = "mpv.desktop";
        # 文件管理器
        "inode/directory"        = "org.gnome.Nautilus.desktop";
        # 文本编辑
        "text/plain"             = "code.desktop";
      };
    };
  };

  # ══════════════════════════════════════════════════════════
  # 11. 启用 Home Manager 自管理
  # ══════════════════════════════════════════════════════════
  programs.home-manager.enable = true;
}
