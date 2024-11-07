{ config, pkgs, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = "tokyonight_storm";
    };
  };
}
