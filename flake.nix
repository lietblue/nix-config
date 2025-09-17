{
  description = "Liet Blue desktop env";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    honkai-railway-grub-theme.url = "github:voidlhf/StarRailGrubThemes";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
    colmena.url = "github:zhaofengli/colmena";
  };
  outputs =
    { self, colmena, nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {
        o2-cn-east-1 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = with inputs; [
            ./user/root
            ./user/dustella
            ./host/o2-cn-east-1
            ./platform/aliyun-swas
            ./platform/aliyun-swas/disk
            disko.nixosModules.disko
            flake-programs-sqlite.nixosModules.programs-sqlite
            sops-nix.nixosModules.sops
            # {
            #   system.configurationRevision = if (builtins.pathExists ./.git) then
            #     builtins.readFile (builtins.fetchGit { url = ./.; rev = "HEAD"; } + "/.git/HEAD")
            #   else
            #     null;
            # }
            { system.configurationRevision = self.rev or "dirty"; }
          ];
          specialArgs = {
            inherit inputs;
          }; 
        };
        liet-desktop-kate = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = with inputs; [
            ./user/root
            ./user/liet-v2
            ./desktop-env/kde-plasma
            # ./user/migg
            ./host/liet-desktop-kate
            ./platform/c7-amd
            ./platform/c7-amd/disk
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            flake-programs-sqlite.nixosModules.programs-sqlite
            # {
            #   system.configurationRevision = if (builtins.pathExists ./.git) then
            #     builtins.readFile (builtins.fetchGit { url = ./.; rev = "HEAD"; } + "/.git/HEAD")
            #   else
            #     null;
            # }
            { system.configurationRevision = self.rev or "dirty"; }
          ];
          specialArgs = {
            inherit inputs;
          }; 
        };
        liet-tablet-ap5 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";     
          modules = with inputs; [
            ./server/liet-tablet-ap5
            ./desktop-env/kde-plasma
            ./desktop-env/hyperland
            ./desktop-env/gnome
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            flake-programs-sqlite.nixosModules.programs-sqlite
            # {
            #   system.configurationRevision = if (builtins.pathExists ./.git) then
            #     builtins.readFile (builtins.fetchGit { url = ./.; rev = "HEAD"; } + "/.git/HEAD")
            #   else
            #     null;
            # }
            { system.configurationRevision = self.rev or "dirty"; }
          ];
          specialArgs = {
            inherit inputs;
          };
        };
        bootstrap-iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = with inputs; [
            ./platform/iso
          ];
        };
        bootstrap = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = with inputs; [
            ./user/root
            ./host/o2-cn-east-1
            ./platform/aliyun-swas
            ./platform/aliyun-swas/disk
            disko.nixosModules.disko
            flake-programs-sqlite.nixosModules.programs-sqlite
            # {
            #   system.configurationRevision = if (builtins.pathExists ./.git) then
            #     builtins.readFile (builtins.fetchGit { url = ./.; rev = "HEAD"; } + "/.git/HEAD")
            #   else
            #     null;
            # }
            { system.configurationRevision = self.rev or "dirty"; }
          ];
          specialArgs = {
            inherit inputs;
          }; 
        };
      };
      colmenaHive = colmena.lib.makeHive {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [];
          };
        };
        o2-cn-east-1 = {
          imports = with inputs; [
            ./user/root
            ./user/dustella
            ./host/o2-cn-east-1
            ./platform/aliyun-swas
            ./platform/aliyun-swas/disk
            disko.nixosModules.disko
            # flake-programs-sqlite.nixosModules.programs-sqlite
            # {
            #   system.configurationRevision = if (builtins.pathExists ./.git) then
            #     builtins.readFile (builtins.fetchGit { url = ./.; rev = "HEAD"; } + "/.git/HEAD")
            #   else
            #     null;
            # }
            { system.configurationRevision = self.rev or "dirty"; }
          ];
          specialArgs = {
            inherit inputs;
          }; 
        };
      };
      packages.x86_64-linux = {
        bootstrapIso = self.nixosConfigurations.bootstrap-iso.config.system.build.isoImage;
        topLevelImage = self.nixosConfigurations.o2-cn-east-1.config.system.build.toplevel;
        diskoScript = self.nixosConfigurations.o2-cn-east-1.config.system.build.diskoScript;
      };
    };
}
