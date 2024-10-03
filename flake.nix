{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forEachSystem =
        f:
        inputs.nixpkgs.lib.listToAttrs (
          map (system: {
            name = system;
            value = f {
              inherit system;
              pkgs = import inputs.nixpkgs { inherit system; };
            };
          }) systems
        );
    in
    {
      devShells = forEachSystem (
        { pkgs, system }:
        {
          default = pkgs.mkShell {
            packages = [ pkgs.catppuccin-whiskers ];
          };
        }
      );
      formatter = forEachSystem ({ pkgs, system }: pkgs.nixfmt-rfc-style);
      overlays.default = final: _: {
        catppuccin-where-is-my-sddm-theme = final.callPackage ./default.nix { };
      };
      packages = forEachSystem (
        { pkgs, system }:
        {
          default = inputs.self.packages.${system}.catppuccin-where-is-my-sddm-theme;
          catppuccin-where-is-my-sddm-theme = pkgs.callPackage ./default.nix { };
        }
      );
    };

  nixConfig = {
    extra-substituters = [ "https://catppuccin.cachix.org" ];
    extra-trusted-public-keys = [
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
    ];
  };
}
