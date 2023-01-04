{ pkgs, mixEnv ? "dev", version ? "0.0.1" }:

with pkgs;

let
  pname = "pep";
  src = ./.;

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    sha256 = "sha256-sYWaznDp2sOosDBHzIn4xUAOLN7T0y42nqyItj91OW8=";
  };
in
  beamPackages.mixRelease { 
    inherit mixFodDeps pname version src mixEnv elixir; 

    LC_ALL = "en_US.UTF-8"; 
    LANG = "en_US.UTF-8";

    }
