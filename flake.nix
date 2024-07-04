{
  description = "Development environment";

  inputs = {
    nixpkgs = {url = "github:NixOS/nixpkgs/nixpkgs-unstable";};
    flake-utils = {url = "github:numtide/flake-utils";};
    nix2container.url = "github:nlewo/nix2container";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nix2container,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        elixir_overlay = (
          self: super: rec {
            erlang = super.erlang_26;
            beamPackages = super.beam.packagesWith erlang;
            elixir = beamPackages.elixir.override {
              version = "1.17.1";
              sha256 = "sha256-a7A+426uuo3bUjggkglY1lqHmSbZNpjPaFpQUXYtW9k=";
            };
            hex = beamPackages.hex.override {inherit elixir;};
            rebar3 = beamPackages.rebar3;
            buildMix = super.beam.packages.erlang.buildMix'.override {inherit elixir erlang hex;};
          }
        );

        inherit (nixpkgs.lib) optional;
        pkgs = import nixpkgs {
          inherit system;
          # overlays = [elixir_overlay];
        };

        nix2containerPkgs = nix2container.packages.${system};
      in
        with pkgs; rec {
          packages = rec {
            pep = callPackage ./default.nix {};
            container = callPackage ./container.nix {inherit pep nix2containerPkgs;};
          };

          defaultPackage = packages.pep;
          devShell = callPackage ./shell.nix {};
        }
    );
}
