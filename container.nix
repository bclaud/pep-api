{
  pkgs,
  nix2containerPkgs,
  pep,
}:
nix2containerPkgs.nix2container.buildImage {
  name = "pep-container";
  tag = "latest";

  config = {
    Cmd = ["sh" "-c" "bin/pep eval Pep.Release.migrate && bin/pep start"];
    Env = [
      "USER=nobody"
      "PHX_SERVER=true"
      "LC_ALL=en_US.UTF-8"
      "LANG=en_US.UTF-8"
      "LOCALE_ARCHIVE=${
        if pkgs.stdenv.isLinux
        then "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive"
        else ""
      }"
    ];
    ExposedPorts = {
      "80/tcp" = {};
      "4000/tcp" = {};
    };
  };

  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = with pkgs; [
      pep
      bash
    ];
    pathsToLink = ["/bin"];
  };

}
