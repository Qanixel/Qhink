{ pkgs, ... }:

{
  programs.zsh.enable = true;

  services = {
    dbus.enable = true;
    printing.enable = false;
    udev.enable = true;
    gvfs.enable = true;
    # gnome.gnome-keyring.enable = true;
  };
}
