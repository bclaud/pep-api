{
    description = "Development environment";

  inputs = {
      nixpkgs = { url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
      flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        elixir_overlay = (self: super: rec {
          erlang = super.erlangR25;
          beamPackages = (super.beam.packagesWith erlang);
          elixir = beamPackages.elixir.override {
            version = "1.14.2";
            sha256 = "sha256-ABS+tXWm0vP3jb4ixWSi84Ltya7LHAuEkGMuAoZqHPA=";
            };
          }
        );
        
        inherit (nixpkgs.lib) optional;
        pkgs = import nixpkgs { inherit system; overlays = [ elixir_overlay ];};

      in
      with pkgs;
     rec  {
          packages = rec { 
            pep = callPackage ./default.nix { pkgs = pkgs; mixEnv = "dev"; version = "0.0.1"; };
            container = callPackage ./container.nix { pkgs = pkgs; pep = pep; };
          };

          defaultPackage = packages.pep;
          devShell = callPackage ./shell.nix { pkgs = pkgs;};
      }
    );
}
