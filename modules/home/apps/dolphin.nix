{ ... }:

{
  programs.dolphin = {
    enable = true;

    # Dolphin 设置
    settings = {
      # 通用设置
      General = {
        BrowseThroughArchives = true;        # 允许浏览压缩文件
        ConfirmClosingMultipleTabs = false;  # 关闭多个标签页时不确认
        EditableUrl = true;                  # URL 栏可编辑
        FilterBar = true;                    # 显示过滤栏
        GlobalViewProps = true;              # 全局视图属性
        ShowFullPath = true;                 # 显示完整路径
        ShowFullPathInTitlebar = true;       # 在标题栏显示完整路径
        ShowSelectionToggle = true;          # 显示选择切换按钮
        UseTabForSwitchingSplitView = true;  # 使用 Tab 键切换分割视图
      };

      # 视图设置
      "KFileDialog Settings" = {
        "Automatically select filename extension" = true;
        "Show hidden files" = true;           # 显示隐藏文件
        "Show speedbar" = true;               # 显示速度栏
        "Show bookmarks" = true;              # 显示书签
        "Sort by" = "Name";                   # 按名称排序
        "Sort directories first" = true;      # 目录优先排序
        "Sort hidden last" = true;            # 隐藏文件最后排序
        "View Style" = "Details";             # 详细视图
      };

      # 详细信息视图设置
      "DetailsMode" = {
        "ExpandableFolders" = true;           # 可展开文件夹
        "PreviewSize" = 256;                  # 预览大小
        "UseRelativesDates" = true;           # 使用相对日期
      };

      # 图标视图设置
      "IconsMode" = {
        "MaximumTextLines" = 2;               # 最大文本行数
        "PreviewSize" = 128;                  # 预览大小
        "TextWidthIndex" = 0;                 # 文本宽度索引
      };

      # 紧凑视图设置
      "CompactMode" = {
        "MaximumTextLines" = 1;               # 最大文本行数
        "PreviewSize" = 64;                   # 预览大小
      };

      # 上下文菜单设置
      ContextMenus = {
        ShowCopyToOtherSplitView = true;      # 显示复制到其他分割视图
        ShowMoveToOtherSplitView = true;      # 显示移动到其他分割视图
        ShowOpenTerminal = true;              # 显示打开终端
        ShowSortBy = true;                    # 显示排序选项
      };

      # 版本控制设置
      VersionControl = {
        enabledPlugins = "git";               # 启用 Git 插件
      };
    };
  };
}