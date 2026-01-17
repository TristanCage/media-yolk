# Start from the official Parkervcp Python 3.12 yolk
FROM ghcr.io/parkervcp/yolks:python_3.12

USER root

# We need:
# - curl + ca-certificates to fetch the installer
# - unzip because the Deno installer downloads a zip
# - ffmpeg for yt-dlp merges/audio extraction
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl unzip ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# Install the latest Deno using the official install script
# (Docs recommend this exact URL)
# We'll install it into /usr/local/deno so it’s not stuck in /root/.deno
ENV DENO_INSTALL=/usr/local/deno
RUN curl -fsSL https://deno.land/install.sh | sh

# Put Deno on PATH for everyone (root + the pterodactyl "container" user)
ENV PATH="/usr/local/deno/bin:${PATH}"

# Quick sanity checks (fail the build if anything is missing)
RUN python --version && deno --version && ffmpeg -version | head -n 1

# Back to the default container user expected by Pterodactyl
USER container
WORKDIR /home/container