{pkgs, ...}: {
  home.packages = with pkgs; [
    google-chrome
    obsidian
    logseq
    siyuan
    mpv
    imv
    pavucontrol
    thunar
    lazygit
    ripgrep
    fd
    bat
    eza
    fzf
    zoxide
    starship
    delta
    jq
    yq
    aria2
  ];
}
