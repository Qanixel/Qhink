{ config, pkgs, ... }:

{
  # 开启显卡驱动
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # 5060 Ti 属于新架构，建议使用最新的生产分支或 Stable 驱动
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # 对于 16 系列及以后的显卡，open 为 true 通常更稳定且性能更好
    open = true;

    modesetting.enable = true;

    # 针对现代显卡的电源管理
    powerManagement = {
      enable = true;
      # 如果是笔记本建议开启 finegrained，台式机保持 false 以获取高性能
      finegrained = false;
    };

    # 启用 NVIDIA 设置面板
    nvidiaSettings = true;

    # 关键优化：解决 Wayland 下的闪烁或同步问题
    # 强制启用 Nvidia 的显存同步处理
    forceFullCompositionPipeline = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # 硬件加速接口
      nvidia-vaapi-driver
      libvdpau-va-gl
      # 针对 CUDA 和 OpenCL 的支持
      libvdpau
      libva-vdpau-driver
    ];
  };

  # 环境变量优化：提升 Wayland 和视频剪辑软件的兼容性
  home-manager.users.qanix.home.sessionVariables = {
    # 强制让大部分应用走显卡硬件加速
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # 修复某些电子应用在 Wayland 下的显示问题
    NIXOS_OZONE_WL = "1";
  };
}
