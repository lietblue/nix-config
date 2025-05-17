{
  description = "Liet Blue desktop env";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    honkai-railway-grub-theme.url = "github:voidlhf/StarRailGrubThemes";
    impermanence.url = "github:nix-community/impermanence";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-programs-sqlite = {
      # 原来是有成品方案的 对 nix channel 哈气了
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    umu = {
      url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Any env
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {
        liet-tablet-ap5 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = with inputs; [
            ./server/liet-tablet-ap5
            ./desktop-env/kde-plasma
            ./desktop-env/hyperland
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            flake-programs-sqlite.nixosModules.programs-sqlite
          ];
          specialArgs = {
            inherit inputs;
          };
        };
      };
      packages.x86_64-linux = {
        #topLevelImage = self.nixosConfigurations.bootstrap.config.system.build.toplevel;
        #diskoScript = self.nixosConfigurations.bootstrap.config.system.build.diskoScript;
      };
    };
}
