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

      tag = pkgs.buildGoModule {
        pname = "tag";
        version = "1.4.0";
        src = ./.;
        vendorSha256 = "sha256-wspcVQWCSCioXH3YstP4pu22DlMkX2HiINxiFP/CCMM=";

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
