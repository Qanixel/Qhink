{pkgs, ...}: {
  # 1. 安装 nixd 以及配套的 Nix 开发工具
  home.packages = with pkgs; [
    nixd # 核心：Nix 语言服务器
    alejandra # 社区推荐：语法最严格、最整齐的 Nix 格式化工具
    nix-tree # 实用：以树状图查看 Nix 派生文件的依赖关系
    nix-index # 实用：查找某个文件属于哪个 nixpkgs 软件包 (指令：nix-locate)
    nixpkgs-fmt # 备选：传统的 nixpkgs 标准格式化工具
  ];

  # 补充配置：让工具更好用
  programs = {
    # 启用 nix-index 的 shell 集成
    # 这样当你输入一个未安装的命令时，它会自动提示你用哪个包
    nix-index.enable = true;
    nix-index.enableZshIntegration = true; # 如果你用 zsh
    nix-index.enableBashIntegration = true; # 如果你用 bash
  };

  # # 解决 nixd 的路径搜索问题
  # # 确保在终端或编辑器中，nix 相关的环境变量是正确的
  # home.sessionVariables = {
  #   # 告诉一些旧工具 nixpkgs 的位置
  #   NIX_PATH = "nixpkgs=\${HOME}/Qhink/nixpkgs:nixpkgs-overlays=\${HOME}/Qhink/overlays:\$NIX_PATH";
  # };
}
