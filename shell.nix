{ pkgs }:

with pkgs;

let
  projectName = "pep-api";
in

mkShell {
  name = "${projectName}-shell";

  buildInputs = [
    glibcLocalesUtf8
    elixir
    # nodejs_latest
    # postgresql_15
    # yarn2nix
    # nodePackages.node2nix
    # nodePackages.prettier
  ] ++ lib.optionals stdenv.isLinux
      [
        libnotify # For ExUnit Notifier on Linux.
        inotify-tools # For file_system on Linux.
      ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks;
      [
        terminal-notifier # For ExUnit Notifier on macOS.
        CoreFoundation CoreServices # For file_system on macOS.
      ]);

  # Fixes locale issue on `nix-shell --pure` (at least on NixOS). See
  # + https://github.com/NixOS/nix/issues/318#issuecomment-52986702
  # + http://lists.linuxfromscratch.org/pipermail/lfs-support/2004-June/023900.html
  # export LC_ALL=en_US.UTF-8
  LOCALE_ARCHIVE = if pkgs.stdenv.isLinux then "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive" else "";
}
