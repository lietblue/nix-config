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

  dconf = {
    enable = true;
    settings."org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        #"appindicatorsupport@rgcjonas.gmail.com"
        alttab-scroll-workaround.extensionUuid
        auto-accent-colour.extensionUuid
        kimpanel.extensionUuid
        #gnome-shell-extensions
        dash-to-dock.extensionUuid
        blur-my-shell.extensionUuid
        boost-volume.extensionUuid
        caffeine.extensionUuid
        clipboard-indicator.extensionUuid
        desktop-clock.extensionUuid
        extension-list.extensionUuid
        night-theme-switcher.extensionUuid
        notification-counter.extensionUuid
        shutdowntimer.extensionUuid
        weather-oclock.extensionUuid
        dash-to-dock.extensionUuid
        logo-activities.extensionUuid
      ];
    };
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
    libreoffice-qt6
  ];

  home.username = "liet";
  home.homeDirectory = "/home/liet";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
