{pkgs}:
with pkgs; let
  projectName = "pep-api";
  
  ciTest = pkgs.writeScriptBin "ci-test" ''
  # echo "Avoid utf-8 issues"
  export LOCALE_ARCHIVE = "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive"
  export LANG=en_US.UTF-8

  echo "Installing hex and rebar"
  mix local.hex --force
  mix local.rebar --force

  echo "Fetching Deps"
  MIX_ENV=test mix deps.get
  MIX_ENV=test mix test
  '';
in
  mkShell {
    name = "${projectName}-shell";

    buildInputs =
      [
        ciTest
        glibcLocalesUtf8
        elixir
        elixir_ls
        mix2nix
        # nodejs_latest
        # postgresql_15
        # yarn2nix
        # nodePackages.node2nix
        # nodePackages.prettier
      ]
      ++ lib.optionals stdenv.isLinux
      [
        libnotify # For ExUnit Notifier on Linux.
        inotify-tools # For file_system on Linux.
      ]
      ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
        terminal-notifier # For ExUnit Notifier on macOS.
        CoreFoundation
        CoreServices # For file_system on macOS.
      ]);

    # Fixes locale issue on `nix-shell --pure` (at least on NixOS). See
    # + https://github.com/NixOS/nix/issues/318#issuecomment-52986702
    # + http://lists.linuxfromscratch.org/pipermail/lfs-support/2004-June/023900.html
    # export LC_ALL=en_US.UTF-8
    LOCALE_ARCHIVE =
      if pkgs.stdenv.isLinux
      then "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive"
      else "";
  }
