{
  description = "qhink 的模块化 NixOS 配置";

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

  outputs = inputs@{ self, nixpkgs, home-manager, noctalia, ... }:
  let
    lib = nixpkgs.lib;
    systems = [ "x86_64-linux" ];
    forAllSystems = lib.genAttrs systems;

    pkgsFor = system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    user = "qanix";
  in
  {
    formatter = forAllSystems (system:
      (pkgsFor system).alejandra
    );

    nixosConfigurations = {
      qhink = lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit inputs self; };

        modules = [
          ./hosts/qhink

          # 拆分后的模块
          ./modules/nix.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              extraSpecialArgs = { inherit inputs self noctalia; };

              users.${user} = import ./hosts/qhink/home.nix;
            };
          }
        ];
      };
    };
  };
}