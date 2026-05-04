{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # 硬件配置（由系统生成）
    ./hardware-configuration.nix

    # 可复用的 NixOS 模块集合
    ../../modules/nixos
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
