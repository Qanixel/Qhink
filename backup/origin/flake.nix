# ============================================================
# flake.nix — NixOS Flake 入口文件
# 主机: qhink | 用户: qanix | 架构: x86_64-linux
# 全面使用 nixos-unstable 频道
# ============================================================
{
  description = "qhink 的 NixOS 配置 (Intel + RTX 5060 Ti + Niri + 中文环境)";

  # ── 输入源 ──────────────────────────────────────────────────
  inputs = {
    # NixOS 不稳定频道（滚动更新，获取最新软件包）
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager —— 管理用户级配置，跟随 nixpkgs-unstable
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # 与主 nixpkgs 版本一致，避免重复构建
    };

    # Niri —— 基于 Smithay 的平铺式 Wayland 合成器
    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ── 输出 ────────────────────────────────────────────────────
  outputs = { self, nixpkgs, home-manager, niri, ... }@inputs:
  let
    system = "x86_64-linux";

    # 构造 pkgs，允许非自由软件（NVIDIA 驱动、VSCode 等需要）
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;          # 允许非自由软件包
        allowUnfreePredicate = _: true;
      };
    };
  in
  {
    # NixOS 系统配置
    nixosConfigurations.qhink = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; }; # 将 inputs 传入所有模块

      modules = [
        # ── 核心系统配置 ──
        ./configuration.nix

        # ── Home Manager 作为 NixOS 模块集成 ──
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;    # 使用系统级 pkgs（避免重复下载）
            useUserPackages = true;  # 将 HM 包装入系统环境
            extraSpecialArgs = { inherit inputs; };
            users.qanix = import ./home.nix;
          };
        }

        # ── Niri Wayland 合成器模块 ──
        niri.nixosModules.niri
      ];
    };
  };
}
