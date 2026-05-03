# NixOS 配置文件说明
# qhink | qanix | Intel + RTX 5060 Ti + Niri + 中文环境

## 文件结构

```
~/.config/nixos/              ← 建议存放位置（可用 git 管理）
├── flake.nix                 # Flake 入口：输入源 + 系统定义
├── flake.lock                # 锁定文件（首次 nix flake update 自动生成）
├── configuration.nix         # 系统级配置（引导/硬件/服务/字体等）
├── home.nix                  # 用户级配置（Shell/终端/桌面应用等）
├── hardware-configuration.nix  # ⚠ 由 nixos-generate-config 自动生成，勿手动创建
└── README.md                 # 本文件
```

---

## 安装步骤

### 1. 安装 NixOS 基础系统

按照官方安装介质引导，分区并挂载文件系统后执行：

```bash
nixos-generate-config --root /mnt
```

这会在 `/mnt/etc/nixos/` 生成 `hardware-configuration.nix`。

### 2. 克隆本配置

```bash
# 进入安装环境 Shell
nixos-install --no-root-passwd  # 先跑一次确认基础无误

# 将配置文件复制到目标位置
cp -r /path/to/nixos-config/* /mnt/etc/nixos/
# 或者克隆 git 仓库
git clone <your-repo> /mnt/etc/nixos/
```

### 3. 关键：复制 hardware-configuration.nix

```bash
# hardware-configuration.nix 由 nixos-generate-config 生成，不要用本仓库的
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hardware-configuration.nix
# 已经在正确位置，无需额外操作
```

### 4. 首次构建

```bash
nixos-install --flake /mnt/etc/nixos#qhink
```

### 5. 重启后的首次配置

```bash
# 修改初始密码
passwd qanix

# 将配置目录移至用户家目录（方便管理）
sudo mv /etc/nixos ~/.config/nixos
sudo ln -s ~/.config/nixos /etc/nixos  # 可选：保持 /etc/nixos 软链接

# 更新 Flake 锁（获取最新包）
nix flake update --flake ~/.config/nixos

# 应用配置
sudo nixos-rebuild switch --flake ~/.config/nixos#qhink
```

---

## 常用命令（已配置别名）

| 别名  | 完整命令                                                      | 说明         |
|-------|---------------------------------------------------------------|--------------|
| `nrs` | `sudo nixos-rebuild switch --flake ~/.config/nixos#qhink`    | 立即应用配置 |
| `nrt` | `sudo nixos-rebuild test --flake ~/.config/nixos#qhink`       | 测试配置     |
| `nrb` | `sudo nixos-rebuild boot --flake ~/.config/nixos#qhink`       | 下次启动生效 |
| `nfu` | `nix flake update --flake ~/.config/nixos`                    | 更新所有输入 |
| `ngc` | `sudo nix-collect-garbage -d`                                  | 清理旧世代   |
| `nse` | `nix search nixpkgs <包名>`                                    | 搜索软件包   |

---

## 思源笔记安装方法

由于 `siyuan` 目前在 nixpkgs 中不稳定，推荐以下两种方式：

### 方法 A：通过官方 AppImage（推荐）

```bash
# 下载最新版 AppImage
wget https://github.com/siyuan-note/siyuan/releases/latest/download/siyuan-linux.AppImage
chmod +x siyuan-linux.AppImage

# 使用 appimage-run 运行（需在 configuration.nix 中启用）
# programs.appimage.enable = true;
appimage-run siyuan-linux.AppImage
```

在 `configuration.nix` 中添加：

```nix
programs.appimage = {
  enable = true;
  binfmt = true;  # 允许直接运行 AppImage
};
```

### 方法 B：通过 Flatpak

```bash
# 在 configuration.nix 中启用：services.flatpak.enable = true;
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.siyuan.siyuan
```

---

## 显示器名称查询

安装完成登录 Niri 后，运行以下命令查看实际显示器标识符：

```bash
niri msg outputs
# 示例输出：DP-1, HDMI-A-1 等
```

将 `home.nix` 中 `"DP-1"` 替换为实际名称。

---

## NVIDIA 驱动验证

```bash
# 确认驱动已加载
nvidia-smi

# 确认 Wayland + NVIDIA 渲染正常
vulkaninfo --summary | grep -i nvidia

# 查看 GPU 使用率
nvtop
```

---

## 中文输入法

Fcitx5 开机自动启动（由 Niri 的 `spawn-at-startup` 管理）。

- **切换输入法**：`Ctrl+Space` 或 `Super+Space`（请在 Fcitx5 配置工具中确认）
- **图形化配置**：运行 `fcitx5-configtool`
- **词库位置**：`~/.local/share/fcitx5/pinyin/`

如果输入法无法弹出，检查环境变量：

```bash
echo $GTK_IM_MODULE  # 应为 fcitx
echo $QT_IM_MODULE   # 应为 fcitx
echo $XMODIFIERS     # 应为 @im=fcitx
```

---

## 镜像源说明

配置使用清华大学 TUNA 镜像加速：

- **二进制缓存**：`https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store`
- **官方缓存（兜底）**：`https://cache.nixos.org`

如需切换其他镜像，修改 `configuration.nix` 中 `nix.settings.substituters`。

---

## 许可

本配置文件可自由修改和分发，无版权限制。
