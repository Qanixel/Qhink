{ pkgs, ... }:

{
  nix = {
    # 1. 核心设置 (必要)
    settings = {
      experimental-features = [ "nix-command" "flakes" ]; # 启用现代 Nix 命令和 Flakes
      trusted-users = [ "root" "qanix" ];                # 允许普通用户管理缓存 (非常建议)
      
      # 2. 二进制缓存 (建议：国内镜像 + 特定项目缓存)
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://niri.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfx7LRyRRxdSAQQ1Ldx3X0/MRWXY0="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];

      # 3. 性能与存储优化 (非必要但强烈建议)
      auto-optimise-store = true; # 自动硬链接重复文件，节省空间
      max-jobs = "auto";          # 最大并行构建任务数
    };

    # 4. 自动化维护 (非必要但建议)
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d"; # 自动清理 30 天前的旧世代
    };
  };
}