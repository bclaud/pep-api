{ pkgs, projectElixir, mixEnv ? "dev", version ? "0.0.1" }:

# where this pkgs is comming from?!
with pkgs;

let
  beamPkg = pkgs.beam.packagesWith pkgs.erlangR25;

  pname = "pep";
  src = ./.;
  # Using projectElixir override gives me latin1 enconding issues and elixir.compiler/4 error
  # i am not sure if they are related

  mixNixDeps = with pkgs; import ./mix_deps.nix { inherit lib beamPackages; };
in
  beamPackages.mixRelease { 
    inherit mixNixDeps pname version src mixEnv; 
    elixir = projectElixir;
    preConfigure = ''
      locale
    '';
  }
