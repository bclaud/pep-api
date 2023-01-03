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
          elixir = super.elixir.override {
            version = "1.14.2";
            sha256 = super.lib.fakeSha256;
            minimumOTPVersion = "25";
          };
        });
        
        inherit (nixpkgs.lib) optional;
        pkgs = import nixpkgs { inherit system; overlays = [ elixir_overlay ];};

      in
      with pkgs;
      {
          defaultPackage = callPackage ./default.nix { pkgs = pkgs; mixEnv = "dev"; version = "0.0.1"; projectElixir = elixir;};
          devShell = callPackage ./shell.nix { projectElixir = elixir; };
      }
    );
}
