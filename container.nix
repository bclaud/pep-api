{ pkgs
, pep
, ...
}:
pkgs.dockerTools.buildImage {
  name = "pep-api/pep-container";
  tag = "latest";

  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = [ pep pkgs.bash pkgs.glibcLocalesUtf8 ];
    pathsToLink = [ "/bin" ];
  };

  config = {
    Cmd = [ "sh" "-c" "bin/pep eval Pep.Release.migrate && bin/pep start" ];
    Env = [
      "USER=nobody"
      "PHX_SERVER=true"
      "LC_ALL=en_US.UTF-8"
      "LANG=en_US.UTF-8"
      "ELIXIR_ERL_OPTIONS=+fnu"
      "LOCALE_ARCHIVE=${if pkgs.stdenv.isLinux then "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive" else ""}"
    ];
    ExposedPorts = {
      "4000/tcp" = { };
    };
  };
}