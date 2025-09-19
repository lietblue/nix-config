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
      lib = {
        mkDiskConfig = (import ./disk) { inherit inputs; };
        # Predefined disk configurations for common use cases
        diskConfigs = {
          default = (import ./disk) { inherit inputs; } {};
          nvme = (import ./disk) { inherit inputs; } { device = "/dev/nvme0n1"; };
          sata = (import ./disk) { inherit inputs; } { device = "/dev/sda"; };
          withSwap = (import ./disk) { inherit inputs; } { swapSize = "16G"; };
          ext4 = (import ./disk) { inherit inputs; } { rootFormat = "ext4"; };
        };
      };
      
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
        # Example host using modular disk configuration with custom values
        example-host = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = with inputs; [
            ./user/root
            ./user/liet-v2
            ./desktop-env/kde-plasma
            # Use elegant lib interface with custom configuration
            (self.lib.mkDiskConfig {
              device = "/dev/sda";
              diskName = "example-disk";
              espSize = "1G";
              swapSize = "16G";
              rootFormat = "ext4";
            })
            home-manager.nixosModules.home-manager
            flake-programs-sqlite.nixosModules.programs-sqlite
            {
              networking.hostName = "example-host";
            }
            { system.configurationRevision = self.rev or "dirty"; }
          ];
          specialArgs = {
            inherit inputs;
          }; 
        };
        # Example host using predefined default disk configuration - most elegant!
        default-disk-host = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = with inputs; [
            ./user/root
            ./user/liet-v2
            ./desktop-env/kde-plasma
            # Use predefined default configuration - super clean!
            self.lib.diskConfigs.default
            home-manager.nixosModules.home-manager
            flake-programs-sqlite.nixosModules.programs-sqlite
            {
              networking.hostName = "default-disk-host";
            }
            { system.configurationRevision = self.rev or "dirty"; }
          ];
          specialArgs = {
            inherit inputs;
          }; 
        };
        # Example host using predefined SATA disk configuration
        sata-disk-host = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = with inputs; [
            ./user/root
            ./user/liet-v2
            ./desktop-env/kde-plasma
            # Use predefined SATA configuration
            self.lib.diskConfigs.sata
            home-manager.nixosModules.home-manager
            flake-programs-sqlite.nixosModules.programs-sqlite
            {
              networking.hostName = "sata-disk-host";
            }
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
