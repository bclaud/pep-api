{ pkgs, pep }:

pkgs.dockerTools.buildImage {
  name = "pep-container";

  config = {
    Cmd = [ "pep" "start" ];
    Env = [
      "USER=nobody"
      "PHX_SERVER=true"
      "LC_ALL=en_US.UTF-8"
      "LANG=en_US.UTF-8"
      "LOCALE_ARCHIVE=${if pkgs.stdenv.isLinux then "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive" else ""}"
    ];
    ExposedPorts = {
      "80/tcp" = { };
      "4000/tcp" = { };
    };
  };

  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = with pkgs; [
      pep
      coreutils
      gnused
      gnugrep
      bash
    ];
    pathsToLink = [ "/bin" ];
  };
}
