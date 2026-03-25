ARG NAMESPACE_BASE_IMAGE_REF=""
FROM ${NAMESPACE_BASE_IMAGE_REF} AS base

USER root

RUN curl -fsSL https://install.determinate.systems/nix | sh -s -- install linux --determinate --init none --no-confirm --no-sudo

RUN echo 'source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' >> /etc/bash.bashrc

ENV PATH="/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:$PATH"
ENV NIX_SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"

USER runner
