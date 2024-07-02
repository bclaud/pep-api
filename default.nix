{pkgs}:
with pkgs; let
  pname = "pep";
  version = "0.0.1";

  src = ./.;

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    sha256 = "sha256-pZPexIgz2cM3gGJOyxJCK/e7EZRfG2iLlOUuamVkZeI=";
  };
in
  beamPackages.mixRelease {
    inherit mixFodDeps pname version src;

    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
  }
