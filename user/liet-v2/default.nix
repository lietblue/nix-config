{
  user,
  pkgs,
  lib,
  ...
}:
{
  users.users.liet = {
    isNormalUser = true;
    description = "Liet Blue";
    extraGroups = [
      "networkmanager"
      "wheel"
      "tss"
      "dialout"
      "plugdev"
    ];
    openssh.authorizedKeys.keys = [
      # replace with your own public key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFArgGhEUnOALCK3foeNfmrNtg4KlA8Mz9LT89hjRvLY liet-temp-2025-05-09"
    ];
    hashedPassword = "$y$j9T$JIPsM36vqB7s80SNHCVp7/$bMtm/gwd2lrOrdSE8Vo.el/D1h/mylsuA/ugbgmvxVA";
  };

  security.pam.services = {
    login.u2fAuth = true;
  };

  security.pam.u2f = {
    enable = true;
    settings = {
      origin = "pam://yubi";
      authfile = pkgs.writeText "u2f-mappings" (
        lib.concatStrings [
          "liet"
          ":PgUglaRF0CKTtvdAXLCHy4hPpZoWEYOJvphE5uMrMSg2esZUTfg9b+qVNvtTn9emmGqoziCavor5t03qh3Rwia9q54GzYu4A2bkj3wXb+ZkxJCZDGyDHuAM7Aj+AgS62G8rIZkzELGwKeEAbpfsQN5IehiAdoEMLe0hIPzqxiz8=,C/qgBiwdKswKKsvfjI6vkQRwNJDkA7wDWISxhMnf7QE=,eddsa,+presence"
        ]
      );
      interactive = true;
      cue = true;
    };
  };
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.liet = import ./home;
}
