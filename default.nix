{ pkgs, mixEnv ? "dev", version ? "0.0.1" }:

with pkgs;

let
  pname = "pep";
  src = ./.;

  mixNixDeps = with pkgs; import ./mix_deps.nix { inherit lib beamPackages; };
in
  beamPackages.mixRelease { 
    inherit mixNixDeps pname version src mixEnv elixir; 

    LC_ALL = "en_US.UTF-8"; 
    LANG = "en_US.UTF-8";

    }
