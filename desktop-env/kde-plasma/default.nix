{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    ./..
  ];
  services.desktopManager.plasma6.enable = true;
  services.xserver = {
    enable = true;
  };
}
