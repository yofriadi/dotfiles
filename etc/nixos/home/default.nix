{ config, pkgs, ... }:

{
  imports = [
    ../hosts/wsl/home.nix
    ./programs.nix
  ];
}
