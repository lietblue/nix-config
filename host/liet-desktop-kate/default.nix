{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:{
  
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

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  security.sudo.wheelNeedsPassword = false;
  users.mutableUsers = false;
  time.timeZone = "Asia/Shanghai";
  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    podman-compose # start group of containers for dev


    # base system
    git
    nano

    # 有些东西该啊啊大叫
    gnutar

    pciutils # lspci
    usbutils # lsusb
    smartmontools # smartctl

    nmap

    vim # 有人在我电脑打vim发现找不到
    htop
    lm_sensors
    ethtool
    hyfetch
    fastfetch # 防爆柜

    nix-output-monitor # 米奇妙妙 nix 输出查看器
    efibootmgr # manage efi
  ];

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
    "C.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_US.UTF-8";

  environment.variables.EDITOR = "nano";
  networking.hostName = "liet-desktop-kate";
  boot.tmp.cleanOnBoot = true;

  services.openssh = {
    enable = true;
    settings = {
      #PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };
  # networking.firewall.allowedTCPPorts = [ 
  #   3000 
  #   3001
  #   3005
  #   5200 
  # ];
  services.displayManager.ly.enable = true;
  system.stateVersion = "25.05";
}