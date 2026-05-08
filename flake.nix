{
  description = "pep-api";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem = flake-utils.lib.eachSystem supportedSystems (system:
        let
          beamPkgs = pkgs.beam.packagesWith pkgs.beam.interpreters.erlang_28;
          beamPackages = beamPkgs // {
            elixir = beamPkgs.elixir_1_19;
            hex = beamPkgs.hex.override { elixir = beamPkgs.elixir_1_19; };
            rebar3 = beamPkgs.rebar3;
          };

          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              (self: super: {
                inherit beamPackages;
              })
            ];
          };
        in
        {
          devShells.default = pkgs.mkShell {
            name = "pep-api";

            packages = with pkgs; [
              elixir_1_19
              elixir-ls
              postgresql
              mix2nix
              inotify-tools
              glibcLocalesUtf8
            ];

            env = {
              MIX_HOME     = "${placeholder "out"}/.mix";
              HEX_HOME     = "${placeholder "out"}/.hex";
              LANG         = "en_US.UTF-8";
              LOCALE_ARCHIVE = if pkgs.stdenv.isLinux then "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive" else "";
            };

            shellHook = ''
              echo "pep-api dev shell (Elixir 1.19 / OTP 28)"
            '';
          };

          packages = rec {
            pep = pkgs.callPackage ./default.nix { };
            container = pkgs.callPackage ./container.nix { inherit pep; };
            defaultPackage = pep;
          };

          formatter = pkgs.nixpkgs-fmt;
        }
      );

      pkgs = import nixpkgs { system = "x86_64-linux"; };

      pushContainer = pkgs.writeShellApplication {
        name = "push-container";
        runtimeInputs = [ pkgs.age pkgs.skopeo ];
        text = ''
          set -euo pipefail
          export HOME=$PWD

          mkdir -p "$HOME/.config/containers"
          cat > "$HOME/.config/containers/policy.json" <<'POLICY'
          {"default": [{"type": "insecureAcceptAnything"}]}
          POLICY

          TOKEN=$(age -d -i "$GARNIX_ACTION_PRIVATE_KEY_FILE" "${
            ./secrets/ghcr-token.age
          }")
          skopeo copy \
            --dest-creds "bclaud:$TOKEN" \
            "docker-archive:${self.packages.aarch64-linux.container}" \
            docker://ghcr.io/bclaud/pep-api/pep-container:latest
        '';
      };
    in
    perSystem // {
      apps.x86_64-linux.push-container = {
        type = "app";
        program = "${pushContainer}/bin/push-container";
      };
    };
}