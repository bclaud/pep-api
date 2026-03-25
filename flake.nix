{
  description = "pep-api";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix2container = {
      url = "github:nlewo/nix2container";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nix2container }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        beamPkgs = pkgs.beam.packagesWith pkgs.beam.interpreters.erlang_28;
        beamPackages = beamPkgs // {
          elixir = beamPkgs.elixir_1_19;
          hex = beamPkgs.hex.override { elixir = beamPkgs.elixir_1_19; };
          rebar3 = beamPkgs.rebar3;
        };

        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (self: super: {
              inherit beamPackages;
            })
          ];
        };

        nix2containerPkgs = nix2container.packages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          name = "pep-api";

          packages = with pkgs; [
            elixir_1_19
            elixir-ls
            postgresql
            mix2nix
            inotify-tools
            glibcLocalesUtf8
          ];

          env = {
            MIX_HOME     = "${placeholder "out"}/.mix";
            HEX_HOME     = "${placeholder "out"}/.hex";
            LANG         = "en_US.UTF-8";
            LOCALE_ARCHIVE = if pkgs.stdenv.isLinux then "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive" else "";
          };

          shellHook = ''
            echo "pep-api dev shell (Elixir 1.19 / OTP 28)"
          '';
        };

        packages = rec {
          pep = pkgs.callPackage ./default.nix { };
          container = pkgs.callPackage ./container.nix {
            inherit nix2containerPkgs;
            inherit pep;
          };
          defaultPackage = pep;
        };

        formatter = pkgs.nixpkgs-fmt;
      }
    );
}