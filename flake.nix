{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "flake:nixpkgs";
  inputs.flake-utils.url = "flake:flake-utils";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };
  inputs.overlays.url = "github:thelonelyghost/blank-overlay-nix";

  outputs = { self, nixpkgs, flake-utils, flake-compat, overlays }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [overlays.overlays.default];
      };

      tag = pkgs.buildGo119Module {
        pname = "tag";
        version = "1.4.0";
        src = ./.;
        vendorHash = "sha256-rEb6Q6b3+XKY+8Pn6xkNMLqUeKaqXCdFwh3Sd6NePs4=";

        meta = {
          description = "Instantly jump to your ag or ripgrep matches";
          homepage = "https://github.com/thelonelyghost/tag";
        };
      };
    in {
      devShell = pkgs.mkShell {
        nativeBuildInputs = [
          pkgs.bashInteractive
          pkgs.go
        ];
        buildInputs = [
        ];
      };

      packages = {
        inherit tag;
      };
      defaultPackage = tag;

      apps = {
        inherit tag;
      };
      defaultApp = tag;
    });
}
