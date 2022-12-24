{
    description = "Development environment";

  inputs = {
      nixpkgs = { url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
      flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (nixpkgs.lib) optional;
        pkgs = import nixpkgs { inherit system; };
        beamPkg = pkgs.beam.packagesWith pkgs.erlangR25;

        elixir14 = beamPkg.elixir.override {
          version = "1.14.2";
          sha256 = "ABS+tXWm0vP3jb4ixWSi84Ltya7LHAuEkGMuAoZqHPA=";
          };
      in
      with pkgs;
      {
          defaultPackage = callPackage ./default.nix { mixEnv = "dev"; version = "0.0.1"; projectElixir = elixir14;};
          devShell = callPackage ./shell.nix { projectElixir = elixir14; };
      }
    );
}
