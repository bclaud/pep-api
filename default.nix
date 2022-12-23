{ pkgs }:

with pkgs;

let
  pname = "pep";
  version = "0.0.1";
  src = ./.;

  mixNixDeps = with pkgs; import ./mix_deps.nix { inherit lib beamPackages; };
in
  beamPackages.mixRelease { inherit mixNixDeps pname version src; }
