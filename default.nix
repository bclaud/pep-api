{ pkgs }:

with pkgs;

let
  pname = "pep-api";
  version = "0.0.1";
  src = ./.;

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "${pname}-deps";
    inherit src version;
    sha256 = lib.fakeSha;
  };

  mixNixDeps = with pkgs; import ./mix_deps.nix { inherit lib beamPackages; };
in
  beamPackages.mixRelease { inherit mixNixDeps;}
