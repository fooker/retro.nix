{ lib, pkgs, ... }:

with lib;

{
  imports = [
    ./systems.nix
    ./inputs.nix
    ./games.nix
  ];

  config = {
    # TODO: Add assertion to check emulator names are globally unique
  };
}