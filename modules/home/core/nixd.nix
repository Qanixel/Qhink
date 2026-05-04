{pkgs, ...}: {
  # 1. 安装 nixd 以及配套的 Nix 开发工具
  home.packages = with pkgs; [
    nixd # 核心：Nix 语言服务器
    alejandra # 社区推荐：语法最严格、最整齐的 Nix 格式化工具
    nix-tree # 实用：以树状图查看 Nix 派生文件的依赖关系
    nix-index # 实用：查找某个文件属于哪个 nixpkgs 软件包 (指令：nix-locate)
    nixpkgs-fmt # 备选：传统的 nixpkgs 标准格式化工具
  ];
}
