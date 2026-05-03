# NixOS 模块化配置文件
# qhink | qanix | Intel + RTX 5060 Ti + 中文环境

本配置已根据最新的模块化理念进行重构，将系统配置与用户配置进行解耦，方便维护和扩展。

## 目录结构

```
~/.config/nixos/
├── flake.nix                 # Flake 入口：定义输入源与主机定义
├── hosts/                    # 主机特定配置
│   └── qhink/
│       ├── default.nix       # 主机系统入口（导入模块）
│       ├── home.nix          # 主机用户入口（导入 HM 模块）
│       └── hardware-configuration.nix # ⚠ 硬件扫描生成文件
├── modules/                  # 可复用功能模块
│   ├── nixos/                # NixOS 系统级模块
│   │   ├── core/             # 核心配置（Nix, Boot, Users, Env）
│   │   ├── hardware/         # 硬件驱动（Nvidia, Audio, BT）
│   │   ├── desktop/          # 桌面环境（Fonts）
│   │   ├── i18n/             # 国际化（Locale, Input Method）
│   │   └── services/         # 系统服务（Network, SSH）
│   └── home/                 # Home Manager 用户级模块
│       ├── core/             # 基础（Shell, Packages, XDG）
│       ├── apps/             # 应用程序（VSCode, Ghostty, Git）
│       └── desktop/          # 桌面应用（Waybar, Mako, Fuzzel）
└── backup/                   # 旧配置备份
```

---

## 安装与部署

### 1. 准备硬件配置

在安装环境中生成硬件配置：
```bash
nixos-generate-config --root /mnt
```
将生成的 `/mnt/etc/nixos/hardware-configuration.nix` 覆盖到本仓库的 `hosts/qhink/hardware-configuration.nix`。

### 2. 首次构建

```bash
nixos-install --flake .#qhink
```

### 3. 应用配置（已设置别名）

| 别名  | 说明         |
|-------|--------------|
| `nrs` | 立即应用配置 |
| `nrt` | 测试配置     |
| `nrb` | 下次启动生效 |
| `nfu` | 更新 Flake   |
| `ngc` | 垃圾回收     |

---

## 模块化说明

- **解耦**：所有功能均拆分为独立文件。例如，如需更换显卡驱动，只需修改 `modules/nixos/hardware/nvidia.nix`。
- **可维护性**：`hosts/qhink/default.nix` 集中管理该主机启用的所有模块。
- **用户配置**：通过 `hosts/qhink/home.nix` 组织 Home Manager 模块，实现高度定制化。

---

## 关键功能支持

- **中文环境**：全系统简体中文，Fcitx5 输入法（含维基百科词库）。
- **字体优化**：使用 Maple Mono (Nerd Font) 作为默认等宽字体，Noto CJK 系列解决中日文字形冲突。
- **最新驱动**：支持 RTX 5060 Ti (Blackwell) 的最新 NVIDIA 驱动。
- **现代桌面**：配套 Ghostty、Waybar、Mako 等。

---

## 注意事项

1. **显示器标识符**：请根据您的窗口管理器配置相应的输出名称。
2. **初始密码**：初始密码为 `xqapp`，登录后请立即修改。
3. **备份**：原始的单体配置文件已移动到 `backup/` 文件夹。
