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
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    # modify based on need
    ../../disk-composition/gpt-bios-compat.nix
    ../../user/root
  ];

  nix.settings.substituters = [
    "https://mirror.sjtu.edu.cn/nix-channels/store"
    "https://cache.nixos.org"
  ];
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  environment.systemPackages = with pkgs; [
    #gitMinimal
    git
    nano
    fastfetch
  ];
  time.timeZone = "Asia/Shanghai";

  users.mutableUsers = false;

  services.openssh = {
    enable = true;
    settings = {
      #PermitRootLogin = "yes";
      #PasswordAuthentication = true;
    };
    openFirewall = true;
  };

  boot.tmp.cleanOnBoot = true;
  networking.hostName = "bootstrap";
  security.sudo.wheelNeedsPassword = false;

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
    "C.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_US.UTF-8";

  environment.variables.EDITOR = "nano";
  system.stateVersion = "24.11";
}
