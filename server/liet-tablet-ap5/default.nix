{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
# Liet的契约
{
  imports = [
    ./hardware-configuration.nix
    # modify based on need
    ./disk.nix
    ../../user/liet
    ./..
  ];
  boot.loader.grub = rec {
    device = "nodev";
    efiSupport = true;
    theme = inputs.honkai-railway-grub-theme.packages.x86_64-linux.march7th-thehunt_cn-grub-theme;
    splashImage = "${theme}/background.png";
    memtest86.enable = true;
    #efiInstallAsRemovable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.firewall.allowedTCPPorts = [ 53317 ];

  hardware.bluetooth.enable = true;

  networking.hostName = "liet-tablet-ap5";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "24.11";
}
