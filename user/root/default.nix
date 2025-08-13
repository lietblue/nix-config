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
    hashedPassword = "$y$j9T$oyHUzOw9l5wC24ZmNm44r1$NHqGpVwgI6w57qxyqWYXf3kcMZJ39AS7obSj78CGEe4";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvAHjQDflHG4EGpJralY9rgmdn33qUbt17AU0AbDgF5 liet-key-20231122"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKRQW5QLkpJwkq9VGmhiUgd2glOarlyoCYNYz27W/yEn"
    ];
  };
}
