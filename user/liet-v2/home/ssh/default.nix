{ config, pkgs, ... }:
{
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    addKeysToAgent = "2h";
    # todo host info need a safer place
    matchBlocks = { };
  };
}
