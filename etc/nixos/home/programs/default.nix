{ config, pkgs, ... }:

{
  imports = [
    ./atuin.nix
    ./bat.nix
    ./fish.nix
    ./git.nix
    ./helix.nix
    ./neovim.nix
    ./zellij.nix
  ];
}
