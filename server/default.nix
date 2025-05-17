{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  nix.settings.substituters = [
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
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

  users.mutableUsers = false;
  security.sudo.wheelNeedsPassword = false;

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  services.displayManager.ly.enable = true;

  environment.systemPackages = with pkgs; [
    # base system
    git
    nano

    # 有些东西该啊啊大叫
    gnutar

    pciutils # lspci
    usbutils # lsusb

    nmap

    vim # 有人在我电脑打vim发现找不到
    htop
    lm_sensors
    ethtool
    hyfetch
    fastfetch # 防爆柜

    nix-output-monitor # 米奇妙妙 nix 输出查看器
  ];

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
    "C.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_US.UTF-8";

  environment.variables.EDITOR = "nano";

  boot.tmp.cleanOnBoot = true;

  services.openssh = {
    enable = true;
    settings = {
      #PermitRootLogin = "yes";
      #PasswordAuthentication = true;
    };
    openFirewall = true;
  };

  time.timeZone = "Asia/Shanghai";
}
