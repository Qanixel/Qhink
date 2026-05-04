{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # 硬件配置（由系统生成）
    ./hardware-configuration.nix

    # NixOS 核心模块
    ../../modules/nixos/core/nix.nix
    ../../modules/nixos/core/boot.nix
    ../../modules/nixos/core/users.nix
    ../../modules/nixos/core/environment.nix

    # 硬件支持
    ../../modules/nixos/hardware/nvidia.nix
    ../../modules/nixos/hardware/audio.nix
    ../../modules/nixos/hardware/bluetooth.nix

    # 桌面环境与字体
    ../../modules/nixos/desktop/fonts.nix
    ../../modules/nixos/desktop/temporary.nix

    # 国际化与输入法
    ../../modules/nixos/i18n/locale.nix
    ../../modules/nixos/i18n/input-method.nix

    # 服务
    ../../modules/nixos/services/networking.nix
    ../../modules/nixos/services/ssh.nix
    ../../modules/nixos/services/system-services.nix
  ];

  # 主机名
  networking.hostName = "Qhink";

  # 键盘映射：交换 Alt 和 Super 键，模拟 Mac 布局
  services.xserver.xkb.options = "altwin:swap_lalt_lwin";
  # 如果你使用控制台，也可以统一配置
  console.useXkbConfig = true;

  # 系统版本标记
  system.stateVersion = "25.05";
}
