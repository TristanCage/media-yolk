# Start from the official Parkervcp Python 3.12 yolk
FROM ghcr.io/parkervcp/yolks:python_3.12

USER root

# System packages we actually need:
# - curl + ca-certificates: download installers safely
# - xz-utils: some archives rely on it
# - ffmpeg: required by yt-dlp for merging / audio extraction
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl xz-utils ffmpeg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install latest Deno (more reliable than Node for yt-dlp JS challenges)
RUN curl -fsSL https://deno.land/x/install/install.sh | sh

# Make sure Deno is available to the container user at runtime
ENV PATH="/root/.deno/bin:/usr/local/bin:${PATH}"

# Fail the build early if something important is missing
RUN python --version && deno --version && ffmpeg -version | head -n 1

# Switch back to the user Pterodactyl expects
USER container
WORKDIR /home/container

# Keep Deno in PATH after switching users
ENV PATH="/root/.deno/bin:/usr/local/bin:${PATH}"