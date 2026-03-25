# CI base image for Namespace runner profiles
#
# Nix is pre-installed so CI jobs don't need to install it at runtime.
# The base must be NAMESPACE_BASE_IMAGE_REF and the user must be `runner`.
#
# Start nix daemon at job beginning:
#   sudo /nix/var/nix/profiles/default/bin/nix-daemon &

ARG NAMESPACE_BASE_IMAGE_REF=""
FROM ${NAMESPACE_BASE_IMAGE_REF} AS base

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      curl \
      ca-certificates \
      xz-utils \
 && rm -rf /var/lib/apt/lists/*

# Install Nix in multi-user mode without systemd.
RUN curl --proto '=https' --tlsv1.2 -sSf -L \
      https://install.determinate.systems/nix \
    | sh -s -- install linux \
        --init none \
        --no-confirm \
        --extra-conf "trusted-users = root runner"

# Enable flakes + nix-command globally, and trust the `runner` user.
RUN mkdir -p /etc/nix \
 && echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf \
 && echo "trusted-users = root runner"                >> /etc/nix/nix.conf

# Allow `runner` to start nix-daemon without a password prompt.
RUN mkdir -p /etc/sudoers.d \
 && echo "runner ALL=(root) NOPASSWD: /nix/var/nix/profiles/default/bin/nix-daemon" \
      > /etc/sudoers.d/runner-nix-daemon \
 && chmod 0440 /etc/sudoers.d/runner-nix-daemon

ENV PATH="/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:$PATH"
ENV NIX_SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"

USER runner
