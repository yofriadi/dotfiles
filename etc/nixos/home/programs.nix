{ config, pkgs, ... }:

{
  imports = [
    ./programs
  ];

  home.packages = with pkgs; [
    git
    lsd  # ls
    eza  # ls
    fd
    fzf
    delta
    jless
    ripgrep
    ripgrep-all
    zoxide
    yazi
    jaq
    difftastic
    csvlens
    watchexec
    just
    dust
    navi
    tokei
    sd
    sad  # sd but tui
    mise
    bottom
    gping
    procs
    xh
    tealdeer
    cmd-wrapped  # basically inessetial this and below
    macchina
    onefetch
    shfmt
    doggo

    # looks unmaintained
    trashy
  ];
  
  programs.home-manager.enable = true;

  # Make fish as default shell
  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "${pkgs.fish}/bin/fish";
  };
}
