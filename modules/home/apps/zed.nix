{ pkgs, lib, ... }:

{
  programs.zed-editor = {
    enable = true;

    # Extensions to install (Home Manager handles the download)
    extensions = [ "nix" "catppuccin" ];

    # This replaces xdg.configFile."zed/settings.json"
    userSettings = {
      theme = "Catppuccin Mocha";
      ui_font_size = 16;
      buffer_font_family = "Maple Mono NF";
      buffer_font_size = 14;
      terminal = {
        font_family = "Maple Mono NF";
        copy_on_select = true;
      };
      format_on_save = "on";
      languages = {
        Nix = {
          language_servers = [ "nixd" ];
        };
      };
      vim_mode = false;
    };

    # Optional: Keybindings can also be managed here
    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          "ctrl-alt-x" = "editor::CheckSelection";
        };
      }
    ];
  };
}
