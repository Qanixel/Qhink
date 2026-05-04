{
  description = "Qhink flakes 配置";

  nixConfig = {
    extra-substituters = ["https://noctalia.cachix.org"];
    extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    noctalia,
    ...
  }: let
    lib = nixpkgs.lib;
    systems = [
      "x86_64-linux"
      # "aarch64-darwin"
    ];
    forAllSystems = lib.genAttrs systems;

    pkgsFor = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    user = "qanix";
  in {
    formatter = forAllSystems (
      system:
        (pkgsFor system).alejandra
    );

    nixosConfigurations = {
      qhink = lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {inherit inputs self;};

        modules = [
          ./hosts/qhink/default.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              extraSpecialArgs = {inherit inputs self noctalia;};

              users.${user} = import ./hosts/qhink/home.nix;
            };
          }
        ];
      };
    };
  };
}
