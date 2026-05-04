{pkgs, ...}: {
  home.packages = with pkgs; [
    nixd
    alejandra
    nix-tree
    nix-index
    # nixpkgs-fmt  # 既然有了 alejandra，这个可以注释掉以保持纯净
  ];

  # 补充配置：让工具更好用
  programs = {
    # 启用 nix-index 的 shell 集成
    # 这样当你输入一个未安装的命令时，它会自动提示你用哪个包
    nix-index.enable = true;
    nix-index.enableZshIntegration = true; # 如果你用 zsh
    nix-index.enableBashIntegration = true; # 如果你用 bash
  };

  # 解决 nixd 的路径搜索问题
  # 确保在终端或编辑器中，nix 相关的环境变量是正确的
  home.sessionVariables = {
    # 告诉一些旧工具 nixpkgs 的位置
    NIX_PATH = "nixpkgs=\${HOME}/Qhink/nixpkgs:nixpkgs-overlays=\${HOME}/Qhink/overlays:\$NIX_PATH";
  };
}
