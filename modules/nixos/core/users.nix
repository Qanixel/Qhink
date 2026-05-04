{ pkgs, ... }:

{
  # TODO 用户配置是否有点冗余了？
  users.users.qanix = {
    isNormalUser = true;
    description = "qanix";
    initialPassword = "xqapp";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
      "render"
    ];
    shell = pkgs.zsh;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
    extraConfig = ''
      Defaults env_keep += "HOME"
      Defaults timestamp_timeout=30
    '';
  };
}
