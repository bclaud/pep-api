{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

  outputs = { self, nixpkgs }: {


    devShells.x86_64-linux.default =
      let
        pkgs = import nixpkgs { system = "x86_64-linux"; };
      in
      pkgs.mkShell {
        name = "gosto";
        buildInputs =
          let
            inherit (pkgs.beam) packagesWith;
            inherit (pkgs.beam.interpreters) erlangR25;
            packages = packagesWith erlangR25;
          in
          with pkgs; [
            gnumake
            gcc
            readline
            openssl
            zlib
            libxml2
            curl
            libiconv
            packages.elixir
            glibcLocales
            erlangR25
          ];
        shellHook = ''
          # create local tmp folders
          mkdir -p .nix-mix
          mkdir -p .nix-hex

          mix local.hex --force --if-missing
          mix local.rebar --force --if-missing

          # to not conflict with your host elixir
          # version and supress warnings about standard
          # libraries
          export ERL_LIBS="$HEX_HOME/lib/erlang/lib"

          export GPG_TTY="$(tty)"

          # this allows mix to work on the local directory
          export MIX_HOME=$PWD/.nix-mix
          export HEX_HOME=$PWD/.nix-mix
          export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH
          export ERL_AFLAGS="-kernel shell_history enabled"

          export LANG=en_US.UTF-8
        '';
      };

  };
}
