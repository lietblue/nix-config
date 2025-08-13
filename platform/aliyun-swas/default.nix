{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:{
  imports = [
    ./hardware-configuration.nix
  ];
  boot.kernelParams = [
    "audit=0"
    "net.ifnames=0"
  ];
  boot.initrd = {
    compressor = "zstd";
    compressorArgs = ["-19" "-T0"];
    systemd.enable = true;
  };
  documentation = {
    man.enable = false;
    dev.enable = false;
    doc.enable = false;
    nixos.enable = false;
  };
  boot.initrd.postDeviceCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
    # Set the system time from the hardware clock to work around a
    # bug in qemu-kvm > 1.5.2 (where the VM clock is initialised
    # to the *boot time* of the host).
    hwclock -s
  '';
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  networking.useDHCP = lib.mkDefault true;
}