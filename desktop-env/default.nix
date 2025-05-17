{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    ./common/font.nix
    ./common/fcitx5.nix
  ];
}
