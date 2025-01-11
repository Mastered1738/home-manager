{
  description = "Home Manager configuration with NVF";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = { self, nixpkgs, home-manager, nvf, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    homeConfigurations.vinko = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        nvf.homeManagerModules.default
        ./home.nix
      ];
    };
  };
}
