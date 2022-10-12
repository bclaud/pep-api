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

        elixir = beamPkg.elixir.override {
            version = "1.14.1";
            sha256 =  "/QQckiRvwmD3gdIo19TXM0bIgdxNx8eQwpd1RnEo35A=";
        };

        elixir-ls = pkgs.beam.packages.erlang.elixir_ls;
        locales = pkgs.glibcLocales;
      in
      with pkgs;
      {
          devShell = pkgs.mkShell
          {
              buildInputs = [
                erlangR25
                elixir
                locales
            ];
          };
      }
    );
}