{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  users.users.root = {
    hashedPassword = "$y$j9T$rs7PKfXvqv5i7IdHNM3Xu0$0p3ZpqnfI6O3jERB1hgppAdnTT5A.P8Yz6YNdvrZreD"; # s1CnO9g5QE5nYj
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvAHjQDflHG4EGpJralY9rgmdn33qUbt17AU0AbDgF5 liet-key-20231122"
    ];
  };
}
