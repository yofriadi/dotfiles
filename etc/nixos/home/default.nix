{ config, pkgs, ... }:

{
  imports = [
    ../hosts/msl/home.nix
    ./programs.nix
  ];
}
