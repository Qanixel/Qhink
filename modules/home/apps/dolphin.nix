{
  config,
  pkgs,
  ...
}: {
  # 确保安装了 Dolphin 及其必要的依赖
  home.packages = with pkgs; [
    kdePackages.dolphin
    kdePackages.ffmpegthumbs # 视频缩略图支持
    kdePackages.kdegraphics-thumbnailers # 图片/PDF 缩略图支持
  ];

  # 直接管理 Dolphin 配置文件
  home.file.".config/dolphinrc".text = ''
    [General]
    # 在新标签页而非新窗口中打开文件夹
    OpenExternallyCalledFolderInNewTab=true
    # 在标题栏显示完整路径
    ShowFullPath=true
    # 确认删除（防止误删）
    ConfirmDelete=true

    [IconsMode]
    # 图标模式下的预览大小
    IconSize=64

    [PreviewSettings]
    # 启用的预览插件
    Plugins=directorythumbnail,imagethumbnail,ffmpegthumbs,fontthumbnail,kio-extras

    [DetailsMode]
    # 在详细列表模式下显示符号链接的目标
    ShowTarget=true
  '';

  # 可选：管理全局视图属性（例如默认排序方式、是否显示隐藏文件）
  home.file.".local/share/dolphin/view_properties/global/.directory".text = ''
    [MainView]
    # 默认不显示隐藏文件
    HiddenFilesShown=false
    # 视图模式 (1 为图标模式, 2 为列表模式)
    Mode=1
    # 排序方式
    SortRole=text
  '';
}
