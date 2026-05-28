{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    codex-cli-nix = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/latest";
    };
  };

  outputs =
    inputs@{
      self,
      home-manager,
      lanzaboote,
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      localPackages = {
        mihomo-config-fetcher = pkgs.callPackage ./packages/mihomo-config-fetcher { };
        network-auto-login = pkgs.callPackage ./packages/network-auto-login { };
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          deadnix
          fennel-ls
          fnlfmt
          luaPackages.fennel
          nil
          nixd
          nixfmt
          statix
        ];
      };

      formatter.${system} = pkgs.nixfmt;

      packages.${system} = localPackages;

      homeConfigurations.akari = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./users/akari/home.nix
        ];
      };

      nixosConfigurations.atri = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs self; };

        modules = [
          ./devices/atri/configuration.nix
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.akari = ./users/akari/home.nix;
            };
          }
        ];
      };

      nixosConfigurations.chii = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs self; };

        modules = [
          ./devices/chii/configuration.nix
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.akari = ./users/akari/home.nix;
            };
          }
        ];
      };
    };
}
