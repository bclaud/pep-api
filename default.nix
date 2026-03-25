{ pkgs }:
with pkgs;

let
  pname = "pep";
  version = "0.0.1";
  src = ./.;
  deps = import ./mix_deps.nix { inherit lib beamPackages; };
in
beamPackages.mixRelease {
  inherit pname src version;
  mixNixDeps = deps;
  ELIXIR_ERL_OPTIONS = "+fnu";
}