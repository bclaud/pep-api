ARG NAMESPACE_BASE_IMAGE_REF=""
FROM ${NAMESPACE_BASE_IMAGE_REF} AS base

RUN apt-get update && apt-get install -y curl sudo && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://install.determinate.systems/nix | sh -s -- install linux --determinate --init none --no-confirm

RUN sudo tee -a /etc/bash.bashrc << 'EOF'
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
EOF

ENV PATH="/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:$PATH"
ENV NIX_SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
