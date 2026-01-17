# Base on the official Parkervcp python yolk
FROM ghcr.io/parkervcp/yolks:python_3.12

USER root

# Install OS deps + ffmpeg + Node.js LTS
# Notes:
# - xz-utils is needed for some tar/archives tooling
# - ca-certificates/curl for Nodesource installer
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl gnupg xz-utils ffmpeg && \
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Quick sanity checks (build will fail if missing)
RUN python --version && node --version && npm --version && ffmpeg -version | head -n 1

# Back to default container user expected by Pterodactyl
USER container
WORKDIR /home/container