{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Yofriadi Yahya";
    userEmail = "yofriadi.yahya@proton.me";

    extraConfig = {
      core.excludesfile = "~/.config/.gitignore";
      pull.rebase = true;
      merge.conflictstyle = "zdiff3";

      # Delta git config
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta.navigate = true;
      delta.line-numbers = true;
      delta.features = "decorations";
    };
  };
}
