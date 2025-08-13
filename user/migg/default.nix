{
  user,
  pkgs,
  lib,
  ...
}:
{
  users.users.migg = {
    isNormalUser = true;
    description = "Migg";
    openssh.authorizedKeys.keys = [
      # replace with your own public key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHqQzVvsr6PZhAhI+TgpAsTPh0YbSGyaRTwGRQvIrBvY migg@DESKTOP-RVPOP3B"
    ];
    hashedPassword = "$y$j9T$JIPsM36vqB7s80SNHCVp7/$bMtm/gwd2lrOrdSE8Vo.el/D1h/mylsuA/ugbgmvxVA";
    packages = with pkgs; [
      nodejs_22
      corepack_22
    ];
  };
  # nixpkgs.config.allowBroken = true;
  # services.openvscode-server = {
  #   enable = true;
  #   group = "migg";
  #   user = "migg";
  #   port = 3005;
  # };
}
