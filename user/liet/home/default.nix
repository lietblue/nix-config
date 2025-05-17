{ config, pkgs, ... }:
{
  imports = [
    ./ssh
  ];

  programs.git = {
    enable = true;
    userName = "Liet Blue";
    userEmail = "lietblue@posteo.net";
  };

  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
  '';

  home.packages = with pkgs; [
    kitty
    clash-nyanpasu
    hmcl
    nixfmt-rfc-style
    nil
    podman
    nixos-anywhere
    firefox
    vscodium
    localsend
    telegram-desktop
  ];

  home.username = "liet";
  home.homeDirectory = "/home/liet";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
