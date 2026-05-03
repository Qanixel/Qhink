{ pkgs, ... }:

{
  # 1. 安装 nixd 以及配套的 Nix 开发工具
  home.packages = with pkgs; [
    nixd          # 核心：Nix 语言服务器
    alejandra     # 社区推荐：语法最严格、最整齐的 Nix 格式化工具
    nix-tree      # 实用：以树状图查看 Nix 派生文件的依赖关系
    nix-index     # 实用：查找某个文件属于哪个 nixpkgs 软件包 (指令：nix-locate)
    nixpkgs-fmt   # 备选：传统的 nixpkgs 标准格式化工具
  ];

  # 2. 配置 VSCode 的 nixd 联动设置
  # 这里假设你已经在 home.nix 中启用了 programs.vscode
  programs.vscode.userSettings = {
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nixd";
    
    # 告诉 nixd 使用哪个工具进行格式化
    "nix.formatterPath" = "alejandra"; 
    
    # nixd 专属配置：开启诊断和对 nixpkgs 的基本支持
    "nixd.nixpkgs.expr" = "import <nixpkgs> { }";
    "nixd.options.nixos.expr" = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.qhink.options";
    
    # 编辑器层面的格式化指定
    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
      "editor.formatOnSave" = true;
    };
  };

  # 3. 可选：启用 nix-index 的 shell 集成
  programs.nix-index.enable = true;
}