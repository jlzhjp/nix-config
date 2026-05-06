{
  description = "Fedora bootc nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    codex-cli-nix = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      fedoraNixConfigurations."atri" = {
        prefix = pkgs.buildEnv {
          name = "system-nix-prefix";
          paths = [ home-manager.packages.${system}.default ];
        };
        graphicsDrivers = pkgs.buildEnv {
          name = "system-nix-graphics-driver";
          paths = with pkgs; [
            mesa
            libvdpau-va-gl
            intel-media-driver
          ];
        };
      };
      homeConfigurations."akari" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home.nix ];
      };
    };
}
