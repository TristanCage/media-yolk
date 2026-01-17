# Base on the official Parkervcp python yolk
FROM ghcr.io/parkervcp/yolks:python_3.12

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl ffmpeg \
 && rm -rf /var/lib/apt/lists/*

# Install Deno to /usr/local/bin/deno
ENV DENO_INSTALL=/usr/local
RUN curl -fsSL https://deno.land/x/install/install.sh | sh

# Ensure /usr/local/bin is in PATH (it usually is, but we force it)
ENV PATH="/usr/local/bin:${PATH}"

# Quick sanity checks (build will fail if missing)
RUN python --version && node --version && npm --version && ffmpeg -version | head -n 1

# Back to default container user expected by Pterodactyl
USER container
WORKDIR /home/container