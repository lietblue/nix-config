{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  systemd.network.networks.eth0 = {
    address = [ "whatever/24" ];
    gateway = [ "whereever" ];
    matchConfig.Name = "eth0";
  };
  networking.nameservers = [
    "119.29.29.29"
  ];
  systemd.network.enable = true;
  services.resolved.enable = false;

}
