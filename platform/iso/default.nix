{ pkgs, modulesPath, ... }: 
{
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
  environment.systemPackages = [ pkgs.fastfetch ];
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  networking.hostName = "liet-bootstrap-iso";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKRQW5QLkpJwkq9VGmhiUgd2glOarlyoCYNYz27W/yEn liet-meilin"
  ];
}